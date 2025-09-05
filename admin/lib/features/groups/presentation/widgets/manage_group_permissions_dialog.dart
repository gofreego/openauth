import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:openauth/shared/utils/toast_utils.dart';
import 'package:openauth/src/generated/openauth/v1/permission_assignments.pb.dart';
import 'package:openauth/src/generated/openauth/v1/permissions.pb.dart';
import '../../../../src/generated/openauth/v1/groups.pb.dart';
import '../../../permissions/presentation/bloc/permissions_bloc.dart';
import '../bloc/group_permissions_bloc.dart';
import '../bloc/group_permissions_state.dart';
import '../../../../shared/widgets/custom_search_bar.dart';

class ManageGroupPermissionsDialog extends StatefulWidget {
  final Group group;

  const ManageGroupPermissionsDialog({
    super.key,
    required this.group,
  });

  @override
  State<ManageGroupPermissionsDialog> createState() => _ManageGroupPermissionsDialogState();
}

class _ManageGroupPermissionsDialogState extends State<ManageGroupPermissionsDialog> {
  String _searchQuery = '';
  List<Permission> _availablePermissions = [];
  List<EffectivePermission> _groupPermissions = [];
  Set<Int64> selectedPermissions =
      <Int64>{}; // Track selected permissions to add
  Set<Int64> selectedRemovePermissions =
      <Int64>{}; // Track selected permissions to remove
  bool _isAssigning = false;
  bool _isRemoving = false;

  @override
  void initState() {
    super.initState();
    // Load group permissions and available permissions (only if not system group)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GroupPermissionsBloc>().add(
            ListGroupPermissionsRequest(groupId: widget.group.id),
          );
      // Only fetch available permissions if this is not a system group
      if (!widget.group.isSystem) {
        context.read<PermissionsBloc>().add(ListPermissionsRequest(all: true));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocListener<GroupPermissionsBloc, GroupPermissionsState>(
      listener: (context, state) {
        if (state is GroupPermissionsBulkAssigned) {
          // Clear selections when permissions are successfully assigned
          setState(() {
            selectedPermissions.clear();
            _isAssigning = false;
          });

          // Show success message
          ToastUtils.showSuccess(state.message);

          // Refresh group permissions list to update available permissions
          context.read<GroupPermissionsBloc>().add(
                ListGroupPermissionsRequest(groupId: widget.group.id),
              );
        } else if (state is GroupPermissionRemoved) {
          // Clear selections when permissions are successfully removed
          setState(() {
            selectedRemovePermissions.clear();
            _isRemoving = false;
          });

          // Show success message
          ToastUtils.showSuccess(state.message);

          // Refresh permissions list
          context.read<GroupPermissionsBloc>().add(
                ListGroupPermissionsRequest(groupId: widget.group.id),
              );
        } else if (state is GroupPermissionsError) {
          setState(() {
            _isAssigning = false;
            _isRemoving = false;
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
                    child: Icon(
                      Icons.group,
                      color: Colors.white,
                    ),
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
                          'for ${widget.group.displayName.isEmpty ? widget.group.name : widget.group.displayName}',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.7),
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

              // System group warning
              if (widget.group.isSystem)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    border: Border.all(color: Colors.orange.shade200),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.warning_amber,
                        color: Colors.orange.shade700,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'This is a system group. Permissions cannot be modified.',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.orange.shade800,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              if (widget.group.isSystem) const SizedBox(height: 16),

              // Side by side layout
              Expanded(
                child: Row(
                  children: [
                    // Current permissions (left side)
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Current Permissions',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Spacer(),
                              if (selectedRemovePermissions.isNotEmpty && !widget.group.isSystem)
                                Chip(
                                  label: Text('${selectedRemovePermissions.length} selected'),
                                  backgroundColor: Colors.red.withValues(alpha: 0.1),
                                ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Expanded(child: _buildCurrentPermissionsPanel()),
                        ],
                      ),
                    ),
                    // Available permissions (right side) - only show for non-system groups
                    if (!widget.group.isSystem) ...[
                      const SizedBox(width: 24),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Available Permissions',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Spacer(),
                                if (selectedPermissions.isNotEmpty && !widget.group.isSystem)
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
                  ],
                ),
              ),

              // Action buttons
              const SizedBox(height: 16),
              Row(
                children: [
                  // Left side - Clear buttons
                  Expanded(
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        if (selectedPermissions.isNotEmpty && !widget.group.isSystem)
                          TextButton.icon(
                            onPressed: () {
                              setState(() {
                                selectedPermissions.clear();
                              });
                            },
                            icon: const Icon(Icons.clear_all),
                            label: const Text('Clear Add'),
                          ),
                        if (selectedRemovePermissions.isNotEmpty && !widget.group.isSystem)
                          TextButton.icon(
                            onPressed: () {
                              setState(() {
                                selectedRemovePermissions.clear();
                              });
                            },
                            icon: const Icon(Icons.clear_all),
                            label: const Text('Clear Remove'),
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.red,
                            ),
                          ),
                      ],
                    ),
                  ),
                  // Right side - Action buttons
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Close'),
                      ),
                      if (selectedRemovePermissions.isNotEmpty && !widget.group.isSystem)
                        BlocConsumer<GroupPermissionsBloc, GroupPermissionsState>(
                          listener: (context, state) {
                            if (state is GroupPermissionRemoved) {
                              setState(() {
                                _isRemoving = false;
                              });
                            } else if (state is GroupPermissionsError) {
                              setState(() {
                                _isRemoving = false;
                              });
                            }
                          },
                          builder: (context, state) {
                            return ElevatedButton.icon(
                              onPressed: _isRemoving ? null : _removeSelectedPermissions,
                              icon: _isRemoving
                                  ? const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(strokeWidth: 2),
                                    )
                                  : const Icon(Icons.remove),
                              label: Text(_isRemoving ? 'Removing...' : 'Remove'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                              ),
                            );
                          },
                        ),
                      if (selectedPermissions.isNotEmpty && !widget.group.isSystem)
                        BlocConsumer<GroupPermissionsBloc, GroupPermissionsState>(
                          listener: (context, state) {
                            if (state is GroupPermissionAssigned) {
                              setState(() {
                                _isAssigning = false;
                              });
                            } else if (state is GroupPermissionsError) {
                              setState(() {
                                _isAssigning = false;
                              });
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
                                  : const Icon(Icons.add),
                              label: Text(_isAssigning ? 'Assigning...' : 'Assign'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: theme.colorScheme.primary,
                                foregroundColor: Colors.white,
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
    return BlocBuilder<GroupPermissionsBloc, GroupPermissionsState>(
      builder: (context, state) {
        if (state is GroupPermissionsLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is GroupPermissionsError) {
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
                    context.read<GroupPermissionsBloc>().add(
                          ListGroupPermissionsRequest(groupId: widget.group.id),
                        );
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        } else if (state is GroupPermissionsLoaded) {
          _groupPermissions.clear();
          _groupPermissions.addAll(state.permissions);
          
          final filteredPermissions = _groupPermissions.where((permission) {
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
                  const Text('This group has no permissions assigned.'),
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
    return BlocBuilder<GroupPermissionsBloc, GroupPermissionsState>(
      builder: (context, groupPermissionsState) {
        // Update _groupPermissions when loaded
        if (groupPermissionsState is GroupPermissionsLoaded) {
          _groupPermissions.clear();
          _groupPermissions.addAll(groupPermissionsState.permissions);
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
                    const Icon(Icons.error_outline,
                        size: 48, color: Colors.red),
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
                            .add(ListPermissionsRequest(all: true));
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            } else if (state is PermissionsLoaded) {
              // Only process if group permissions state is loaded or if we have cached group permissions
              if (groupPermissionsState is! GroupPermissionsLoaded && _groupPermissions.isEmpty) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text('Loading group permissions...'),
                    ],
                  ),
                );
              }

              _availablePermissions = state.permissions
                  .map((entity) => Permission(
                        id: entity.id,
                        name: entity.name,
                        displayName: entity.displayName,
                        description: entity.description,
                      ))
                  .toList();

              // Filter out permissions already assigned to group
              final assignedPermissionIds =
                  _groupPermissions.map((p) => p.permissionId.toInt()).toSet();
              final unassignedPermissions =
                  _availablePermissions.where((permission) {
                return !assignedPermissionIds.contains(permission.id.toInt());
              }).toList();

              final filteredPermissions =
                  unassignedPermissions.where((permission) {
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
                            ? 'This group has been assigned all available permissions.'
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

  Widget _buildSelectablePermissionCard(Permission permission) {
    final theme = Theme.of(context);
    final isSelected = selectedPermissions.contains(permission.id);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color:
          isSelected ? theme.colorScheme.primary.withValues(alpha: 0.1) : null,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isSelected
              ? theme.colorScheme.primary
              : Colors.green.withValues(alpha: 0.1),
          child: Icon(
            isSelected ? Icons.check_circle : Icons.add_circle_outline,
            color: isSelected ? Colors.white : Colors.green,
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
        onTap: widget.group.isSystem ? null : () {
          setState(() {
            final permissionId = permission.id;
            if (isSelected) {
              selectedPermissions.remove(permissionId);
              debugPrint(
                  'Deselected permission: ${permission.displayName} (ID: $permissionId)');
            } else {
              selectedPermissions.add(permissionId);
              debugPrint(
                  'Selected permission: ${permission.displayName} (ID: $permissionId)');
            }
            debugPrint('Total selected: ${selectedPermissions.length}');
          });
        },
      ),
    );
  }

  Widget _buildCurrentPermissionCard(EffectivePermission permission) {
    final theme = Theme.of(context);
    final bool isSelected = !widget.group.isSystem &&
        selectedRemovePermissions.contains(permission.permissionId);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: isSelected ? Colors.red.withValues(alpha: 0.1) : null,
      child: ListTile(
        leading: widget.group.isSystem 
            ? CircleAvatar(
                backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.1),
                child: Icon(
                  Icons.security,
                  color: theme.colorScheme.primary,
                ),
              )
            : GestureDetector(
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      selectedRemovePermissions.remove(permission.permissionId);
                    } else {
                      selectedRemovePermissions.add(permission.permissionId);
                    }
                  });
                },
                child: CircleAvatar(
                  backgroundColor: isSelected
                      ? Colors.red
                      : theme.colorScheme.primary.withValues(alpha: 0.1),
                  child: Icon(
                    isSelected
                        ? Icons.check_circle
                        : Icons.remove_circle_outline,
                    color: isSelected
                        ? Colors.white
                        : Colors.red,
                  ),
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
              ],
            ),
          ],
        ),
        onTap: widget.group.isSystem ? null : () {
          setState(() {
            if (isSelected) {
              selectedRemovePermissions.remove(permission.permissionId);
            } else {
              selectedRemovePermissions.add(permission.permissionId);
            }
          });
        },
        trailing: widget.group.isSystem 
            ? Icon(
                Icons.lock,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
              )
            : IconButton(
                icon: Icon(
                  isSelected ? Icons.check_circle : Icons.remove_circle_outline,
                  color: Colors.red,
                ),
                tooltip: isSelected
                    ? 'Deselect for bulk removal'
                    : 'Remove permission',
                onPressed: isSelected
                    ? () {
                        setState(() {
                          selectedRemovePermissions
                              .remove(permission.permissionId);
                        });
                      }
                    : () => _removePermission(permission),
              ),
      ),
    );
  }

  void _assignSelectedPermissions() {
    if (selectedPermissions.isEmpty) return;

    setState(() {
      _isAssigning = true;
    });

    // Create the request with multiple permission IDs
    context.read<GroupPermissionsBloc>().add(
          AssignPermissionsToGroupRequest(
            groupId: widget.group.id,
            permissionsIds: selectedPermissions.toList(),
          ),
        );
  }

  void _removeSelectedPermissions() {
    if (selectedRemovePermissions.isEmpty) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Permissions'),
        content: Text(
          'Are you sure you want to remove ${selectedRemovePermissions.length} permission${selectedRemovePermissions.length == 1 ? '' : 's'} from ${widget.group.displayName.isEmpty ? widget.group.name : widget.group.displayName}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                _isRemoving = true;
              });
              context.read<GroupPermissionsBloc>().add(
                    RemovePermissionsFromGroupRequest(
                      groupId: widget.group.id,
                      permissionsIds: selectedRemovePermissions.toList(),
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

  void _removePermission(EffectivePermission permission) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Permission'),
        content: Text(
          'Are you sure you want to remove "${permission.permissionDisplayName.isEmpty ? permission.permissionName : permission.permissionDisplayName}" permission from ${widget.group.displayName.isEmpty ? widget.group.name : widget.group.displayName}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<GroupPermissionsBloc>().add(
                    RemovePermissionsFromGroupRequest(
                      groupId: widget.group.id,
                      permissionsIds: [permission.permissionId],
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

  String _formatDate(int timestamp) {
    if (timestamp == 0) return 'Unknown';
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return '${date.day}/${date.month}/${date.year}';
  }
}
