import 'package:equatable/equatable.dart';

abstract class SessionsEvent extends Equatable {
  const SessionsEvent();

  @override
  List<Object?> get props => [];
}

class LoadUserSessionsEvent extends SessionsEvent {
  final String userId;

  const LoadUserSessionsEvent(this.userId);

  @override
  List<Object?> get props => [userId];
}

class RefreshUserSessionsEvent extends SessionsEvent {
  final String userId;

  const RefreshUserSessionsEvent(this.userId);

  @override
  List<Object?> get props => [userId];
}

class TerminateSessionEvent extends SessionsEvent {
  final String sessionId;

  const TerminateSessionEvent(this.sessionId);

  @override
  List<Object?> get props => [sessionId];
}

class TerminateAllUserSessionsEvent extends SessionsEvent {
  final String userId;

  const TerminateAllUserSessionsEvent(this.userId);

  @override
  List<Object?> get props => [userId];
}
