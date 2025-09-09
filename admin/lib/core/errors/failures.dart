import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  const Failure({required this.message, this.title = 'Something went wrong'});

  final String message;
  final String title;
  static Failure fromException(Exception exception) {
    if (exception is DioException){
      if (exception.type == DioExceptionType.connectionTimeout ||
          exception.type == DioExceptionType.sendTimeout ||
          exception.type == DioExceptionType.receiveTimeout) {
        return const NetworkFailure(message: 'Connection timed out. Please check your internet connection.');
      } else if (exception.type == DioExceptionType.badResponse) {
        final statusCode = exception.response?.statusCode ?? 0;
         if (statusCode == 401) {
          return const AuthenticationFailure(message: 'Authentication failed. Please log in again.');
        } else if (statusCode == 400) {
          final errorMessage = exception.response?.data['message'] ?? 'Unknown error occurred';
       
          return ValidationFailure(message: 'Bad request: $errorMessage');
        } else if (statusCode == 403) {
          return const PermissionFailure(message: 'You do not have permission to perform this action.');
        } else if (statusCode == 404) {
          return const ServerFailure(message: 'Requested resource not found.');
        }
        else if (statusCode == 503) {
          return const ServiceUnavailableFailure(message: 'Service is currently unavailable. Please try again later.');
        } else {
          final errorMessage = exception.response?.data['message'] ?? 'Unknown error occurred';
       
          return ServerFailure(message: 'Server error ($statusCode): $errorMessage');
        }
      } else if (exception.type == DioExceptionType.cancel) {
        return const NetworkFailure(message: 'Request was cancelled. Please try again.');
      } else if (exception.type == DioExceptionType.connectionError) {
        return const NetworkFailure(message: 'Server is unreachable. Please check your internet connection. \n Or our server is down, please try again later.');
      }else {
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
  const ServerFailure({required super.message, super.title = 'Server Error'});
}

class CacheFailure extends Failure {
  const CacheFailure({required super.message, super.title = 'Cache Error'});
}

class NetworkFailure extends Failure {
  const NetworkFailure({required super.message, super.title = 'Network Error'});
}

class ValidationFailure extends Failure {
  const ValidationFailure({required super.message, super.title = 'Validation Error'});
}

class AuthenticationFailure extends Failure {
  const AuthenticationFailure({required super.message, super.title = 'Authentication Failed'});
}

class PermissionFailure extends Failure {
  const PermissionFailure({required super.message, super.title = 'Permission Denied'});
}

class ServiceUnavailableFailure extends Failure {
  const ServiceUnavailableFailure({required super.message, super.title = 'Service Unavailable'});
}

class UnknownFailure extends Failure {
  const UnknownFailure({required super.message, super.title = 'Something went wrong'});
}
