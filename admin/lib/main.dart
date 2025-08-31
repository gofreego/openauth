import 'package:flutter/material.dart';
import 'app.dart';
import 'config/dependency_injection/service_locator.dart';
import 'config/environment/environment_config.dart';

void main() async {
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();
  
  // Determine environment from build mode or environment variables
  // You can also read from --dart-define or environment variables
  const String environmentName = String.fromEnvironment(
    'ENVIRONMENT',
    defaultValue: 'development',
  );
  
  final environmentType = _parseEnvironmentType(environmentName);
  
  // Initialize dependencies with environment
  await initializeDependencies(environmentType: environmentType);
  
  // Run the app
  runApp(const OpenAuthAdmin());
}

/// Parse environment type from string
EnvironmentType _parseEnvironmentType(String environmentName) {
  switch (environmentName.toLowerCase()) {
    case 'dev':
    case 'development':
      return EnvironmentType.development;
    case 'staging':
    case 'stage':
      return EnvironmentType.staging;
    case 'prod':
    case 'production':
      return EnvironmentType.production;
    default:
      return EnvironmentType.development;
  }
}
