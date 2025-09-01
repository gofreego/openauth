import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/permissions_bloc.dart';
import 'permissions_page.dart';
import '../../../../config/dependency_injection/service_locator.dart';

class PermissionsPageWrapper extends StatelessWidget {
  const PermissionsPageWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => serviceLocator<PermissionsBloc>()
        ..add(const LoadPermissions()),
      child: const PermissionsPage(),
    );
  }
}

// Alternative implementation that can be used if the above doesn't work
class PermissionsPageWithProvider extends StatelessWidget {
  const PermissionsPageWithProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _ensureDependenciesReady(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Loading permissions...'),
                ],
              ),
            ),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  const Text('Failed to initialize permissions'),
                  const SizedBox(height: 8),
                  Text('Error: ${snapshot.error}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // Force rebuild
                      (context as Element).markNeedsBuild();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        return BlocProvider(
          create: (context) => serviceLocator<PermissionsBloc>()
            ..add(const LoadPermissions()),
          child: const PermissionsPage(),
        );
      },
    );
  }

  Future<void> _ensureDependenciesReady() async {
    // Small delay to ensure service locator is fully initialized
    await Future.delayed(const Duration(milliseconds: 100));
    
    // Check if all required dependencies are registered
    if (!serviceLocator.isRegistered<PermissionsBloc>()) {
      throw Exception('PermissionsBloc not registered in service locator');
    }
    
    // Try to create the bloc to ensure all dependencies are available
    try {
      final bloc = serviceLocator<PermissionsBloc>();
      bloc.close(); // Clean up test instance
    } catch (e) {
      throw Exception('Failed to create PermissionsBloc: $e');
    }
  }
}
