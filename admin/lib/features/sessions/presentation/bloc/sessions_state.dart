import 'package:equatable/equatable.dart';
import '../../../../src/generated/openauth/v1/sessions.pb.dart' as pb;

abstract class SessionsState extends Equatable {
  const SessionsState();

  @override
  List<Object?> get props => [];
}

class SessionsInitial extends SessionsState {}

class SessionsLoading extends SessionsState {}

class SessionsLoaded extends SessionsState {
  final List<pb.Session> sessions;
  final String userId;

  const SessionsLoaded({
    required this.sessions,
    required this.userId,
  });

  @override
  List<Object?> get props => [sessions, userId];
}

class SessionsError extends SessionsState {
  final String message;

  const SessionsError(this.message);

  @override
  List<Object?> get props => [message];
}

class SessionTerminating extends SessionsState {
  final String sessionId;

  const SessionTerminating(this.sessionId);

  @override
  List<Object?> get props => [sessionId];
}

class SessionTerminated extends SessionsState {
  final String sessionId;
  final String message;

  const SessionTerminated({
    required this.sessionId,
    required this.message,
  });

  @override
  List<Object?> get props => [sessionId, message];
}

class AllSessionsTerminating extends SessionsState {
  final String userId;

  const AllSessionsTerminating(this.userId);

  @override
  List<Object?> get props => [userId];
}

class AllSessionsTerminated extends SessionsState {
  final String userId;
  final String message;

  const AllSessionsTerminated({
    required this.userId,
    required this.message,
  });

  @override
  List<Object?> get props => [userId, message];
}
