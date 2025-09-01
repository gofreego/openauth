// Permissions API Integration Example
// This file demonstrates how to use the permissions APIs

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/permissions/presentation/bloc/permissions_bloc.dart';
import 'features/permissions/domain/entities/permission_entity.dart';
import 'src/generated/openauth/v1/permissions.pb.dart' as pb;
import 'package:fixnum/fixnum.dart';

class PermissionsExampleUsage extends StatelessWidget {
  const PermissionsExampleUsage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Permissions API Example')),
      body: BlocConsumer<PermissionsBloc, PermissionsState>(
        listener: (context, state) {
          if (state is PermissionError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.message}')),
            );
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // API Action Buttons
                const Text('API Actions:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  children: [
                    ElevatedButton(
                      onPressed: () => _loadPermissions(context),
                      child: const Text('Load Permissions'),
                    ),
                    ElevatedButton(
                      onPressed: () => _createPermission(context),
                      child: const Text('Create Permission'),
                    ),
                    ElevatedButton(
                      onPressed: () => _searchPermissions(context),
                      child: const Text('Search Permissions'),
                    ),
                    ElevatedButton(
                      onPressed: () => _refreshPermissions(context),
                      child: const Text('Refresh'),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                
                // State Display
                const Text('Current State:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                Expanded(
                  child: _buildStateWidget(state),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStateWidget(PermissionsState state) {
    if (state is PermissionsLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is PermissionsLoaded) {
      return _buildPermissionsList(state.permissions);
    } else if (state is PermissionCreated) {
      return Column(
        children: [
          const Icon(Icons.check_circle, color: Colors.green, size: 48),
          const SizedBox(height: 16),
          const Text('Permission created successfully!'),
          const SizedBox(height: 8),
          Text('Created: ${state.permission.displayName}'),
        ],
      );
    } else if (state is PermissionsError) {
      return Column(
        children: [
          const Icon(Icons.error, color: Colors.red, size: 48),
          const SizedBox(height: 16),
          Text('Error: ${state.message}'),
        ],
      );
    } else {
      return const Center(child: Text('No permissions loaded'));
    }
  }

  Widget _buildPermissionsList(List<PermissionEntity> permissions) {
    return ListView.builder(
      itemCount: permissions.length,
      itemBuilder: (context, index) {
        final permission = permissions[index];
        return Card(
          child: ListTile(
            leading: CircleAvatar(
              child: Text('${index + 1}'),
            ),
            title: Text(permission.displayName),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Name: ${permission.name}'),
                Text('Description: ${permission.description}'),
                Text('Created: ${permission.createdAt}'),
              ],
            ),
            trailing: PopupMenuButton<String>(
              onSelected: (action) => _handlePermissionAction(context, action, permission),
              itemBuilder: (context) => [
                const PopupMenuItem(value: 'edit', child: Text('Edit')),
                const PopupMenuItem(value: 'delete', child: Text('Delete')),
              ],
            ),
          ),
        );
      },
    );
  }

  // API Integration Methods
  void _loadPermissions(BuildContext context) {
    context.read<PermissionsBloc>().add(const LoadPermissions());
  }

  void _createPermission(BuildContext context) {
    final request = pb.CreatePermissionRequest()
      ..name = 'example.permission'
      ..displayName = 'Example Permission'
      ..description = 'This is an example permission created via API';

    context.read<PermissionsBloc>().add(CreatePermission(request));
  }

  void _searchPermissions(BuildContext context) {
    context.read<PermissionsBloc>().add(const SearchPermissions('user'));
  }

  void _refreshPermissions(BuildContext context) {
    context.read<PermissionsBloc>().add(const RefreshPermissions());
  }

  void _handlePermissionAction(BuildContext context, String action, PermissionEntity permission) {
    switch (action) {
      case 'edit':
        final request = pb.UpdatePermissionRequest()
          ..id = Int64(permission.id)
          ..name = permission.name
          ..displayName = '${permission.displayName} (Updated)'
          ..description = '${permission.description} - Updated via API';

        context.read<PermissionsBloc>().add(UpdatePermission(request));
        break;
      case 'delete':
        context.read<PermissionsBloc>().add(DeletePermission(permission.id));
        break;
    }
  }
}
