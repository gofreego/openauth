import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../domain/repositories/auth_repository.dart';
import '../../../../shared/shared.dart';
import '../../../../src/generated/openauth/v1/sessions.pb.dart' as pb;

/// Implementation of AuthRepository using HTTP API calls
class AuthRepositoryImpl implements AuthRepository {
  final HTTPServiceClient _httpClient;
  final SharedPreferences _prefs;
  final SessionManager _sessionManager;

  static const String _tokenKey = 'auth_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _sessionIdKey = 'session_id';

  AuthRepositoryImpl(this._httpClient, this._prefs, this._sessionManager);

  @override
  Future<pb.SignInResponse> signIn({
    required String username,
    required String password,
    String? deviceId,
    String? deviceName,
    String? deviceType,
    bool rememberMe = false,
  }) async {
    try {
      // Get device information if not provided
      final deviceSession = await DeviceUtils.createDeviceSession();
      
      final request = pb.SignInRequest(
        username: username,
        password: password,
        rememberMe: rememberMe,
        metadata: pb.SignInMetadata(
          deviceId: deviceId ?? deviceSession['deviceId'],
          deviceName: deviceName ?? deviceSession['deviceName'],
          deviceType: deviceType ?? deviceSession['deviceType'],
        ),
      );

      final response = await _httpClient.post<Map<String, dynamic>>(
        '/openauth/v1/auth/signin',
        data: request.toProto3Json(),
      );

      final signInResponse = pb.SignInResponse()..mergeFromProto3Json(response);
      
      if (signInResponse.hasAccessToken()) {
        // Store tokens using legacy method for backward compatibility
        await _storeTokens(signInResponse);
        
        // Create enhanced session with device tracking
        await _sessionManager.createSession(
          signInResponse: signInResponse,
          identifier: username,
          rememberMe: rememberMe,
        );
        
        return signInResponse;
      }
      
      throw Exception('Sign in failed: Invalid response');
    } catch (e) {
      throw Exception('Sign in failed: $e');
    }
  }

  @override
  Future<pb.RefreshTokenResponse> refreshToken(String refreshToken) async {
    try {
      final request = pb.RefreshTokenRequest(refreshToken: refreshToken);

      final response = await _httpClient.post<Map<String, dynamic>>(
        '/openauth/v1/auth/refresh',
        data: request.toProto3Json(),
      );

      final refreshResponse = pb.RefreshTokenResponse()..mergeFromProto3Json(response);
      
      if (refreshResponse.hasAccessToken()) {
        // Update stored tokens
        await _prefs.setString(_tokenKey, refreshResponse.accessToken);
        if (refreshResponse.hasRefreshToken()) {
          await _prefs.setString(_refreshTokenKey, refreshResponse.refreshToken);
        }
        return refreshResponse;
      }
      
      throw Exception('Token refresh failed: Invalid response');
    } catch (e) {
      throw Exception('Token refresh failed: $e');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      final tokens = await getStoredTokens();
      if (tokens != null && tokens['accessToken'] != null) {
        final request = pb.LogoutRequest();
        
        await _httpClient.post<Map<String, dynamic>>(
          '/openauth/v1/auth/logout',
          data: request.toProto3Json(),
          options: Options(
            headers: {'Authorization': 'Bearer ${tokens['accessToken']}'},
          ),
        );
      }
    } catch (e) {
      // Continue with local cleanup even if server logout fails
      debugPrint('Server logout failed: $e');
    } finally {
      await clearAuthData();
    }
  }

  @override
  Future<pb.ValidateTokenResponse?> validateToken(String token) async {
    try {
      final request = pb.ValidateTokenRequest(accessToken: token);

      final response = await _httpClient.post<Map<String, dynamic>>(
        '/openauth/v1/auth/validate',
        data: request.toProto3Json(),
      );

      final validateResponse = pb.ValidateTokenResponse()..mergeFromProto3Json(response);
      return validateResponse;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<Map<String, String>?> getStoredTokens() async {
    try {
      // Try to get tokens from session manager first
      final sessionTokens = await _sessionManager.getAuthTokens();
      if (sessionTokens != null) {
        return sessionTokens;
      }
      
      // Fallback to legacy storage
      final accessToken = _prefs.getString(_tokenKey);
      final refreshToken = _prefs.getString(_refreshTokenKey);
      final sessionId = _prefs.getString(_sessionIdKey);
      
      if (accessToken != null) {
        return {
          'accessToken': accessToken,
          'refreshToken': refreshToken ?? '',
          'sessionId': sessionId ?? '',
        };
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> isAuthenticated() async {
    // Check using session manager first
    final sessionAuth = await _sessionManager.isAuthenticated();
    if (sessionAuth) {
      // Validate session security
      final securityStatus = await _sessionManager.validateSessionSecurity();
      return securityStatus == SessionSecurityStatus.valid;
    }
    
    // Fallback to legacy check
    final tokens = await getStoredTokens();
    return tokens != null && tokens['accessToken']?.isNotEmpty == true;
  }

  @override
  Future<void> clearAuthData() async {
    // Clear session manager data
    await _sessionManager.clearSession();
    
    // Clear legacy storage
    await _prefs.remove(_tokenKey);
    await _prefs.remove(_refreshTokenKey);
    await _prefs.remove(_sessionIdKey);
  }

  Future<void> _storeTokens(pb.SignInResponse response) async {
    await _prefs.setString(_tokenKey, response.accessToken);
    await _prefs.setString(_refreshTokenKey, response.refreshToken);
    if (response.hasSessionId()) {
      await _prefs.setString(_sessionIdKey, response.sessionId);
    }
  }
}
