import 'package:dartz/dartz.dart';
import 'package:openauth/src/generated/openauth/v1/permissions.pbserver.dart';
import '../../../../core/errors/failures.dart';

abstract class PermissionsRepository {
  Future<Either<Failure, List<Permission>>> getPermissions(ListPermissionsRequest request);

  Future<Either<Failure, Permission>> getPermission(GetPermissionRequest request);

  Future<Either<Failure,  Permission>> createPermission(CreatePermissionRequest request);

  Future<Either<Failure, Permission>> updatePermission(UpdatePermissionRequest request);

  Future<Either<Failure, void>> deletePermission(DeletePermissionRequest request);
}
