import 'environment.dart';
import 'dev_environment.dart';
import 'staging_environment.dart';
import 'prod_environment.dart';

/// Environment types supported by the application
enum EnvironmentType {
  development,
  staging,
  production,
}

/// Factory class for managing environment configurations
class EnvironmentConfig {
  static Environment? _currentEnvironment;

  /// Get the current environment configuration
  static Environment get current {
    if (_currentEnvironment == null) {
      throw StateError(
        'Environment not initialized. Call EnvironmentConfig.initialize() first.',
      );
    }
    return _currentEnvironment!;
  }

  /// Initialize the environment configuration
  /// This should be called during app startup
  static void initialize(EnvironmentType type) {
    switch (type) {
      case EnvironmentType.development:
        _currentEnvironment = DevEnvironment();
        break;
      case EnvironmentType.staging:
        _currentEnvironment = StagingEnvironment();
        break;
      case EnvironmentType.production:
        _currentEnvironment = ProdEnvironment();
        break;
    }
  }

  /// Initialize environment based on string value
  /// Useful for reading from environment variables or build configurations
  static void initializeFromString(String environmentName) {
    final type = _parseEnvironmentType(environmentName);
    initialize(type);
  }

  /// Parse environment type from string
  static EnvironmentType _parseEnvironmentType(String environmentName) {
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
        // Default to development for unknown environments
        return EnvironmentType.development;
    }
  }

  /// Check if current environment is development
  static bool get isDevelopment =>
      _currentEnvironment?.environmentName == 'development';

  /// Check if current environment is staging
  static bool get isStaging =>
      _currentEnvironment?.environmentName == 'staging';

  /// Check if current environment is production
  static bool get isProduction =>
      _currentEnvironment?.environmentName == 'production';
}
