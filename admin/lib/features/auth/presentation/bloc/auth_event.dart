import 'package:equatable/equatable.dart';
import 'package:openauth/src/generated/openauth/v1/sessions.pb.dart';
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
  final SignInRequest request;
  const AuthSignInRequested({
    required this.request,
  });

  @override
  List<Object?> get props => [request];
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
