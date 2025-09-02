import 'package:dio/dio.dart';
import 'dart:async';
import 'http_client.dart';

class ApiService {
  HttpClient? _httpClient;
  bool _isInitialized = false;

  ApiService();

  /// Ensure HTTP client is initialized
  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      _httpClient = await HttpClient.getInstance();
      _isInitialized = true;
    }
  }

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      await _ensureInitialized();
      return await _httpClient!.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      await _ensureInitialized();
      return await _httpClient!.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      await _ensureInitialized();
      return await _httpClient!.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      await _ensureInitialized();
      return await _httpClient!.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Manually set authorization header for testing or special cases
  void setAuthorizationHeader(String token) {
    // This is handled by the singleton HttpClient now
  }

  /// Remove authorization header
  void removeAuthorizationHeader() {
    // This is handled by the singleton HttpClient now
  }
}
