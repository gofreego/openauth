import 'package:dio/dio.dart';
import '../../../../src/generated/openauth/v1/sessions.pb.dart' as pb;
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/api_service.dart';

abstract class SessionsRemoteDataSource {
  Future<pb.ListUserSessionsResponse> getUserSessions(String userId);
  Future<pb.TerminateSessionResponse> terminateSession(String sessionId);
  Future<void> terminateAllUserSessions(String userId);
}

class SessionsRemoteDataSourceImpl implements SessionsRemoteDataSource {
  final ApiService _apiService;

  SessionsRemoteDataSourceImpl(this._apiService);

  @override
  Future<pb.ListUserSessionsResponse> getUserSessions(String userId) async {
    try {
      final response = await _apiService.get(
        '/openauth/v1/users/$userId/sessions',
      );
      var sessionList = pb.ListUserSessionsResponse();
      sessionList.mergeFromProto3Json(response.data);
      return sessionList;
    } on DioException catch (e) {
      throw ServerException(
        message: 'Failed to fetch user sessions: ${e.message}',
        statusCode: e.response?.statusCode ?? 500,
      );
    } catch (e) {
      throw ServerException(
        message: 'Unexpected error occurred while fetching user sessions: $e',
        statusCode: 500,
      );
    }
  }

  @override
  Future<pb.TerminateSessionResponse> terminateSession(String sessionId) async {
    try {

      final response = await _apiService.put(
        '/openauth/v1/sessions/terminate',
        data: pb.TerminateSessionRequest(sessionId: sessionId).toProto3Json(),
      );
      var terminateSessionResponse = pb.TerminateSessionResponse();
      terminateSessionResponse.mergeFromProto3Json(response.data);
      return terminateSessionResponse;
    } on DioException catch (e) {
      throw ServerException(
        message: 'Failed to terminate session: ${e.message}',
        statusCode: e.response?.statusCode ?? 500,
      );
    } catch (e) {
      throw ServerException(
        message: 'Unexpected error occurred while terminating session: $e',
        statusCode: 500,
      );
    }
  }

  @override
  Future<void> terminateAllUserSessions(String userId) async {
    try {
      await _apiService.post(
        '/openauth/v1/sessions/terminate',
        data: pb.TerminateSessionRequest(userId: userId).toProto3Json(),
      );
    } on DioException catch (e) {
      throw ServerException(
        message: 'Failed to terminate all user sessions: ${e.message}',
        statusCode: e.response?.statusCode ?? 500,
      );
    } catch (e) {
      throw ServerException(
        message: 'Unexpected error occurred while terminating all user sessions: $e',
        statusCode: 500,
      );
    }
  }
}
