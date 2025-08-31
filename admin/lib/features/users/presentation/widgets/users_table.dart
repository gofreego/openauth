import 'package:flutter/material.dart';
import '../widgets/user_row.dart';
import '../../data/models/user_model.dart';

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
    final filteredUsers = _getFilteredUsers();
    
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
            child: ListView.builder(
              itemCount: filteredUsers.length,
              itemBuilder: (context, index) {
                final user = filteredUsers[index];
                return UserRow(
                  user: user,
                  index: index,
                  onUserAction: _handleUserAction,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  List<UserModel> _getFilteredUsers() {
    List<UserModel> users = UserModel.mockUsers;
    
    // Apply search filter
    if (searchQuery.isNotEmpty) {
      users = users.where((user) {
        return user.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
               user.username.toLowerCase().contains(searchQuery.toLowerCase()) ||
               user.email.toLowerCase().contains(searchQuery.toLowerCase());
      }).toList();
    }
    
    // Apply status filters
    if (showActiveOnly && !showInactiveOnly) {
      users = users.where((user) => user.isActive).toList();
    } else if (showInactiveOnly && !showActiveOnly) {
      users = users.where((user) => !user.isActive).toList();
    }
    
    return users;
  }

  void _handleUserAction(String action, UserModel user, BuildContext context) {
    switch (action) {
      case 'edit':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Edit ${user.name}')),
        );
        break;
      case 'permissions':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Manage permissions for ${user.name}')),
        );
        break;
      case 'sessions':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('View sessions for ${user.name}')),
        );
        break;
      case 'delete':
        _showDeleteUserDialog(user, context);
        break;
    }
  }

  void _showDeleteUserDialog(UserModel user, BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete User'),
        content: Text('Are you sure you want to delete ${user.name}? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${user.name} deleted successfully')),
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
}
