import 'package:flutter/material.dart';
import '../widgets/create_group_dialog.dart';

class GroupsHeader extends StatelessWidget {
  final Function(String)? onSearchChanged;
  final VoidCallback? onRefresh;
  final VoidCallback? onBackToDashboard;

  const GroupsHeader({
    super.key,
    this.onSearchChanged,
    this.onRefresh,
    this.onBackToDashboard,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (onBackToDashboard != null) ...[
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: onBackToDashboard,
              ),
              const SizedBox(width: 8),
            ],
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
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: onRefresh,
              tooltip: 'Refresh',
            ),
            const SizedBox(width: 8),
            FilledButton.icon(
              onPressed: () => _showCreateGroupDialog(context),
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
        const SizedBox(height: 24),
        // Search bar
        SizedBox(
          width: 400,
          child: TextField(
            onChanged: onSearchChanged,
            decoration: InputDecoration(
              hintText: 'Search groups...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showCreateGroupDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const CreateGroupDialog(),
    );
  }
}
