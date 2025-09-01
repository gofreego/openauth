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

  Future<pb.Permission> getPermission(int permissionId);

  Future<pb.Permission> createPermission(pb.CreatePermissionRequest request);

  Future<pb.Permission> updatePermission(pb.UpdatePermissionRequest request);

  Future<pb.DeletePermissionResponse> deletePermission(int permissionId);
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
  Future<pb.Permission> getPermission(int permissionId) async {
    try {
      // For now, return mock data until backend is ready
      await _apiService.get('/openauth/v1/permissions/$permissionId');

      return _createMockPermission(permissionId);
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
      // For now, return mock data until backend is ready
      await _apiService.post(
        '/openauth/v1/permissions',
        data: {
          'name': request.name,
          'display_name': request.displayName,
          'description': request.description,
        },
      );

      return _createMockCreatePermissionResponse(request);
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

      // For now, return mock data until backend is ready
      await _apiService.put(
        '/openauth/v1/permissions/$permissionId',
        data: {
          'name': request.name,
          'display_name': request.displayName,
          'description': request.description,
        },
      );

      return _createMockUpdatePermissionResponse(request);
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
  Future<pb.DeletePermissionResponse> deletePermission(int permissionId) async {
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

  // Mock data methods for development

  pb.ListPermissionsResponse _createMockListPermissionsResponse(
      int? limit, int? offset) {
    final permissions = _getMockPermissions();
    final startIndex = offset ?? 0;
    final endIndex = limit != null
        ? (startIndex + limit).clamp(0, permissions.length)
        : permissions.length;

    final paginatedPermissions = permissions.sublist(
      startIndex.clamp(0, permissions.length),
      endIndex,
    );

    return pb.ListPermissionsResponse()
      ..permissions.addAll(paginatedPermissions)
      ..limit = limit ?? permissions.length
      ..offset = offset ?? 0;
  }

  pb.Permission _createMockPermission(int permissionId) {
    final permissions = _getMockPermissions();
    return permissions.firstWhere(
      (p) => p.id.toInt() == permissionId,
      orElse: () {
        final defaultPermission = permissions.first;
        return pb.Permission()
          ..id = Int64(permissionId)
          ..name = defaultPermission.name
          ..displayName = defaultPermission.displayName
          ..description = defaultPermission.description
          ..createdBy = defaultPermission.createdBy
          ..createdAt = defaultPermission.createdAt
          ..updatedAt = defaultPermission.updatedAt;
      },
    );
  }

  pb.Permission _createMockCreatePermissionResponse(
      pb.CreatePermissionRequest request) {
    return pb.Permission()
      ..id = Int64(DateTime.now().millisecondsSinceEpoch)
      ..name = request.name
      ..displayName = request.displayName
      ..description = request.description
      ..createdBy = Int64(1) // Current user ID
      ..createdAt = Int64(DateTime.now().millisecondsSinceEpoch ~/ 1000)
      ..updatedAt = Int64(DateTime.now().millisecondsSinceEpoch ~/ 1000);
  }

  pb.Permission _createMockUpdatePermissionResponse(
      pb.UpdatePermissionRequest request) {
    return pb.Permission()
      ..id = request.id
      ..name = request.name
      ..displayName = request.displayName
      ..description = request.description
      ..createdBy = Int64(1) // Current user ID
      ..createdAt = Int64(DateTime.now()
              .subtract(const Duration(days: 30))
              .millisecondsSinceEpoch ~/
          1000)
      ..updatedAt = Int64(DateTime.now().millisecondsSinceEpoch ~/ 1000);
  }

  List<pb.Permission> _getMockPermissions() {
    return [
      pb.Permission()
        ..id = Int64(1)
        ..name = 'user.create'
        ..displayName = 'Create Users'
        ..description = 'Ability to create new user accounts'
        ..createdBy = Int64(1)
        ..createdAt = Int64(DateTime.now()
                .subtract(const Duration(days: 30))
                .millisecondsSinceEpoch ~/
            1000)
        ..updatedAt = Int64(DateTime.now()
                .subtract(const Duration(days: 15))
                .millisecondsSinceEpoch ~/
            1000),
      pb.Permission()
        ..id = Int64(2)
        ..name = 'user.read'
        ..displayName = 'View Users'
        ..description = 'Ability to view user accounts and profiles'
        ..createdBy = Int64(1)
        ..createdAt = Int64(DateTime.now()
                .subtract(const Duration(days: 25))
                .millisecondsSinceEpoch ~/
            1000)
        ..updatedAt = Int64(DateTime.now()
                .subtract(const Duration(days: 10))
                .millisecondsSinceEpoch ~/
            1000),
      pb.Permission()
        ..id = Int64(3)
        ..name = 'user.update'
        ..displayName = 'Edit Users'
        ..description = 'Ability to edit existing user accounts'
        ..createdBy = Int64(1)
        ..createdAt = Int64(DateTime.now()
                .subtract(const Duration(days: 20))
                .millisecondsSinceEpoch ~/
            1000)
        ..updatedAt = Int64(DateTime.now()
                .subtract(const Duration(days: 5))
                .millisecondsSinceEpoch ~/
            1000),
      pb.Permission()
        ..id = Int64(4)
        ..name = 'user.delete'
        ..displayName = 'Delete Users'
        ..description = 'Ability to delete user accounts'
        ..createdBy = Int64(1)
        ..createdAt = Int64(DateTime.now()
                .subtract(const Duration(days: 18))
                .millisecondsSinceEpoch ~/
            1000)
        ..updatedAt = Int64(DateTime.now()
                .subtract(const Duration(days: 3))
                .millisecondsSinceEpoch ~/
            1000),
      pb.Permission()
        ..id = Int64(5)
        ..name = 'system.settings'
        ..displayName = 'System Settings'
        ..description = 'Access to system configuration settings'
        ..createdBy = Int64(1)
        ..createdAt = Int64(DateTime.now()
                .subtract(const Duration(days: 15))
                .millisecondsSinceEpoch ~/
            1000)
        ..updatedAt = Int64(DateTime.now()
                .subtract(const Duration(days: 2))
                .millisecondsSinceEpoch ~/
            1000),
      pb.Permission()
        ..id = Int64(6)
        ..name = 'analytics.view'
        ..displayName = 'View Analytics'
        ..description = 'Access to system analytics and reports'
        ..createdBy = Int64(1)
        ..createdAt = Int64(DateTime.now()
                .subtract(const Duration(days: 12))
                .millisecondsSinceEpoch ~/
            1000)
        ..updatedAt = Int64(DateTime.now()
                .subtract(const Duration(days: 1))
                .millisecondsSinceEpoch ~/
            1000),
      pb.Permission()
        ..id = Int64(7)
        ..name = 'analytics.export'
        ..displayName = 'Export Data'
        ..description = 'Ability to export system data'
        ..createdBy = Int64(1)
        ..createdAt = Int64(DateTime.now()
                .subtract(const Duration(days: 10))
                .millisecondsSinceEpoch ~/
            1000)
        ..updatedAt = Int64(DateTime.now()
                .subtract(const Duration(hours: 12))
                .millisecondsSinceEpoch ~/
            1000),
      pb.Permission()
        ..id = Int64(8)
        ..name = 'content.publish'
        ..displayName = 'Publish Content'
        ..description = 'Ability to publish content'
        ..createdBy = Int64(1)
        ..createdAt = Int64(DateTime.now()
                .subtract(const Duration(days: 8))
                .millisecondsSinceEpoch ~/
            1000)
        ..updatedAt = Int64(DateTime.now()
                .subtract(const Duration(hours: 6))
                .millisecondsSinceEpoch ~/
            1000),
      pb.Permission()
        ..id = Int64(9)
        ..name = 'content.moderate'
        ..displayName = 'Moderate Content'
        ..description = 'Ability to moderate user content'
        ..createdBy = Int64(1)
        ..createdAt = Int64(DateTime.now()
                .subtract(const Duration(days: 6))
                .millisecondsSinceEpoch ~/
            1000)
        ..updatedAt = Int64(DateTime.now()
                .subtract(const Duration(hours: 3))
                .millisecondsSinceEpoch ~/
            1000),
      pb.Permission()
        ..id = Int64(10)
        ..name = 'system.backup'
        ..displayName = 'Backup & Restore'
        ..description = 'Ability to create and restore backups'
        ..createdBy = Int64(1)
        ..createdAt = Int64(DateTime.now()
                .subtract(const Duration(days: 4))
                .millisecondsSinceEpoch ~/
            1000)
        ..updatedAt = Int64(DateTime.now()
                .subtract(const Duration(hours: 1))
                .millisecondsSinceEpoch ~/
            1000),
    ];
  }
}
