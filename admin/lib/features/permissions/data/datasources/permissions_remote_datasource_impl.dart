import 'package:dio/dio.dart';
import 'package:openauth/src/generated/openauth/v1/permissions.pb.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/api_service.dart';

abstract class PermissionsRemoteDataSource {
  Future<ListPermissionsResponse> getPermissions(ListPermissionsRequest request);

  Future<Permission> getPermission(GetPermissionRequest request);

  Future<Permission> createPermission(CreatePermissionRequest request);

  Future<Permission> updatePermission(UpdatePermissionRequest request);

  Future<DeletePermissionResponse> deletePermission(DeletePermissionRequest request);
}

class PermissionsRemoteDataSourceImpl implements PermissionsRemoteDataSource {
  final ApiService _apiService;

  PermissionsRemoteDataSourceImpl(this._apiService);

  @override
  Future<ListPermissionsResponse> getPermissions(ListPermissionsRequest request) async {
    try {
      final queryParams = <String, dynamic>{};
        queryParams['limit'] = request.limit;
        queryParams['offset'] = request.offset;

      if (request.search.isNotEmpty) {
        queryParams['search'] = request.search;
      }

      // For now, return mock data until backend is ready
      var response = await _apiService.get(
        '/openauth/v1/permissions',
        queryParameters: queryParams,
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
}
