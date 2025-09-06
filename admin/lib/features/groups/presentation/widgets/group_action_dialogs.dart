import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:openauth/features/groups/presentation/bloc/group_permissions_bloc.dart';
import 'package:openauth/features/groups/presentation/bloc/groups_bloc.dart';
import 'package:openauth/features/groups/presentation/widgets/group_details_dialog.dart';
import 'package:openauth/features/groups/presentation/widgets/manage_group_members_dialog.dart';
import 'package:openauth/features/groups/presentation/widgets/manage_group_permissions_dialog.dart';
import 'package:openauth/features/permissions/presentation/bloc/permissions_bloc.dart';
import 'package:openauth/features/users/presentation/bloc/users_bloc.dart';
import 'package:openauth/src/generated/openauth/v1/groups.pb.dart';

class GroupActionDialogs {
  
  static void showDeleteGroupDialog(BuildContext context, Group group) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Group'),
        content: Text(
          'Are you sure you want to delete "${group.displayName}"? '
          'This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              context.read<GroupsBloc>().add(DeleteGroupRequest(id: group.id));
              Navigator.of(context).pop();
            },
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }


  static void showManageMembersDialog(BuildContext context, Group group) {
    showDialog(
      context: context,
      builder: (dialogContext) => MultiBlocProvider(
        providers: [
          BlocProvider.value(value: context.read<GroupsBloc>()),
          BlocProvider.value(value: context.read<UsersBloc>()),
        ],
        child: ManageGroupMembersDialog(
          group: group,
        ),
      ),
    );
  }


  static  showGroupDetails(BuildContext context, Group group, {bool editMode = false}) {
    showDialog(
      context: context,
      builder: (dialogContext) => MultiBlocProvider(
        providers: [
          BlocProvider.value(value: context.read<GroupsBloc>()),
          BlocProvider.value(value: context.read<UsersBloc>()),
        ],
        child: GroupDetailsDialog(
          group: group,
          editMode: editMode,
        ),
      ),
    );
  }

  static void showManagePermissionsDialog(BuildContext context, Group group) {
    showDialog(
      context: context,
      builder: (dialogContext) => MultiBlocProvider(
        providers: [
          BlocProvider.value(value: context.read<GroupsBloc>()),
          BlocProvider.value(value: context.read<PermissionsBloc>()),
          BlocProvider.value(value: context.read<GroupPermissionsBloc>()),
        ],
        child: ManageGroupPermissionsDialog(
          group: group,
        ),
      ),
    );
  }


}