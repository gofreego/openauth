import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:openauth/shared/utils/toast_utils.dart';
import '../../../../src/generated/openauth/v1/users.pb.dart' as user_pb;
import '../../../../src/generated/openauth/v1/permission_assignments.pb.dart'
    as perm_pb;
import '../../../../src/generated/openauth/v1/permissions.pb.dart'
    as permissions_pb;
import '../../../permissions/presentation/bloc/permissions_bloc.dart';
import '../bloc/user_permissions_bloc.dart';
import '../bloc/user_permissions_event.dart';
import '../bloc/user_permissions_state.dart';
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
  List<perm_pb.EffectivePermission> _userPermissions = [];
  Set<int> selectedPermissions = <int>{}; // Track selected permissions to add
  bool _isAssigning = false;

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

    return BlocListener<UserPermissionsBloc, UserPermissionsState>(
      listener: (context, state) {
        if (state is UserPermissionsBulkAssigned) {
          // Clear selections when permissions are successfully assigned
          setState(() {
            selectedPermissions.clear();
            _isAssigning = false;
          });
            
          // Show success message
          ToastUtils.showSuccess(state.message);
        } else if (state is UserPermissionsError) {
          setState(() {
            _isAssigning = false;
          });
          
          // Show error message
          ToastUtils.showError(state.message);
        }
      },
      child: Dialog(
      child: Container(
        width: 1200, // Increased width for side-by-side layout
        height: 700,
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
                        'for ${widget.user.name} (@${widget.user.username})',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
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
              triggerSearchOnKeyStroke: true,
              onSearch: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
            const SizedBox(height: 16),

            // Side by side layout
            Expanded(
              child: Row(
                children: [
                  // Current permissions (left side)
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Current Permissions',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Expanded(child: _buildCurrentPermissionsPanel()),
                      ],
                    ),
                  ),
                  const SizedBox(width: 24),
                  // Available permissions (right side)
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Available Permissions',
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Spacer(),
                            if (selectedPermissions.isNotEmpty)
                              Chip(
                                label: Text('${selectedPermissions.length} selected'),
                                backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.1),
                              ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Expanded(child: _buildAvailablePermissionsPanel()),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Action buttons
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (selectedPermissions.isNotEmpty)
                  TextButton.icon(
                    onPressed: () {
                      setState(() {
                        selectedPermissions.clear();
                      });
                    },
                    icon: const Icon(Icons.clear_all),
                    label: const Text('Clear Selection'),
                  )
                else
                  const SizedBox.shrink(),
                Row(
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Close'),
                    ),
                    const SizedBox(width: 8),
                    if (selectedPermissions.isNotEmpty)
                      BlocConsumer<UserPermissionsBloc, UserPermissionsState>(
                        listener: (context, state) {
                          if (state is UserPermissionAssigned) {
                            setState(() {
                              selectedPermissions.clear();
                              _isAssigning = false;
                            });
                            ToastUtils.showSuccess('Permissions assigned successfully');
                            // Refresh permissions
                            context.read<UserPermissionsBloc>().add(
                                  LoadUserPermissions(widget.user.id.toInt()),
                                );
                          } else if (state is UserPermissionsError) {
                            setState(() {
                              _isAssigning = false;
                            });
                            ToastUtils.showError('Error: ${state.message}');
                          }
                        },
                        builder: (context, state) {
                          return ElevatedButton.icon(
                            onPressed: _isAssigning ? null : _assignSelectedPermissions,
                            icon: _isAssigning
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  )
                                : const Icon(Icons.add_circle),
                            label: Text(
                              _isAssigning
                                  ? 'Assigning...'
                                  : 'Assign ${selectedPermissions.length} Permission${selectedPermissions.length == 1 ? '' : 's'}',
                            ),
                          );
                        },
                      ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    ),
    );
  }

  Widget _buildCurrentPermissionsPanel() {
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
            return permission.permissionDisplayName
                    .toLowerCase()
                    .contains(_searchQuery.toLowerCase()) ||
                permission.permissionDescription
                    .toLowerCase()
                    .contains(_searchQuery.toLowerCase());
          }).toList();

          if (filteredPermissions.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.security_outlined,
                      size: 48, color: Colors.grey),
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

  Widget _buildAvailablePermissionsPanel() {
    return BlocBuilder<UserPermissionsBloc, UserPermissionsState>(
      builder: (context, userPermissionsState) {
        // Update _userPermissions when loaded
        if (userPermissionsState is UserPermissionsLoaded) {
          _userPermissions = userPermissionsState.permissions;
        }

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
                        context
                            .read<PermissionsBloc>()
                            .add(const LoadPermissions());
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            } else if (state is PermissionsLoaded) {
              // Only process if user permissions are also loaded
              if (_userPermissions.isEmpty) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text('Loading user permissions...'),
                    ],
                  ),
                );
              }

          _availablePermissions = state.permissions
              .map((entity) => permissions_pb.Permission(
                    id: entity.id,
                    name: entity.name,
                    displayName: entity.displayName,
                    description: entity.description,
                  ))
              .toList();

          // Filter out permissions already assigned to user
          final assignedPermissionIds =
              _userPermissions.map((p) => p.permissionId.toInt()).toSet();
          final unassignedPermissions =
              _availablePermissions.where((permission) {
            return !assignedPermissionIds.contains(permission.id.toInt());
          }).toList();

          final filteredPermissions = unassignedPermissions.where((permission) {
            if (_searchQuery.isEmpty) return true;
            return permission.displayName
                    .toLowerCase()
                    .contains(_searchQuery.toLowerCase()) ||
                permission.description
                    .toLowerCase()
                    .contains(_searchQuery.toLowerCase());
          }).toList();

          if (filteredPermissions.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.check_circle_outline,
                      size: 48, color: Colors.green),
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
              return _buildSelectablePermissionCard(permission);
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  },
    );
  }

  Widget _buildSelectablePermissionCard(permissions_pb.Permission permission) {
    final theme = Theme.of(context);
    final isSelected = selectedPermissions.contains(permission.id.toInt());

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: isSelected 
          ? theme.colorScheme.primary.withValues(alpha: 0.1)
          : null,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isSelected
              ? theme.colorScheme.primary
              : theme.colorScheme.secondary.withValues(alpha: 0.1),
          child: Icon(
            isSelected ? Icons.check_circle : Icons.add_circle_outline,
            color: isSelected
                ? Colors.white
                : theme.colorScheme.secondary,
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
        trailing: isSelected
            ? Icon(
                Icons.check_circle,
                color: theme.colorScheme.primary,
              )
            : null,
        onTap: () {
          setState(() {
            final permissionId = permission.id.toInt();
            if (isSelected) {
              selectedPermissions.remove(permissionId);
              debugPrint('Deselected permission: ${permission.displayName} (ID: $permissionId)');
            } else {
              selectedPermissions.add(permissionId);
              debugPrint('Selected permission: ${permission.displayName} (ID: $permissionId)');
            }
            debugPrint('Total selected: ${selectedPermissions.length}');
          });
        },
      ),
    );
  }

  void _assignSelectedPermissions() {
    if (selectedPermissions.isEmpty) return;

    setState(() {
      _isAssigning = true;
    });

    // Create the request with multiple permission IDs
    context.read<UserPermissionsBloc>().add(
          AssignPermissionsToUser(
            widget.user.id.toInt(),
            selectedPermissions.toList(),
          ),
        );
  }

  Widget _buildCurrentPermissionCard(perm_pb.EffectivePermission permission) {
    final theme = Theme.of(context);
    final bool isGroupPermission = permission.source.toLowerCase() == 'group';

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.1),
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
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
                const SizedBox(width: 4),
                Text(
                  'Granted ${_formatDate(permission.grantedAt.toInt())}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
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
                if (isGroupPermission) ...[
                  const SizedBox(width: 16),
                  Icon(
                    Icons.group,
                    size: 12,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Group : ${permission.groupDisplayName.isNotEmpty ? permission.groupDisplayName : permission.groupName}',
                    style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
        trailing: isGroupPermission
            ? IconButton(
                icon: Icon(
                  Icons.remove_circle_outline,
                  color: Colors.grey.withValues(alpha: 0.5),
                ),
                tooltip:
                    'Group permissions cannot be deleted directly.\nYou can delete the group or remove permission from the group.',
                onPressed: null, // Disabled
              )
            : IconButton(
                icon:
                    const Icon(Icons.remove_circle_outline, color: Colors.red),
                tooltip: 'Remove permission',
                onPressed: () => _removePermission(permission),
              ),
      ),
    );
  }

  void _removePermission(perm_pb.EffectivePermission permission) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Permission'),
        content: Text(
          'Are you sure you want to remove "${permission.permissionDisplayName.isEmpty ? permission.permissionName : permission.permissionDisplayName}" permission from ${widget.user.name}?',
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
    if (widget.user.name.isEmpty) {
      return widget.user.username.isNotEmpty
          ? widget.user.username[0].toUpperCase()
          : '?';
    }
    return widget.user.name[0].toUpperCase();
  }

  String _formatDate(int timestamp) {
    if (timestamp == 0) return 'Unknown';
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return '${date.day}/${date.month}/${date.year}';
  }
}
