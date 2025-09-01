import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/permission_entity.dart';
import '../repositories/permissions_repository.dart';
import '../../../../src/generated/openauth/v1/permissions.pb.dart' as pb;

class UpdatePermissionUseCase {
  final PermissionsRepository repository;

  UpdatePermissionUseCase(this.repository);

  Future<Either<Failure, PermissionEntity>> call(pb.UpdatePermissionRequest request) async {
    return await repository.updatePermission(request);
  }
}
