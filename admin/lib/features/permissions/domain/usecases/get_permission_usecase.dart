import 'package:dartz/dartz.dart';
import 'package:fixnum/fixnum.dart';
import 'package:openauth/src/generated/openauth/v1/permissions.pb.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/permissions_repository.dart';

class GetPermissionUseCase {
  final PermissionsRepository repository;

  GetPermissionUseCase(this.repository);

  Future<Either<Failure, Permission>> call(Int64 permissionId) async {
    return await repository.getPermission(permissionId);
  }
}
