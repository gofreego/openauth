import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  const Failure({required this.message});

  final String message;
  static Failure fromException(Exception exception) {
    if (exception is DioException){
      if (exception.type == DioExceptionType.connectionTimeout ||
          exception.type == DioExceptionType.sendTimeout ||
          exception.type == DioExceptionType.receiveTimeout) {
        return const NetworkFailure(message: 'Connection timed out. Please check your internet connection.');
      } else if (exception.type == DioExceptionType.badResponse) {
        final statusCode = exception.response?.statusCode ?? 0;
        final errorMessage = exception.response?.data['message'] ?? 'Unknown error occurred';
        if (statusCode == 401) {
          return const AuthenticationFailure(message: 'Authentication failed. Please log in again.');
        } else if (statusCode == 503) {
          return const ServiceUnavailableFailure(message: 'Service is currently unavailable. Please try again later.');
        } else {
          return ServerFailure(message: 'Server error ($statusCode): $errorMessage');
        }
      } else if (exception.type == DioExceptionType.cancel) {
        return const NetworkFailure(message: 'Request was cancelled. Please try again.');
      } else {
        return const NetworkFailure(message: 'Network error occurred. Please check your connection.');
      }
    }
    
    // Map different exception types to specific Failure types
    // For simplicity, we return a generic ServerFailure here
    return UnknownFailure(message: exception.toString());
  }
  @override
  List<Object> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure({required super.message});
}

class CacheFailure extends Failure {
  const CacheFailure({required super.message});
}

class NetworkFailure extends Failure {
  const NetworkFailure({required super.message});
}

class ValidationFailure extends Failure {
  const ValidationFailure({required super.message});
}

class AuthenticationFailure extends Failure {
  const AuthenticationFailure({required super.message});
}

class ServiceUnavailableFailure extends Failure {
  const ServiceUnavailableFailure({required super.message});
}

class UnknownFailure extends Failure {
  const UnknownFailure({required super.message});
}
