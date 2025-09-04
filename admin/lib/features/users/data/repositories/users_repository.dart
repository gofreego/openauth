import 'package:dartz/dartz.dart';
import 'package:openauth/src/generated/openauth/v1/users.pbserver.dart';
import '../../../../core/errors/failures.dart';

abstract class UsersRepository {
  Future<Either<Failure, List<User>>> getUsers(ListUsersRequest request);

  Future<Either<Failure, User>> getUser(GetUserRequest request);

  Future<Either<Failure, User>> createUser(SignUpRequest request);

  Future<Either<Failure, User>> updateUser(UpdateUserRequest request);

  Future<Either<Failure, void>> deleteUser(DeleteUserRequest request);

  Future<Either<Failure, UserProfile>> createProfile(CreateProfileRequest request);

  Future<Either<Failure, UserProfile>> updateProfile(UpdateProfileRequest request);

  Future<Either<Failure, void>> deleteProfile(DeleteProfileRequest request);
}