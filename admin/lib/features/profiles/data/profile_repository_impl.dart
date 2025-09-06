import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../src/generated/openauth/v1/users.pb.dart' as pb;
import '../../users/data/datasources/users_remote_datasource_impl.dart';
import 'profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final UsersRemoteDataSource remoteDataSource;

  ProfileRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, pb.ListUserProfilesResponse>> listUserProfiles(pb.ListUserProfilesRequest request) async {
    try {
      final response = await remoteDataSource.listUserProfiles(request);
      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'An unexpected error occurred: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, pb.CreateProfileResponse>> createProfile(pb.CreateProfileRequest request) async {
    try {
      final response = await remoteDataSource.createProfile(request);
      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'An unexpected error occurred: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, pb.UpdateProfileResponse>> updateProfile(pb.UpdateProfileRequest request) async {
    try {
      final response = await remoteDataSource.updateProfile(request);
      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'An unexpected error occurred: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, pb.DeleteProfileResponse>> deleteProfile(pb.DeleteProfileRequest request) async {
    try {
      final response = await remoteDataSource.deleteProfile(request);
      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'An unexpected error occurred: ${e.toString()}'));
    }
  }
}
