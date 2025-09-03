import 'package:dartz/dartz.dart';
import 'package:fixnum/fixnum.dart';
import '../../../../core/errors/failures.dart';
import '../../../../src/generated/openauth/v1/permissions.pb.dart' as pb;

abstract class PermissionsRepository {
  Future<Either<Failure, List<pb.Permission>>> getPermissions({
    int? limit,
    int? offset,
    String? search,
  });

  Future<Either<Failure, pb.Permission>> getPermission(Int64 permissionId);

  Future<Either<Failure, pb.Permission>> createPermission(pb.CreatePermissionRequest request);

  Future<Either<Failure, pb.Permission>> updatePermission(pb.UpdatePermissionRequest request);

  Future<Either<Failure, void>> deletePermission(Int64 permissionId);
}
