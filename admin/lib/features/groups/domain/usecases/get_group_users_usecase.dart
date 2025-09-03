import 'package:dartz/dartz.dart';
import 'package:fixnum/fixnum.dart';
import '../../../../core/errors/failures.dart';
import '../../../../src/generated/openauth/v1/groups.pb.dart';
import '../repositories/groups_repository.dart';

class GetGroupUsersUseCase {
  final GroupsRepository repository;

  GetGroupUsersUseCase(this.repository);

  Future<Either<Failure, List<GroupUser>>> call(Int64 groupId) async {
    return await repository.getGroupUsers(groupId);
  }
}
