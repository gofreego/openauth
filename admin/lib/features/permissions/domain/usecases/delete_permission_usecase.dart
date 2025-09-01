import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/permissions_repository.dart';

class DeletePermissionUseCase {
  final PermissionsRepository repository;

  DeletePermissionUseCase(this.repository);

  Future<Either<Failure, void>> call(int permissionId) async {
    return await repository.deletePermission(permissionId);
  }
}
