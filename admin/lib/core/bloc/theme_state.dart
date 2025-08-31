import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

abstract class ThemeState extends Equatable {
  const ThemeState();

  @override
  List<Object> get props => [];
}

class ThemeLight extends ThemeState {
  const ThemeLight();
}

class ThemeDark extends ThemeState {
  const ThemeDark();
}

class ThemeSystem extends ThemeState {
  const ThemeSystem();
}

extension ThemeStateExtension on ThemeState {
  ThemeMode get themeMode {
    switch (this) {
      case ThemeLight _:
        return ThemeMode.light;
      case ThemeDark _:
        return ThemeMode.dark;
      case ThemeSystem _:
      default:
        return ThemeMode.system;
    }
  }

  bool get isDarkMode {
    return this is ThemeDark;
  }
}
