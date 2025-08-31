import 'package:equatable/equatable.dart';

abstract class AppEvent extends Equatable {
  const AppEvent();

  @override
  List<Object?> get props => [];
}

class AppStarted extends AppEvent {
  const AppStarted();
}

class AppAuthenticationChanged extends AppEvent {
  final bool isAuthenticated;

  const AppAuthenticationChanged({required this.isAuthenticated});

  @override
  List<Object> get props => [isAuthenticated];
}

