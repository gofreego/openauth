import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../environment/environment_config.dart';
import '../../core/network/api_service.dart';
import '../../core/bloc/theme_bloc.dart';
import '../../core/bloc/app_bloc.dart';
import '../../shared/shared.dart';
import '../../features/auth/data/repositories/auth_repository.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';

// Users feature dependencies
import '../../features/users/data/datasources/users_remote_datasource_impl.dart';
import '../../features/users/data/repositories/users_repository_impl.dart';
import '../../features/users/data/repositories/users_repository.dart';
import '../../features/users/presentation/bloc/users_bloc.dart';
import '../../features/users/presentation/bloc/user_permissions_bloc.dart';

// Profile feature dependencies
import '../../features/profiles/data/profile_repository.dart';
import '../../features/profiles/data/profile_repository_impl.dart';
import '../../features/profiles/presentation/bloc/profiles_bloc.dart';

// Permissions feature dependencies
import '../../features/permissions/data/datasources/permissions_remote_datasource_impl.dart';
import '../../features/permissions/data/repositories/permissions_repository_impl.dart';
import '../../features/permissions/data/repositories/permissions_repository.dart';
import '../../features/permissions/presentation/bloc/permissions_bloc.dart';

// Groups feature dependencies
import '../../features/groups/data/datasources/groups_remote_datasource_impl.dart';
import '../../features/groups/data/repositories/groups_repository_impl.dart';
import '../../features/groups/data/repositories/groups_repository.dart';
import '../../features/groups/presentation/bloc/groups_bloc.dart';
import '../../features/groups/presentation/bloc/group_permissions_bloc.dart';

// Dashboard feature dependencies
import '../../features/dashboard/data/repositories/stats_repository_impl.dart';
import '../../features/dashboard/data/repositories/stats_repository.dart';
import '../../features/dashboard/presentation/bloc/dashboard_bloc.dart';

// Sessions feature dependencies
import '../../features/sessions/data/datasources/sessions_remote_datasource_impl.dart';
import '../../features/sessions/data/repositories/sessions_repository_impl.dart';
import '../../features/sessions/data/repositories/sessions_repository.dart';
import '../../features/sessions/presentation/bloc/sessions_bloc.dart';

final serviceLocator = GetIt.instance;

Future<void> initializeDependencies({
  EnvironmentType environmentType = EnvironmentType.development,
}) async {
  // Initialize environment configuration first
  EnvironmentConfig.initialize(environmentType);
  
  // External dependencies
  final sharedPreferences = await SharedPreferences.getInstance();

  serviceLocator.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  
  // Session Manager
  serviceLocator.registerLazySingleton<SessionManager>(
    () => SessionManager(serviceLocator<SharedPreferences>()),
  );

  // API Service with centralized HTTP client
  serviceLocator.registerLazySingleton<ApiService>(
    () => ApiService(),
  );

  // Shared Catalog Service
  serviceLocator.registerLazySingleton<HTTPServiceClient>(
    () => HTTPServiceClient(),
  );

  // Auth Repository
  serviceLocator.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      serviceLocator<HTTPServiceClient>(),
      serviceLocator<SharedPreferences>(),
      serviceLocator<SessionManager>(),
    ),
  );

  // Users data sources
  serviceLocator.registerLazySingleton<UsersRemoteDataSource>(
    () => UsersRemoteDataSourceImpl(serviceLocator<ApiService>()),
  );

  // Users repositories
  serviceLocator.registerLazySingleton<UsersRepository>(
    () => UsersRepositoryImpl(
      remoteDataSource: serviceLocator<UsersRemoteDataSource>(),
    ),
  );

  // Permissions data sources
  serviceLocator.registerLazySingleton<PermissionsRemoteDataSource>(
    () => PermissionsRemoteDataSourceImpl(serviceLocator<ApiService>()),
  );

  // Permissions repositories
  serviceLocator.registerLazySingleton<PermissionsRepository>(
    () => PermissionsRepositoryImpl(
      remoteDataSource: serviceLocator<PermissionsRemoteDataSource>(),
    ),
  );

  // Groups data sources
  serviceLocator.registerLazySingleton<GroupsRemoteDataSource>(
    () => GroupsRemoteDataSourceImpl(serviceLocator<ApiService>()),
  );

  // Groups repositories
  serviceLocator.registerLazySingleton<GroupsRepository>(
    () => GroupsRepositoryImpl(
      remoteDataSource: serviceLocator<GroupsRemoteDataSource>(),
    ),
  );

  // Dashboard repositories
  serviceLocator.registerLazySingleton<StatsRepository>(
    () => StatsRepositoryImpl(
      apiService: serviceLocator<ApiService>(),
    ),
  );

  // Sessions data sources
  serviceLocator.registerLazySingleton<SessionsRemoteDataSource>(
    () => SessionsRemoteDataSourceImpl(serviceLocator<ApiService>()),
  );

  // Sessions repositories
  serviceLocator.registerLazySingleton<SessionsRepository>(
    () => SessionsRepositoryImpl(
      remoteDataSource: serviceLocator<SessionsRemoteDataSource>(),
    ),
  );

  // Profile repositories  
  serviceLocator.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(
      remoteDataSource: serviceLocator<UsersRemoteDataSource>(),
    ),
  );

  // Register BLoCs
  serviceLocator.registerLazySingleton<AuthBloc>(
    () => AuthBloc(
      authRepository: serviceLocator<AuthRepository>(),
    ),
  );

  serviceLocator.registerLazySingleton<UsersBloc>(
    () => UsersBloc(
    repository: serviceLocator<UsersRepository>(),
    ),
  );

  serviceLocator.registerLazySingleton<UserPermissionsBloc>(
    () => UserPermissionsBloc(
      repository: serviceLocator<PermissionsRepository>(),
    ),
  );

  serviceLocator.registerFactory<ProfilesBloc>(
    () => ProfilesBloc(
      repository: serviceLocator<ProfileRepository>(),
    ),
  );

  serviceLocator.registerLazySingleton<GroupPermissionsBloc>(
    () => GroupPermissionsBloc(
      repository: serviceLocator<PermissionsRepository>(),
    ),
  );

  serviceLocator.registerLazySingleton<PermissionsBloc>(
    () => PermissionsBloc(
      repository: serviceLocator<PermissionsRepository>(),
    ),
  );

  serviceLocator.registerLazySingleton<GroupsBloc>(
    () => GroupsBloc(
      repository: serviceLocator<GroupsRepository>(),
    ),
  );

  serviceLocator.registerLazySingleton<DashboardBloc>(
    () => DashboardBloc(
      repository: serviceLocator<StatsRepository>(),
    ),
  );

  serviceLocator.registerLazySingleton<SessionsBloc>(
    () => SessionsBloc(
      sessionsRepository: serviceLocator<SessionsRepository>(),
    ),
  );

  serviceLocator.registerLazySingleton<ThemeBloc>(
    () => ThemeBloc(sharedPreferences: sharedPreferences),
  );
  
  serviceLocator.registerLazySingleton<AppBloc>(
    () => AppBloc(authBloc: serviceLocator<AuthBloc>()),
  );

}
