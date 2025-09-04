import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:openauth/features/sessions/data/repositories/sessions_repository.dart';
import 'package:openauth/src/generated/openauth/v1/sessions.pb.dart';
import 'package:protobuf/protobuf.dart';
import 'sessions_state.dart';

class SessionsBloc extends Bloc<GeneratedMessage, SessionsState> {
  final SessionsRepository _sessionsRepository;

  SessionsBloc({
    required SessionsRepository sessionsRepository,
  })  : _sessionsRepository = sessionsRepository,
        super(SessionsInitial()) {
    on<ListUserSessionsRequest>(_onLoadUserSessions);
    on<TerminateSessionRequest>(_onTerminateSession);
  }

  Future<void> _onLoadUserSessions(
    ListUserSessionsRequest event,
    Emitter<SessionsState> emit,
  ) async {
    try {
      emit(SessionsLoading());
      final result = await _sessionsRepository.getUserSessions(event);
      result.fold(
        (failure) => emit(SessionsError(failure.message)),
        (sessions) => emit(SessionsLoaded(sessions: sessions, userId: event.userUuid)),
      );
    } catch (e) {
      emit(SessionsError('Failed to load sessions: ${e.toString()}'));
    }
  }

  Future<void> _onTerminateSession(
    TerminateSessionRequest event,
    Emitter<SessionsState> emit,
  ) async {
    try {
      emit(SessionTerminating(event.sessionId));
      final result = await _sessionsRepository.terminateSession(event);
      result.fold(
        (failure) => emit(SessionsError(failure.message)),
        (_) => emit(SessionTerminated(
          sessionId: event.sessionId,
          message: 'Session terminated successfully',
        )),
      );
    } catch (e) {
      emit(SessionsError('Failed to terminate session: ${e.toString()}'));
    }
  }
}
