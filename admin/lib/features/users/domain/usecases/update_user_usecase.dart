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
    String? firstName,
    String? lastName,
    String? displayName,
    String? bio,
    String? avatarUrl,
  }) async {
    final request = pb.UpdateUserRequest()..uuid = uuid;

    if (username != null) request.username = username;
    if (email != null) request.email = email;
    if (phone != null) request.phone = phone;
    if (isActive != null) request.isActive = isActive;
    // Note: firstName, lastName, displayName, and bio are not available in UpdateUserRequest
    // They might be part of a separate profile update request
    if (avatarUrl != null) request.avatarUrl = avatarUrl;

    return await repository.updateUser(request);
  }
}