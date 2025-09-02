import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../src/generated/openauth/v1/users.pb.dart' as pb;
import '../../data/repositories/users_repository.dart';

class GetUsersUseCase {
  final UsersRepository repository;

  GetUsersUseCase(this.repository);

  Future<Either<Failure, List<pb.User>>> call({
    int page = 1,
    int limit = 50,
    String? search,
    bool? isActive,
  }) async {
    return await repository.getUsers(
      page: page,
      limit: limit,
      search: search,
      isActive: isActive,
    );
  }
}