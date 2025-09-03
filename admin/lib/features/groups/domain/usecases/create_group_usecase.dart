import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../src/generated/openauth/v1/groups.pb.dart';
import '../repositories/groups_repository.dart';

class CreateGroupUseCase {
  final GroupsRepository repository;

  CreateGroupUseCase(this.repository);

  Future<Either<Failure, Group>> call({
    required CreateGroupRequest request,
  }) async {
    return await repository.createGroup(
      request: request,
    );
  }
}
