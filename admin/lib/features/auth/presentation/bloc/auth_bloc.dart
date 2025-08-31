import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';

import '../../domain/usecases/sign_in_usecase.dart';
import '../../domain/usecases/sign_out_usecase.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../../../src/generated/openauth/v1/users.pb.dart' as pb;
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignInUseCase _signInUseCase;
  final SignOutUseCase _signOutUseCase;
  final AuthRepository _authRepository;

  AuthBloc({
    required SignInUseCase signInUseCase,
    required SignOutUseCase signOutUseCase,
    required AuthRepository authRepository,
  })  : _signInUseCase = signInUseCase,
        _signOutUseCase = signOutUseCase,
        _authRepository = authRepository,
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
      final isAuthenticated = await _authRepository.isAuthenticated();
      
      if (isAuthenticated) {
        final tokens = await _authRepository.getStoredTokens();
        if (tokens != null && tokens['accessToken'] != null) {
          // Create a minimal session response for authenticated state
          final session = pb.SignInResponse(
            accessToken: tokens['accessToken']!,
            refreshToken: tokens['refreshToken'] ?? '',
            sessionId: tokens['sessionId'] ?? '',
          );
          emit(AuthAuthenticated(session));
        } else {
          emit(const AuthUnauthenticated());
        }
      } else {
        emit(const AuthUnauthenticated());
      }
    } catch (e) {
      emit(const AuthUnauthenticated());
    }
  }

  Future<void> _onAuthSignInRequested(
    AuthSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    try {
      final session = await _signInUseCase(
        username: event.username,
        password: event.password,
        rememberMe: event.rememberMe,
      );

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
      await _signOutUseCase();
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
