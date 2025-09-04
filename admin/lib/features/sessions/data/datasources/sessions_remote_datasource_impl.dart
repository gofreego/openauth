import 'package:dio/dio.dart';
import 'package:openauth/src/generated/openauth/v1/sessions.pb.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/api_service.dart';

abstract class SessionsRemoteDataSource {
  Future<ListUserSessionsResponse> getUserSessions(ListUserSessionsRequest request);
  Future<TerminateSessionResponse> terminateSession(TerminateSessionRequest request);
}

class SessionsRemoteDataSourceImpl implements SessionsRemoteDataSource {
  final ApiService _apiService;

  SessionsRemoteDataSourceImpl(this._apiService);

  @override
  Future<ListUserSessionsResponse> getUserSessions(ListUserSessionsRequest request) async {
    try {
      final response = await _apiService.get(
        '/openauth/v1/users/${request.userUuid}/sessions?limit=${request.limit}&offset=${request.offset}',
      );
      var sessionList = ListUserSessionsResponse();
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
  Future<TerminateSessionResponse> terminateSession(TerminateSessionRequest request) async {
    try {

      final response = await _apiService.put(
        '/openauth/v1/sessions/terminate',
        data: request.toProto3Json(),
      );
      var terminateSessionResponse = TerminateSessionResponse();
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
}
