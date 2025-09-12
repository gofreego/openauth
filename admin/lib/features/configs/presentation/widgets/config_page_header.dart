import 'package:flutter/material.dart';

class ConfigPageHeader extends StatelessWidget {
  final VoidCallback? onAddEntity;

  const ConfigPageHeader({
    super.key,
    this.onAddEntity,
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
              Icons.settings,
              size: 32,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(width: 12),
            Text(
              'Config Management',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            FilledButton.icon(
              onPressed: onAddEntity,
              icon: const Icon(Icons.add),
              label: const Text('Add Entity'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Manage configuration entities, configs, their permissions and access control',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
