import 'environment.dart';

/// Production environment configuration
/// Uses production URLs and optimized settings
class ProdEnvironment implements Environment {
  @override
  String get environmentName => 'production';

  @override
  String get apiBaseUrl => '';

  @override
  bool get isDebug => false;

  @override
  Duration get connectTimeout => const Duration(seconds: 15);

  @override
  Duration get receiveTimeout => const Duration(seconds: 15);

  @override
  bool get enableLogging => false;

  @override
  Map<String, dynamic> get additionalConfig => {
    'enableMockData': false,
    'logLevel': 'error',
    'enablePerformanceMonitoring': false,
    'enableCrashReporting': true,
  };
}
