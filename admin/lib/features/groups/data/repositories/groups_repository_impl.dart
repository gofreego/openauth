import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../src/generated/openauth/v1/groups.pb.dart';
import 'groups_repository.dart';
import '../datasources/groups_remote_datasource_impl.dart';

class GroupsRepositoryImpl implements GroupsRepository {
  final GroupsRemoteDataSource remoteDataSource;

  GroupsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Group>>> getGroups(ListGroupsRequest request) async {
    try {
      final response = await remoteDataSource.getGroups( request);
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
  Future<Either<Failure, Group>> getGroup(GetGroupRequest request) async {
    try {
      final group = await remoteDataSource.getGroup(request);
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
  Future<Either<Failure, Group>> createGroup(CreateGroupRequest request) async {
    try {
      final group = await remoteDataSource.createGroup(request);
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
  Future<Either<Failure, Group>> updateGroup(UpdateGroupRequest request) async {
    try {
      final group = await remoteDataSource.updateGroup(request);
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
  Future<Either<Failure, void>> deleteGroup(DeleteGroupRequest request) async {
    try {
      await remoteDataSource.deleteGroup( request);
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
  Future<Either<Failure, List<GroupUser>>> getGroupUsers(ListGroupUsersRequest request) async {
    try {
      final response = await remoteDataSource.getGroupUsers(request);
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
  Future<Either<Failure, List<UserGroup>>> getUserGroups(ListUserGroupsRequest request) async {
    try {
      final response = await remoteDataSource.getUserGroups(request);
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
  Future<Either<Failure, void>> assignUserToGroup(AssignUsersToGroupRequest request) async {
    try {
      await remoteDataSource.assignUsersToGroup(request);
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
  Future<Either<Failure, void>> removeUserFromGroup(RemoveUsersFromGroupRequest request) async {
    try {
      await remoteDataSource.removeUserFromGroup(request);
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
