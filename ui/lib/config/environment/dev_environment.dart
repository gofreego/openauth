import 'environment.dart';

/// Development environment configuration
/// Uses localhost URLs for local development
class DevEnvironment implements Environment {
  @override
  String get environmentName => 'development';

  @override
  String get apiBaseUrl => 'http://localhost:8081';

  @override
  bool get isDebug => true;

  @override
  Duration get connectTimeout => const Duration(seconds: 30);

  @override
  Duration get receiveTimeout => const Duration(seconds: 30);

  @override
  bool get enableLogging => true;

  @override
  Map<String, dynamic> get additionalConfig => {
    'enableMockData': true,
    'logLevel': 'debug',
    'enablePerformanceMonitoring': true,
  };
}
