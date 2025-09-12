import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:openauth/features/home/presentation/pages/home_page.dart';
import 'package:openauth/features/configs/presentation/pages/configs_page.dart';
import 'app_routes.dart';

class AppRouter {
  static GoRouter router = GoRouter(
    initialLocation: AppRoutes.splash,
    routes: [
      
      GoRoute(
        path: AppRoutes.home,
        name: 'home',
        builder: (context, state) {
          return const HomePage();
        },
      ),
      GoRoute(
        path: AppRoutes.comingSoon,
        name: 'comingSoon',
        builder: (context, state) {
          return const ComingSoonPage();
        },
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(
        title: const Text('Error'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              'Page not found: ${state.uri.path}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go(AppRoutes.home),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
  );
}
