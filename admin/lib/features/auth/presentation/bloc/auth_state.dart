import 'package:equatable/equatable.dart';
import '../../../../src/generated/openauth/v1/users.pb.dart' as pb;

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthAuthenticated extends AuthState {
  final pb.SignInResponse session;

  const AuthAuthenticated(this.session);

  @override
  List<Object> get props => [session];
}

class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object> get props => [message];
}

class AuthSignInError extends AuthState {
  final String message;

  const AuthSignInError(this.message);

  @override
  List<Object> get props => [message];
}
