import '../../../../core/network/api_service.dart';
import '../../../../src/generated/openauth/v1/groups.pb.dart';

abstract class GroupsRemoteDataSource {
  Future<ListGroupsResponse> getGroups(ListGroupsRequest request);

  Future<Group> getGroup(GetGroupRequest request);

  Future<Group> createGroup(CreateGroupRequest request);

  Future<Group> updateGroup(UpdateGroupRequest request);

  Future<DeleteGroupResponse> deleteGroup(DeleteGroupRequest request);

  Future<ListGroupUsersResponse> getGroupUsers(ListGroupUsersRequest request);

  Future<ListUserGroupsResponse> getUserGroups(ListUserGroupsRequest request);

  Future<AssignUsersToGroupResponse> assignUsersToGroup(
      AssignUsersToGroupRequest request);

  Future<RemoveUsersFromGroupResponse> removeUserFromGroup(
      RemoveUsersFromGroupRequest request);
}

class GroupsRemoteDataSourceImpl implements GroupsRemoteDataSource {
  final ApiService _apiService;

  GroupsRemoteDataSourceImpl(this._apiService);

  @override
  Future<ListGroupsResponse> getGroups(ListGroupsRequest request) async {
    final queryParams = <String, dynamic>{};

    if (request.search.isNotEmpty) {
      queryParams['search'] = request.search;
    }

    if (request.id > 0) {
      queryParams['id'] = request.id;
    }

    if (request.limit > 0) {
      queryParams['limit'] = request.limit;
    }

    if (request.offset > 0) {
      queryParams['offset'] = request.offset;
    }

    final response = await _apiService.get(
      '/openauth/v1/groups',
      queryParameters: queryParams,
    );

    final pbResponse = ListGroupsResponse();
    pbResponse.mergeFromProto3Json(response.data);
    return pbResponse;
  }

  @override
  Future<Group> getGroup(GetGroupRequest request) async {
    final response = await _apiService.get('/openauth/v1/groups/${request.id}');

    final pbResponse = Group();
    pbResponse.mergeFromProto3Json(response.data);
    return pbResponse;
  }

  @override
  Future<Group> createGroup(CreateGroupRequest request) async {
    final response = await _apiService.post(
      '/openauth/v1/groups',
      data: request.toProto3Json(),
    );

    final pbResponse = CreateGroupResponse();
    pbResponse.mergeFromProto3Json(response.data);
    return pbResponse.group;
  }

  @override
  Future<Group> updateGroup(UpdateGroupRequest request) async {
    final response = await _apiService.put(
      '/openauth/v1/groups/${request.id}',
      data: request.toProto3Json(),
    );

    final pbResponse = UpdateGroupResponse();
    pbResponse.mergeFromProto3Json(response.data);
    return pbResponse.group;
  }

  @override
  Future<DeleteGroupResponse> deleteGroup(DeleteGroupRequest request) async {
    final response =
        await _apiService.delete('/openauth/v1/groups/${request.id}');

    final pbResponse = DeleteGroupResponse();
    if (response.data != null) {
      pbResponse.mergeFromProto3Json(response.data);
    }
    return pbResponse;
  }

  @override
  Future<ListGroupUsersResponse> getGroupUsers(
      ListGroupUsersRequest request) async {
    final response =
        await _apiService.get('/openauth/v1/groups/${request.groupId}/users');

    final pbResponse = ListGroupUsersResponse();
    pbResponse.mergeFromProto3Json(response.data);
    return pbResponse;
  }

  @override
  Future<ListUserGroupsResponse> getUserGroups(
      ListUserGroupsRequest request) async {
    final response =
        await _apiService.get('/openauth/v1/users/${request.userId}/groups');

    final pbResponse = ListUserGroupsResponse();
    pbResponse.mergeFromProto3Json(response.data);
    return pbResponse;
  }

  @override
  Future<AssignUsersToGroupResponse> assignUsersToGroup(
      AssignUsersToGroupRequest request) async {
    final response = await _apiService.post(
      '/openauth/v1/groups/${request.groupId}/users',
      data: request.toProto3Json(),
    );

    final pbResponse = AssignUsersToGroupResponse();
    if (response.data != null) {
      pbResponse.mergeFromProto3Json(response.data);
    }
    return pbResponse;
  }

  @override
  Future<RemoveUsersFromGroupResponse> removeUserFromGroup(
      RemoveUsersFromGroupRequest request) async {
    final response = await _apiService.put(
      '/openauth/v1/groups/${request.groupId}/users',
      data: request.toProto3Json(),
    );

    final pbResponse = RemoveUsersFromGroupResponse();
    if (response.data != null) {
      pbResponse.mergeFromProto3Json(response.data);
    }
    return pbResponse;
  }
}
