import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/users_repository.dart';

class DeleteUserUseCase {
  final UsersRepository repository;

  DeleteUserUseCase(this.repository);

  Future<Either<Failure, void>> call(String userIdOrUuid) async {
    return await repository.deleteUser(userIdOrUuid);
  }
}