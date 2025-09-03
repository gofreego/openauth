import 'package:dio/dio.dart';
import 'package:fixnum/fixnum.dart';
import '../../../../src/generated/openauth/v1/permissions.pb.dart' as pb;
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/api_service.dart';

abstract class PermissionsRemoteDataSource {
  Future<pb.ListPermissionsResponse> getPermissions({
    int? limit,
    int? offset,
    String? search,
  });

  Future<pb.Permission> getPermission(Int64 permissionId);

  Future<pb.Permission> createPermission(pb.CreatePermissionRequest request);

  Future<pb.Permission> updatePermission(pb.UpdatePermissionRequest request);

  Future<pb.DeletePermissionResponse> deletePermission(Int64 permissionId);
}

class PermissionsRemoteDataSourceImpl implements PermissionsRemoteDataSource {
  final ApiService _apiService;

  PermissionsRemoteDataSourceImpl(this._apiService);

  @override
  Future<pb.ListPermissionsResponse> getPermissions({
    int? limit,
    int? offset,
    String? search,
  }) async {
    try {
      final queryParams = <String, dynamic>{};

      if (limit != null) {
        queryParams['limit'] = limit;
      }

      if (offset != null) {
        queryParams['offset'] = offset;
      }

      if (search != null && search.isNotEmpty) {
        queryParams['search'] = search;
      }

      // For now, return mock data until backend is ready
      var response = await _apiService.get(
        '/openauth/v1/permissions',
        queryParameters: queryParams,
      );
      var pbResponse = pb.ListPermissionsResponse();
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
  Future<pb.Permission> getPermission(Int64 permissionId) async {
    try {
      var response = await _apiService.get('/openauth/v1/permissions/$permissionId');

      var pbResponse = pb.Permission();
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
  Future<pb.Permission> createPermission(
      pb.CreatePermissionRequest request) async {
    try {
      var response = await _apiService.post(
        '/openauth/v1/permissions',
        data: {
          'name': request.name,
          'display_name': request.displayName,
          'description': request.description,
        },
      );

      var pbResponse = pb.Permission();
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
  Future<pb.Permission> updatePermission(
      pb.UpdatePermissionRequest request) async {
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
      var pbResponse = pb.Permission();
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
  Future<pb.DeletePermissionResponse> deletePermission(Int64 permissionId) async {
    try {
      await _apiService.delete('/openauth/v1/permissions/$permissionId');

      return pb.DeletePermissionResponse()
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
