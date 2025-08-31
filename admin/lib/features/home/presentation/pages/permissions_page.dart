import 'package:flutter/material.dart';

class PermissionsPage extends StatefulWidget {
  const PermissionsPage({super.key});

  @override
  State<PermissionsPage> createState() => _PermissionsPageState();
}

class _PermissionsPageState extends State<PermissionsPage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
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
                onPressed: _showCreatePermissionDialog,
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
          const SizedBox(height: 32),

          // Search and filters
          Row(
            children: [
              Expanded(
                child: SearchBar(
                  hintText: 'Search permissions...',
                  leading: const Icon(Icons.search),
                  onChanged: (value) {
                    // TODO: Implement search
                  },
                ),
              ),
              const SizedBox(width: 16),
              FilterChip(
                label: const Text('System'),
                selected: true,
                onSelected: (selected) {
                  // TODO: Implement filter
                },
              ),
              const SizedBox(width: 8),
              FilterChip(
                label: const Text('Custom'),
                selected: false,
                onSelected: (selected) {
                  // TODO: Implement filter
                },
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Permissions grid
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.2,
              ),
              itemCount: _mockPermissions.length,
              itemBuilder: (context, index) {
                final permission = _mockPermissions[index];
                return _buildPermissionCard(context, permission);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPermissionCard(BuildContext context, Map<String, dynamic> permission) {
    final theme = Theme.of(context);
    
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: () => _showPermissionDetails(permission),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    _getPermissionIcon(permission['category']),
                    color: theme.colorScheme.primary,
                    size: 24,
                  ),
                  const Spacer(),
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert, size: 20),
                    onSelected: (value) => _handlePermissionAction(value, permission),
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
                        value: 'duplicate',
                        child: ListTile(
                          leading: Icon(Icons.copy),
                          title: Text('Duplicate'),
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
              const SizedBox(height: 12),
              Text(
                permission['name'],
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                permission['description'],
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const Spacer(),
              Row(
                children: [
                  Chip(
                    label: Text(permission['category']),
                    backgroundColor: _getCategoryColor(permission['category']).withOpacity(0.1),
                    labelStyle: TextStyle(
                      color: _getCategoryColor(permission['category']),
                      fontSize: 11,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${permission['users']} users',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getPermissionIcon(String category) {
    switch (category) {
      case 'User Management':
        return Icons.people;
      case 'System':
        return Icons.settings;
      case 'Content':
        return Icons.article;
      case 'Analytics':
        return Icons.analytics;
      default:
        return Icons.security;
    }
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'User Management':
        return Colors.blue;
      case 'System':
        return Colors.orange;
      case 'Content':
        return Colors.green;
      case 'Analytics':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  void _showCreatePermissionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create New Permission'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const TextField(
              decoration: InputDecoration(
                labelText: 'Permission Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
              ),
              items: ['User Management', 'System', 'Content', 'Analytics']
                  .map((category) => DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      ))
                  .toList(),
              onChanged: (value) {},
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Permission created successfully')),
              );
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _showPermissionDetails(Map<String, dynamic> permission) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(permission['name']),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Description:',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(permission['description']),
            const SizedBox(height: 16),
            Text(
              'Category:',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Chip(
              label: Text(permission['category']),
              backgroundColor: _getCategoryColor(permission['category']).withOpacity(0.1),
              labelStyle: TextStyle(
                color: _getCategoryColor(permission['category']),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Assigned Users: ${permission['users']}',
              style: Theme.of(context).textTheme.bodyMedium,
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
              _handlePermissionAction('edit', permission);
            },
            child: const Text('Edit'),
          ),
        ],
      ),
    );
  }

  void _handlePermissionAction(String action, Map<String, dynamic> permission) {
    switch (action) {
      case 'edit':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Edit ${permission['name']}')),
        );
        break;
      case 'duplicate':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Duplicate ${permission['name']}')),
        );
        break;
      case 'delete':
        _showDeletePermissionDialog(permission);
        break;
    }
  }

  void _showDeletePermissionDialog(Map<String, dynamic> permission) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Permission'),
        content: Text(
          'Are you sure you want to delete "${permission['name']}"? '
          'This will affect ${permission['users']} users and cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${permission['name']} deleted successfully')),
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

  // Mock data for demonstration
  final List<Map<String, dynamic>> _mockPermissions = [
    {
      'name': 'User Create',
      'description': 'Ability to create new user accounts',
      'category': 'User Management',
      'users': 12,
    },
    {
      'name': 'User Edit',
      'description': 'Ability to edit existing user accounts',
      'category': 'User Management',
      'users': 8,
    },
    {
      'name': 'User Delete',
      'description': 'Ability to delete user accounts',
      'category': 'User Management',
      'users': 3,
    },
    {
      'name': 'System Settings',
      'description': 'Access to system configuration settings',
      'category': 'System',
      'users': 5,
    },
    {
      'name': 'View Analytics',
      'description': 'Access to system analytics and reports',
      'category': 'Analytics',
      'users': 15,
    },
    {
      'name': 'Export Data',
      'description': 'Ability to export system data',
      'category': 'Analytics',
      'users': 7,
    },
    {
      'name': 'Content Publish',
      'description': 'Ability to publish content',
      'category': 'Content',
      'users': 10,
    },
    {
      'name': 'Content Moderate',
      'description': 'Ability to moderate user content',
      'category': 'Content',
      'users': 6,
    },
    {
      'name': 'Backup Restore',
      'description': 'Ability to create and restore backups',
      'category': 'System',
      'users': 2,
    },
  ];
}
