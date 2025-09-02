import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/errors/exceptions.dart';
import 'users_repository.dart';
import '../datasources/users_remote_datasource_impl.dart';
import '../../../../src/generated/openauth/v1/users.pb.dart' as pb;

class UsersRepositoryImpl implements UsersRepository {
  final UsersRemoteDataSource remoteDataSource;

  UsersRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<pb.User>>> getUsers({
    int page = 1,
    int limit = 50,
    String? search,
    bool? isActive,
  }) async {
    try {
      final response = await remoteDataSource.getUsers(
        page: page,
        limit: limit,
        search: search,
        isActive: isActive,
      );

      return Right(response.users);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'An unexpected error occurred: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, pb.User>> getUser(String userIdOrUuid) async {
    try {
      final response = await remoteDataSource.getUser(userIdOrUuid);
      return Right(response.user);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'An unexpected error occurred: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, pb.User>> createUser(pb.SignUpRequest request) async {
    try {
      final response = await remoteDataSource.createUser(request);
      return Right(response.user);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'An unexpected error occurred: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, pb.User>> updateUser(pb.UpdateUserRequest request) async {
    try {
      final response = await remoteDataSource.updateUser(request);
      return Right(response.user);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'An unexpected error occurred: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteUser(String userIdOrUuid) async {
    try {
      await remoteDataSource.deleteUser(userIdOrUuid);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'An unexpected error occurred: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, pb.UserProfile>> createProfile(pb.CreateProfileRequest request) async {
    try {
      final response = await remoteDataSource.createProfile(request);
      return Right(response.profile);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'An unexpected error occurred: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, pb.UserProfile>> updateProfile(pb.UpdateProfileRequest request) async {
    try {
      final response = await remoteDataSource.updateProfile(request);
      return Right(response.profile);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'An unexpected error occurred: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteProfile(String profileUuid) async {
    try {
      await remoteDataSource.deleteProfile(profileUuid);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'An unexpected error occurred: ${e.toString()}'));
    }
  }
}
