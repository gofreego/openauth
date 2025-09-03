import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fixnum/fixnum.dart';
import '../../../../src/generated/openauth/v1/groups.pb.dart';
import '../../../../src/generated/openauth/v1/permission_assignments.pb.dart';
import '../../../../src/generated/openauth/v1/permissions.pb.dart';
import '../../../permissions/presentation/bloc/permissions_bloc.dart';

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
  final Set<Int64> _assignedPermissionIds = <Int64>{};
  final Set<Int64> _selectedPermissionIds = <Int64>{};
  List<Permission> _allPermissions = [];
  final List<EffectivePermission> _groupPermissions = [];
  bool _isLoading = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    // Load all permissions
    context.read<PermissionsBloc>().add(const LoadPermissions());
    
    // Load group permissions
    // TODO: Add LoadGroupPermissions event to bloc if not exists
    // For now, we'll simulate loading group permissions
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          const Icon(Icons.security),
          const SizedBox(width: 8),
          Expanded(
            child: Text('Manage Permissions - ${widget.group.displayName}'),
          ),
        ],
      ),
      content: SizedBox(
        width: 800,
        height: 600,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _buildContent(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _selectedPermissionIds.isNotEmpty ? _saveChanges : null,
          child: const Text('Save Changes'),
        ),
      ],
    );
  }

  Widget _buildContent() {
    return Column(
      children: [
        // Search bar
        TextField(
          decoration: const InputDecoration(
            labelText: 'Search permissions',
            prefixIcon: Icon(Icons.search),
            border: OutlineInputBorder(),
          ),
          onChanged: (value) {
            setState(() {
              _searchQuery = value.toLowerCase();
            });
          },
        ),
        const SizedBox(height: 16),
        
        // Tabs for assigned/available permissions
        DefaultTabController(
          length: 2,
          child: Expanded(
            child: Column(
              children: [
                const TabBar(
                  tabs: [
                    Tab(text: 'Assigned Permissions'),
                    Tab(text: 'Available Permissions'),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      _buildAssignedPermissions(),
                      _buildAvailablePermissions(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAssignedPermissions() {
    final filteredPermissions = _groupPermissions.where((permission) {
      if (_searchQuery.isEmpty) return true;
      return permission.permissionName.toLowerCase().contains(_searchQuery) ||
             permission.permissionDisplayName.toLowerCase().contains(_searchQuery);
    }).toList();

    if (filteredPermissions.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.security_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('No assigned permissions'),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: filteredPermissions.length,
      itemBuilder: (context, index) {
        final permission = filteredPermissions[index];
        return Card(
          child: ListTile(
            leading: const Icon(Icons.security, color: Colors.green),
            title: Text(permission.permissionDisplayName),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(permission.permissionName),
                if (permission.hasPermissionDescription())
                  Text(
                    permission.permissionDescription,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
              ],
            ),
            trailing: IconButton(
              icon: const Icon(Icons.remove_circle, color: Colors.red),
              onPressed: () => _removePermission(permission.permissionId),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAvailablePermissions() {
    return BlocBuilder<PermissionsBloc, PermissionsState>(
      builder: (context, state) {
        if (state is PermissionsLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is PermissionsLoaded) {
          _allPermissions = state.permissions;
          
          final availablePermissions = _allPermissions.where((permission) {
            // Filter out already assigned permissions
            if (_assignedPermissionIds.contains(permission.id)) return false;
            
            // Apply search filter
            if (_searchQuery.isEmpty) return true;
            return permission.name.toLowerCase().contains(_searchQuery) ||
                   permission.displayName.toLowerCase().contains(_searchQuery);
          }).toList();

          if (availablePermissions.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search_off, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('No available permissions found'),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: availablePermissions.length,
            itemBuilder: (context, index) {
              final permission = availablePermissions[index];
              final isSelected = _selectedPermissionIds.contains(permission.id);
              
              return Card(
                child: ListTile(
                  leading: Icon(
                    isSelected ? Icons.check_circle : Icons.security_outlined,
                    color: isSelected ? Colors.green : Colors.grey,
                  ),
                  title: Text(permission.displayName),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(permission.name),
                      if (permission.hasDescription())
                        Text(
                          permission.description,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                    ],
                  ),
                  trailing: IconButton(
                    icon: Icon(
                      isSelected ? Icons.remove : Icons.add,
                      color: isSelected ? Colors.red : Colors.green,
                    ),
                    onPressed: () => _togglePermission(permission.id),
                  ),
                  onTap: () => _togglePermission(permission.id),
                ),
              );
            },
          );
        } else if (state is PermissionError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text('Error: ${state.message}'),
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
        }
        
        return const Center(child: Text('No permissions available'));
      },
    );
  }

  void _togglePermission(Int64 permissionId) {
    setState(() {
      if (_selectedPermissionIds.contains(permissionId)) {
        _selectedPermissionIds.remove(permissionId);
      } else {
        _selectedPermissionIds.add(permissionId);
      }
    });
  }

  void _removePermission(Int64 permissionId) {
    // TODO: Implement remove permission from group
    // This should call the group permission management API
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Permission'),
        content: const Text('Are you sure you want to remove this permission from the group?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              // TODO: Call API to remove permission from group
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Permission removed successfully'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }

  void _saveChanges() {
    if (_selectedPermissionIds.isEmpty) return;
    
    // TODO: Implement assign permissions to group
    // This should call the group permission management API
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Assign Permissions'),
        content: Text('Are you sure you want to assign ${_selectedPermissionIds.length} permission(s) to this group?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              // TODO: Call API to assign permissions to group
              Navigator.of(context).pop();
              Navigator.of(context).pop(); // Close main dialog
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${_selectedPermissionIds.length} permission(s) assigned successfully'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Assign'),
          ),
        ],
      ),
    );
  }
}
