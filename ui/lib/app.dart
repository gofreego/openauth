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
        
      ],
      redirect: (context, state) {
        final appBloc = context.read<AppBloc>();
        final appState = appBloc.state;

        // Show splash screen while app is loading
        if (appState is AppLoading) {
          return AppRoutes.splash;
        }

          if (appState is AppAuthenticated) {
            return AppRoutes.home;
          }
          return null;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
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
              title: 'BappaApp',
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
