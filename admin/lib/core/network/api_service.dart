import 'package:dio/dio.dart';
import 'dart:async';
import '../../config/environment/environment_config.dart';
import '../../shared/services/session_manager.dart';
import '../../src/generated/openauth/v1/sessions.pb.dart' as pb;

class ApiService {
  late final Dio _dio;
  final SessionManager? _sessionManager;

  ApiService([this._sessionManager]) {
    final environment = EnvironmentConfig.current;
    _dio = Dio(BaseOptions(
      baseUrl: environment.apiBaseUrl,
      connectTimeout: environment.connectTimeout,
      receiveTimeout: environment.receiveTimeout,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    _setupInterceptors();
  }

  void _setupInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Add auth token if available
          if (_sessionManager != null) {
            final token = await _sessionManager.getAccessToken();
            if (token != null && token.isNotEmpty) {
              options.headers['Authorization'] = 'Bearer $token';
            }
          }
          handler.next(options);
        },
        onError: (error, handler) async {
          // Handle 401 errors by attempting token refresh
          if (error.response?.statusCode == 401 && _sessionManager != null) {
            try {
              final tokens = await _sessionManager.getAuthTokens();
              if (tokens != null && tokens['refreshToken'] != null) {
                // Attempt to refresh token
                final refreshResponse = await _attemptTokenRefresh(tokens['refreshToken']!);
                if (refreshResponse != null && refreshResponse['accessToken'] != null) {
                  // Convert response to RefreshTokenResponse protobuf
                  final pbResponse = pb.RefreshTokenResponse()..mergeFromProto3Json(refreshResponse);
                  await _sessionManager.updateAuthTokens(pbResponse);
                  
                  // Retry original request with new token
                  final clonedRequest = await _dio.request(
                    error.requestOptions.path,
                    options: Options(
                      method: error.requestOptions.method,
                      headers: {
                        ...error.requestOptions.headers,
                        'Authorization': 'Bearer ${refreshResponse['accessToken']}',
                      },
                    ),
                    data: error.requestOptions.data,
                    queryParameters: error.requestOptions.queryParameters,
                  );
                  return handler.resolve(clonedRequest);
                }
              }
              // If refresh fails, clear session and let error propagate
              await _sessionManager.clearSession();
            } catch (e) {
              // Refresh failed, clear session
              await _sessionManager.clearSession();
            }
          }
          handler.next(error);
        },
      ),
    );
  }

  Future<Map<String, dynamic>?> _attemptTokenRefresh(String refreshToken) async {
    try {
      final response = await _dio.post(
        '/openauth/v1/auth/refresh',
        data: {'refreshToken': refreshToken},
      );
      return response.data as Map<String, dynamic>?;
    } catch (e) {
      return null;
    }
  }

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.get<T>(
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
      return await _dio.post<T>(
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
      return await _dio.put<T>(
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
      return await _dio.delete<T>(
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
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  /// Remove authorization header
  void removeAuthorizationHeader() {
    _dio.options.headers.remove('Authorization');
  }
}
