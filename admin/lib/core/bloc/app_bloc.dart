import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'app_event.dart';
import 'app_state.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/bloc/auth_event.dart';
import '../../features/auth/presentation/bloc/auth_state.dart' as auth;

class AppBloc extends Bloc<AppEvent, AppState> {
  final AuthBloc _authBloc;
  StreamSubscription? _authBlocSubscription;

  AppBloc({required AuthBloc authBloc}) 
      : _authBloc = authBloc,
        super(const AppInitial()) {
    on<AppStarted>(_onAppStarted);
    
    // Listen to authentication state changes
    _authBlocSubscription = _authBloc.stream.listen((authState) {
      if (authState is auth.AuthAuthenticated) {
        if (state is! AppAuthenticated) {
          add(const AppAuthenticationChanged(isAuthenticated: true));
        }
      } else if (authState is auth.AuthUnauthenticated) {
        if (state is! AppUnauthenticated) {
          add(const AppAuthenticationChanged(isAuthenticated: false));
        }
      }
    });
    
    on<AppAuthenticationChanged>(_onAppAuthenticationChanged);
  }

  Future<void> _onAppStarted(
    AppStarted event,
    Emitter<AppState> emit,
  ) async {
    emit(const AppLoading());

    try {
      // Check authentication status
      _authBloc.add(const AuthCheckRequested());
      
      // Wait a bit for auth check to complete
      await Future.delayed(const Duration(milliseconds: 500));
      
      // State will be updated by auth bloc listener
    } catch (e) {
      emit(const AppUnauthenticated());
    }
  }

  Future<void> _onAppAuthenticationChanged(
    AppAuthenticationChanged event,
    Emitter<AppState> emit,
  ) async {
    if (event.isAuthenticated) {
      emit(const AppAuthenticated());
    } else {
      emit(const AppUnauthenticated());
    }
  }

  @override
  Future<void> close() {
    _authBlocSubscription?.cancel();
    return super.close();
  }
}
