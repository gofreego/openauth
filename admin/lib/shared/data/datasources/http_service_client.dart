import 'package:dio/dio.dart';
import '../../../core/network/http_client.dart';

/// A shared client for the Catalog Service that provides common functionality
/// for all catalog-related operations (topics, questions, grades)
class HTTPServiceClient {
  HttpClient? _httpClient;
  bool _isInitialized = false;
  
  HTTPServiceClient();

  /// Initialize the HTTP client
  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      _httpClient = await HttpClient.getInstance();
      _isInitialized = true;
    }
  }

  /// Performs a GET request to the catalog service
  Future<T> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      await _ensureInitialized();
      final response = await _httpClient!.get<T>(
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
      await _ensureInitialized();
      final response = await _httpClient!.post<T>(
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
      await _ensureInitialized();
      final response = await _httpClient!.put<T>(
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
      await _ensureInitialized();
      final response = await _httpClient!.delete<T>(
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
