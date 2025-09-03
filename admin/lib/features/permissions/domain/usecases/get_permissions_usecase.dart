import 'package:dartz/dartz.dart';
import 'package:openauth/src/generated/openauth/v1/permissions.pb.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/permissions_repository.dart';

class GetPermissionsUseCase {
  final PermissionsRepository repository;

  GetPermissionsUseCase(this.repository);

  Future<Either<Failure, List<Permission>>> call({
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
