import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import '../../config/environment/environment_config.dart';
import '../../shared/services/session_manager.dart';
import '../../src/generated/openauth/v1/sessions.pb.dart' as pb;

/// Singleton HTTP client that handles authentication for all API requests
class HttpClient {
  static HttpClient? _instance;
  static bool _isInitializing = false;
  
  late final Dio _dio;
  SessionManager? _sessionManager;
  bool _isRefreshing = false;
  final List<RequestOptions> _pendingRequests = [];

  HttpClient._internal();

  /// Get the singleton instance
  static Future<HttpClient> getInstance() async {
    if (_instance == null) {
      if (_isInitializing) {
        // Wait for initialization to complete
        while (_instance == null) {
          await Future.delayed(const Duration(milliseconds: 10));
        }
        return _instance!;
      }
      
      _isInitializing = true;
      _instance = HttpClient._internal();
      await _instance!._initialize();
      _isInitializing = false;
    }
    return _instance!;
  }

  /// Initialize the HTTP client with session manager
  Future<void> _initialize() async {
    final prefs = await SharedPreferences.getInstance();
    _sessionManager = SessionManager(prefs);
    
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
            final token = await _sessionManager!.getAccessToken();
            if (token != null && token.isNotEmpty) {
              options.headers['Authorization'] = 'Bearer $token';
            }
          }
          handler.next(options);
        },
        onError: (error, handler) async {
          // Handle 401 errors by attempting token refresh
          if (error.response?.statusCode == 401 && _sessionManager != null) {
            if (_isRefreshing) {
              // If already refreshing, queue this request
              _pendingRequests.add(error.requestOptions);
              return;
            }

            _isRefreshing = true;
            
            try {
              final tokens = await _sessionManager!.getAuthTokens();
              if (tokens != null && tokens['refreshToken'] != null) {
                // Attempt to refresh token
                final refreshed = await _refreshToken(tokens['refreshToken']!);
                
                if (refreshed) {
                  // Retry original request with new token
                  final newToken = await _sessionManager!.getAccessToken();
                  final clonedRequest = await _retryRequest(error.requestOptions, newToken);
                  
                  // Process any pending requests with new token
                  await _processPendingRequests(newToken);
                  
                  return handler.resolve(clonedRequest);
                } else {
                  // Refresh failed, clear session
                  await _sessionManager!.clearSession();
                  _clearPendingRequests();
                }
              } else {
                // No refresh token available
                await _sessionManager!.clearSession();
                _clearPendingRequests();
              }
            } catch (e) {
              // Refresh failed, clear session
              await _sessionManager!.clearSession();
              _clearPendingRequests();
            } finally {
              _isRefreshing = false;
            }
          }
          handler.next(error);
        },
      ),
    );
  }

  /// Refresh the authentication token
  Future<bool> _refreshToken(String refreshToken) async {
    try {
      // Create a separate Dio instance for refresh to avoid interceptor recursion
      final refreshDio = Dio(BaseOptions(
        baseUrl: _dio.options.baseUrl,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ));

      final request = pb.RefreshTokenRequest(refreshToken: refreshToken);
      final response = await refreshDio.post(
        '/openauth/v1/auth/refresh',
        data: request.toProto3Json(),
      );

      if (response.statusCode == 200) {
        final refreshResponse = pb.RefreshTokenResponse()..mergeFromProto3Json(response.data);
        await _sessionManager!.updateAuthTokens(refreshResponse);
        return true;
      }
      
      return false;
    } catch (e) {
      return false;
    }
  }

  /// Retry a request with new authentication token
  Future<Response> _retryRequest(RequestOptions options, String? newToken) async {
    final retryOptions = Options(
      method: options.method,
      headers: {
        ...options.headers,
        if (newToken != null) 'Authorization': 'Bearer $newToken',
      },
    );

    return await _dio.request(
      options.path,
      options: retryOptions,
      data: options.data,
      queryParameters: options.queryParameters,
    );
  }

  /// Process pending requests with new token
  Future<void> _processPendingRequests(String? newToken) async {
    final requests = List<RequestOptions>.from(_pendingRequests);
    _pendingRequests.clear();

    for (final request in requests) {
      try {
        await _retryRequest(request, newToken);
      } catch (e) {
        // Log error but continue processing other requests
        debugPrint('Failed to retry pending request: $e');
      }
    }
  }

  /// Clear pending requests
  void _clearPendingRequests() {
    _pendingRequests.clear();
  }

  /// Get the Dio instance (for direct use if needed)
  Dio get dio => _dio;

  /// Reset singleton instance (for testing only)
  @visibleForTesting
  static void reset() {
    _instance = null;
    _isInitializing = false;
  }

  /// Standard HTTP methods
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await _dio.get<T>(
      path,
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await _dio.post<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await _dio.put<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await _dio.delete<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }
}
