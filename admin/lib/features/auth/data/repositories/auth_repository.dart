import 'package:openauth/src/generated/openauth/v1/users.pb.dart';

import '../../../../src/generated/openauth/v1/sessions.pb.dart' as pb;

/// Repository interface for authentication operations
abstract class AuthRepository {
  /// Sign in an existing user
  Future<pb.SignInResponse> signIn(pb.SignInRequest request);

  /// Refresh authentication tokens
  Future<pb.RefreshTokenResponse> refreshToken(String refreshToken);

  /// Sign out user
  Future<void> signOut();

  /// Check if user is authenticated
  Future<bool> isAuthenticated();

  /// Clear stored authentication data
  Future<void> clearAuthData();

  /// Get current user
  Future<User> getCurrentUser();
}
