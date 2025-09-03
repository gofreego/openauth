import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../src/generated/openauth/v1/groups.pb.dart';
import '../repositories/groups_repository.dart';

class CreateGroupUseCase {
  final GroupsRepository repository;

  CreateGroupUseCase(this.repository);

  Future<Either<Failure, Group>> call({
    required String name,
    required String displayName,
    String? description,
  }) async {
    return await repository.createGroup(
      name: name,
      displayName: displayName,
      description: description,
    );
  }
}
