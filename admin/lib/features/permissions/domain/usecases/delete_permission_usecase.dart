import 'package:dartz/dartz.dart';
import 'package:fixnum/fixnum.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/permissions_repository.dart';

class DeletePermissionUseCase {
  final PermissionsRepository repository;

  DeletePermissionUseCase(this.repository);

  Future<Either<Failure, void>> call(Int64 permissionId) async {
    return await repository.deletePermission(permissionId);
  }
}
