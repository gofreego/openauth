import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../src/generated/openauth/v1/users.pb.dart' as user_pb;
import '../../../../src/generated/openauth/v1/groups.pb.dart' as groups_pb;
import '../../../../shared/shared.dart';
import '../../../groups/presentation/bloc/groups_bloc.dart';
import '../../../../shared/widgets/custom_search_bar.dart';

class UserGroupsDialog extends StatefulWidget {
  final user_pb.User user;

  const UserGroupsDialog({
    super.key,
    required this.user,
  });

  static void show(BuildContext context, user_pb.User user) {
    showDialog(
      context: context,
      builder: (context) => UserGroupsDialog(user: user),
    );
  }

  @override
  State<UserGroupsDialog> createState() => _UserGroupsDialogState();
}

class _UserGroupsDialogState extends State<UserGroupsDialog> {
  String _searchQuery = '';
  List<groups_pb.UserGroup> _userGroups = [];
  bool _isRemoving = false;

  @override
  void initState() {
    super.initState();
    // Load user groups
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GroupsBloc>().add(
            groups_pb.ListUserGroupsRequest(userId: widget.user.id),
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      child: Container(
        width: 800,
        height: 600,
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: theme.colorScheme.primary,
                  backgroundImage: widget.user.avatarUrl.isNotEmpty
                      ? NetworkImage(widget.user.avatarUrl)
                      : null,
                  child: widget.user.avatarUrl.isEmpty
                      ? Text(
                          _getInitial(),
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'User Groups',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'for ${widget.user.name} (@${widget.user.username})',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Search Bar
            CustomSearchBar(
              hintText: 'Search user groups...',
              onKeyStrokeChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
            const SizedBox(height: 16),

            // Groups List
            Expanded(
              child: BlocListener<GroupsBloc, GroupsState>(
                listener: (context, state) {
                  if (state is UserRemoved) {
                    setState(() {
                      _isRemoving = false;
                    });
                    ToastUtils.showSuccess('${widget.user.name} removed from group successfully');
                    // Refresh the groups list
                    context.read<GroupsBloc>().add(
                          groups_pb.ListUserGroupsRequest(userId: widget.user.id),
                        );
                  } else if (state is GroupsError) {
                    setState(() {
                      _isRemoving = false;
                    });
                    ToastUtils.showError('Failed to remove user from group: ${state.message}');
                  }
                },
                child: BlocBuilder<GroupsBloc, GroupsState>(
                  builder: (context, state) {
                    if (state is GroupsLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is GroupsError) {
                      return _buildErrorWidget(state.message);
                    } else if (state is UserGroupsLoaded) {
                      _userGroups = state.groups;
                      return _buildGroupsList();
                    }
                    return _buildEmptyState();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorWidget(String message) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            'Error loading user groups',
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(message),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              context.read<GroupsBloc>().add(
                    groups_pb.ListUserGroupsRequest(userId: widget.user.id),
                  );
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.group_outlined, size: 48, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            'No groups found',
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          const Text('This user is not assigned to any groups.'),
        ],
      ),
    );
  }

  Widget _buildGroupsList() {
    final filteredGroups = _userGroups.where((group) {
      if (_searchQuery.isEmpty) return true;
      return group.groupName
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()) ||
          group.groupDescription
              .toLowerCase()
              .contains(_searchQuery.toLowerCase());
    }).toList();

    if (filteredGroups.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search_off, size: 48, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              'No groups found matching "$_searchQuery"',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: filteredGroups.length,
      itemBuilder: (context, index) {
        final group = filteredGroups[index];
        return _buildGroupCard(group);
      },
    );
  }

  Widget _buildGroupCard(groups_pb.UserGroup group) {
    final theme = Theme.of(context);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(
            Icons.group,
            color: theme.colorScheme.secondary,
        ),
        title: Text(
          group.groupDisplayName,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: group.groupDescription.isNotEmpty
            ? Text(
                group.groupDescription,
                style: theme.textTheme.bodySmall,
              )
            : null,
        trailing: _isRemoving
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : IconButton(
                icon: const Icon(Icons.remove_circle_outline),
                color: Colors.red,
                tooltip: 'Remove from group',
                onPressed: () => _showRemoveConfirmation(group),
              ),
      ),
    );
  }

  void _showRemoveConfirmation(groups_pb.UserGroup group) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove from Group'),
        content: Text(
          'Are you sure you want to remove ${widget.user.name} from the group "${group.groupName}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              _removeFromGroup(group);
            },
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }

  void _removeFromGroup(groups_pb.UserGroup group) {
    setState(() {
      _isRemoving = true;
    });

    // Create the remove request
    final removeRequest = groups_pb.RemoveUsersFromGroupRequest(
      groupId: group.groupId,
      userIds: [widget.user.id],
    );

    context.read<GroupsBloc>().add(removeRequest);
  }

  String _getInitial() {
    if (widget.user.name.isNotEmpty) {
      return widget.user.name[0].toUpperCase();
    } else if (widget.user.username.isNotEmpty) {
      return widget.user.username[0].toUpperCase();
    }
    return 'U';
  }
}
