import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user.dart';
import '../repositories/users_repository.dart';
import '../../../../src/generated/openauth/v1/users.pb.dart' as pb;

class CreateUserUseCase {
  final UsersRepository repository;

  CreateUserUseCase(this.repository);

  Future<Either<Failure, UserEntity>> call({
    required String username,
    required String email,
    required String password,
    String? phone,
  }) async {
    final request = pb.SignUpRequest()
      ..username = username
      ..email = email
      ..password = password;

    if (phone != null && phone.isNotEmpty) {
      request.phone = phone;
    }

    return await repository.createUser(request);
  }
}