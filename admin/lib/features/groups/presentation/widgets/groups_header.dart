import 'package:flutter/material.dart';

class GroupsHeader extends StatelessWidget {
  final VoidCallback? onAddGroup;

  const GroupsHeader({
    super.key,
    this.onAddGroup,
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
              Icons.group,
              size: 32,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(width: 12),
            Text(
              'Groups Management',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            FilledButton.icon(
              onPressed: onAddGroup,
              icon: const Icon(Icons.add),
              label: const Text('Add Group'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Organize users into groups and manage collective permissions',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
