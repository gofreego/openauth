import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user.dart';
import '../repositories/users_repository.dart';

class GetUsersUseCase {
  final UsersRepository repository;

  GetUsersUseCase(this.repository);

  Future<Either<Failure, List<UserEntity>>> call({
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