import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user.dart';
import '../repositories/users_repository.dart';
import '../../../../src/generated/openauth/v1/users.pb.dart' as pb;

class UpdateUserUseCase {
  final UsersRepository repository;

  UpdateUserUseCase(this.repository);

  Future<Either<Failure, UserEntity>> call({
    required String uuid,
    String? username,
    String? email,
    String? phone,
    bool? isActive,
    String? name,
    String? avatarUrl,
  }) async {
    final request = pb.UpdateUserRequest()..uuid = uuid;

    if (username != null) request.username = username;
    if (email != null) request.email = email;
    if (phone != null) request.phone = phone;
    if (isActive != null) request.isActive = isActive;
    if (name != null) request.name = name;
    if (avatarUrl != null) request.avatarUrl = avatarUrl;

    return await repository.updateUser(request);
  }
}