import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:openauth/core/errors/failures.dart';
import 'package:openauth/src/generated/openauth/v1/users.pb.dart';

import 'auth_repository.dart';
import '../../../../shared/shared.dart';
import '../../../../src/generated/openauth/v1/sessions.pb.dart' as pb;

/// Implementation of AuthRepository using HTTP API calls
class AuthRepositoryImpl implements AuthRepository {
  final HTTPServiceClient _httpClient;
  final SessionManager _sessionManager;

  AuthRepositoryImpl(this._httpClient, this._sessionManager);

  @override
  Future<Either<Failure, pb.SignInResponse>> signIn(
      pb.SignInRequest request) async {
    try {
      final deviceSession = await DeviceUtils.createDeviceSession();

      request.metadata = pb.SignInMetadata(
        deviceId: deviceSession['deviceId'],
        deviceName: deviceSession['deviceName'],
        deviceType: deviceSession['deviceType'],
      );
      request.includePermissions = true;

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
        return Right(signInResponse);
      }
      return const Left(
          ServerFailure(message: 'Sign-in failed: Invalid response'));
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, pb.RefreshTokenResponse>> refreshToken(
      String refreshToken) async {
    final request = pb.RefreshTokenRequest(refreshToken: refreshToken);
    request.includePermissions = true;
    try {
      final response = await _httpClient.post<Map<String, dynamic>>(
        '/openauth/v1/auth/refresh',
        data: request.toProto3Json(),
      );

      final refreshResponse = pb.RefreshTokenResponse()
        ..mergeFromProto3Json(response);

      if (refreshResponse.hasAccessToken()) {
        _sessionManager.updateAuthTokens(refreshResponse);
        return Right(refreshResponse);
      }

      return const Left(
          ServerFailure(message: 'Token refresh failed: Invalid response'));
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      final accessToken = await _sessionManager.getAccessToken();
      if (accessToken != null) {
        final request = pb.LogoutRequest(
          sessionId: await _sessionManager.getCurrentSessionId(),
        );

        await _httpClient.post<Map<String, dynamic>>(
          '/openauth/v1/auth/logout',
          data: request.toProto3Json(),
          options: Options(
            headers: {'Authorization': 'Bearer $accessToken'},
          ),
        );
      }
      return const Right(null);
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    } finally {
      await clearAuthData();
    }
  }

  @override
  Future<bool> isAuthenticated() async {
    return await _sessionManager.getAccessToken() != null;
  }

  @override
  Future<void> clearAuthData() async {
    // Clear session manager data
    await _sessionManager.clearSession();
  }

  @override
  Future<User> getCurrentUser() async {
    final user = await _sessionManager.getCurrentUser();
    if (user != null) {
      return user;
    }
    throw Exception('User not found');
  }
}
