import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/permission_entity.dart';
import '../repositories/permissions_repository.dart';

class GetPermissionsUseCase {
  final PermissionsRepository repository;

  GetPermissionsUseCase(this.repository);

  Future<Either<Failure, List<PermissionEntity>>> call({
    int? limit,
    int? offset,
    String? search,
  }) async {
    return await repository.getPermissions(
      limit: limit,
      offset: offset,
      search: search,
    );
  }
}
