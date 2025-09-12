import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:openauth/src/generated/openauth/v1/configs.pb.dart';
import '../../../../shared/shared.dart';
import '../bloc/config_entities_bloc.dart';
import '../bloc/config_entities_state.dart';

class CreateConfigEntityDialog extends StatefulWidget {
  final VoidCallback? onEntityCreated;

  const CreateConfigEntityDialog({
    super.key,
    this.onEntityCreated,
  });

  static void show(BuildContext context, {VoidCallback? onEntityCreated}) {
    showDialog(
      context: context,
      builder: (context) => CreateConfigEntityDialog(
        onEntityCreated: onEntityCreated,
      ),
    );
  }

  @override
  State<CreateConfigEntityDialog> createState() => _CreateConfigEntityDialogState();
}

class _CreateConfigEntityDialogState extends State<CreateConfigEntityDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _displayNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _readPermController = TextEditingController();
  final _writePermController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _displayNameController.dispose();
    _descriptionController.dispose();
    _readPermController.dispose();
    _writePermController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ConfigEntitiesBloc, ConfigEntitiesState>(
      listener: (context, state) {
        if (state is ConfigEntityCreated) {
          Navigator.of(context).pop();
          widget.onEntityCreated?.call();
          ToastUtils.showSuccess(
              'Config entity created successfully');
        } else if (state is ConfigEntityCreateError) {
          ToastUtils.showError('Error: ${state.message}');
        }
      },
      child: AlertDialog(
        title: const Text('Add New Config Entity'),
        content: SizedBox(
          width: 500,
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.text_fields_outlined),
                      helperText: 'Unique identifier for this entity',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a name';
                      }
                      if (value.length < 3) {
                        return 'Name must be at least 3 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _displayNameController,
                    decoration: const InputDecoration(
                      labelText: 'Display Name',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.label_outlined),
                      helperText: 'Human-readable name for display',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a display name';
                      }
                      if (value.length < 3) {
                        return 'Display name must be at least 3 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.description_outlined),
                      helperText: 'Brief description of this entity',
                    ),
                    maxLines: 3,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Description is required';
                      }
                      if (value.length < 10) {
                        return 'Description must be at least 10 characters if provided';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _readPermController,
                    decoration: const InputDecoration(
                      labelText: 'Read Permission',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.visibility_outlined),
                      helperText: 'Permission level required to read this entity',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Read Permission is required";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _writePermController,
                    decoration: const InputDecoration(
                      labelText: 'Write Permission',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.edit_outlined),
                      helperText: 'Permission level required to modify this entity',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Write Permission is required";
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          BlocBuilder<ConfigEntitiesBloc, ConfigEntitiesState>(
            builder: (context, state) {
              final isLoading = state is ConfigEntitiesLoading;

              return FilledButton(
                onPressed: isLoading ? null : _createEntity,
                child: isLoading
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Create Entity'),
              );
            },
          ),
        ],
      ),
    );
  }

  void _createEntity() {
    if (_formKey.currentState!.validate()) {
      final readPerm = _readPermController.text.trim();
      final writePerm = _writePermController.text.trim();

      context.read<ConfigEntitiesBloc>().add(
            CreateConfigEntityRequest(
              name: _nameController.text.trim(),
              displayName: _displayNameController.text.trim(),
              description: _descriptionController.text.trim(),
              readPerm: readPerm.isEmpty ? null : readPerm,
              writePerm: writePerm.isEmpty ? null :writePerm,
            ),
          );
    }
  }
}
