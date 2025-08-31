import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
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
import 'shared/shared.dart';

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
          builder: (context, state) => Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const AppLogo.extraLarge(withBackground: true),
                  const SizedBox(height: 24),
                  Text(
                    'OpenAuth',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const CircularProgressIndicator(),
                ],
              ),
            ),
          ),
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

          if (appState is AppAuthenticated) {
            return AppRoutes.home;
          }
          
          if (appState is AppUnauthenticated) {
            return AppRoutes.signIn;
          }
          
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
