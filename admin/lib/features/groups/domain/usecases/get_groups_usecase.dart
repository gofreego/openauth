import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../src/generated/openauth/v1/groups.pb.dart';
import '../repositories/groups_repository.dart';

class GetGroupsUseCase {
  final GroupsRepository repository;

  GetGroupsUseCase(this.repository);

  Future<Either<Failure, List<Group>>> call({
   required ListGroupsRequest request,
  }) async {
    return await repository.getGroups(
      request: request,
    );
  }
}
