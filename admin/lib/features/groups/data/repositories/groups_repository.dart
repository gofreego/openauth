import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../src/generated/openauth/v1/groups.pb.dart';

abstract class GroupsRepository {
  Future<Either<Failure, List<Group>>> getGroups(ListGroupsRequest request);

  Future<Either<Failure, Group>> getGroup(GetGroupRequest request);

  Future<Either<Failure, Group>> createGroup(CreateGroupRequest request);

  Future<Either<Failure, Group>> updateGroup(UpdateGroupRequest request);

  Future<Either<Failure, void>> deleteGroup(DeleteGroupRequest request);

  Future<Either<Failure, List<GroupUser>>> getGroupUsers(ListGroupUsersRequest request);

  Future<Either<Failure, List<UserGroup>>> getUserGroups(ListUserGroupsRequest request);

  Future<Either<Failure, void>> assignUserToGroup(AssignUsersToGroupRequest request);

  Future<Either<Failure, void>> removeUserFromGroup(RemoveUsersFromGroupRequest request);
}
