import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/permission_entity.dart';
import '../repositories/permissions_repository.dart';

class GetPermissionUseCase {
  final PermissionsRepository repository;

  GetPermissionUseCase(this.repository);

  Future<Either<Failure, PermissionEntity>> call(int permissionId) async {
    return await repository.getPermission(permissionId);
  }
}
