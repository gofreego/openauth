import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/permissions_repository.dart';
import '../../../../src/generated/openauth/v1/permissions.pb.dart' as pb;

class CreatePermissionUseCase {
  final PermissionsRepository repository;

  CreatePermissionUseCase(this.repository);

  Future<Either<Failure, pb.Permission>> call(pb.CreatePermissionRequest request) async {
    return await repository.createPermission(request);
  }
}
