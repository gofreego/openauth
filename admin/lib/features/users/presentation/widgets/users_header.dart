import 'package:flutter/material.dart';

class UsersHeader extends StatelessWidget {
  final VoidCallback? onAddUser;

  const UsersHeader({
    super.key,
    this.onAddUser,
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
              Icons.people,
              size: 32,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(width: 12),
            Text(
              'Users Management',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            FilledButton.icon(
              onPressed: onAddUser,
              icon: const Icon(Icons.add),
              label: const Text('Add User'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Manage user accounts, profiles, and access permissions',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
