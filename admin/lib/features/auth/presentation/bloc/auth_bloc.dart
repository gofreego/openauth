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
    on<AuthSignInRequested>(_onAuthSignInRequested);
    on<AuthSignOutRequested>(_onAuthSignOutRequested);
    on<AuthUserUpdated>(_onAuthUserUpdated);
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
