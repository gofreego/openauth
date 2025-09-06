import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../shared/services/session_manager.dart';
import '../../src/generated/openauth/v1/sessions.pb.dart' as pb;

/// Authentication interceptor that handles token refresh and unauthorized responses
class AuthInterceptor extends Interceptor {
  final SessionManager _sessionManager;
  
  AuthInterceptor(this._sessionManager);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // Add auth token if available
    final token = await _sessionManager.getAccessToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Handle 401 Unauthorized responses
    if (err.response?.statusCode == 401) {
      try {
        // Attempt to refresh token
        final refreshed = await _refreshToken();
        if (refreshed) {
          // Retry the original request with new token
          final clonedRequest = await _retryRequest(err);
          if (clonedRequest != null) {
            return handler.resolve(clonedRequest);
          }
        }
      } catch (e) {
        // Refresh failed, clear session
        await _sessionManager.clearSession();
      }
    }
    
    super.onError(err, handler);
  }

  /// Attempt to refresh the authentication token
  Future<bool> _refreshToken() async {
    try {
      final tokens = await _sessionManager.getAuthTokens();
      if (tokens == null || tokens['refreshToken'] == null) {
        return false;
      }

      // Create new Dio instance without interceptors to avoid recursion
      final dio = Dio();
      
      final request = pb.RefreshTokenRequest(refreshToken: tokens['refreshToken']!);
      final response = await dio.post(
        '/openauth/v1/auth/refresh',
        data: request.toProto3Json(),
      );

      if (response.statusCode == 200) {
        final refreshResponse = pb.RefreshTokenResponse()..mergeFromProto3Json(response.data);
        await _sessionManager.updateAuthTokens(refreshResponse);
        return true;
      }
      
      return false;
    } catch (e) {
      return false;
    }
  }

  /// Retry the failed request with new authentication token
  Future<Response?> _retryRequest(DioException err) async {
    try {
      final token = await _sessionManager.getAccessToken();
      if (token == null) return null;

      // Create new Dio instance for retry
      final dio = Dio();
      
      return await dio.request(
        err.requestOptions.path,
        options: Options(
          method: err.requestOptions.method,
          headers: {
            ...err.requestOptions.headers,
            'Authorization': 'Bearer $token',
          },
        ),
        data: err.requestOptions.data,
        queryParameters: err.requestOptions.queryParameters,
      );
    } catch (e) {
      return null;
    }
  }
}

/// Factory method to create AuthInterceptor
Future<AuthInterceptor> createAuthInterceptor() async {
  final prefs = await SharedPreferences.getInstance();
  final sessionManager = SessionManager(prefs);
  return AuthInterceptor(sessionManager);
}
