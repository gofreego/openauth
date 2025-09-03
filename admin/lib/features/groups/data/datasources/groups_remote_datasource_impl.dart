import 'package:dio/dio.dart';
import 'package:fixnum/fixnum.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/api_service.dart';
import '../../../../src/generated/openauth/v1/groups.pb.dart';

abstract class GroupsRemoteDataSource {
  Future<ListGroupsResponse> getGroups({
    String? search,
    int? pageSize,
    String? pageToken,
  });

  Future<Group> getGroup(Int64 groupId);

  Future<Group> createGroup({
    required String name,
    required String displayName,
    String? description,
  });

  Future<Group> updateGroup({
    required Int64 groupId,
    required String name,
    required String displayName,
    String? description,
  });

  Future<DeleteGroupResponse> deleteGroup(Int64 groupId);

  Future<ListGroupUsersResponse> getGroupUsers(Int64 groupId);

  Future<AssignUserToGroupResponse> assignUserToGroup({
    required Int64 groupId,
    required Int64 userId,
  });

  Future<RemoveUserFromGroupResponse> removeUserFromGroup({
    required Int64 groupId,
    required Int64 userId,
  });
}

class GroupsRemoteDataSourceImpl implements GroupsRemoteDataSource {
  final ApiService _apiService;

  GroupsRemoteDataSourceImpl(this._apiService);

  @override
  Future<ListGroupsResponse> getGroups({
    String? search,
    int? pageSize,
    String? pageToken,
  }) async {
    try {
      final queryParams = <String, dynamic>{};

      if (search != null && search.isNotEmpty) {
        queryParams['search'] = search;
      }
      if (pageSize != null) {
        queryParams['page_size'] = pageSize;
      }
      if (pageToken != null && pageToken.isNotEmpty) {
        queryParams['page_token'] = pageToken;
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
    required String name,
    required String displayName,
    String? description,
  }) async {
    try {
      final response = await _apiService.post(
        '/openauth/v1/groups',
        data: {
          'name': name,
          'display_name': displayName,
          if (description != null) 'description': description,
        },
      );

      final pbResponse = Group();
      pbResponse.mergeFromProto3Json(response.data);
      return pbResponse;
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
    required Int64 groupId,
    required String name,
    required String displayName,
    String? description,
  }) async {
    try {
      final response = await _apiService.put(
        '/openauth/v1/groups/$groupId',
        data: {
          'name': name,
          'display_name': displayName,
          if (description != null) 'description': description,
        },
      );

      final pbResponse = Group();
      pbResponse.mergeFromProto3Json(response.data);
      return pbResponse;
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
    required Int64 groupId,
    required Int64 userId,
  }) async {
    try {
      final response = await _apiService.post(
        '/openauth/v1/groups/$groupId/users',
        data: {'user_id': userId.toString()},
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
    required Int64 groupId,
    required Int64 userId,
  }) async {
    try {
      final response = await _apiService.delete(
        '/openauth/v1/groups/$groupId/users/$userId',
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
