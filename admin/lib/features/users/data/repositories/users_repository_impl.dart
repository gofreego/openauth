import 'package:dartz/dartz.dart';
import 'package:openauth/src/generated/openauth/v1/users.pbserver.dart';
import '../../../../core/errors/failures.dart';
import 'users_repository.dart';
import '../datasources/users_remote_datasource_impl.dart';
import '../../../../src/generated/openauth/v1/users.pb.dart' as pb;

class UsersRepositoryImpl implements UsersRepository {
  final UsersRemoteDataSource remoteDataSource;

  UsersRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<pb.User>>> getUsers(pb.ListUsersRequest request) async {
    try {
      final response = await remoteDataSource.getUsers(
        request: request,
      );

      return Right(response.users);
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    } 
  }

  @override
  Future<Either<Failure, pb.User>> getUser(pb.GetUserRequest request) async {
    try {
      final response = await remoteDataSource.getUser(request);
      return Right(response.user);
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, pb.User>> createUser(pb.SignUpRequest request) async {
    try {
      final response = await remoteDataSource.createUser(request);
      return Right(response.user);
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, pb.User>> updateUser(pb.UpdateUserRequest request) async {
    try {
      final response = await remoteDataSource.updateUser(request);
      return Right(response.user);
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, void>> deleteUser(DeleteUserRequest request) async {
    try {
      await remoteDataSource.deleteUser(request);
      return const Right(null);
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, pb.UserProfile>> createProfile(pb.CreateProfileRequest request) async {
    try {
      final response = await remoteDataSource.createProfile(request);
      return Right(response.profile);
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, pb.UserProfile>> updateProfile(pb.UpdateProfileRequest request) async {
    try {
      final response = await remoteDataSource.updateProfile(request);
      return Right(response.profile);
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, void>> deleteProfile(DeleteProfileRequest request) async {
    try {
      await remoteDataSource.deleteProfile(request);
      return const Right(null);
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, List<pb.UserProfile>>> listUserProfiles(pb.ListUserProfilesRequest request) async {
    try {
      final response = await remoteDataSource.listUserProfiles(request);
      return Right(response.profiles);
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }
}
