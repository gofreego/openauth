# Environment Configuration

This directory contains environment-specific configurations for the BappaApp.

## Available Environments

### Development (`dev_environment.dart`)
- **API Base URL**: `https://api.examapp.com`
- **Catalog Service URL**: `http://localhost:8081/catalogservice/`
- **Debug Mode**: Enabled
- **Logging**: Enabled
- **Timeout**: 30 seconds

### Staging (`staging_environment.dart`)
- **API Base URL**: `https://staging-api.examapp.com`
- **Catalog Service URL**: `https://staging-catalog.examapp.com/catalogservice/`
- **Debug Mode**: Enabled
- **Logging**: Enabled
- **Timeout**: 20 seconds

### Production (`prod_environment.dart`)
- **API Base URL**: `https://api.examapp.com`
- **Catalog Service URL**: `https://catalog.examapp.com/catalogservice/`
- **Debug Mode**: Disabled
- **Logging**: Disabled (errors only)
- **Timeout**: 15 seconds

## How to Use Different Environments

### 1. Using --dart-define (Recommended)

```bash
# Development (default)
flutter run

# Staging
flutter run --dart-define=ENVIRONMENT=staging

# Production
flutter run --dart-define=ENVIRONMENT=production
```

### 2. Building for Different Environments

```bash
# Build for staging
flutter build apk --dart-define=ENVIRONMENT=staging

# Build for production
flutter build apk --dart-define=ENVIRONMENT=production
```

### 3. Web Builds

```bash
# Development
flutter build web

# Staging
flutter build web --dart-define=ENVIRONMENT=staging

# Production
flutter build web --dart-define=ENVIRONMENT=production
```

## Adding New Environments

1. Create a new environment class implementing the `Environment` interface
2. Add the new environment type to `EnvironmentType` enum in `environment_config.dart`
3. Update the factory method in `EnvironmentConfig.initialize()`
4. Update the parsing logic in both `environment_config.dart` and `main.dart`

## Environment Variables

The app reads the `ENVIRONMENT` variable to determine which configuration to use:
- `dev` or `development` → Development environment
- `staging` or `stage` → Staging environment  
- `prod` or `production` → Production environment
- Any other value → Defaults to development

## Configuration Properties

Each environment configuration includes:
- **environmentName**: Human-readable name
- **apiBaseUrl**: Main API service URL
- **catalogServiceBaseUrl**: Catalog service URL
- **isDebug**: Debug mode flag
- **connectTimeout**: HTTP connection timeout
- **receiveTimeout**: HTTP receive timeout
- **enableLogging**: Logging flag
- **additionalConfig**: Environment-specific settings

## Usage in Code

```dart
import 'package:bappaapp/config/environment/environment_config.dart';

// Get current environment
final environment = EnvironmentConfig.current;

// Access configuration
final apiUrl = environment.apiBaseUrl;
final catalogUrl = environment.catalogServiceBaseUrl;
final isDebug = environment.isDebug;

// Check environment type
if (EnvironmentConfig.isDevelopment) {
  // Development-specific code
}
```
