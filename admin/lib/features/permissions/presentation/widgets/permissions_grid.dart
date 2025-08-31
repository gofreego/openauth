import 'package:flutter/material.dart';
import '../../data/models/permission_model.dart';
import '../widgets/permission_card.dart';
import '../widgets/permission_details_dialog.dart';

class PermissionsGrid extends StatelessWidget {
  final String searchQuery;
  final bool showSystemOnly;
  final bool showCustomOnly;

  const PermissionsGrid({
    super.key,
    required this.searchQuery,
    required this.showSystemOnly,
    required this.showCustomOnly,
  });

  @override
  Widget build(BuildContext context) {
    final filteredPermissions = _getFilteredPermissions();
    
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.2,
      ),
      itemCount: filteredPermissions.length,
      itemBuilder: (context, index) {
        final permission = filteredPermissions[index];
        return PermissionCard(
          permission: permission,
          onTap: () => _showPermissionDetails(context, permission),
          onAction: (action, permission) => _handlePermissionAction(context, action, permission),
        );
      },
    );
  }

  List<PermissionModel> _getFilteredPermissions() {
    List<PermissionModel> permissions = PermissionModel.mockPermissions;
    
    // Apply search filter
    if (searchQuery.isNotEmpty) {
      permissions = permissions.where((permission) {
        return permission.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
               permission.description.toLowerCase().contains(searchQuery.toLowerCase()) ||
               permission.category.displayName.toLowerCase().contains(searchQuery.toLowerCase());
      }).toList();
    }
    
    // Apply category filters (simplified for demo - treating system category as system, others as custom)
    if (showSystemOnly && !showCustomOnly) {
      permissions = permissions.where((permission) => 
        permission.category == PermissionCategory.system).toList();
    } else if (showCustomOnly && !showSystemOnly) {
      permissions = permissions.where((permission) => 
        permission.category != PermissionCategory.system).toList();
    }
    
    return permissions;
  }

  void _showPermissionDetails(BuildContext context, PermissionModel permission) {
    showDialog(
      context: context,
      builder: (context) => PermissionDetailsDialog(
        permission: permission,
        onEdit: () => _handlePermissionAction(context, 'edit', permission),
      ),
    );
  }

  void _handlePermissionAction(BuildContext context, String action, PermissionModel permission) {
    switch (action) {
      case 'edit':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Edit ${permission.name}')),
        );
        break;
      case 'duplicate':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Duplicate ${permission.name}')),
        );
        break;
      case 'delete':
        _showDeletePermissionDialog(context, permission);
        break;
    }
  }

  void _showDeletePermissionDialog(BuildContext context, PermissionModel permission) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Permission'),
        content: Text(
          'Are you sure you want to delete "${permission.name}"? '
          'This will affect ${permission.assignedUsers} users and cannot be undone.',
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
                SnackBar(content: Text('${permission.name} deleted successfully')),
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
}
