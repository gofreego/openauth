/// Base environment configuration class
/// Defines the contract for all environment-specific configurations
abstract class Environment {
  /// The name of the environment (dev, staging, prod, etc.)
  String get environmentName;
  
  /// Base URL for the main API service
  String get apiBaseUrl;
  
  /// Whether this is a debug/development environment
  bool get isDebug;
  
  /// Connection timeout for HTTP requests
  Duration get connectTimeout;
  
  /// Receive timeout for HTTP requests
  Duration get receiveTimeout;
  
  /// Whether to enable logging
  bool get enableLogging;
  
  /// Any additional environment-specific configurations
  Map<String, dynamic> get additionalConfig;
}
