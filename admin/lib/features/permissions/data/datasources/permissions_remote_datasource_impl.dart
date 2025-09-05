import 'package:dio/dio.dart';
import 'package:openauth/src/generated/openauth/v1/permission_assignments.pb.dart';
import 'package:openauth/src/generated/openauth/v1/permissions.pb.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/api_service.dart';

abstract class PermissionsRemoteDataSource {
  Future<ListPermissionsResponse> getPermissions(ListPermissionsRequest request);

  Future<Permission> getPermission(GetPermissionRequest request);

  Future<Permission> createPermission(CreatePermissionRequest request);

  Future<Permission> updatePermission(UpdatePermissionRequest request);

  Future<DeletePermissionResponse> deletePermission(DeletePermissionRequest request);
  Future<ListUserPermissionsResponse> getUserPermissions(ListUserPermissionsRequest request);
  Future<AssignPermissionsToUserResponse> assignPermissionsToUser(AssignPermissionsToUserRequest request);
  Future<RemovePermissionsFromUserResponse> removePermissionsFromUser(RemovePermissionsFromUserRequest request);

  Future<ListGroupPermissionsResponse> getGroupPermissions(ListGroupPermissionsRequest request);
  Future<AssignPermissionsToGroupResponse> assignPermissionsToGroup(AssignPermissionsToGroupRequest request);
  Future<RemovePermissionsFromGroupResponse> removePermissionsFromGroup(RemovePermissionsFromGroupRequest request);
}

class PermissionsRemoteDataSourceImpl implements PermissionsRemoteDataSource {
  final ApiService _apiService;

  PermissionsRemoteDataSourceImpl(this._apiService);

  @override
  Future<ListPermissionsResponse> getPermissions(ListPermissionsRequest request) async {
    try {

      // For now, return mock data until backend is ready
      var response = await _apiService.get(
        '/openauth/v1/permissions?search=${request.search}&limit=${request.limit}&offset=${request.offset}&all=${request.all}',
      );
      var pbResponse = ListPermissionsResponse();
      pbResponse.mergeFromProto3Json(response.data);
      return pbResponse;
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'Failed to fetch permissions',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw NetworkException(message: 'Network error: ${e.toString()}');
    }
  }

  @override
  Future<Permission> getPermission(GetPermissionRequest request) async {
    try {
      var response = await _apiService.get('/openauth/v1/permissions/${request.id}');

      var pbResponse = Permission();
      pbResponse.mergeFromProto3Json(response.data);
      return pbResponse;
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'Failed to fetch permission',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw NetworkException(message: 'Network error: ${e.toString()}');
    }
  }

  @override
  Future<Permission> createPermission(CreatePermissionRequest request) async {
    try {
      var response = await _apiService.post(
        '/openauth/v1/permissions',
        data: {
          'name': request.name,
          'display_name': request.displayName,
          'description': request.description,
        },
      );

      var pbResponse = Permission();
      pbResponse.mergeFromProto3Json(response.data);
      return pbResponse;
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'Failed to create permission',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw NetworkException(message: 'Network error: ${e.toString()}');
    }
  }

  @override
  Future<Permission> updatePermission(UpdatePermissionRequest request) async {
    try {
      final permissionId = request.id.toInt();
      var response = await _apiService.put(
        '/openauth/v1/permissions/$permissionId',
        data: {
          'name': request.name,
          'display_name': request.displayName,
          'description': request.description,
        },
      );
      var pbResponse = Permission();
      pbResponse.mergeFromProto3Json(response.data);
      return pbResponse;
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'Failed to update permission',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw NetworkException(message: 'Network error: ${e.toString()}');
    }
  }

  @override
  Future<DeletePermissionResponse> deletePermission(DeletePermissionRequest request) async {
    try {
      await _apiService.delete('/openauth/v1/permissions/${request.id}');

      return DeletePermissionResponse()
        ..success = true
        ..message = 'Permission deleted successfully';
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'Failed to delete permission',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw NetworkException(message: 'Network error: ${e.toString()}');
    }
  }

  @override
  Future<ListUserPermissionsResponse> getUserPermissions(ListUserPermissionsRequest request) async {
    try {
      final response = await _apiService.get(
        '/openauth/v1/users/${request.userId}/effective-permissions',
      );
      var permissionList = ListUserPermissionsResponse();
      permissionList.mergeFromProto3Json(response.data);
    
      return permissionList;
    } on DioException catch (e) {
      throw ServerException(
        message: 'Failed to fetch user permissions: ${e.message}',
        statusCode: e.response?.statusCode ?? 500,
      );
    } catch (e) {
      throw ServerException(
        message: 'Unexpected error occurred while fetching user permissions: $e',
        statusCode: 500,
      );
    }
  }

   @override
  Future<AssignPermissionsToUserResponse> assignPermissionsToUser(AssignPermissionsToUserRequest request) async {
    try {
      final response = await _apiService.post(
        '/openauth/v1/users/${request.userId}/permissions',
        data: request.toProto3Json(),
      );
      var assignResponse = AssignPermissionsToUserResponse();
      assignResponse.mergeFromProto3Json(response.data);
      return assignResponse;
    } on DioException catch (e) {
      throw ServerException(
        message: 'Failed to assign permissions to user: ${e.message}',
        statusCode: e.response?.statusCode ?? 500,
      );
    } catch (e) {
      throw ServerException(
        message: 'Unexpected error occurred while assigning permissions to user: $e',
        statusCode: 500,
      );
    }
  } 


  @override
  Future<RemovePermissionsFromUserResponse> removePermissionsFromUser(RemovePermissionsFromUserRequest request) async {
    try {
      final response = await _apiService.put(
        '/openauth/v1/users/${request.userId}/permissions',
        data: request.toProto3Json(),
      );
      var removeResponse = RemovePermissionsFromUserResponse();
      removeResponse.mergeFromProto3Json(response.data);
      return removeResponse;
    } on DioException catch (e) {
      throw ServerException(
        message: 'Failed to remove permission from user: ${e.message}',
        statusCode: e.response?.statusCode ?? 500,
      );
    } catch (e) {
      throw ServerException(
        message: 'Unexpected error occurred while removing permission from user: $e',
        statusCode: 500,
      );
    }
  }

  @override
  Future<ListGroupPermissionsResponse> getGroupPermissions(ListGroupPermissionsRequest request) async {
    try {
      final response = await _apiService.get(
        '/openauth/v1/groups/${request.groupId}/permissions',
      );
      var groupPermissionsResponse = ListGroupPermissionsResponse();
      groupPermissionsResponse.mergeFromProto3Json(response.data);
      return groupPermissionsResponse;
    } on DioException catch (e) {
      throw ServerException(
        message: 'Failed to get group permissions: ${e.message}',
        statusCode: e.response?.statusCode ?? 500,
      );
    } catch (e) {
      throw ServerException(
        message: 'Unexpected error occurred while getting group permissions: $e',
        statusCode: 500,
      );
    }
  }

  @override
  Future<AssignPermissionsToGroupResponse> assignPermissionsToGroup(AssignPermissionsToGroupRequest request) async {
    try {
      final response = await _apiService.post(
        '/openauth/v1/groups/${request.groupId}/permissions',
        data: request.toProto3Json(),
      );
      var assignResponse = AssignPermissionsToGroupResponse();
      assignResponse.mergeFromProto3Json(response.data);
      return assignResponse;
    } on DioException catch (e) {
      throw ServerException(
        message: 'Failed to assign permissions to group: ${e.message}',
        statusCode: e.response?.statusCode ?? 500,
      );
    } catch (e) {
      throw ServerException(
        message: 'Unexpected error occurred while assigning permissions to group: $e',
        statusCode: 500,
      );
    }
  }

  @override
  Future<RemovePermissionsFromGroupResponse> removePermissionsFromGroup(RemovePermissionsFromGroupRequest request) async {
    try {
      final response = await _apiService.put(
        '/openauth/v1/groups/${request.groupId}/permissions',
        data: request.toProto3Json(),
      );
      var removeResponse = RemovePermissionsFromGroupResponse();
      removeResponse.mergeFromProto3Json(response.data);
      return removeResponse;
    } on DioException catch (e) {
      throw ServerException(
        message: 'Failed to remove permissions from group: ${e.message}',
        statusCode: e.response?.statusCode ?? 500,
      );
    } catch (e) {
      throw ServerException(
        message: 'Unexpected error occurred while removing permissions from group: $e',
        statusCode: 500,
      );
    }
  }
}
