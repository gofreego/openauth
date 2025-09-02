import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fixnum/fixnum.dart';
import '../../../../src/generated/openauth/v1/users.pb.dart' as user_pb;
import '../../../../src/generated/openauth/v1/permission_assignments.pb.dart' as perm_pb;
import '../../../../src/generated/openauth/v1/permissions.pb.dart' as permissions_pb;
import '../../../permissions/presentation/bloc/permissions_bloc.dart';
import '../bloc/user_permissions_bloc.dart';
import '../bloc/user_permissions_event.dart';
import '../bloc/user_permissions_state.dart';
import '../../domain/extensions/user_extensions.dart';
import '../../../../shared/widgets/custom_search_bar.dart';

class UserPermissionsDialog extends StatefulWidget {
  final user_pb.User user;

  const UserPermissionsDialog({
    super.key,
    required this.user,
  });

  @override
  State<UserPermissionsDialog> createState() => _UserPermissionsDialogState();
}

class _UserPermissionsDialogState extends State<UserPermissionsDialog> {
  String _searchQuery = '';
  List<permissions_pb.Permission> _availablePermissions = [];
  List<perm_pb.UserPermission> _userPermissions = [];

  @override
  void initState() {
    super.initState();
    // Load user permissions and available permissions
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserPermissionsBloc>().add(
        LoadUserPermissions(widget.user.id.toInt()),
      );
      context.read<PermissionsBloc>().add(
        const LoadPermissions(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Dialog(
      child: Container(
        width: 800,
        height: 600,
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: theme.colorScheme.primary,
                  backgroundImage: widget.user.avatarUrl.isNotEmpty 
                      ? NetworkImage(widget.user.avatarUrl) 
                      : null,
                  child: widget.user.avatarUrl.isEmpty 
                      ? Text(
                          _getInitial(),
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Manage Permissions',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'for ${widget.user.displayName} (@${widget.user.username})',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Search bar
            CustomSearchBar(
              hintText: 'Search permissions...',
              initialQuery: _searchQuery,
              onSearch: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
            const SizedBox(height: 16),

            // Tabs
            DefaultTabController(
              length: 2,
              child: Expanded(
                child: Column(
                  children: [
                    TabBar(
                      tabs: const [
                        Tab(text: 'Current Permissions'),
                        Tab(text: 'Available Permissions'),
                      ],
                      labelColor: theme.colorScheme.primary,
                      unselectedLabelColor: theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: TabBarView(
                        children: [
                          _buildCurrentPermissionsTab(),
                          _buildAvailablePermissionsTab(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Action buttons
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Close'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentPermissionsTab() {
    return BlocBuilder<UserPermissionsBloc, UserPermissionsState>(
      builder: (context, state) {
        if (state is UserPermissionsLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is UserPermissionsError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  'Error loading permissions',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(state.message),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    context.read<UserPermissionsBloc>().add(
                      LoadUserPermissions(widget.user.id.toInt()),
                    );
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        } else if (state is UserPermissionsLoaded) {
          _userPermissions = state.permissions;
          final filteredPermissions = _userPermissions.where((permission) {
            if (_searchQuery.isEmpty) return true;
            return permission.permissionDisplayName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                   permission.permissionDescription.toLowerCase().contains(_searchQuery.toLowerCase());
          }).toList();

          if (filteredPermissions.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.security_outlined, size: 48, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    _searchQuery.isEmpty 
                        ? 'No permissions assigned'
                        : 'No permissions found matching "$_searchQuery"',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  const Text('This user has no permissions assigned.'),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: filteredPermissions.length,
            itemBuilder: (context, index) {
              final permission = filteredPermissions[index];
              return _buildCurrentPermissionCard(permission);
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildAvailablePermissionsTab() {
    return BlocBuilder<PermissionsBloc, PermissionsState>(
      builder: (context, state) {
        if (state is PermissionsLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is PermissionsError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  'Error loading available permissions',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(state.message),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    context.read<PermissionsBloc>().add(const LoadPermissions());
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        } else if (state is PermissionsLoaded) {
          _availablePermissions = state.permissions.map((entity) => 
            permissions_pb.Permission(
              id: Int64(entity.id),
              name: entity.name,
              displayName: entity.displayName,
              description: entity.description,
            )
          ).toList();
          
          // Filter out permissions already assigned to user
          final assignedPermissionIds = _userPermissions.map((p) => p.permissionId).toSet();
          final unassignedPermissions = _availablePermissions.where((permission) {
            return !assignedPermissionIds.contains(permission.id);
          }).toList();

          final filteredPermissions = unassignedPermissions.where((permission) {
            if (_searchQuery.isEmpty) return true;
            return permission.displayName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                   permission.description.toLowerCase().contains(_searchQuery.toLowerCase());
          }).toList();

          if (filteredPermissions.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.check_circle_outline, size: 48, color: Colors.green),
                  const SizedBox(height: 16),
                  Text(
                    _searchQuery.isEmpty 
                        ? 'All permissions assigned'
                        : 'No available permissions found matching "$_searchQuery"',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _searchQuery.isEmpty 
                        ? 'This user has been assigned all available permissions.'
                        : 'Try adjusting your search query.',
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: filteredPermissions.length,
            itemBuilder: (context, index) {
              final permission = filteredPermissions[index];
              return _buildAvailablePermissionCard(permission);
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildCurrentPermissionCard(perm_pb.UserPermission permission) {
    final theme = Theme.of(context);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
          child: Icon(
            Icons.security_outlined,
            color: theme.colorScheme.primary,
          ),
        ),
        title: Text(
          permission.permissionDisplayName.isEmpty 
              ? permission.permissionName 
              : permission.permissionDisplayName,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (permission.permissionDescription.isNotEmpty)
              Text(
                permission.permissionDescription,
                style: theme.textTheme.bodySmall,
              ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  Icons.access_time,
                  size: 12,
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                ),
                const SizedBox(width: 4),
                Text(
                  'Granted ${_formatDate(permission.createdAt.toInt())}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
                if (permission.expiresAt.toInt() > 0) ...[
                  const SizedBox(width: 16),
                  const Icon(
                    Icons.schedule,
                    size: 12,
                    color: Colors.orange,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Expires ${_formatDate(permission.expiresAt.toInt())}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.orange,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
          tooltip: 'Remove permission',
          onPressed: () => _removePermission(permission),
        ),
      ),
    );
  }

  Widget _buildAvailablePermissionCard(permissions_pb.Permission permission) {
    final theme = Theme.of(context);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: theme.colorScheme.secondary.withOpacity(0.1),
          child: Icon(
            Icons.add_circle_outline,
            color: theme.colorScheme.secondary,
          ),
        ),
        title: Text(
          permission.displayName.isEmpty 
              ? permission.name 
              : permission.displayName,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: permission.description.isNotEmpty
            ? Text(
                permission.description,
                style: theme.textTheme.bodySmall,
              )
            : null,
        trailing: IconButton(
          icon: const Icon(Icons.add_circle_outline, color: Colors.green),
          tooltip: 'Add permission',
          onPressed: () => _addPermission(permission),
        ),
      ),
    );
  }

  void _addPermission(permissions_pb.Permission permission) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Permission'),
        content: Text(
          'Are you sure you want to add "${permission.displayName.isEmpty ? permission.name : permission.displayName}" permission to ${widget.user.displayName}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<UserPermissionsBloc>().add(
                AssignPermissionToUser(
                  widget.user.id.toInt(),
                  permission.id.toInt(),
                ),
              );
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _removePermission(perm_pb.UserPermission permission) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Permission'),
        content: Text(
          'Are you sure you want to remove "${permission.permissionDisplayName.isEmpty ? permission.permissionName : permission.permissionDisplayName}" permission from ${widget.user.displayName}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<UserPermissionsBloc>().add(
                RemovePermissionFromUser(
                  widget.user.id.toInt(),
                  permission.permissionId.toInt(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }

  String _getInitial() {
    if (widget.user.displayName.isEmpty) {
      return widget.user.username.isNotEmpty 
          ? widget.user.username[0].toUpperCase() 
          : '?';
    }
    return widget.user.displayName[0].toUpperCase();
  }

  String _formatDate(int timestamp) {
    if (timestamp == 0) return 'Unknown';
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return '${date.day}/${date.month}/${date.year}';
  }
}
