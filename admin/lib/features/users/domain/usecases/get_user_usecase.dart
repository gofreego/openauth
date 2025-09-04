import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../src/generated/openauth/v1/users.pb.dart' as pb;
import '../../data/repositories/users_repository.dart';

class GetUserUseCase {
  final UsersRepository repository;

  GetUserUseCase(this.repository);

  Future<Either<Failure, pb.User>> call(String userIdOrUuid) async {
    return await repository.getUser(userIdOrUuid);
  }
}
