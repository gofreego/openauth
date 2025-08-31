import 'package:equatable/equatable.dart';

abstract class AppState extends Equatable {
  const AppState();

  @override
  List<Object?> get props => [];
}

class AppInitial extends AppState {
  const AppInitial();
}

class AppLoading extends AppState {
  const AppLoading();
}

class AppUnauthenticated extends AppState {
  const AppUnauthenticated();
}

class AppAuthenticated extends AppState {
  const AppAuthenticated();
}