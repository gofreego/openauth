import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/dashboard_screen.dart';
import '../screens/permissions/permissions_list_screen.dart';
import '../screens/permissions/permission_detail_screen.dart';
import '../screens/permissions/permission_form_screen.dart';

class AdminApp extends StatelessWidget {
  const AdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'OpenAuth Admin',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        cardTheme: CardTheme(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      routerConfig: _router,
    );
  }
}

final GoRouter _router = GoRouter(
  initialLocation: '/',
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const DashboardScreen();
      },
    ),
    GoRoute(
      path: '/permissions',
      builder: (BuildContext context, GoRouterState state) {
        return const PermissionsListScreen();
      },
    ),
    GoRoute(
      path: '/permissions/new',
      builder: (BuildContext context, GoRouterState state) {
        return const PermissionFormScreen();
      },
    ),
    GoRoute(
      path: '/permissions/:id',
      builder: (BuildContext context, GoRouterState state) {
        final id = int.tryParse(state.pathParameters['id'] ?? '');
        if (id == null) {
          return const Scaffold(
            body: Center(child: Text('Invalid permission ID')),
          );
        }
        return PermissionDetailScreen(permissionId: id);
      },
    ),
    GoRoute(
      path: '/permissions/:id/edit',
      builder: (BuildContext context, GoRouterState state) {
        final id = int.tryParse(state.pathParameters['id'] ?? '');
        if (id == null) {
          return const Scaffold(
            body: Center(child: Text('Invalid permission ID')),
          );
        }
        return PermissionFormScreen(permissionId: id);
      },
    ),
  ],
);
