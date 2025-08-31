import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'theme_event.dart';
import 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  static const String _themeKey = 'theme_mode';
  final SharedPreferences _sharedPreferences;

  ThemeBloc({required SharedPreferences sharedPreferences})
      : _sharedPreferences = sharedPreferences,
        super(const ThemeSystem()) {
    on<ThemeInitialized>(_onThemeInitialized);
    on<ThemeChanged>(_onThemeChanged);
  }

  Future<void> _onThemeInitialized(
    ThemeInitialized event,
    Emitter<ThemeState> emit,
  ) async {
    final themeIndex = _sharedPreferences.getInt(_themeKey) ?? 0;
    
    switch (themeIndex) {
      case 0:
        emit(const ThemeSystem());
        break;
      case 1:
        emit(const ThemeLight());
        break;
      case 2:
        emit(const ThemeDark());
        break;
      default:
        emit(const ThemeSystem());
    }
  }

  Future<void> _onThemeChanged(
    ThemeChanged event,
    Emitter<ThemeState> emit,
  ) async {
    ThemeState newState;
    int themeIndex;

    // Cycle through themes: System -> Light -> Dark -> System...
    if (state is ThemeSystem) {
      newState = const ThemeLight();
      themeIndex = 1;
    } else if (state is ThemeLight) {
      newState = const ThemeDark();
      themeIndex = 2;
    } else {
      newState = const ThemeSystem();
      themeIndex = 0;
    }

    await _sharedPreferences.setInt(_themeKey, themeIndex);
    emit(newState);
  }
}
