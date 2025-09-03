import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:openauth/src/generated/openauth/v1/permissions.pbserver.dart';
import '../bloc/permissions_bloc.dart';
import '../../../../src/generated/openauth/v1/permissions.pb.dart' as pb;
import 'package:fixnum/fixnum.dart';

class PermissionsGrid extends StatefulWidget {
  final List<Permission> permissions;
  final String searchQuery;
  final bool showSystemOnly;
  final bool showCustomOnly;
  final bool hasReachedMax;
  final bool isLoadingMore;
  final VoidCallback? onLoadMore;

  const PermissionsGrid({
    super.key,
    required this.permissions,
    required this.searchQuery,
    required this.showSystemOnly,
    required this.showCustomOnly,
    this.hasReachedMax = false,
    this.isLoadingMore = false,
    this.onLoadMore,
  });

  @override
  State<PermissionsGrid> createState() => _PermissionsGridState();
}

class _PermissionsGridState extends State<PermissionsGrid> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom && !widget.hasReachedMax && !widget.isLoadingMore) {
      widget.onLoadMore?.call();
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9); // Trigger when 90% scrolled
  }

  @override
  Widget build(BuildContext context) {
    final filteredPermissions = _getFilteredPermissions();
    
    if (filteredPermissions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'No permissions found',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.searchQuery.isNotEmpty 
                ? 'Try adjusting your search query'
                : 'Try adjusting your filters',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      );
    }
    
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            controller: _scrollController,
            padding: EdgeInsets.all(MediaQuery.of(context).size.width < 600 ? 8 : 16),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final crossAxisCount = (constraints.maxWidth / 320).floor().clamp(1, 10);
                final cardWidth = (constraints.maxWidth - (16 * (crossAxisCount - 1))) / crossAxisCount;
                
                return Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    ...filteredPermissions.map((permission) => SizedBox(
                      width: cardWidth,
                      child: PermissionCard(
                        permission: permission,
                        onTap: () => _showPermissionDetails(context, permission),
                        onAction: (action) => _handlePermissionAction(context, action, permission),
                      ),
                    )),
                    if (widget.isLoadingMore)
                      SizedBox(
                        width: cardWidth,
                        height: 120,
                        child: const Card(
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  List<Permission> _getFilteredPermissions() {
    List<Permission> filtered = List.from(widget.permissions);
    
    // Apply search filter
    if (widget.searchQuery.isNotEmpty) {
      filtered = filtered.where((permission) {
        final query = widget.searchQuery.toLowerCase();
        return permission.name.toLowerCase().contains(query) ||
               permission.displayName.toLowerCase().contains(query) ||
               permission.description.toLowerCase().contains(query);
      }).toList();
    }
    
    // Apply category filters (simplified for now - could be enhanced)
    if (widget.showSystemOnly && !widget.showCustomOnly) {
      filtered = filtered.where((permission) => 
        permission.name.startsWith('system.')).toList();
    } else if (widget.showCustomOnly && !widget.showSystemOnly) {
      filtered = filtered.where((permission) => 
        !permission.name.startsWith('system.')).toList();
    }
    
    return filtered;
  }

  void _showPermissionDetails(BuildContext context, Permission permission) {
    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: context.read<PermissionsBloc>(),
        child: PermissionDetailsDialog(
          permission: permission,
          onEdit: () => _handlePermissionAction(context, 'edit', permission),
        ),
      ),
    );
  }

  void _handlePermissionAction(BuildContext context, String action, Permission permission) {
    switch (action) {
      case 'edit':
        _showEditPermissionDialog(context, permission);
        break;
      case 'delete':
        _showDeletePermissionDialog(context, permission);
        break;
    }
  }

  void _showEditPermissionDialog(BuildContext context, Permission permission) {
    // Create edit dialog similar to create dialog but pre-filled
    final nameController = TextEditingController(text: permission.name);
    final displayNameController = TextEditingController(text: permission.displayName);
    final descriptionController = TextEditingController(text: permission.description);

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Edit Permission'),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Permission Name',
                  hintText: 'e.g., user.create',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: displayNameController,
                decoration: const InputDecoration(
                  labelText: 'Display Name',
                  hintText: 'e.g., Create Users',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  hintText: 'Brief description of the permission',
                ),
                maxLines: 2,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final request = pb.UpdatePermissionRequest()
                ..id = permission.id
                ..name = nameController.text
                ..displayName = displayNameController.text
                ..description = descriptionController.text;

              context.read<PermissionsBloc>().add(UpdatePermission(request));
              Navigator.of(context).pop();
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }


  void _showDeletePermissionDialog(BuildContext context, Permission permission) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Permission'),
        content: Text(
          'Are you sure you want to delete "${permission.displayName}"? '
          'This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              context.read<PermissionsBloc>().add(DeletePermission(permission.id));
              Navigator.of(context).pop();
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

// Card widget for Permission
class PermissionCard extends StatelessWidget {
  final Permission permission;
  final VoidCallback onTap;
  final void Function(String action) onAction;

  const PermissionCard({
    super.key,
    required this.permission,
    required this.onTap,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
              children: [
              Row(
                children: [
                  const Icon(
                    Icons.security,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      permission.displayName,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert, size: 20),
                    onSelected: onAction,
                    itemBuilder: (context) => [
                        PopupMenuItem(
                        enabled: !permission.isSystem,
                        value: 'edit',
                        child: const Row(
                          children: [
                            Icon(Icons.edit),
                            SizedBox(width: 8),
                            Text('Edit'),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        enabled: !permission.isSystem,
                        value: 'delete',
                        child: const Row(
                          children: [
                            Icon(Icons.delete, color: Colors.red),
                            SizedBox(width: 8),
                            Text('Delete', style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                permission.description,
                style: Theme.of(context).textTheme.bodyMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            ),
          ),
        ),
    );
  }
}

// Details dialog for Permission
class PermissionDetailsDialog extends StatelessWidget {
  final Permission permission;
  final VoidCallback onEdit;

  const PermissionDetailsDialog({
    super.key,
    required this.permission,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(permission.displayName),
      content: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 400,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Name', permission.name),
            const SizedBox(height: 12),
            _buildDetailRow('Description', permission.description),
            const SizedBox(height: 12),
            _buildDetailRow('Created', _formatDate(permission.createdAt)),
            const SizedBox(height: 12),
            _buildDetailRow('Last Updated', _formatDate(permission.updatedAt)),
            const SizedBox(height: 12),
            _buildDetailRow('Created by', permission.createdBy.toString()),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
        FilledButton(
          onPressed: permission.isSystem?null: () {
            Navigator.of(context).pop();
            onEdit();
          },
          child: const Text('Edit'),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 4),
        Text(value),
      ],
    );
  }

  String _formatDate(Int64 millis) {
    final date = DateTime.fromMillisecondsSinceEpoch(millis.toInt());
    return '${date.day}/${date.month}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}
