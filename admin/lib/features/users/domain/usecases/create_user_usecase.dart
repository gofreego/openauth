import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/users_repository.dart';
import '../../../../src/generated/openauth/v1/users.pb.dart' as pb;

class CreateUserUseCase {
  final UsersRepository repository;

  CreateUserUseCase(this.repository);

  Future<Either<Failure, pb.User>> call({
    required pb.SignUpRequest request,
  }) async {
    return await repository.createUser(request);
  }
}