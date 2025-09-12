import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:openauth/src/generated/openauth/v1/configs.pb.dart';
import 'package:openauth/shared/widgets/info_row_with_copy.dart';
import '../../../../shared/shared.dart';
import '../bloc/config_entities_bloc.dart';
import '../bloc/config_entities_state.dart';

class EditConfigEntityDialog extends StatefulWidget {
  final ConfigEntity entity;
  final VoidCallback? onEntityUpdated;
  final bool isViewMode;

  const EditConfigEntityDialog({
    super.key,
    required this.entity,
    this.onEntityUpdated,
    this.isViewMode = false,
  });

  static void show(BuildContext context, ConfigEntity entity) {
    showDialog(
      context: context,
      builder: (context) => EditConfigEntityDialog(
        entity: entity,
        isViewMode: true,
        onEntityUpdated: () {
          // Optionally trigger a refresh or callback
        },
      ),
    );
  }

  @override
  State<EditConfigEntityDialog> createState() => _EditConfigEntityDialogState();
}

class _EditConfigEntityDialogState extends State<EditConfigEntityDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _displayNameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _readPermController;
  late final TextEditingController _writePermController;
  late bool _isEditMode;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.entity.name);
    _displayNameController = TextEditingController(text: widget.entity.displayName);
    _descriptionController = TextEditingController(text: widget.entity.description);
    _readPermController = TextEditingController(
      text: widget.entity.hasReadPerm() ? widget.entity.readPerm.toString() : '',
    );
    _writePermController = TextEditingController(
      text: widget.entity.hasWritePerm() ? widget.entity.writePerm.toString() : '',
    );
    _isEditMode = !widget.isViewMode;
  }

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
    final theme = Theme.of(context);
    
    return BlocListener<ConfigEntitiesBloc, ConfigEntitiesState>(
      listener: (context, state) {
        if (state is ConfigEntityUpdated) {
          Navigator.of(context).pop();
          widget.onEntityUpdated?.call();
          ToastUtils.showSuccess(
              'Config entity ${state.entity.name} updated successfully');
        } else if (state is ConfigEntityUpdateError) {
          ToastUtils.showError('Error: ${state.message}');
        }
      },
      child: AlertDialog(
        title: Row(
          children: [
            Icon(
              Icons.settings,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Text(_isEditMode ? 'Edit Config Entity' : 'Config Entity Details'),
            const Spacer(),
            if (!_isEditMode)
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  setState(() {
                    _isEditMode = true;
                  });
                },
                tooltip: 'Edit Entity',
              ),
          ],
        ),
        content: SizedBox(
          width: 600,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!_isEditMode) ...[
                  // View Mode - Entity Information
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Entity Information',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          if (widget.entity.hasId())
                            InfoRowWithCopy(
                              label: 'ID',
                              value: widget.entity.id.toString(),
                            ),
                          InfoRowWithCopy(
                            label: 'Name',
                            value: widget.entity.name,
                          ),
                          InfoRowWithCopy(
                            label: 'Display Name',
                            value: widget.entity.displayName.isEmpty 
                                ? 'Not set' 
                                : widget.entity.displayName,
                          ),
                          InfoRowWithCopy(
                            label: 'Description',
                            value: widget.entity.description.isEmpty 
                                ? 'Not set' 
                                : widget.entity.description,
                          ),
                          InfoRowWithCopy(
                            label: 'Read Permission',
                            value: widget.entity.hasReadPerm() 
                                ? widget.entity.readPerm.toString() 
                                : 'Not set',
                          ),
                          InfoRowWithCopy(
                            label: 'Write Permission',
                            value: widget.entity.hasWritePerm() 
                                ? widget.entity.writePerm.toString() 
                                : 'Not set',
                          ),
                          if (widget.entity.hasCreatedAt())
                            InfoRowWithCopy(
                              label: 'Created At',
                              value: DateTime.fromMillisecondsSinceEpoch(
                                      widget.entity.createdAt.toInt() * 1000)
                                  .toString(),
                            ),
                          if (widget.entity.hasUpdatedAt())
                            InfoRowWithCopy(
                              label: 'Updated At',
                              value: DateTime.fromMillisecondsSinceEpoch(
                                      widget.entity.updatedAt.toInt() * 1000)
                                  .toString(),
                            ),
                        ],
                      ),
                    ),
                  ),
                ] else ...[
                  // Edit Mode - Form Fields
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            labelText: 'Name',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.text_fields_outlined),
                            helperText: 'Name cannot be changed after creation',
                          ),
                          enabled: false, // Name is immutable
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
                            if (value != null && value.isNotEmpty && value.length < 10) {
                              return 'Description must be at least 10 characters if provided';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _readPermController,
                          decoration: const InputDecoration(
                            labelText: 'Read Permission (Optional)',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.visibility_outlined),
                            helperText: 'Permission level required to read this entity',
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value != null && value.isNotEmpty) {
                              final intValue = int.tryParse(value);
                              if (intValue == null || intValue < 0) {
                                return 'Please enter a valid non-negative number';
                              }
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _writePermController,
                          decoration: const InputDecoration(
                            labelText: 'Write Permission (Optional)',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.edit_outlined),
                            helperText: 'Permission level required to modify this entity',
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value != null && value.isNotEmpty) {
                              final intValue = int.tryParse(value);
                              if (intValue == null || intValue < 0) {
                                return 'Please enter a valid non-negative number';
                              }
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
          if (_isEditMode) ...[
            TextButton(
              onPressed: () {
                setState(() {
                  _isEditMode = false;
                  // Reset form to original values
                  _nameController.text = widget.entity.name;
                  _displayNameController.text = widget.entity.displayName;
                  _descriptionController.text = widget.entity.description;
                  _readPermController.text = widget.entity.hasReadPerm() 
                      ? widget.entity.readPerm.toString() 
                      : '';
                  _writePermController.text = widget.entity.hasWritePerm() 
                      ? widget.entity.writePerm.toString() 
                      : '';
                });
              },
              child: const Text('Cancel'),
            ),
            BlocBuilder<ConfigEntitiesBloc, ConfigEntitiesState>(
              builder: (context, state) {
                final isLoading = state is ConfigEntitiesLoading;

                return FilledButton(
                  onPressed: isLoading ? null : _updateEntity,
                  child: isLoading
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Update Entity'),
                );
              },
            ),
          ],
        ],
      ),
    );
  }

  void _updateEntity() {
    if (_formKey.currentState!.validate()) {
      final readPerm = _readPermController.text.trim();
      final writePerm = _writePermController.text.trim();

      context.read<ConfigEntitiesBloc>().add(
            UpdateConfigEntityRequest(
              id: widget.entity.id,
              displayName: _displayNameController.text.trim(),
              description: _descriptionController.text.trim(),
              readPerm: readPerm.isEmpty ? null : readPerm,
              writePerm: writePerm.isEmpty ? null : writePerm,
            ),
          );
    }
  }
}
