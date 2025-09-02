import 'package:flutter_bloc/flutter_bloc.dart';
import 'sessions_event.dart';
import 'sessions_state.dart';
import '../../data/repositories/sessions_repository.dart';

class SessionsBloc extends Bloc<SessionsEvent, SessionsState> {
  final SessionsRepository _sessionsRepository;

  SessionsBloc({
    required SessionsRepository sessionsRepository,
  })  : _sessionsRepository = sessionsRepository,
        super(SessionsInitial()) {
    on<LoadUserSessionsEvent>(_onLoadUserSessions);
    on<RefreshUserSessionsEvent>(_onRefreshUserSessions);
    on<TerminateSessionEvent>(_onTerminateSession);
    on<TerminateAllUserSessionsEvent>(_onTerminateAllUserSessions);
  }

  Future<void> _onLoadUserSessions(
    LoadUserSessionsEvent event,
    Emitter<SessionsState> emit,
  ) async {
    try {
      emit(SessionsLoading());
      final result = await _sessionsRepository.getUserSessions(event.userId);
      result.fold(
        (failure) => emit(SessionsError(failure.message)),
        (sessions) => emit(SessionsLoaded(sessions: sessions, userId: event.userId)),
      );
    } catch (e) {
      emit(SessionsError('Failed to load sessions: ${e.toString()}'));
    }
  }

  Future<void> _onRefreshUserSessions(
    RefreshUserSessionsEvent event,
    Emitter<SessionsState> emit,
  ) async {
    try {
      final result = await _sessionsRepository.getUserSessions(event.userId);
      result.fold(
        (failure) => emit(SessionsError(failure.message)),
        (sessions) => emit(SessionsLoaded(sessions: sessions, userId: event.userId)),
      );
    } catch (e) {
      emit(SessionsError('Failed to refresh sessions: ${e.toString()}'));
    }
  }

  Future<void> _onTerminateSession(
    TerminateSessionEvent event,
    Emitter<SessionsState> emit,
  ) async {
    try {
      emit(SessionTerminating(event.sessionId));
      final result = await _sessionsRepository.terminateSession(event.sessionId);
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

  Future<void> _onTerminateAllUserSessions(
    TerminateAllUserSessionsEvent event,
    Emitter<SessionsState> emit,
  ) async {
    try {
      emit(AllSessionsTerminating(event.userId));
      final result = await _sessionsRepository.terminateAllUserSessions(event.userId);
      result.fold(
        (failure) => emit(SessionsError(failure.message)),
        (_) => emit(AllSessionsTerminated(
          userId: event.userId,
          message: 'All sessions terminated successfully',
        )),
      );
    } catch (e) {
      emit(SessionsError('Failed to terminate all sessions: ${e.toString()}'));
    }
  }
}
