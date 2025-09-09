import 'environment.dart';

/// Staging environment configuration
/// Uses staging URLs for pre-production testing
class StagingEnvironment implements Environment {
  @override
  String get environmentName => 'staging';

  @override
  String get apiBaseUrl => '';

  @override
  bool get isDebug => true;

  @override
  Duration get connectTimeout => const Duration(seconds: 20);

  @override
  Duration get receiveTimeout => const Duration(seconds: 20);

  @override
  bool get enableLogging => true;

  @override
  Map<String, dynamic> get additionalConfig => {
    'enableMockData': false,
    'logLevel': 'info',
    'enablePerformanceMonitoring': true,
    'enableCrashReporting': true,
  };
}
