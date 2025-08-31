import 'package:dio/dio.dart';
import '../../../config/environment/environment_config.dart';

/// A shared client for the Catalog Service that provides common functionality
/// for all catalog-related operations (topics, questions, grades)
class HTTPServiceClient {
  const HTTPServiceClient();

  /// Creates a configured Dio instance for catalog service requests
  Dio _createDioInstance() {
    final environment = EnvironmentConfig.current;
    return Dio(BaseOptions(
      baseUrl: environment.apiBaseUrl,
      connectTimeout: environment.connectTimeout,
      receiveTimeout: environment.receiveTimeout,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));
  }

  /// Performs a GET request to the catalog service
  Future<T> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final dio = _createDioInstance();
      final response = await dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
      );
      
      if (response.data != null) {
        return response.data!;
      } else {
        throw Exception('No data received from catalog service');
      }
    } on DioException catch (e) {
      throw Exception('HTTP service request failed: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error in HTTP service: $e');
    }
  }

  /// Performs a POST request to the catalog service
  Future<T> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final dio = _createDioInstance();
      final response = await dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      
      if (response.data != null) {
        return response.data!;
      } else {
        throw Exception('No data received from catalog service');
      }
    } on DioException catch (e) {
      throw Exception('Catalog service request failed: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error in catalog service: $e');
    }
  }

  /// Performs a PUT request to the catalog service
  Future<T> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final dio = _createDioInstance();
      final response = await dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      
      if (response.data != null) {
        return response.data!;
      } else {
        throw Exception('No data received from catalog service');
      }
    } on DioException catch (e) {
      throw Exception('HTTP service request failed: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error in HTTP service: $e');
    }
  }

  /// Performs a DELETE request to the catalog service
  Future<T> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final dio = _createDioInstance();
      final response = await dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      
      if (response.data != null) {
        return response.data!;
      } else {
        throw Exception('No data received from catalog service');
      }
    } on DioException catch (e) {
      throw Exception('HTTP service request failed: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error in HTTP service: $e');
    }
  }
}
