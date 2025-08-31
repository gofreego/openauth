import 'package:flutter/material.dart';
import '../../data/models/user_model.dart';

class UserRow extends StatelessWidget {
  final UserModel user;
  final int index;
  final Function(String action, UserModel user, BuildContext context) onUserAction;

  const UserRow({
    super.key,
    required this.user,
    required this.index,
    required this.onUserAction,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEven = index % 2 == 0;
    
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: isEven ? null : theme.colorScheme.surface,
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: theme.colorScheme.primary,
                  child: Text(
                    user.name[0].toUpperCase(),
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      user.username,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Text(
              user.email,
              style: theme.textTheme.bodyMedium,
            ),
          ),
          Expanded(
            child: Chip(
              label: Text(user.status),
              backgroundColor: user.isActive 
                ? Colors.green.withOpacity(0.1)
                : Colors.orange.withOpacity(0.1),
              labelStyle: TextStyle(
                color: user.isActive 
                  ? Colors.green.shade700
                  : Colors.orange.shade700,
                fontSize: 12,
              ),
            ),
          ),
          Expanded(
            child: Text(
              user.lastLogin,
              style: theme.textTheme.bodyMedium,
            ),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) => onUserAction(value, user, context),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'edit',
                child: ListTile(
                  leading: Icon(Icons.edit),
                  title: Text('Edit'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              const PopupMenuItem(
                value: 'permissions',
                child: ListTile(
                  leading: Icon(Icons.security),
                  title: Text('Permissions'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              const PopupMenuItem(
                value: 'sessions',
                child: ListTile(
                  leading: Icon(Icons.access_time),
                  title: Text('Sessions'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem(
                value: 'delete',
                child: ListTile(
                  leading: Icon(Icons.delete, color: Colors.red),
                  title: Text('Delete', style: TextStyle(color: Colors.red)),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
