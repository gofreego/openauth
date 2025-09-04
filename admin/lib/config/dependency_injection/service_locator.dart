import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../environment/environment_config.dart';
import '../../core/network/api_service.dart';
import '../../core/bloc/theme_bloc.dart';
import '../../core/bloc/app_bloc.dart';
import '../../shared/shared.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/usecases/sign_in_usecase.dart';
import '../../features/auth/domain/usecases/sign_out_usecase.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';

// Users feature dependencies
import '../../features/users/data/datasources/users_remote_datasource_impl.dart';
import '../../features/users/data/repositories/users_repository_impl.dart';
import '../../features/users/data/repositories/users_repository.dart';
import '../../features/users/domain/usecases/get_users_usecase.dart';
import '../../features/users/domain/usecases/get_user_usecase.dart';
import '../../features/users/domain/usecases/create_user_usecase.dart';
import '../../features/users/domain/usecases/update_user_usecase.dart';
import '../../features/users/domain/usecases/delete_user_usecase.dart';
import '../../features/users/presentation/bloc/users_bloc.dart';
import '../../features/users/presentation/bloc/user_permissions_bloc.dart';

// Permissions feature dependencies
import '../../features/permissions/data/datasources/permissions_remote_datasource_impl.dart';
import '../../features/permissions/data/repositories/permissions_repository_impl.dart';
import '../../features/permissions/domain/repositories/permissions_repository.dart';
import '../../features/permissions/domain/usecases/get_permissions_usecase.dart';
import '../../features/permissions/domain/usecases/get_permission_usecase.dart';
import '../../features/permissions/domain/usecases/create_permission_usecase.dart';
import '../../features/permissions/domain/usecases/update_permission_usecase.dart';
import '../../features/permissions/domain/usecases/delete_permission_usecase.dart';
import '../../features/permissions/presentation/bloc/permissions_bloc.dart';

// Groups feature dependencies
import '../../features/groups/data/datasources/groups_remote_datasource_impl.dart';
import '../../features/groups/data/repositories/groups_repository_impl.dart';
import '../../features/groups/domain/repositories/groups_repository.dart';
import '../../features/groups/domain/usecases/get_groups_usecase.dart';
import '../../features/groups/domain/usecases/get_group_usecase.dart';
import '../../features/groups/domain/usecases/get_group_users_usecase.dart';
import '../../features/groups/domain/usecases/create_group_usecase.dart';
import '../../features/groups/domain/usecases/update_group_usecase.dart';
import '../../features/groups/domain/usecases/delete_group_usecase.dart';
import '../../features/groups/presentation/bloc/groups_bloc.dart';

// Dashboard feature dependencies
import '../../features/dashboard/data/datasources/stats_remote_datasource.dart';
import '../../features/dashboard/data/repositories/stats_repository_impl.dart';
import '../../features/dashboard/domain/repositories/stats_repository.dart';
import '../../features/dashboard/domain/usecases/get_stats_usecase.dart';
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

  // Auth Use Cases
  serviceLocator.registerLazySingleton<SignInUseCase>(
    () => SignInUseCase(serviceLocator<AuthRepository>()),
  );
  
  serviceLocator.registerLazySingleton<SignOutUseCase>(
    () => SignOutUseCase(serviceLocator<AuthRepository>()),
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

  // Users use cases
  serviceLocator.registerLazySingleton<GetUsersUseCase>(
    () => GetUsersUseCase(serviceLocator<UsersRepository>()),
  );

  serviceLocator.registerLazySingleton<GetUserUseCase>(
    () => GetUserUseCase(serviceLocator<UsersRepository>()),
  );

  serviceLocator.registerLazySingleton<CreateUserUseCase>(
    () => CreateUserUseCase(serviceLocator<UsersRepository>()),
  );

  serviceLocator.registerLazySingleton<UpdateUserUseCase>(
    () => UpdateUserUseCase(serviceLocator<UsersRepository>()),
  );

  serviceLocator.registerLazySingleton<DeleteUserUseCase>(
    () => DeleteUserUseCase(serviceLocator<UsersRepository>()),
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

  // Permissions use cases
  serviceLocator.registerLazySingleton<GetPermissionsUseCase>(
    () => GetPermissionsUseCase(serviceLocator<PermissionsRepository>()),
  );

  serviceLocator.registerLazySingleton<GetPermissionUseCase>(
    () => GetPermissionUseCase(serviceLocator<PermissionsRepository>()),
  );

  serviceLocator.registerLazySingleton<CreatePermissionUseCase>(
    () => CreatePermissionUseCase(serviceLocator<PermissionsRepository>()),
  );

  serviceLocator.registerLazySingleton<UpdatePermissionUseCase>(
    () => UpdatePermissionUseCase(serviceLocator<PermissionsRepository>()),
  );

  serviceLocator.registerLazySingleton<DeletePermissionUseCase>(
    () => DeletePermissionUseCase(serviceLocator<PermissionsRepository>()),
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

  // Groups use cases
  serviceLocator.registerLazySingleton<GetGroupsUseCase>(
    () => GetGroupsUseCase(serviceLocator<GroupsRepository>()),
  );

  serviceLocator.registerLazySingleton<GetGroupUseCase>(
    () => GetGroupUseCase(serviceLocator<GroupsRepository>()),
  );

  serviceLocator.registerLazySingleton<GetGroupUsersUseCase>(
    () => GetGroupUsersUseCase(serviceLocator<GroupsRepository>()),
  );

  serviceLocator.registerLazySingleton<CreateGroupUseCase>(
    () => CreateGroupUseCase(serviceLocator<GroupsRepository>()),
  );

  serviceLocator.registerLazySingleton<UpdateGroupUseCase>(
    () => UpdateGroupUseCase(serviceLocator<GroupsRepository>()),
  );

  serviceLocator.registerLazySingleton<DeleteGroupUseCase>(
    () => DeleteGroupUseCase(serviceLocator<GroupsRepository>()),
  );

  // Dashboard data sources
  serviceLocator.registerLazySingleton<StatsRemoteDataSource>(
    () => StatsRemoteDataSourceImpl(serviceLocator<ApiService>()),
  );

  // Dashboard repositories
  serviceLocator.registerLazySingleton<StatsRepository>(
    () => StatsRepositoryImpl(
      remoteDataSource: serviceLocator<StatsRemoteDataSource>(),
    ),
  );

  // Dashboard use cases
  serviceLocator.registerLazySingleton<GetStatsUseCase>(
    () => GetStatsUseCase(serviceLocator<StatsRepository>()),
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

  // Register BLoCs
  serviceLocator.registerLazySingleton<AuthBloc>(
    () => AuthBloc(
      signInUseCase: serviceLocator<SignInUseCase>(),
      signOutUseCase: serviceLocator<SignOutUseCase>(),
      authRepository: serviceLocator<AuthRepository>(),
    ),
  );

  serviceLocator.registerLazySingleton<UsersBloc>(
    () => UsersBloc(
      getUsersUseCase: serviceLocator<GetUsersUseCase>(),
      getUserUseCase: serviceLocator<GetUserUseCase>(),
      createUserUseCase: serviceLocator<CreateUserUseCase>(),
      updateUserUseCase: serviceLocator<UpdateUserUseCase>(),
      deleteUserUseCase: serviceLocator<DeleteUserUseCase>(),
    ),
  );

  serviceLocator.registerLazySingleton<UserPermissionsBloc>(
    () => UserPermissionsBloc(
      apiService: serviceLocator<ApiService>(),
    ),
  );

  serviceLocator.registerLazySingleton<PermissionsBloc>(
    () => PermissionsBloc(
      getPermissionsUseCase: serviceLocator<GetPermissionsUseCase>(),
      getPermissionUseCase: serviceLocator<GetPermissionUseCase>(),
      createPermissionUseCase: serviceLocator<CreatePermissionUseCase>(),
      updatePermissionUseCase: serviceLocator<UpdatePermissionUseCase>(),
      deletePermissionUseCase: serviceLocator<DeletePermissionUseCase>(),
    ),
  );

  serviceLocator.registerLazySingleton<GroupsBloc>(
    () => GroupsBloc(
      getGroupsUseCase: serviceLocator<GetGroupsUseCase>(),
      getGroupUseCase: serviceLocator<GetGroupUseCase>(),
      getGroupUsersUseCase: serviceLocator<GetGroupUsersUseCase>(),
      createGroupUseCase: serviceLocator<CreateGroupUseCase>(),
      updateGroupUseCase: serviceLocator<UpdateGroupUseCase>(),
      deleteGroupUseCase: serviceLocator<DeleteGroupUseCase>(),
    ),
  );

  serviceLocator.registerLazySingleton<DashboardBloc>(
    () => DashboardBloc(
      getStatsUseCase: serviceLocator<GetStatsUseCase>(),
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
