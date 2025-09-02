import 'package:dio/dio.dart';
import '../../../../src/generated/openauth/v1/users.pb.dart' as pb;
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/api_service.dart';

abstract class UsersRemoteDataSource {
  Future<pb.ListUsersResponse> getUsers({
    int page = 1,
    int limit = 50,
    String? search,
    bool? isActive,
  });

  Future<pb.GetUserResponse> getUser(String userIdOrUuid);

  Future<pb.SignUpResponse> createUser(pb.SignUpRequest request);

  Future<pb.UpdateUserResponse> updateUser(pb.UpdateUserRequest request);

  Future<pb.DeleteUserResponse> deleteUser(String userIdOrUuid);

  Future<pb.CreateProfileResponse> createProfile(pb.CreateProfileRequest request);

  Future<pb.UpdateProfileResponse> updateProfile(pb.UpdateProfileRequest request);

  Future<pb.DeleteProfileResponse> deleteProfile(String profileUuid);
}

class UsersRemoteDataSourceImpl implements UsersRemoteDataSource {
  final ApiService _apiService;

  UsersRemoteDataSourceImpl(this._apiService);

  @override
  Future<pb.ListUsersResponse> getUsers({
    int page = 1,
    int limit = 50,
    String? search,
    bool? isActive,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'limit': limit,
      };

      if (search != null && search.isNotEmpty) {
        queryParams['search'] = search;
      }

      if (isActive != null) {
        queryParams['is_active'] = isActive;
      }

      // For now, return mock data until backend is ready
      var response = await _apiService.get(
        '/openauth/v1/users',
        queryParameters: queryParams,
      );
      // just declare variable
      var listUsersResponse = pb.ListUsersResponse();
      listUsersResponse.mergeFromProto3Json(response.data);
      return listUsersResponse;
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'Failed to fetch users',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw NetworkException(message: 'Network error: ${e.toString()}');
    }
  }

  @override
  Future<pb.GetUserResponse> getUser(String userIdOrUuid) async {
    try {
      var response = await _apiService.get('/openauth/v1/users/$userIdOrUuid');
      var result = pb.GetUserResponse();
      result.mergeFromProto3Json(response.data);
      return result;
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'Failed to fetch user',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw NetworkException(message: 'Network error: ${e.toString()}');
    }
  }

  @override
  Future<pb.SignUpResponse> createUser(pb.SignUpRequest request) async {
    try {
      var response = await _apiService.post(
        '/openauth/v1/users/signup',
        data: request.toProto3Json(),
      );
      var result = pb.SignUpResponse();
      result.mergeFromProto3Json(response.data);
      return result;
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'Failed to create user',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw NetworkException(message: 'Network error: ${e.toString()}');
    }
  }

  @override
  Future<pb.UpdateUserResponse> updateUser(pb.UpdateUserRequest request) async {
    try {
      final userUuid = request.uuid;
      
      // For now, return mock data until backend is ready
      var response = await _apiService.put(
        '/openauth/v1/users/$userUuid',
        data: request.toProto3Json() ,
      );
      var result = pb.UpdateUserResponse();
      result.mergeFromProto3Json(response.data);
      return result;
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'Failed to update user',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw NetworkException(message: 'Network error: ${e.toString()}');
    }
  }

  @override
  Future<pb.DeleteUserResponse> deleteUser(String userIdOrUuid) async {
    try {
      await _apiService.delete('/openauth/v1/users/$userIdOrUuid');

      return pb.DeleteUserResponse()
        ..success = true
        ..message = 'User deleted successfully';
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'Failed to delete user',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw NetworkException(message: 'Network error: ${e.toString()}');
    }
  }

  @override
  Future<pb.CreateProfileResponse> createProfile(pb.CreateProfileRequest request) async {
    try {
      var response = await _apiService.post(
        '/openauth/v1/profiles',
        data: request.toProto3Json(),
      );

      var result = pb.CreateProfileResponse();
      result.mergeFromProto3Json(response.data);
      return result;
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'Failed to create profile',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw NetworkException(message: 'Network error: ${e.toString()}');
    }
  }

  @override
  Future<pb.UpdateProfileResponse> updateProfile(pb.UpdateProfileRequest request) async {
    try {
      final profileUuid = request.profileUuid;
      
      // For now, return mock data until backend is ready
      await _apiService.put(
        '/openauth/v1/profiles/$profileUuid',
        data: request.toProto3Json(),
      );

      var response = await _apiService.put(
        '/openauth/v1/profiles/$profileUuid',
        data: request.toProto3Json(),
      );

      var result = pb.UpdateProfileResponse();
      result.mergeFromProto3Json(response.data);
      return result;
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'Failed to update profile',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw NetworkException(message: 'Network error: ${e.toString()}');
    }
  }

  @override
  Future<pb.DeleteProfileResponse> deleteProfile(String profileUuid) async {
    try {
      await _apiService.delete('/openauth/v1/profiles/$profileUuid');

      return pb.DeleteProfileResponse()
        ..success = true
        ..message = 'Profile deleted successfully';
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'Failed to delete profile',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw NetworkException(message: 'Network error: ${e.toString()}');
    }
  }
}