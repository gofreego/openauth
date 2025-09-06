import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:openauth/features/splash/presentation/pages/splash_screen.dart';
import 'core/themes/app_theme.dart';
import 'config/dependency_injection/service_locator.dart';
import 'config/routes/app_routes.dart';
import 'core/bloc/app_bloc.dart';
import 'core/bloc/app_event.dart';
import 'core/bloc/app_state.dart';
import 'core/bloc/theme_bloc.dart';
import 'core/bloc/theme_event.dart';
import 'core/bloc/theme_state.dart';
import 'features/home/presentation/pages/home_page.dart';
import 'features/auth/presentation/pages/sign_in_page.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/users/presentation/bloc/users_bloc.dart';
import 'features/users/presentation/bloc/user_permissions_bloc.dart';
import 'features/permissions/presentation/bloc/permissions_bloc.dart';
import 'features/groups/presentation/bloc/groups_bloc.dart';
import 'features/groups/presentation/bloc/group_permissions_bloc.dart';
import 'features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'features/sessions/presentation/bloc/sessions_bloc.dart';

class OpenAuthAdmin extends StatefulWidget {
  const OpenAuthAdmin({super.key});

  @override
  State<OpenAuthAdmin> createState() => _OpenAuthAdminState();
}

class _OpenAuthAdminState extends State<OpenAuthAdmin> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();

    _router = GoRouter(
      initialLocation: AppRoutes.splash,
      routes: [
        GoRoute(
          path: AppRoutes.splash,
          builder: (context, state) => const SplashScreen(),
        ),
        GoRoute(
          path: AppRoutes.signIn,
          builder: (context, state) => const SignInPage(),
        ),
        GoRoute(
          path: AppRoutes.home,
          builder: (context, state) => const HomePage(),
        ),
      ],
      redirect: (context, state) {
        try {
          final appBloc = context.read<AppBloc>();
          final appState = appBloc.state;

          // Show splash screen while app is loading
          if (appState is AppLoading) {
            return AppRoutes.splash;
          }

          // If we're authenticated, go to home (unless already there)
          if (appState is AppAuthenticated) {
            if (state.uri.path == AppRoutes.signIn || state.uri.path == AppRoutes.splash) {
              return AppRoutes.home;
            }
            return null; // Stay on current route
          }
          
          // If we're unauthenticated, go to sign in (unless already there)
          if (appState is AppUnauthenticated) {
            if (state.uri.path != AppRoutes.signIn) {
              return AppRoutes.signIn;
            }
            return null; // Stay on sign in page
          }
          
          // For any other state, stay on current route
          return null;
        } catch (e) {
          // If we can't read the bloc yet, stay on splash
          return AppRoutes.splash;
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => serviceLocator<AuthBloc>(),
        ),
        BlocProvider<AppBloc>(
          create: (context) =>
              serviceLocator<AppBloc>()..add(const AppStarted()),
        ),
        BlocProvider<ThemeBloc>(
          create: (context) =>
              serviceLocator<ThemeBloc>()..add(const ThemeInitialized()),
        ),
        BlocProvider<UsersBloc>(
          create: (context) => serviceLocator<UsersBloc>(),
        ),
        BlocProvider<UserPermissionsBloc>(
          create: (context) => serviceLocator<UserPermissionsBloc>(),
        ),
        BlocProvider<GroupPermissionsBloc>(
          create: (context) => serviceLocator<GroupPermissionsBloc>(),
        ),
        BlocProvider<PermissionsBloc>(
          create: (context) => serviceLocator<PermissionsBloc>(),
        ),
        BlocProvider<GroupsBloc>(
          create: (context) => serviceLocator<GroupsBloc>(),
        ),
        BlocProvider<DashboardBloc>(
          create: (context) => serviceLocator<DashboardBloc>(),
        ),
        BlocProvider<SessionsBloc>(
          create: (context) => serviceLocator<SessionsBloc>(),
        ),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, themeState) {
          return BlocListener<AppBloc, AppState>(
            listener: (context, state) {
              // Refresh router when app state changes
              _router.refresh();
            },
            child: MaterialApp.router(
              title: 'OpenAuth Admin',
              debugShowCheckedModeBanner: false,
              themeMode: themeState.themeMode,
              theme: AppTheme.getTheme(false), // Light theme
              darkTheme: AppTheme.getTheme(true), // Dark theme
              routerConfig: _router,
            ),
          );
        },
      ),
    );
  }
}
