import 'package:dartz/dartz.dart';
import 'package:fixnum/fixnum.dart';
import '../../../../core/errors/failures.dart';
import '../../../../src/generated/openauth/v1/groups.pb.dart';
import '../repositories/groups_repository.dart';

class UpdateGroupUseCase {
  final GroupsRepository repository;

  UpdateGroupUseCase(this.repository);

  Future<Either<Failure, Group>> call({
    required Int64 groupId,
    required String name,
    required String displayName,
    String? description,
  }) async {
    return await repository.updateGroup(
      groupId: groupId,
      name: name,
      displayName: displayName,
      description: description,
    );
  }
}
