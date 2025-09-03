import 'package:dio/dio.dart';
import 'package:fixnum/fixnum.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/api_service.dart';
import '../../../../src/generated/openauth/v1/groups.pb.dart';

abstract class GroupsRemoteDataSource {
  Future<ListGroupsResponse> getGroups({
    required ListGroupsRequest request,
  });

  Future<Group> getGroup(Int64 groupId);

  Future<Group> createGroup({
    required CreateGroupRequest request,
  });

  Future<Group> updateGroup({
    required UpdateGroupRequest request,
  });

  Future<DeleteGroupResponse> deleteGroup(Int64 groupId);

  Future<ListGroupUsersResponse> getGroupUsers(Int64 groupId);

  Future<AssignUserToGroupResponse> assignUserToGroup({
    required AssignUserToGroupRequest request,
  });

  Future<RemoveUserFromGroupResponse> removeUserFromGroup({
    required RemoveUserFromGroupRequest request,
  });
}

class GroupsRemoteDataSourceImpl implements GroupsRemoteDataSource {
  final ApiService _apiService;

  GroupsRemoteDataSourceImpl(this._apiService);

  @override
  Future<ListGroupsResponse> getGroups({
    required ListGroupsRequest request,
  }) async {
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
  Future<Group> getGroup(Int64 groupId) async {
    try {
      final response = await _apiService.get('/openauth/v1/groups/$groupId');
      
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
  Future<Group> createGroup({
    required CreateGroupRequest request,
  }) async {
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
  Future<Group> updateGroup({
    required UpdateGroupRequest request,
  }) async {
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
  Future<DeleteGroupResponse> deleteGroup(Int64 groupId) async {
    try {
      final response = await _apiService.delete('/openauth/v1/groups/$groupId');
      
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
  Future<ListGroupUsersResponse> getGroupUsers(Int64 groupId) async {
    try {
      final response = await _apiService.get('/openauth/v1/groups/$groupId/users');
      
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
  Future<AssignUserToGroupResponse> assignUserToGroup({
    required AssignUserToGroupRequest request,
  }) async {
    try {
      final response = await _apiService.post(
        '/openauth/v1/groups/${request.groupId}/users',
        data: request.toProto3Json(),
      );
      
      final pbResponse = AssignUserToGroupResponse();
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
  Future<RemoveUserFromGroupResponse> removeUserFromGroup({
    required RemoveUserFromGroupRequest request,
  }) async {
    try {
      final response = await _apiService.delete(
        '/openauth/v1/groups/${request.groupId}/users/${request.userId}',
      );
      
      final pbResponse = RemoveUserFromGroupResponse();
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
