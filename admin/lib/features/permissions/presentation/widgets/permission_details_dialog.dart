import 'package:flutter/material.dart';
import '../../data/models/permission_model.dart';

class PermissionDetailsDialog extends StatelessWidget {
  final PermissionModel permission;
  final VoidCallback? onEdit;

  const PermissionDetailsDialog({
    super.key,
    required this.permission,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return AlertDialog(
      title: Text(permission.name),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Description:',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(permission.description),
          const SizedBox(height: 16),
          Text(
            'Category:',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Chip(
            label: Text(permission.category.displayName),
            backgroundColor: permission.category.color.withOpacity(0.1),
            labelStyle: TextStyle(
              color: permission.category.color,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Assigned Users: ${permission.assignedUsers}',
            style: theme.textTheme.bodyMedium,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
        FilledButton(
          onPressed: () {
            Navigator.of(context).pop();
            onEdit?.call();
          },
          child: const Text('Edit'),
        ),
      ],
    );
  }
}
