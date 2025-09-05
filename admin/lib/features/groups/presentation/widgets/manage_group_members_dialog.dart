import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fixnum/fixnum.dart';
import 'package:openauth/shared/utils/toast_utils.dart';
import '../../../../src/generated/openauth/v1/groups.pb.dart';
import '../../../../src/generated/openauth/v1/users.pb.dart' as users_pb;
import '../../../users/presentation/bloc/users_bloc.dart';
import '../../../users/presentation/bloc/users_state.dart';
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
  List<users_pb.User> _availableUsers = [];
  bool _isLoading = true;
  bool _isLoadingUsers = true;
  String _searchQuery = '';
  Set<Int64> selectedUsersToAdd = <Int64>{}; // Track selected users to add
  Set<Int64> selectedUsersToRemove = <Int64>{}; // Track selected users to remove
  bool _isAddingUsers = false;
  bool _isRemovingUsers = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    // Load group members
    context.read<GroupsBloc>().add(ListGroupUsersRequest(groupId: widget.group.id));
    // Load all users
    context.read<UsersBloc>().add(users_pb.ListUsersRequest());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Dialog(
      child: Container(
        width: 1200, // Increased width for side-by-side layout
        height: 700,
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
                  child: const Icon(
                    Icons.people,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Manage Members',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'for ${widget.group.displayName.isEmpty ? widget.group.name : widget.group.displayName}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.refresh),
                  tooltip: 'Refresh',
                  onPressed: () {
                    setState(() {
                      _isLoading = true;
                      _isLoadingUsers = true;
                    });
                    _loadData();
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // System group info
            if (widget.group.isSystem)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  border: Border.all(color: Colors.blue.shade200),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info, color: Colors.blue.shade600, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'This is a system group. You can manage members, but permissions are controlled by the system.',
                        style: TextStyle(
                          color: Colors.blue.shade700,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            // Search bar
            TextField(
              decoration: const InputDecoration(
                labelText: 'Search users...',
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

            // Side by side layout
            Expanded(
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
                        // Clear selections when users are successfully assigned
                        setState(() {
                          selectedUsersToAdd.clear();
                          _isAddingUsers = false;
                        });
                        ToastUtils.showSuccess('User(s) added to group successfully');
                        // Reload group members
                        context.read<GroupsBloc>().add(ListGroupUsersRequest(groupId: widget.group.id));
                      } else if (state is UserRemoved) {
                        // Clear selections when users are successfully removed
                        setState(() {
                          selectedUsersToRemove.clear();
                          _isRemovingUsers = false;
                        });
                        ToastUtils.showSuccess('User(s) removed from group successfully');
                        // Reload group members
                        context.read<GroupsBloc>().add(ListGroupUsersRequest(groupId: widget.group.id));
                      } else if (state is UserAssigning) {
                        setState(() {
                          _isAddingUsers = true;
                        });
                      } else if (state is UserRemoving) {
                        setState(() {
                          _isRemovingUsers = true;
                        });
                      } else if (state is GroupsError) {
                        setState(() {
                          _isAddingUsers = false;
                          _isRemovingUsers = false;
                        });
                        ToastUtils.showError('Error: ${state.message}');
                      }
                    },
                  ),
                  BlocListener<UsersBloc, UsersState>(
                    listener: (context, state) {
                      if (state is UsersLoaded) {
                        setState(() {
                          _availableUsers = state.users;
                          _isLoadingUsers = false;
                        });
                      } else if (state is UsersError) {
                        ToastUtils.showError('Error loading users: ${state.message}');
                        setState(() {
                          _isLoadingUsers = false;
                        });
                      }
                    },
                  ),
                ],
                child: _isLoading || _isLoadingUsers
                    ? const Center(child: CircularProgressIndicator())
                    : Row(
                        children: [
                          // Group members (left side)
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.people,
                                      size: 20,
                                      color: theme.colorScheme.primary,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Group Members (${_groupMembers.length})',
                                      style: theme.textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    if (_groupMembers.isNotEmpty)
                                      TextButton(
                                        onPressed: () {
                                          setState(() {
                                            if (selectedUsersToRemove.length == _groupMembers.length) {
                                              selectedUsersToRemove.clear();
                                            } else {
                                              selectedUsersToRemove.clear();
                                              selectedUsersToRemove.addAll(_groupMembers.map((m) => m.userId));
                                            }
                                          });
                                        },
                                        child: Text(
                                          selectedUsersToRemove.length == _groupMembers.length ? 'Deselect All' : 'Select All',
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      ),
                                    const Spacer(),
                                    if (selectedUsersToRemove.isNotEmpty)
                                      Chip(
                                        label: Text('${selectedUsersToRemove.length} selected'),
                                        backgroundColor: Colors.red.withValues(alpha: 0.1),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Expanded(child: _buildGroupMembers()),
                              ],
                            ),
                          ),
                          // Vertical divider
                          Container(
                            width: 1,
                            margin: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.outline.withValues(alpha: 0.2),
                            ),
                          ),
                          // Available users (right side)
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.person_add,
                                      size: 20,
                                      color: Colors.green,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Available Users',
                                      style: theme.textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    // Select all available users button
                                    BlocBuilder<UsersBloc, UsersState>(
                                      builder: (context, state) {
                                        if (state is UsersLoaded) {
                                          final groupMemberIds = _groupMembers.map((m) => m.userId).toSet();
                                          final availableUsers = state.users.where((user) {
                                            if (groupMemberIds.contains(user.id)) return false;
                                            if (_searchQuery.isEmpty) return true;
                                            return user.username.toLowerCase().contains(_searchQuery) ||
                                                   user.email.toLowerCase().contains(_searchQuery) ||
                                                   user.name.toLowerCase().contains(_searchQuery);
                                          }).toList();
                                          
                                          if (availableUsers.isNotEmpty) {
                                            final availableUserIds = availableUsers.map((u) => u.id).toSet();
                                            final allSelected = availableUserIds.every((id) => selectedUsersToAdd.contains(id));
                                            
                                            return TextButton(
                                              onPressed: () {
                                                setState(() {
                                                  if (allSelected) {
                                                    selectedUsersToAdd.removeAll(availableUserIds);
                                                  } else {
                                                    selectedUsersToAdd.addAll(availableUserIds);
                                                  }
                                                });
                                              },
                                              child: Text(
                                                allSelected ? 'Deselect All' : 'Select All',
                                                style: const TextStyle(fontSize: 12),
                                              ),
                                            );
                                          }
                                        }
                                        return const SizedBox.shrink();
                                      },
                                    ),
                                    const Spacer(),
                                    if (selectedUsersToAdd.isNotEmpty)
                                      Chip(
                                        label: Text('${selectedUsersToAdd.length} selected'),
                                        backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.1),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Expanded(child: _buildAvailableUsers()),
                              ],
                            ),
                          ),
                        ],
                      ),
              ),
            ),

            // Action buttons
            const SizedBox(height: 16),
            Row(
              children: [
                // Left side - Clear buttons
                Expanded(
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      if (selectedUsersToAdd.isNotEmpty)
                        TextButton.icon(
                          onPressed: () {
                            setState(() {
                              selectedUsersToAdd.clear();
                            });
                          },
                          icon: const Icon(Icons.clear_all),
                          label: const Text('Clear Add'),
                        ),
                      if (selectedUsersToRemove.isNotEmpty)
                        TextButton.icon(
                          onPressed: () {
                            setState(() {
                              selectedUsersToRemove.clear();
                            });
                          },
                          icon: const Icon(Icons.clear_all),
                          label: const Text('Clear Remove'),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.red,
                          ),
                        ),
                    ],
                  ),
                ),
                // Right side - Action buttons
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Close'),
                    ),
                    if (selectedUsersToRemove.isNotEmpty)
                      ElevatedButton.icon(
                        onPressed: _isRemovingUsers ? null : _removeSelectedUsers,
                        icon: _isRemovingUsers
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Icon(Icons.remove),
                        label: Text(_isRemovingUsers ? 'Removing...' : 'Remove'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    if (selectedUsersToAdd.isNotEmpty)
                      ElevatedButton.icon(
                        onPressed: _isAddingUsers ? null : _addSelectedUsers,
                        icon: _isAddingUsers
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Icon(Icons.add),
                        label: Text(_isAddingUsers ? 'Adding...' : 'Add'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.primary,
                          foregroundColor: Colors.white,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
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
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _searchQuery.isEmpty ? Icons.people_outline : Icons.search_off,
              size: 64, 
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              _searchQuery.isEmpty 
                  ? 'No members in this group'
                  : 'No members found matching "$_searchQuery"',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              _searchQuery.isEmpty
                  ? 'Add users from the available users list'
                  : 'Try adjusting your search query',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: filteredMembers.length,
      itemBuilder: (context, index) {
        final member = filteredMembers[index];
        final theme = Theme.of(context);
        final isSelected = selectedUsersToRemove.contains(member.userId);
        
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          color: isSelected ? Colors.red.withValues(alpha: 0.1) : null,
          child: ListTile(
            leading: GestureDetector(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    selectedUsersToRemove.remove(member.userId);
                  } else {
                    selectedUsersToRemove.add(member.userId);
                  }
                });
              },
              child: CircleAvatar(
                backgroundColor: isSelected
                    ? Colors.red
                    : theme.colorScheme.primary.withValues(alpha: 0.1),
                child: isSelected
                    ? const Icon(Icons.check_circle, color: Colors.white)
                    : Text(
                        member.name.isNotEmpty 
                            ? member.name[0].toUpperCase()
                            : member.username[0].toUpperCase(),
                        style: TextStyle(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
            title: Text(
              member.name.isNotEmpty ? member.name : member.username,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '@${member.username}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
                if (member.email.isNotEmpty)
                  Text(
                    member.email,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
              ],
            ),
            onTap: () {
              setState(() {
                if (isSelected) {
                  selectedUsersToRemove.remove(member.userId);
                } else {
                  selectedUsersToRemove.add(member.userId);
                }
              });
            },
            trailing: IconButton(
              icon: Icon(
                isSelected ? Icons.check_circle : Icons.remove_circle_outline,
                color: Colors.red,
              ),
              tooltip: isSelected
                  ? 'Deselect for bulk removal'
                  : 'Remove user',
              onPressed: isSelected
                  ? () {
                      setState(() {
                        selectedUsersToRemove.remove(member.userId);
                      });
                    }
                  : () => _removeUserFromGroup(member.userId),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAvailableUsers() {
    if (_isLoadingUsers) {
      return const Center(child: CircularProgressIndicator());
    }

    // Filter out users that are already in the group
    final groupMemberIds = _groupMembers.map((m) => m.userId).toSet();
    final availableUsers = _availableUsers.where((user) {
      if (groupMemberIds.contains(user.id)) return false;
      if (_searchQuery.isEmpty) return true;
      return user.username.toLowerCase().contains(_searchQuery) ||
             user.email.toLowerCase().contains(_searchQuery) ||
             user.name.toLowerCase().contains(_searchQuery);
    }).toList();

    if (availableUsers.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _searchQuery.isEmpty ? Icons.check_circle_outline : Icons.search_off,
              size: 64, 
              color: _searchQuery.isEmpty ? Colors.green : Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              _searchQuery.isEmpty 
                  ? 'All users are members'
                  : 'No available users found matching "$_searchQuery"',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              _searchQuery.isEmpty
                  ? 'All registered users are already members of this group'
                  : 'Try adjusting your search query',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: availableUsers.length,
      itemBuilder: (context, index) {
        final user = availableUsers[index];
        final theme = Theme.of(context);
        final isSelected = selectedUsersToAdd.contains(user.id);
        
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          color: isSelected ? theme.colorScheme.primary.withValues(alpha: 0.1) : null,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: isSelected
                  ? theme.colorScheme.primary
                  : Colors.green.withValues(alpha: 0.1),
              child: isSelected
                  ? const Icon(Icons.check_circle, color: Colors.white)
                  : Text(
                      user.name.isNotEmpty 
                          ? user.name[0].toUpperCase()
                          : user.username[0].toUpperCase(),
                      style: const TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
            title: Text(
              user.name.isNotEmpty ? user.name : user.username,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '@${user.username}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
                if (user.email.isNotEmpty)
                  Text(
                    user.email,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
              ],
            ),
            onTap: () {
              setState(() {
                if (isSelected) {
                  selectedUsersToAdd.remove(user.id);
                } else {
                  selectedUsersToAdd.add(user.id);
                }
              });
            },
            trailing: IconButton(
              icon: Icon(
                isSelected ? Icons.check_circle : Icons.add_circle_outline,
                color: isSelected ? theme.colorScheme.primary : Colors.green,
              ),
              tooltip: isSelected
                  ? 'Deselect for bulk addition'
                  : 'Add to group',
              onPressed: isSelected
                  ? () {
                      setState(() {
                        selectedUsersToAdd.remove(user.id);
                      });
                    }
                  : () => _addUserToGroup(user.id),
            ),
          ),
        );
      },
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
              context.read<GroupsBloc>().add(RemoveUsersFromGroupRequest(
                groupId: widget.group.id,
                userIds: [userId],
              ));
            },
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }

  void _addUserToGroup(Int64 userId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add User'),
        content: const Text('Are you sure you want to add this user to the group?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<GroupsBloc>().add(AssignUsersToGroupRequest(
                groupId: widget.group.id,
                userIds: [userId],
              ));
            },
            style: FilledButton.styleFrom(backgroundColor: Colors.green),
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _addSelectedUsers() {
    if (selectedUsersToAdd.isEmpty) return;

    setState(() {
      _isAddingUsers = true;
    });

    context.read<GroupsBloc>().add(AssignUsersToGroupRequest(
      groupId: widget.group.id,
      userIds: selectedUsersToAdd.toList(),
    ));
  }

  void _removeSelectedUsers() {
    if (selectedUsersToRemove.isEmpty) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Users'),
        content: Text(
          'Are you sure you want to remove ${selectedUsersToRemove.length} user${selectedUsersToRemove.length == 1 ? '' : 's'} from ${widget.group.displayName.isEmpty ? widget.group.name : widget.group.displayName}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                _isRemovingUsers = true;
              });
              context.read<GroupsBloc>().add(
                RemoveUsersFromGroupRequest(
                  groupId: widget.group.id,
                  userIds: selectedUsersToRemove.toList(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }
}
