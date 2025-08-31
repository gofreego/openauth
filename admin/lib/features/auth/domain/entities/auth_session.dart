import 'package:equatable/equatable.dart';
import 'auth_user.dart';

/// Domain entity representing authentication tokens and session data
class AuthSession extends Equatable {
  final String accessToken;
  final String refreshToken;
  final DateTime expiresAt;
  final DateTime refreshExpiresAt;
  final String sessionId;
  final AuthUser user;

  const AuthSession({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresAt,
    required this.refreshExpiresAt,
    required this.sessionId,
    required this.user,
  });

  /// Check if the access token is expired
  bool get isAccessTokenExpired {
    return DateTime.now().isAfter(expiresAt);
  }

  /// Check if the refresh token is expired
  bool get isRefreshTokenExpired {
    return DateTime.now().isAfter(refreshExpiresAt);
  }

  /// Check if the session is still valid (either token is valid)
  bool get isValid {
    return !isRefreshTokenExpired;
  }

  @override
  List<Object> get props => [
        accessToken,
        refreshToken,
        expiresAt,
        refreshExpiresAt,
        sessionId,
        user,
      ];
}
