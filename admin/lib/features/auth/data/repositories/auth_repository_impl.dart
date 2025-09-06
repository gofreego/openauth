import 'dart:developer' as dev;

import 'package:dio/dio.dart';

import 'auth_repository.dart';
import '../../../../shared/shared.dart';
import '../../../../src/generated/openauth/v1/sessions.pb.dart' as pb;

/// Implementation of AuthRepository using HTTP API calls
class AuthRepositoryImpl implements AuthRepository {
  final HTTPServiceClient _httpClient;
  final SessionManager _sessionManager;

  AuthRepositoryImpl(this._httpClient, this._sessionManager);

  @override
  Future<pb.SignInResponse> signIn(pb.SignInRequest request) async {
    try {
      // Get device information if not provided
      final deviceSession = await DeviceUtils.createDeviceSession();
    
      request.metadata = pb.SignInMetadata(
        deviceId: deviceSession['deviceId'],
        deviceName: deviceSession['deviceName'],
        deviceType: deviceSession['deviceType'],
      );


      final response = await _httpClient.post<Map<String, dynamic>>(
        '/openauth/v1/auth/signin',
        data: request.toProto3Json(),
      );

      final signInResponse = pb.SignInResponse()..mergeFromProto3Json(response);
      
      if (signInResponse.hasAccessToken()) {
        // Create enhanced session with device tracking
        await _sessionManager.createSession(
          signInResponse: signInResponse,
          identifier: request.username,
          rememberMe: request.rememberMe,
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
      
      if (refreshResponse.hasAccessToken()){
        _sessionManager.updateAuthTokens(refreshResponse);
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
      dev.log('Server logout failed: $e');
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
  }
}
