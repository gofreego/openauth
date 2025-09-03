import 'package:dartz/dartz.dart';
import 'package:fixnum/fixnum.dart';
import '../../../../core/errors/failures.dart';
import '../../../../src/generated/openauth/v1/groups.pb.dart';
import '../repositories/groups_repository.dart';

class GetGroupUseCase {
  final GroupsRepository repository;

  GetGroupUseCase(this.repository);

  Future<Either<Failure, Group>> call(Int64 groupId) async {
    return await repository.getGroup(groupId);
  }
}
