import 'package:flutter/material.dart';
import '../../data/models/permission_model.dart';

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
  final _descriptionController = TextEditingController();
  PermissionCategory? _selectedCategory;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
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
                  labelText: 'Permission Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a permission name';
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
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<PermissionCategory>(
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
                value: _selectedCategory,
                items: PermissionCategory.values
                    .map((category) => DropdownMenuItem(
                          value: category,
                          child: Row(
                            children: [
                              Icon(category.icon, size: 16, color: category.color),
                              const SizedBox(width: 8),
                              Text(category.displayName),
                            ],
                          ),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select a category';
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
        FilledButton(
          onPressed: _handleCreatePermission,
          child: const Text('Create'),
        ),
      ],
    );
  }

  void _handleCreatePermission() {
    if (_formKey.currentState!.validate()) {
      // TODO: Implement actual permission creation logic
      Navigator.of(context).pop();
      widget.onPermissionCreated?.call();
    }
  }
}
