import 'package:dio/dio.dart';
import '../errors/failures.dart';

/// Common error handler for DioException across the application
class ErrorHandler {
  /// Handles DioException and converts to appropriate Failure
  static Failure handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const NetworkFailure(
          message: 'Connection timeout. Please check your internet connection and try again.',
        );
      
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final responseMessage = e.response?.data is Map<String, dynamic> 
            ? e.response?.data['message'] 
            : null;
        
        switch (statusCode) {
          case 400:
            return ValidationFailure(
              message: responseMessage ?? 'Invalid request. Please check your input and try again.',
            );
          case 401:
            return const AuthenticationFailure(
              message: 'Authentication required. Please log in and try again.',
            );
          case 403:
            return const AuthenticationFailure(
              message: 'Access denied. You don\'t have permission to access this resource.',
            );
          case 404:
            return const ServiceUnavailableFailure(
              message: 'The requested content is currently unavailable. Please check back later.',
            );
          case 500:
            return const ServiceUnavailableFailure(
              message: 'The service is temporarily unavailable. Please try again later.',
            );
          case 502:
          case 503:
          case 504:
            return const ServiceUnavailableFailure(
              message: 'The service is currently down for maintenance. Please try again later.',
            );
          default:
            return ServiceUnavailableFailure(
              message: responseMessage ?? 'Our service is temporarily down. Please check back later.',
            );
        }
      
      case DioExceptionType.cancel:
        return const ServerFailure(message: 'Request was cancelled. Please try again.');
      
      case DioExceptionType.unknown:
      default:
        // Check if it's a connection error
        if (e.message?.toLowerCase().contains('network') == true ||
            e.message?.toLowerCase().contains('connection') == true ||
            e.message?.toLowerCase().contains('timeout') == true) {
          return const NetworkFailure(
            message: 'Unable to connect to the service. Please check your internet connection.',
          );
        }
        return const ServiceUnavailableFailure(
          message: 'The service is currently unavailable. Please try again later.',
        );
    }
  }

  /// Handles general exceptions and converts to ServiceUnavailableFailure
  static Failure handleGeneralException(dynamic e, {String? customMessage}) {
    return ServiceUnavailableFailure(
      message: customMessage ?? 'Our service is temporarily down. Please check back later.',
    );
  }
}
