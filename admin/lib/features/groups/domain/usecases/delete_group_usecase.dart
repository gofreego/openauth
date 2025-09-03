import 'package:dartz/dartz.dart';
import 'package:fixnum/fixnum.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/groups_repository.dart';

class DeleteGroupUseCase {
  final GroupsRepository repository;

  DeleteGroupUseCase(this.repository);

  Future<Either<Failure, void>> call(Int64 groupId) async {
    return await repository.deleteGroup(groupId);
  }
}
