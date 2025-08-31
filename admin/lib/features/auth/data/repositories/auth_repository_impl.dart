import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:dio/dio.dart';

import '../../domain/repositories/auth_repository.dart';
import '../../../../shared/shared.dart';
import '../../../../src/generated/openauth/v1/users.pb.dart' as pb;

/// Implementation of AuthRepository using HTTP API calls
class AuthRepositoryImpl implements AuthRepository {
  final HTTPServiceClient _httpClient;
  final SharedPreferences _prefs;

  static const String _tokenKey = 'auth_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _sessionIdKey = 'session_id';

  AuthRepositoryImpl(this._httpClient, this._prefs);

  @override
  Future<pb.SignInResponse> signIn({
    required String identifier,
    required String password,
    String? deviceId,
    String? deviceName,
    String? deviceType,
    bool rememberMe = false,
  }) async {
    try {
      final request = pb.SignInRequest(
        identifier: identifier,
        password: password,
        deviceId: deviceId,
        deviceName: deviceName,
        deviceType: deviceType,
        rememberMe: rememberMe,
      );

      final response = await _httpClient.post<Map<String, dynamic>>(
        '/openauth/v1/auth/signin',
        data: request.writeToJson(),
      );

      final signInResponse = pb.SignInResponse.fromJson(jsonEncode(response));
      
      if (signInResponse.hasAccessToken()) {
        await _storeTokens(signInResponse);
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
        data: request.writeToJson(),
      );

      final refreshResponse = pb.RefreshTokenResponse.fromJson(jsonEncode(response));
      
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
          data: request.writeToJson(),
          options: Options(
            headers: {'Authorization': 'Bearer ${tokens['accessToken']}'},
          ),
        );
      }
    } catch (e) {
      // Continue with local cleanup even if server logout fails
      print('Server logout failed: $e');
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
        data: request.writeToJson(),
      );

      return pb.ValidateTokenResponse.fromJson(jsonEncode(response));
    } catch (e) {
      return null;
    }
  }

  @override
  Future<Map<String, String>?> getStoredTokens() async {
    try {
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
    final tokens = await getStoredTokens();
    return tokens != null && tokens['accessToken']?.isNotEmpty == true;
  }

  @override
  Future<void> clearAuthData() async {
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
