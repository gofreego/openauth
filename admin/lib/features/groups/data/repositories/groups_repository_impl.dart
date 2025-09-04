import 'package:dartz/dartz.dart';
import 'package:fixnum/fixnum.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../src/generated/openauth/v1/groups.pb.dart';
import '../../domain/repositories/groups_repository.dart';
import '../datasources/groups_remote_datasource_impl.dart';

class GroupsRepositoryImpl implements GroupsRepository {
  final GroupsRemoteDataSource remoteDataSource;

  GroupsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Group>>> getGroups({
   required ListGroupsRequest request,
  }) async {
    try {
      final response = await remoteDataSource.getGroups(request: request);
      return Right(response.groups);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Group>> getGroup(Int64 groupId) async {
    try {
      final group = await remoteDataSource.getGroup(groupId);
      return Right(group);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Group>> createGroup({
    required CreateGroupRequest request,
  }) async {
    try {
      final group = await remoteDataSource.createGroup(request: request);
      return Right(group);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Group>> updateGroup({
    required UpdateGroupRequest request,
  }) async {
    try {
      final group = await remoteDataSource.updateGroup(request: request);
      return Right(group);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteGroup(Int64 groupId) async {
    try {
      await remoteDataSource.deleteGroup(groupId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<GroupUser>>> getGroupUsers(Int64 groupId) async {
    try {
      final response = await remoteDataSource.getGroupUsers(groupId);
      return Right(response.users);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<UserGroup>>> getUserGroups(Int64 userId) async {
    try {
      final response = await remoteDataSource.getUserGroups(userId);
      return Right(response.groups);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> assignUserToGroup({
    required AssignUsersToGroupRequest request,
  }) async {
    try {
      await remoteDataSource.assignUserToGroup(
        request: request
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> removeUserFromGroup({
    required RemoveUsersFromGroupRequest request,
  }) async {
    try {
      await remoteDataSource.removeUserFromGroup(
        request: request
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
