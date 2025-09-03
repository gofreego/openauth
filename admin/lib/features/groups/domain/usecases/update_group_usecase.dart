import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../src/generated/openauth/v1/groups.pb.dart';
import '../repositories/groups_repository.dart';

class UpdateGroupUseCase {
  final GroupsRepository repository;

  UpdateGroupUseCase(this.repository);

  Future<Either<Failure, Group>> call({ required UpdateGroupRequest request }) async {
    return await repository.updateGroup(
      request: request,
    );
  }
}