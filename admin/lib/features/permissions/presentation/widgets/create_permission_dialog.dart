import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:openauth/shared/utils/toast_utils.dart';
import '../bloc/permissions_bloc.dart';
import '../../../../src/generated/openauth/v1/permissions.pb.dart' as pb;

class CreatePermissionDialog extends StatefulWidget {
  final VoidCallback? onPermissionCreated;

  const CreatePermissionDialog({
    super.key,
    this.onPermissionCreated,
  });

  @override
  State<CreatePermissionDialog> createState() => _CreatePermissionDialogState();
}

class _CreatePermissionDialogState extends State<CreatePermissionDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _displayNameController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _displayNameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PermissionsBloc, PermissionsState>(
      listener: (context, state) {
        if (state is PermissionCreated) {
          Navigator.of(context).pop();
          widget.onPermissionCreated?.call();
        } else if (state is PermissionError) {
          ToastUtils.showError(state.message);
        }
      },
      child: AlertDialog(
        title: const Text('Create New Permission'),
        content: SizedBox(
          width: 400,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Permission Name*',
                    hintText: 'e.g., user.create',
                    border: OutlineInputBorder(),
                    helperText: 'Use dot notation for hierarchy',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a permission name';
                    }
                    if (!RegExp(r'^[a-z][a-z0-9._]*[a-z0-9]$').hasMatch(value)) {
                      return 'Use lowercase letters, numbers, dots and underscores only';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _displayNameController,
                  decoration: const InputDecoration(
                    labelText: 'Display Name*',
                    hintText: 'e.g., Create Users',
                    border: OutlineInputBorder(),
                    helperText: 'Human-readable name for the permission',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a display name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description*',
                    hintText: 'Brief description of what this permission allows',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          BlocBuilder<PermissionsBloc, PermissionsState>(
            builder: (context, state) {
              final isCreating = state is PermissionCreating;
              return FilledButton(
                onPressed: isCreating ? null : _handleCreatePermission,
                child: isCreating
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Create'),
              );
            },
          ),
        ],
      ),
    );
  }

  void _handleCreatePermission() {
    if (_formKey.currentState!.validate()) {
      final request = pb.CreatePermissionRequest()
        ..name = _nameController.text.trim()
        ..displayName = _displayNameController.text.trim()
        ..description = _descriptionController.text.trim();

      if (mounted) {
        final bloc = context.read<PermissionsBloc>();
        if (!bloc.isClosed) {
          bloc.add(CreatePermission(request));
        }
      }
    }
  }
}
