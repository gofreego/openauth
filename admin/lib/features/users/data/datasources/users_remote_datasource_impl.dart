import 'package:openauth/src/generated/openauth/v1/users.pbserver.dart';
import '../../../../src/generated/openauth/v1/users.pb.dart' as pb;
import '../../../../core/network/api_service.dart';

abstract class UsersRemoteDataSource {
  Future<pb.ListUsersResponse> getUsers({
    required pb.ListUsersRequest request,
  });

  Future<pb.GetUserResponse> getUser(pb.GetUserRequest request);

  Future<pb.SignUpResponse> createUser(pb.SignUpRequest request);

  Future<pb.UpdateUserResponse> updateUser(pb.UpdateUserRequest request);

  Future<pb.DeleteUserResponse> deleteUser(pb.DeleteUserRequest request);

  Future<pb.CreateProfileResponse> createProfile(
      pb.CreateProfileRequest request);

  Future<pb.UpdateProfileResponse> updateProfile(
      pb.UpdateProfileRequest request);

  Future<pb.DeleteProfileResponse> deleteProfile(
      pb.DeleteProfileRequest request);

  Future<pb.ListUserProfilesResponse> listUserProfiles(
      pb.ListUserProfilesRequest request);
}

class UsersRemoteDataSourceImpl implements UsersRemoteDataSource {
  final ApiService _apiService;

  UsersRemoteDataSourceImpl(this._apiService);

  @override
  Future<pb.ListUsersResponse> getUsers({
    required ListUsersRequest request,
  }) async {
    final queryParams = <String, dynamic>{
      'offset': request.offset,
      'limit': request.limit,
    };

    if (request.search.isNotEmpty) {
      queryParams['search'] = request.search;
    }
    var response = await _apiService.get(
      '/openauth/v1/users',
      queryParameters: queryParams,
    );
    // just declare variable
    var listUsersResponse = pb.ListUsersResponse();
    listUsersResponse.mergeFromProto3Json(response.data);
    return listUsersResponse;
  }

  @override
  Future<pb.GetUserResponse> getUser(pb.GetUserRequest request) async {
    var response = await _apiService.get('/openauth/v1/users/${request.uuid}');
    var result = pb.GetUserResponse();
    result.mergeFromProto3Json(response.data);
    return result;
  }

  @override
  Future<pb.SignUpResponse> createUser(pb.SignUpRequest request) async {
    var response = await _apiService.post(
      '/openauth/v1/users/signup',
      data: request.toProto3Json(),
    );
    var result = pb.SignUpResponse();
    result.mergeFromProto3Json(response.data);
    return result;
  }

  @override
  Future<pb.UpdateUserResponse> updateUser(pb.UpdateUserRequest request) async {
    final userUuid = request.uuid;

    // For now, return mock data until backend is ready
    var response = await _apiService.put(
      '/openauth/v1/users/$userUuid',
      data: request.toProto3Json(),
    );
    var result = pb.UpdateUserResponse();
    result.mergeFromProto3Json(response.data);
    return result;
  }

  @override
  Future<pb.DeleteUserResponse> deleteUser(pb.DeleteUserRequest request) async {
    await _apiService.delete('/openauth/v1/users/${request.uuid}');

    return pb.DeleteUserResponse()
      ..success = true
      ..message = 'User deleted successfully';
  }

  @override
  Future<pb.CreateProfileResponse> createProfile(
      pb.CreateProfileRequest request) async {
    var response = await _apiService.post(
      '/openauth/v1/users/${request.userUuid}/profiles',
      data: request.toProto3Json(),
    );

    var result = pb.CreateProfileResponse();
    result.mergeFromProto3Json(response.data);
    return result;
  }

  @override
  Future<pb.UpdateProfileResponse> updateProfile(
      pb.UpdateProfileRequest request) async {
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
  }

  @override
  Future<pb.DeleteProfileResponse> deleteProfile(
      pb.DeleteProfileRequest request) async {
    await _apiService.delete('/openauth/v1/profiles/${request.profileUuid}');

    return pb.DeleteProfileResponse()
      ..success = true
      ..message = 'Profile deleted successfully';
  }

  @override
  Future<pb.ListUserProfilesResponse> listUserProfiles(
      pb.ListUserProfilesRequest request) async {
    final queryParams = <String, dynamic>{
      'limit': request.limit,
      'offset': request.offset,
    };

    var response = await _apiService.get(
      '/openauth/v1/users/${request.userUuid}/profiles',
      queryParameters: queryParams,
    );

    var result = pb.ListUserProfilesResponse();
    result.mergeFromProto3Json(response.data);
    return result;
  }
}
