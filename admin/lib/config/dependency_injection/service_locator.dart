import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../environment/environment_config.dart';
import '../../core/network/api_service.dart';
import '../../core/bloc/theme_bloc.dart';
import '../../core/bloc/app_bloc.dart';
import '../../shared/catalog.dart';

final serviceLocator = GetIt.instance;

Future<void> initializeDependencies({
  EnvironmentType environmentType = EnvironmentType.development,
}) async {
  // Initialize environment configuration first
  EnvironmentConfig.initialize(environmentType);
  
  // External dependencies
  final sharedPreferences = await SharedPreferences.getInstance();

  serviceLocator.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  serviceLocator.registerLazySingleton<ApiService>(() => ApiService());

  // Shared Catalog Service
    serviceLocator.registerLazySingleton<HTTPServiceClient>(
    () => const HTTPServiceClient(),
  );

  // Register BLoCs
  serviceLocator.registerLazySingleton<ThemeBloc>(
    () => ThemeBloc(sharedPreferences: sharedPreferences),
  );
  
  serviceLocator.registerLazySingleton<AppBloc>(
    () => AppBloc(),
  );

}
