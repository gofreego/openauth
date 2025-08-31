import 'package:flutter/material.dart';
import '../../features/home/presentation/pages/home_page.dart';
import 'app_routes.dart';

class RouteGenerator {
  // Private constructor to prevent instantiation
  RouteGenerator._();

  /// Generates routes for the application
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.home:
        return MaterialPageRoute(
          builder: (_) => const HomePage(),
          settings: settings,
        );
      default:
        return _errorRoute(settings);
    }
  }

  /// Returns an error route for undefined routes
  static Route<dynamic> _errorRoute(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (context) => Scaffold(
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
                'Route not found: ${settings.name}',
                style: const TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Go Back'),
              ),
            ],
          ),
        ),
      ),
      settings: settings,
    );
  }

  /// Get all routes as a map (for backward compatibility if needed)
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      AppRoutes.home: (context) => const HomePage(),
    };
  }
}
