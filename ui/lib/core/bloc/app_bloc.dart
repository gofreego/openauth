import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'app_event.dart';
import 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc() : super(const AppInitial()) {
    on<AppStarted>(_onAppStarted);
  }

  StreamSubscription? _authBlocSubscription;

  Future<void> _onAppStarted(
    AppStarted event,
    Emitter<AppState> emit,
  ) async {
    emit(const AppLoading());

    try {
      emit(const AppAuthenticated());
    } catch (e) {
      if (!emit.isDone) {
        emit(const AppUnauthenticated());
      }
    }
  }

  @override
  Future<void> close() {
    _authBlocSubscription?.cancel();
    return super.close();
  }
}
