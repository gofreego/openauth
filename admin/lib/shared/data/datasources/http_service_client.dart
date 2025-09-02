import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../config/environment/environment_config.dart';
import '../../services/session_manager.dart';

/// A shared client for the Catalog Service that provides common functionality
/// for all catalog-related operations (topics, questions, grades)
class HTTPServiceClient {
  SessionManager? _sessionManager;
  
  HTTPServiceClient();

  /// Initialize session manager for authentication
  Future<void> initializeAuth() async {
    if (_sessionManager == null) {
      final prefs = await SharedPreferences.getInstance();
      _sessionManager = SessionManager(prefs);
    }
  }

  /// Creates a configured Dio instance for catalog service requests
  Future<Dio> _createDioInstance() async {
    await initializeAuth();
    
    final environment = EnvironmentConfig.current;
    final dio = Dio(BaseOptions(
      baseUrl: environment.apiBaseUrl,
      connectTimeout: environment.connectTimeout,
      receiveTimeout: environment.receiveTimeout,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    // Add auth interceptor
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          if (_sessionManager != null) {
            final token = await _sessionManager!.getAccessToken();
            if (token != null && token.isNotEmpty) {
              options.headers['Authorization'] = 'Bearer $token';
            }
          }
          handler.next(options);
        },
      ),
    );

    return dio;
  }

  /// Performs a GET request to the catalog service
  Future<T> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final dio = await _createDioInstance();
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
      final dio = await _createDioInstance();
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
      final dio = await _createDioInstance();
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
      final dio = await _createDioInstance();
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
