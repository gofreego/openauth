import 'package:openauth/src/generated/openauth/v1/permission_assignments.pb.dart';
import 'package:openauth/src/generated/openauth/v1/permissions.pb.dart';
import '../../../../core/network/api_service.dart';

abstract class PermissionsRemoteDataSource {
  Future<ListPermissionsResponse> getPermissions(
      ListPermissionsRequest request);

  Future<Permission> getPermission(GetPermissionRequest request);

  Future<Permission> createPermission(CreatePermissionRequest request);

  Future<Permission> updatePermission(UpdatePermissionRequest request);

  Future<DeletePermissionResponse> deletePermission(
      DeletePermissionRequest request);
  Future<ListUserPermissionsResponse> getUserPermissions(
      ListUserPermissionsRequest request);
  Future<AssignPermissionsToUserResponse> assignPermissionsToUser(
      AssignPermissionsToUserRequest request);
  Future<RemovePermissionsFromUserResponse> removePermissionsFromUser(
      RemovePermissionsFromUserRequest request);

  Future<ListGroupPermissionsResponse> getGroupPermissions(
      ListGroupPermissionsRequest request);
  Future<AssignPermissionsToGroupResponse> assignPermissionsToGroup(
      AssignPermissionsToGroupRequest request);
  Future<RemovePermissionsFromGroupResponse> removePermissionsFromGroup(
      RemovePermissionsFromGroupRequest request);
}

class PermissionsRemoteDataSourceImpl implements PermissionsRemoteDataSource {
  final ApiService _apiService;

  PermissionsRemoteDataSourceImpl(this._apiService);

  @override
  Future<ListPermissionsResponse> getPermissions(
      ListPermissionsRequest request) async {
    var response = await _apiService.get(
      '/openauth/v1/permissions?search=${request.search}&limit=${request.limit}&offset=${request.offset}&all=${request.all}',
    );
    var pbResponse = ListPermissionsResponse();
    pbResponse.mergeFromProto3Json(response.data);
    return pbResponse;
  }

  @override
  Future<Permission> getPermission(GetPermissionRequest request) async {
    var response =
        await _apiService.get('/openauth/v1/permissions/${request.id}');

    var pbResponse = Permission();
    pbResponse.mergeFromProto3Json(response.data);
    return pbResponse;
  }

  @override
  Future<Permission> createPermission(CreatePermissionRequest request) async {
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
  }

  @override
  Future<Permission> updatePermission(UpdatePermissionRequest request) async {
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
  }

  @override
  Future<DeletePermissionResponse> deletePermission(
      DeletePermissionRequest request) async {
    await _apiService.delete('/openauth/v1/permissions/${request.id}');

    return DeletePermissionResponse()
      ..success = true
      ..message = 'Permission deleted successfully';
  }

  @override
  Future<ListUserPermissionsResponse> getUserPermissions(
      ListUserPermissionsRequest request) async {
    final response = await _apiService.get(
      '/openauth/v1/users/${request.userId}/effective-permissions',
    );
    var permissionList = ListUserPermissionsResponse();
    permissionList.mergeFromProto3Json(response.data);

    return permissionList;
  }

  @override
  Future<AssignPermissionsToUserResponse> assignPermissionsToUser(
      AssignPermissionsToUserRequest request) async {
    final response = await _apiService.post(
      '/openauth/v1/users/${request.userId}/permissions',
      data: request.toProto3Json(),
    );
    var assignResponse = AssignPermissionsToUserResponse();
    assignResponse.mergeFromProto3Json(response.data);
    return assignResponse;
  }

  @override
  Future<RemovePermissionsFromUserResponse> removePermissionsFromUser(
      RemovePermissionsFromUserRequest request) async {
    final response = await _apiService.put(
      '/openauth/v1/users/${request.userId}/permissions',
      data: request.toProto3Json(),
    );
    var removeResponse = RemovePermissionsFromUserResponse();
    removeResponse.mergeFromProto3Json(response.data);
    return removeResponse;
  }

  @override
  Future<ListGroupPermissionsResponse> getGroupPermissions(
      ListGroupPermissionsRequest request) async {
    final response = await _apiService.get(
      '/openauth/v1/groups/${request.groupId}/permissions',
    );
    var groupPermissionsResponse = ListGroupPermissionsResponse();
    groupPermissionsResponse.mergeFromProto3Json(response.data);
    return groupPermissionsResponse;
  }

  @override
  Future<AssignPermissionsToGroupResponse> assignPermissionsToGroup(
      AssignPermissionsToGroupRequest request) async {
    final response = await _apiService.post(
      '/openauth/v1/groups/${request.groupId}/permissions',
      data: request.toProto3Json(),
    );
    var assignResponse = AssignPermissionsToGroupResponse();
    assignResponse.mergeFromProto3Json(response.data);
    return assignResponse;
  }

  @override
  Future<RemovePermissionsFromGroupResponse> removePermissionsFromGroup(
      RemovePermissionsFromGroupRequest request) async {
    final response = await _apiService.put(
      '/openauth/v1/groups/${request.groupId}/permissions',
      data: request.toProto3Json(),
    );
    var removeResponse = RemovePermissionsFromGroupResponse();
    removeResponse.mergeFromProto3Json(response.data);
    return removeResponse;
  }
}
