import 'package:dio/dio.dart';
import '../../../../core/errors/exceptions.dart';
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

  Future<AssignUsersToGroupResponse> assignUsersToGroup(AssignUsersToGroupRequest request);

  Future<RemoveUsersFromGroupResponse> removeUserFromGroup(RemoveUsersFromGroupRequest request);
}

class GroupsRemoteDataSourceImpl implements GroupsRemoteDataSource {
  final ApiService _apiService;

  GroupsRemoteDataSourceImpl(this._apiService);

  @override
  Future<ListGroupsResponse> getGroups(ListGroupsRequest request) async {
    try {
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
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'Failed to fetch groups',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw NetworkException(message: 'Network error: ${e.toString()}');
    }
  }

  @override
  Future<Group> getGroup(GetGroupRequest request) async {
    try {
      final response = await _apiService.get('/openauth/v1/groups/${request.id}');

      final pbResponse = Group();
      pbResponse.mergeFromProto3Json(response.data);
      return pbResponse;
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'Failed to fetch group',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw NetworkException(message: 'Network error: ${e.toString()}');
    }
  }

  @override
  Future<Group> createGroup(CreateGroupRequest request) async {
    try {
      final response = await _apiService.post(
        '/openauth/v1/groups',
        data: request.toProto3Json(),
      );

      final pbResponse = CreateGroupResponse();
      pbResponse.mergeFromProto3Json(response.data);
      return pbResponse.group;
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'Failed to create group',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw NetworkException(message: 'Network error: ${e.toString()}');
    }
  }

  @override
  Future<Group> updateGroup(UpdateGroupRequest request) async {
    try {
      final response = await _apiService.put(
        '/openauth/v1/groups/${request.id}',
        data: request.toProto3Json(),
      );

      final pbResponse = UpdateGroupResponse();
      pbResponse.mergeFromProto3Json(response.data);
      return pbResponse.group;
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'Failed to update group',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw NetworkException(message: 'Network error: ${e.toString()}');
    }
  }

  @override
  Future<DeleteGroupResponse> deleteGroup(DeleteGroupRequest request) async {
    try {
      final response = await _apiService.delete('/openauth/v1/groups/${request.id}');
      
      final pbResponse = DeleteGroupResponse();
      if (response.data != null) {
        pbResponse.mergeFromProto3Json(response.data);
      }
      return pbResponse;
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'Failed to delete group',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw NetworkException(message: 'Network error: ${e.toString()}');
    }
  }

  @override
  Future<ListGroupUsersResponse> getGroupUsers(ListGroupUsersRequest request) async {
    try {
      final response = await _apiService.get('/openauth/v1/groups/${request.groupId}/users');

      final pbResponse = ListGroupUsersResponse();
      pbResponse.mergeFromProto3Json(response.data);
      return pbResponse;
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'Failed to fetch group users',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw NetworkException(message: 'Network error: ${e.toString()}');
    }
  }

  @override
  Future<ListUserGroupsResponse> getUserGroups(ListUserGroupsRequest request) async {
    try {
      final response = await _apiService.get('/openauth/v1/users/${request.userId}/groups');

      final pbResponse = ListUserGroupsResponse();
      pbResponse.mergeFromProto3Json(response.data);
      return pbResponse;
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'Failed to fetch user groups',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw NetworkException(message: 'Network error: ${e.toString()}');
    }
  }

  @override
  Future<AssignUsersToGroupResponse> assignUsersToGroup(AssignUsersToGroupRequest request) async {
    try {
      final response = await _apiService.post(
        '/openauth/v1/groups/${request.groupId}/users',
        data: request.toProto3Json(),
      );
      
      final pbResponse = AssignUsersToGroupResponse();
      if (response.data != null) {
        pbResponse.mergeFromProto3Json(response.data);
      }
      return pbResponse;
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'Failed to assign user to group',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw NetworkException(message: 'Network error: ${e.toString()}');
    }
  }

  @override
  Future<RemoveUsersFromGroupResponse> removeUserFromGroup(RemoveUsersFromGroupRequest request) async {
    try {
      final response = await _apiService.delete(
        '/openauth/v1/groups/${request.groupId}/users',
        data: request.toProto3Json(),
      );
      
      final pbResponse = RemoveUsersFromGroupResponse();
      if (response.data != null) {
        pbResponse.mergeFromProto3Json(response.data);
      }
      return pbResponse;
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'Failed to remove user from group',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw NetworkException(message: 'Network error: ${e.toString()}');
    }
  }
}
