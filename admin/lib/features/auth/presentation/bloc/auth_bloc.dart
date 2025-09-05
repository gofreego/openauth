import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';

import '../../data/repositories/auth_repository.dart';
import '../../../../src/generated/openauth/v1/sessions.pb.dart' as pb;
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc({
    required AuthRepository authRepository,
  })  : _authRepository = authRepository,
        super(const AuthInitial()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<AuthSignInRequested>(_onAuthSignInRequested);
    on<AuthSignOutRequested>(_onAuthSignOutRequested);
    on<AuthTokenRefreshRequested>(_onAuthTokenRefreshRequested);
    on<AuthUserUpdated>(_onAuthUserUpdated);
  }

  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    try {
      // First check if we have stored tokens
      final tokens = await _authRepository.getStoredTokens();
      if (tokens == null || tokens['accessToken']?.isEmpty == true) {
        emit(const AuthUnauthenticated());
        return;
      }

      // Validate the token with the server
      final validationResponse = await _authRepository.validateToken(tokens['accessToken']!);
      
      if (validationResponse != null && validationResponse.valid) {
        // Token is valid, create session with user data if available
        final session = pb.SignInResponse(
          accessToken: tokens['accessToken']!,
          refreshToken: tokens['refreshToken'] ?? '',
          sessionId: tokens['sessionId'] ?? '',
        );
        
        // Add user data if available from validation response
        if (validationResponse.hasUser()) {
          session.user = validationResponse.user;
        }
        
        emit(AuthAuthenticated(session));
      } else {
        // Token is invalid, try to refresh it
        final refreshToken = tokens['refreshToken'];
        if (refreshToken != null && refreshToken.isNotEmpty) {
          try {
            final refreshResponse = await _authRepository.refreshToken(refreshToken);
            
            // Convert RefreshTokenResponse to SignInResponse
            final session = pb.SignInResponse(
              accessToken: refreshResponse.accessToken,
              refreshToken: refreshResponse.hasRefreshToken() ? refreshResponse.refreshToken : refreshToken,
              sessionId: tokens['sessionId'] ?? '',
            );
            
            emit(AuthAuthenticated(session));
          } catch (e) {
            // Refresh failed, clear auth data and go to login
            await _authRepository.clearAuthData();
            emit(const AuthUnauthenticated());
          }
        } else {
          // No refresh token, clear auth data and go to login
          await _authRepository.clearAuthData();
          emit(const AuthUnauthenticated());
        }
      }
    } catch (e) {
      // On any error, clear auth data and go to login
      await _authRepository.clearAuthData();
      emit(const AuthUnauthenticated());
    }
  }

  Future<void> _onAuthSignInRequested(
    AuthSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    try {
      final session = await _authRepository.signIn(event.request);

      emit(AuthAuthenticated(session));
    } catch (e) {
      emit(AuthSignInError(e.toString()));
    }
  }

  Future<void> _onAuthSignOutRequested(
    AuthSignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    try {
      await _authRepository.signOut();
      emit(const AuthUnauthenticated());
    } catch (e) {
      // Even if sign out fails on server, clear local data
      await _authRepository.clearAuthData();
      emit(const AuthUnauthenticated());
    }
  }

  Future<void> _onAuthTokenRefreshRequested(
    AuthTokenRefreshRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final tokens = await _authRepository.getStoredTokens();
      
      if (tokens != null && tokens['refreshToken'] != null) {
        final refreshResponse = await _authRepository.refreshToken(tokens['refreshToken']!);
        
        // Create updated session
        final session = pb.SignInResponse(
          accessToken: refreshResponse.accessToken,
          refreshToken: refreshResponse.hasRefreshToken() 
              ? refreshResponse.refreshToken 
              : tokens['refreshToken']!,
          sessionId: tokens['sessionId'] ?? '',
        );
        
        emit(AuthAuthenticated(session));
      } else {
        emit(const AuthUnauthenticated());
      }
    } catch (e) {
      emit(const AuthUnauthenticated());
    }
  }

  Future<void> _onAuthUserUpdated(
    AuthUserUpdated event,
    Emitter<AuthState> emit,
  ) async {
    final currentState = state;
    if (currentState is AuthAuthenticated) {
      // Update session with new user data
      final updatedSession = pb.SignInResponse(
        accessToken: currentState.session.accessToken,
        refreshToken: currentState.session.refreshToken,
        sessionId: currentState.session.sessionId,
        user: event.user,
      );
      emit(AuthAuthenticated(updatedSession));
    }
  }
}
