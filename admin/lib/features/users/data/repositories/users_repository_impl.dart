import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../users/domain/entities/user.dart';
import '../../../users/domain/repositories/users_repository.dart';
import '../datasources/users_remote_datasource_impl.dart';
import '../../../../src/generated/openauth/v1/users.pb.dart' as pb;

class UsersRepositoryImpl implements UsersRepository {
  final UsersRemoteDataSource remoteDataSource;

  UsersRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<UserEntity>>> getUsers({
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

      final userEntities = response.users.map((user) => UserEntity(user: user)).toList();
      return Right(userEntities);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'An unexpected error occurred: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getUser(String userIdOrUuid) async {
    try {
      final response = await remoteDataSource.getUser(userIdOrUuid);
      final userEntity = UserEntity(
        user: response.user,
        profile: response.hasProfile() ? response.profile : null,
      );
      return Right(userEntity);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'An unexpected error occurred: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> createUser(pb.SignUpRequest request) async {
    try {
      final response = await remoteDataSource.createUser(request);
      final userEntity = UserEntity(user: response.user);
      return Right(userEntity);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'An unexpected error occurred: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> updateUser(pb.UpdateUserRequest request) async {
    try {
      final response = await remoteDataSource.updateUser(request);
      final userEntity = UserEntity(user: response.user);
      return Right(userEntity);
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
