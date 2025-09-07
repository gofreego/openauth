import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/device_utils.dart';
import '../../src/generated/openauth/v1/sessions.pb.dart' as pb_sessions;
import '../../src/generated/openauth/v1/users.pb.dart' as pb_users;

/// Enhanced session manager with device tracking and security features
class SessionManager {
  static SessionManager? _instance;
  final SharedPreferences _prefs;
  
  // Storage keys
  static const String _accessTokenKey = 'auth_access_token';
  static const String _refreshTokenKey = 'auth_refresh_token';
  static const String _sessionIdKey = 'auth_session_id';
  static const String _userDataKey = 'auth_user_data';
  static const String _deviceSessionKey = 'device_session_data';
  static const String _sessionMetaKey = 'session_metadata';
  static const String _loginHistoryKey = 'login_history';

  static const String _currentUserKey = 'current_user';

  // Singleton factory
  factory SessionManager(SharedPreferences prefs) {
    return _instance ??= SessionManager._internal(prefs);
  }

  SessionManager._internal(this._prefs);


  Future<void> setCurrentUser(pb_users.User user) async {
    final jsonData = user.writeToJson();
    await _prefs.setString(_currentUserKey, jsonData);
  }

  Future<pb_users.User?> getCurrentUser() async {
    try {
      final userData = _prefs.getString(_currentUserKey);
      if (userData != null) {
        return pb_users.User()..mergeFromJson(userData);
      }
      return null;
    } catch (e) {
      clearSession();
      return null;
    }
  }


  /// Create a new authentication session
  Future<void> createSession({
    required pb_sessions.SignInResponse signInResponse,
    required String identifier,
    bool rememberMe = false,
  }) async {
    try {
      // Store authentication tokens
      await _storeAuthTokens(signInResponse);
      await setCurrentUser(signInResponse.user);
    
      // Create and store device session
      final deviceSession = await DeviceUtils.createDeviceSession();
      await _storeDeviceSession(deviceSession);
      
      // Store session metadata
      await _storeSessionMetadata(
        identifier: identifier,
        rememberMe: rememberMe,
        loginTime: DateTime.now(),
        deviceSession: deviceSession,
      );
      
      // Update login history
      await _updateLoginHistory(identifier, deviceSession);
      
    } catch (e) {
      throw Exception('Failed to create session: $e');
    }
  }

  /// Get current authentication tokens
  Future<Map<String, String>?> getAuthTokens() async {
    try {
      final accessToken = _prefs.getString(_accessTokenKey);
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

  /// Get current access token
  Future<String?> getAccessToken() async {
    try {
      return _prefs.getString(_accessTokenKey);
    } catch (e) {
      return null;
    }
  }

  /// Get current refresh token
  Future<String?> getRefreshToken() async {
    try {
      return _prefs.getString(_refreshTokenKey);
    } catch (e) {
      return null;
    }
  }

  /// Get current session ID
  Future<String?> getCurrentSessionId() async {
    try {
      return _prefs.getString(_sessionIdKey);
    } catch (e) {
      return null;
    }
  }

  /// Update authentication tokens
  Future<void> updateAuthTokens(pb_sessions.RefreshTokenResponse refreshResponse) async {
    await _prefs.setString(_accessTokenKey, refreshResponse.accessToken);
    
    if (refreshResponse.hasRefreshToken()) {
      await _prefs.setString(_refreshTokenKey, refreshResponse.refreshToken);
    }
    
    // Update session metadata with refresh time
    final metadata = await getSessionMetadata();
    if (metadata != null) {
      metadata['lastRefresh'] = DateTime.now().toIso8601String();
      metadata['refreshCount'] = ((int.tryParse(metadata['refreshCount'] ?? '0') ?? 0) + 1).toString();
      await _prefs.setString(_sessionMetaKey, jsonEncode(metadata));
    }
  }

  /// Get device session information
  Future<Map<String, String>?> getDeviceSession() async {
    try {
      final deviceData = _prefs.getString(_deviceSessionKey);
      if (deviceData != null) {
        final jsonData = jsonDecode(deviceData) as Map<String, dynamic>;
        return Map<String, String>.from(jsonData);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Get session metadata
  Future<Map<String, String>?> getSessionMetadata() async {
    try {
      final metaData = _prefs.getString(_sessionMetaKey);
      if (metaData != null) {
        final jsonData = jsonDecode(metaData) as Map<String, dynamic>;
        return Map<String, String>.from(jsonData);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Check if user is authenticated
  Future<bool> isAuthenticated() async {
    final tokens = await getAuthTokens();
    return tokens != null && tokens['accessToken']?.isNotEmpty == true;
  }

  /// Check if session is expired (based on stored metadata)
  Future<bool> isSessionExpired() async {
    final metadata = await getSessionMetadata();
    if (metadata == null) return true;
    
    final loginTimeStr = metadata['loginTime'];
    if (loginTimeStr == null) return true;
    
    try {
      final loginTime = DateTime.parse(loginTimeStr);
      final now = DateTime.now();
      
      // Check if session is older than configured timeout (default 30 days)
      final maxSessionDays = int.tryParse(metadata['maxSessionDays'] ?? '30') ?? 30;
      final sessionAge = now.difference(loginTime);
      return sessionAge.inDays > maxSessionDays;
    } catch (e) {
      return true;
    }
  }

  /// Get login history (last 10 logins)
  Future<List<Map<String, dynamic>>> getLoginHistory() async {
    try {
      final historyData = _prefs.getString(_loginHistoryKey);
      if (historyData != null) {
        final jsonData = jsonDecode(historyData) as List<dynamic>;
        return jsonData.cast<Map<String, dynamic>>();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  /// Validate device session security
  Future<SessionSecurityStatus> validateSessionSecurity() async {
    final deviceSession = await getDeviceSession();
    final metadata = await getSessionMetadata();
    
    if (deviceSession == null || metadata == null) {
      return SessionSecurityStatus.invalid;
    }

    // Check device fingerprint consistency
    final currentFingerprint = await DeviceUtils.generateDeviceFingerprint();
    final storedFingerprint = deviceSession['fingerprint'];
    
    if (currentFingerprint != storedFingerprint) {
      return SessionSecurityStatus.suspicious;
    }

    // Check session age
    if (await isSessionExpired()) {
      return SessionSecurityStatus.expired;
    }

    // Check for excessive refresh attempts
    final refreshCount = int.tryParse(metadata['refreshCount'] ?? '0') ?? 0;
    if (refreshCount > 100) { // Increased threshold from 50 to 100
      return SessionSecurityStatus.suspicious;
    }

    return SessionSecurityStatus.valid;
  }

  /// Clear all session data
  Future<void> clearSession() async {
    await Future.wait([
      _prefs.remove(_accessTokenKey),
      _prefs.remove(_refreshTokenKey),
      _prefs.remove(_sessionIdKey),
      _prefs.remove(_userDataKey),
      _prefs.remove(_deviceSessionKey),
      _prefs.remove(_sessionMetaKey),
      _prefs.remove(_currentUserKey),
    ]);
  }

  /// Private helper methods

  Future<void> _storeAuthTokens(pb_sessions.SignInResponse response) async {
    await _prefs.setString(_accessTokenKey, response.accessToken);
    await _prefs.setString(_refreshTokenKey, response.refreshToken);
    
    if (response.hasSessionId()) {
      await _prefs.setString(_sessionIdKey, response.sessionId);
    }
  }

  Future<void> _storeDeviceSession(Map<String, String> deviceSession) async {
    await _prefs.setString(_deviceSessionKey, jsonEncode(deviceSession));
  }

  Future<void> _storeSessionMetadata({
    required String identifier,
    required bool rememberMe,
    required DateTime loginTime,
    required Map<String, String> deviceSession,
  }) async {
    final metadata = {
      'identifier': identifier,
      'rememberMe': rememberMe.toString(),
      'loginTime': loginTime.toIso8601String(),
      'deviceType': deviceSession['deviceType'] ?? 'unknown',
      'deviceName': deviceSession['deviceName'] ?? 'unknown',
      'ipAddress': deviceSession['ipAddress'] ?? 'unknown',
      'location': deviceSession['location'] ?? 'unknown',
      'refreshCount': '0',
    };
    
    await _prefs.setString(_sessionMetaKey, jsonEncode(metadata));
  }

  Future<void> _updateLoginHistory(String identifier, Map<String, String> deviceSession) async {
    final history = await getLoginHistory();
    
    final newEntry = {
      'identifier': identifier,
      'timestamp': DateTime.now().toIso8601String(),
      'deviceType': deviceSession['deviceType'],
      'deviceName': deviceSession['deviceName'],
      'ipAddress': deviceSession['ipAddress'],
      'location': deviceSession['location'],
      'userAgent': deviceSession['userAgent'],
    };
    
    // Add new entry to the beginning
    history.insert(0, newEntry);
    
    // Keep only the last 10 entries
    if (history.length > 10) {
      history.removeRange(10, history.length);
    }
    
    await _prefs.setString(_loginHistoryKey, jsonEncode(history));
  }
}

/// Enum for session security status
enum SessionSecurityStatus {
  valid,
  expired,
  suspicious,
  invalid,
}
