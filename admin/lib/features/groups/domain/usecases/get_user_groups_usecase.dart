import 'package:dartz/dartz.dart';
import 'package:fixnum/fixnum.dart';
import '../../../../core/errors/failures.dart';
import '../../../../src/generated/openauth/v1/groups.pb.dart';
import '../repositories/groups_repository.dart';

class GetUserGroupsUseCase {
  final GroupsRepository repository;

  GetUserGroupsUseCase(this.repository);

  Future<Either<Failure, List<UserGroup>>> call({
    required Int64 userId,
  }) async {
    return await repository.getUserGroups(userId);
  }
}
