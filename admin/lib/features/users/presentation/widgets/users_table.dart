import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:openauth/src/generated/openauth/v1/users.pb.dart';
import '../../../../src/generated/openauth/v1/users.pb.dart' as pb;
import '../../domain/extensions/user_extensions.dart';
import '../bloc/users_bloc.dart';
import '../bloc/users_state.dart';
import '../bloc/users_event.dart';
import 'user_row.dart';
import 'edit_user_dialog.dart';
import '../../../../shared/widgets/error_widget.dart' as shared;

class UsersTable extends StatelessWidget {
  final String searchQuery;
  final bool showActiveOnly;
  final bool showInactiveOnly;

  const UsersTable({
    super.key,
    required this.searchQuery,
    required this.showActiveOnly,
    required this.showInactiveOnly,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      child: Column(
        children: [
          // Table header
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    'User',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Email',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Status',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Last Login',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 48), // For actions
              ],
            ),
          ),
          
          // Table content
          Expanded(
            child: BlocBuilder<UsersBloc, UsersState>(
              builder: (context, state) {
                if (state is UsersLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is UsersError) {
                  return shared.ErrorWidget(
                    failure: state.failure,
                    onRetry: () {
                      context.read<UsersBloc>().add(const RefreshUsersEvent());
                    },
                  );
                } else if (state is UsersLoaded) {
                  final filteredUsers = _getFilteredUsers(state.users);
                  
                  if (filteredUsers.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.people_outline,
                            size: 64,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No users found',
                            style: theme.textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Try adjusting your search or filters',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  
                  return ListView.builder(
                    itemCount: filteredUsers.length,
                    itemBuilder: (context, index) {
                      final user = filteredUsers[index];
                      return UserRow(
                        user: user,
                        index: index,
                        onUserAction: _handleUserAction,
                      );
                    },
                  );
                }
                
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  List<pb.User> _getFilteredUsers(List<pb.User> users) {
    List<pb.User> filtered = users;
    
    // Apply search filter
    if (searchQuery.isNotEmpty) {
      filtered = filtered.where((user) {
        return user.displayName.toLowerCase().contains(searchQuery.toLowerCase()) ||
               user.username.toLowerCase().contains(searchQuery.toLowerCase()) ||
               user.email.toLowerCase().contains(searchQuery.toLowerCase());
      }).toList();
    }
    
    // Apply status filters
    if (showActiveOnly && !showInactiveOnly) {
      filtered = filtered.where((user) => user.isActive).toList();
    } else if (showInactiveOnly && !showActiveOnly) {
      filtered = filtered.where((user) => !user.isActive).toList();
    }
    
    return filtered;
  }

  void _handleUserAction(String action, pb.User user, BuildContext context) {
    switch (action) {
      case 'edit':
        _showEditUserDialog(user, context);
        break;
      case 'permissions':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Manage permissions for ${user.displayName}')),
        );
        break;
      case 'sessions':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('View sessions for ${user.displayName}')),
        );
        break;
      case 'activate':
      case 'deactivate':
        _toggleUserActiveStatus(user, context);
        break;
      case 'delete':
        _showDeleteUserDialog(user, context);
        break;
    }
  }

  void _showDeleteUserDialog(pb.User user, BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete User'),
        content: Text('Are you sure you want to delete ${user.displayName}? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              final bloc = context.read<UsersBloc>();
              if (!bloc.isClosed) {
                bloc.add(DeleteUserEvent(user.uuid));
              }
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${user.displayName} deleted successfully')),
              );
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

  void _showEditUserDialog(pb.User user, BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: context.read<UsersBloc>(),
        child: EditUserDialog(
          user: user,
          onUserUpdated: () {
            // The BlocConsumer in the dialog will handle the success message
          },
        ),
      ),
    );
  }

  void _toggleUserActiveStatus(pb.User user, BuildContext context) {
    final newStatus = !user.isActive;
    final action = newStatus ? 'activate' : 'deactivate';
    final capitalizedAction = action[0].toUpperCase() + action.substring(1);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('$capitalizedAction User'),
        content: Text('Are you sure you want to $action ${user.displayName}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              final bloc = context.read<UsersBloc>();
              if (!bloc.isClosed) {
                bloc.add(UpdateUserEvent(
                  request: UpdateUserRequest(
                    uuid: user.uuid,
                    isActive: newStatus,
                  ),
                ));
              }
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${user.displayName} ${action}d successfully')),
              );
            },
            child: Text(capitalizedAction),
          ),
        ],
      ),
    );
  }
}
