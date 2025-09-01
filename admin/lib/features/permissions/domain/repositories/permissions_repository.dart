import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/permission_entity.dart';
import '../../../../src/generated/openauth/v1/permissions.pb.dart' as pb;

abstract class PermissionsRepository {
  Future<Either<Failure, List<PermissionEntity>>> getPermissions({
    int? limit,
    int? offset,
    String? search,
  });

  Future<Either<Failure, PermissionEntity>> getPermission(int permissionId);

  Future<Either<Failure, PermissionEntity>> createPermission(pb.CreatePermissionRequest request);

  Future<Either<Failure, PermissionEntity>> updatePermission(pb.UpdatePermissionRequest request);

  Future<Either<Failure, void>> deletePermission(int permissionId);
}
