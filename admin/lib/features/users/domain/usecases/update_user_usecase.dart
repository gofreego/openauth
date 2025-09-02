import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../src/generated/openauth/v1/users.pb.dart' as pb;
import '../repositories/users_repository.dart';

class UpdateUserUseCase {
  final UsersRepository repository;

  UpdateUserUseCase(this.repository);

  Future<Either<Failure, pb.User>> call({
    required pb.UpdateUserRequest request,
  }) async {
    return await repository.updateUser(request);
  }
}