import 'package:flutter/material.dart';

class PermissionsHeader extends StatelessWidget {
  final VoidCallback? onAddPermission;

  const PermissionsHeader({
    super.key,
    this.onAddPermission,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.security,
              size: 32,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(width: 12),
            Text(
              'Permissions Management',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            FilledButton.icon(
              onPressed: onAddPermission,
              icon: const Icon(Icons.add),
              label: const Text('Add Permission'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Configure access control and permissions for users and groups',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
