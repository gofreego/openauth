import 'package:flutter/material.dart';
import '../../domain/entities/user.dart';

class UserRow extends StatelessWidget {
  final UserEntity user;
  final int index;
  final Function(String action, UserEntity user, BuildContext context) onUserAction;

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
                  backgroundImage: user.avatarUrl.isNotEmpty 
                      ? NetworkImage(user.avatarUrl) 
                      : null,
                  child: user.avatarUrl.isEmpty 
                      ? Text(
                          user.displayName.isNotEmpty 
                              ? user.displayName[0].toUpperCase()
                              : user.username[0].toUpperCase(),
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
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        user.displayName,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '@${user.username}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Text(
              user.email,
              style: theme.textTheme.bodyMedium,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: user.isActive ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                user.isActive ? 'Active' : 'Inactive',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: user.isActive ? Colors.green : Colors.red,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Expanded(
            child: Text(
              user.formattedCreatedAt,
              style: theme.textTheme.bodyMedium,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(
            width: 120,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit_outlined, size: 20),
                  onPressed: () => onUserAction('edit', user, context),
                  tooltip: 'Edit user',
                ),
                IconButton(
                  icon: const Icon(Icons.security_outlined, size: 20),
                  onPressed: () => onUserAction('permissions', user, context),
                  tooltip: 'Manage permissions',
                ),
                IconButton(
                  icon: const Icon(Icons.schedule_outlined, size: 20),
                  onPressed: () => onUserAction('sessions', user, context),
                  tooltip: 'View sessions',
                ),
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert, size: 20),
                  onSelected: (action) => onUserAction(action, user, context),
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit_outlined, size: 16),
                          SizedBox(width: 8),
                          Text('Edit'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'permissions',
                      child: Row(
                        children: [
                          Icon(Icons.security_outlined, size: 16),
                          SizedBox(width: 8),
                          Text('Permissions'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'sessions',
                      child: Row(
                        children: [
                          Icon(Icons.schedule_outlined, size: 16),
                          SizedBox(width: 8),
                          Text('Sessions'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: user.isActive ? 'deactivate' : 'activate',
                      child: Row(
                        children: [
                          Icon(
                            user.isActive ? Icons.block_outlined : Icons.check_circle_outline,
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Text(user.isActive ? 'Deactivate' : 'Activate'),
                        ],
                      ),
                    ),
                    const PopupMenuDivider(),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete_outline, color: Colors.red, size: 16),
                          SizedBox(width: 8),
                          Text('Delete', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
