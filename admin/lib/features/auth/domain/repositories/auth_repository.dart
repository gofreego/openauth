import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:io';

import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../../../shared/shared.dart';
import '../../../../src/generated/openauth/v1/users.pb.dart' as pb;

/// Repository interface for authentication operations
abstract class AuthRepository {
  /// Sign in an existing user
  Future<pb.SignInResponse> signIn({
    required String identifier, // username, email, or phone
    required String password,
    String? deviceId,
    String? deviceName,
    String? deviceType,
    bool rememberMe = false,
  });

  /// Refresh authentication tokens
  Future<pb.RefreshTokenResponse> refreshToken(String refreshToken);

  /// Sign out user
  Future<void> signOut();

  /// Validate current token
  Future<pb.ValidateTokenResponse?> validateToken(String token);

  /// Get current stored tokens
  Future<Map<String, String>?> getStoredTokens();

  /// Check if user is authenticated
  Future<bool> isAuthenticated();

  /// Clear stored authentication data
  Future<void> clearAuthData();
}
