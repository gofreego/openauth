import '../../../../src/generated/openauth/v1/sessions.pb.dart' as pb;

/// Repository interface for authentication operations
abstract class AuthRepository {
  /// Sign in an existing user
  Future<pb.SignInResponse> signIn(pb.SignInRequest request);

  /// Refresh authentication tokens
  Future<pb.RefreshTokenResponse> refreshToken(String refreshToken);

  /// Sign out user
  Future<void> signOut();

  /// Clear stored authentication data
  Future<void> clearAuthData();
}
