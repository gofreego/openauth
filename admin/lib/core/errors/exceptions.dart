/// Base exception class for all custom exceptions
abstract class AppException implements Exception {
  final String message;
  final int? statusCode;

  const AppException({
    required this.message,
    this.statusCode,
  });

  @override
  String toString() => 'AppException: $message';
}

/// Exception thrown when there's a server error
class ServerException extends AppException {
  const ServerException({
    required super.message,
    super.statusCode,
  });

  @override
  String toString() => 'ServerException: $message';
}

/// Exception thrown when there's a network error
class NetworkException extends AppException {
  const NetworkException({
    required super.message,
    super.statusCode,
  });

  @override
  String toString() => 'NetworkException: $message';
}

/// Exception thrown when there's a cache error
class CacheException extends AppException {
  const CacheException({
    required super.message,
    super.statusCode,
  });

  @override
  String toString() => 'CacheException: $message';
}

/// Exception thrown when validation fails
class ValidationException extends AppException {
  const ValidationException({
    required super.message,
    super.statusCode,
  });

  @override
  String toString() => 'ValidationException: $message';
}

/// Exception thrown when authentication fails
class AuthenticationException extends AppException {
  const AuthenticationException({
    required super.message,
    super.statusCode,
  });

  @override
  String toString() => 'AuthenticationException: $message';
}
