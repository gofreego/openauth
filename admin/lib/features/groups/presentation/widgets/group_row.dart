import 'package:flutter/material.dart';
import '../../../../src/generated/openauth/v1/groups.pb.dart';

class GroupRow extends StatelessWidget {
  final Group group;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onManageUsers;

  const GroupRow({
    super.key,
    required this.group,
    this.onEdit,
    this.onDelete,
    this.onManageUsers,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
          ),
        ),
      ),
      child: Row(
        children: [
          // Group info
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  group.displayName.isNotEmpty ? group.displayName : group.name,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (group.displayName.isNotEmpty && group.displayName != group.name)
                  Text(
                    '@${group.name}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                if (group.isSystem)
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'System',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          
          // Description
          Expanded(
            child: Text(
              group.description.isNotEmpty ? group.description : '—',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: group.description.isNotEmpty 
                    ? theme.colorScheme.onSurface 
                    : theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          
          // Members count (placeholder)
          Expanded(
            child: Text(
              '0 members', // TODO: Get actual member count
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          
          // Created date
          Expanded(
            child: Text(
              _formatDate(group.createdAt),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          
          // Actions
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'manage_users',
                child: Row(
                  children: [
                    Icon(Icons.people),
                    SizedBox(width: 8),
                    Text('Manage Users'),
                  ],
                ),
              ),
              if (!group.isSystem) ...[
                const PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit),
                      SizedBox(width: 8),
                      Text('Edit'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Delete', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ],
            ],
            onSelected: (value) {
              switch (value) {
                case 'manage_users':
                  onManageUsers?.call();
                  break;
                case 'edit':
                  onEdit?.call();
                  break;
                case 'delete':
                  onDelete?.call();
                  break;
              }
            },
          ),
        ],
      ),
    );
  }

  String _formatDate(dynamic timestamp) {
    if (timestamp == null || timestamp == 0) return '—';
    
    try {
      final date = DateTime.fromMillisecondsSinceEpoch(timestamp.toInt() * 1000);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return '—';
    }
  }
}
