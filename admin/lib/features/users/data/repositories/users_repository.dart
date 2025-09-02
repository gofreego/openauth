import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../src/generated/openauth/v1/users.pb.dart' as pb;

abstract class UsersRepository {
  Future<Either<Failure, List<pb.User>>> getUsers({
    int page = 1,
    int limit = 50,
    String? search,
    bool? isActive,
  });

  Future<Either<Failure, pb.User>> getUser(String userIdOrUuid);

  Future<Either<Failure, pb.User>> createUser(pb.SignUpRequest request);

  Future<Either<Failure, pb.User>> updateUser(pb.UpdateUserRequest request);

  Future<Either<Failure, void>> deleteUser(String userIdOrUuid);

  Future<Either<Failure, pb.UserProfile>> createProfile(pb.CreateProfileRequest request);

  Future<Either<Failure, pb.UserProfile>> updateProfile(pb.UpdateProfileRequest request);

  Future<Either<Failure, void>> deleteProfile(String profileUuid);
}