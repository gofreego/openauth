import 'package:equatable/equatable.dart';
import '../../../../src/generated/openauth/v1/users.pb.dart' as pb;

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthCheckRequested extends AuthEvent {
  const AuthCheckRequested();
}

class AuthSignInRequested extends AuthEvent {
  final String identifier;
  final String password;
  final bool rememberMe;

  const AuthSignInRequested({
    required this.identifier,
    required this.password,
    this.rememberMe = false,
  });

  @override
  List<Object?> get props => [identifier, password, rememberMe];
}

class AuthSignOutRequested extends AuthEvent {
  const AuthSignOutRequested();
}

class AuthTokenRefreshRequested extends AuthEvent {
  const AuthTokenRefreshRequested();
}

class AuthUserUpdated extends AuthEvent {
  final pb.User user;

  const AuthUserUpdated(this.user);

  @override
  List<Object> get props => [user];
}
