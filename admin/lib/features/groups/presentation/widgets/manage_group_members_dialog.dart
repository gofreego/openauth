import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fixnum/fixnum.dart';
import '../../../../src/generated/openauth/v1/groups.pb.dart';
import '../bloc/groups_bloc.dart';

class ManageGroupMembersDialog extends StatefulWidget {
  final Group group;

  const ManageGroupMembersDialog({
    super.key,
    required this.group,
  });

  @override
  State<ManageGroupMembersDialog> createState() => _ManageGroupMembersDialogState();
}

class _ManageGroupMembersDialogState extends State<ManageGroupMembersDialog> {
  List<GroupUser> _groupMembers = [];
  bool _isLoading = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    // For now, just load group members - we'll add full user loading later
    context.read<GroupsBloc>().add(LoadGroupUsers(widget.group.id));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          const Icon(Icons.people),
          const SizedBox(width: 8),
          Expanded(
            child: Text('Manage Members - ${widget.group.displayName}'),
          ),
        ],
      ),
      content: SizedBox(
        width: 800,
        height: 600,
        child: MultiBlocListener(
          listeners: [
            BlocListener<GroupsBloc, GroupsState>(
              listener: (context, state) {
                if (state is GroupUsersLoaded && state.groupId == widget.group.id) {
                  setState(() {
                    _groupMembers = state.users;
                    _isLoading = false;
                  });
                } else if (state is UserAssigned) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('User added to group successfully'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  // Reload group members
                  context.read<GroupsBloc>().add(LoadGroupUsers(widget.group.id));
                } else if (state is UserRemoved) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('User removed from group successfully'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  // Reload group members
                  context.read<GroupsBloc>().add(LoadGroupUsers(widget.group.id));
                } else if (state is GroupsError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error: ${state.message}'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
            ),
          ],
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _buildContent(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    );
  }

  Widget _buildContent() {
    return Column(
      children: [
        // Search bar
        TextField(
          decoration: const InputDecoration(
            labelText: 'Search users',
            prefixIcon: Icon(Icons.search),
            border: OutlineInputBorder(),
          ),
          onChanged: (value) {
            setState(() {
              _searchQuery = value.toLowerCase();
            });
          },
        ),
        const SizedBox(height: 16),
        
        // Tabs for members/available users
        DefaultTabController(
          length: 2,
          child: Expanded(
            child: Column(
              children: [
                const TabBar(
                  tabs: [
                    Tab(text: 'Group Members'),
                    Tab(text: 'Available Users'),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      _buildGroupMembers(),
                      _buildAvailableUsers(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGroupMembers() {
    final filteredMembers = _groupMembers.where((member) {
      if (_searchQuery.isEmpty) return true;
      return member.username.toLowerCase().contains(_searchQuery) ||
             member.email.toLowerCase().contains(_searchQuery) ||
             member.name.toLowerCase().contains(_searchQuery);
    }).toList();

    if (filteredMembers.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.people_outline, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('No members in this group'),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: filteredMembers.length,
      itemBuilder: (context, index) {
        final member = filteredMembers[index];
        return Card(
          child: ListTile(
            leading: CircleAvatar(
              child: Text(
                member.name.isNotEmpty 
                    ? member.name[0].toUpperCase()
                    : member.username[0].toUpperCase(),
              ),
            ),
            title: Text(member.name.isNotEmpty ? member.name : member.username),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('@${member.username}'),
                if (member.email.isNotEmpty)
                  Text(
                    member.email,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
              ],
            ),
            trailing: IconButton(
              icon: const Icon(Icons.remove_circle, color: Colors.red),
              onPressed: () => _removeUserFromGroup(member.userId),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAvailableUsers() {
    // For now, show a placeholder for available users
    // This would be implemented when the UsersBloc is properly available
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.people_outline, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text('User management coming soon...'),
          SizedBox(height: 8),
          Text(
            'This feature will allow you to add new users to the group.',
            style: TextStyle(color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _removeUserFromGroup(Int64 userId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove User'),
        content: const Text('Are you sure you want to remove this user from the group?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<GroupsBloc>().add(RemoveUserFromGroup(
                groupId: widget.group.id,
                userId: userId,
              ));
            },
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }
}
