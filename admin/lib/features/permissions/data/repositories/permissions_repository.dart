import 'package:dartz/dartz.dart';
import 'package:openauth/src/generated/openauth/v1/permission_assignments.pb.dart';
import 'package:openauth/src/generated/openauth/v1/permissions.pbserver.dart';
import '../../../../core/errors/failures.dart';

abstract class PermissionsRepository {
  Future<Either<Failure, List<Permission>>> getPermissions(ListPermissionsRequest request);

  Future<Either<Failure, Permission>> getPermission(GetPermissionRequest request);

  Future<Either<Failure,  Permission>> createPermission(CreatePermissionRequest request);

  Future<Either<Failure, Permission>> updatePermission(UpdatePermissionRequest request);

  Future<Either<Failure, void>> deletePermission(DeletePermissionRequest request);

  Future<Either<Failure, ListUserPermissionsResponse>> getUserPermissions(ListUserPermissionsRequest request);
  Future<Either<Failure, AssignPermissionsToUserResponse>> assignPermissionsToUser(AssignPermissionsToUserRequest request);
  Future<Either<Failure, RemovePermissionsFromUserResponse>> removePermissionsFromUser(RemovePermissionsFromUserRequest request);
}
