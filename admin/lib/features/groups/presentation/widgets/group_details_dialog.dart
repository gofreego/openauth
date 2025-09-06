import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:openauth/shared/utils/utility_functions.dart';
import 'package:openauth/shared/widgets/info_row_with_copy.dart';
import '../../../../src/generated/openauth/v1/groups.pb.dart';
import '../../../users/presentation/bloc/users_bloc.dart';
import '../bloc/groups_bloc.dart';
import 'manage_group_permissions_dialog.dart';
import 'manage_group_members_dialog.dart';

class GroupDetailsDialog extends StatefulWidget {
  final Group group;
  final bool editMode;

  const GroupDetailsDialog({
    super.key,
    required this.group,
    this.editMode = false,
  });

  @override
  State<GroupDetailsDialog> createState() => _GroupDetailsDialogState();
}

class _GroupDetailsDialogState extends State<GroupDetailsDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _displayNameController;
  late final TextEditingController _descriptionController;
  bool _isEditMode = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.group.name);
    _displayNameController =
        TextEditingController(text: widget.group.displayName);
    _descriptionController =
        TextEditingController(text: widget.group.description);
    _isEditMode = widget.editMode;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _displayNameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_isEditMode ? 'Edit Group' : widget.group.displayName),
      content: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 600,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_isEditMode) ...[
                // Edit mode - show form fields
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Group Name *',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Group name is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _displayNameController,
                  decoration: const InputDecoration(
                    labelText: 'Display Name *',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Display name is required';
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
                ),
              ] else ...[
                // System group warning (only in view mode)
                if (widget.group.isSystem)
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      // color: Colors.orange.shade50,
                      border: Border.all(color: Colors.orange.shade200),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.warning,
                            color: Colors.orange.shade600, size: 16),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'This is a system group. Group details cannot be modified.',
                            style: TextStyle(
                              color: Colors.orange.shade600,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 12),
                // View mode - show read-only information
                _buildDetailRow('Name', widget.group.name),
                const SizedBox(height: 12),
                _buildDetailRow('Description', widget.group.description),
                const SizedBox(height: 12),
                InfoRowWithCopy(
                    label: 'Created At',
                    value: UtilityFunctions.formatDate(widget.group.createdAt)),
                const SizedBox(height: 12),
                InfoRowWithCopy(
                    label: 'Updated At',
                    value: UtilityFunctions.formatDate(widget.group.updatedAt)),
                const SizedBox(height: 12),
                InfoRowWithCopy(
                    label: 'Group Id',
                    value: widget.group.id.toString(),
                    copy: true),
                InfoRowWithCopy(
                    label: 'Created by Id',
                    value: widget.group.createdBy.toString(),
                    copy: true),

                const SizedBox(height: 24),
                // Management buttons (always visible)
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.end,
                  // runAlignment: WrapAlignment.end,
                  // alignment: WrapAlignment.end,
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _showManagePermissionsDialog(context),
                        icon: const Icon(Icons.security),
                        label: const Text('Permissions'),
                      ),
                    ),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _showManageMembersDialog(context),
                        icon: const Icon(Icons.people),
                        label: const Text('Members'),
                      ),
                    ),
                    if (!widget.group.isSystem)
                    Expanded(
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                          side: const BorderSide(color: Colors.red),
                        ),
                        onPressed: () => _showManageMembersDialog(context),
                        icon: const Icon(Icons.delete),
                        label: const Text('Delete'),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
      actions: _buildActions(),
    );
  }

  List<Widget> _buildActions() {
    if (_isEditMode) {
      return [
        TextButton(
          onPressed: () {
            setState(() {
              _isEditMode = false;
              // Reset form to original values
              _nameController.text = widget.group.name;
              _displayNameController.text = widget.group.displayName;
              _descriptionController.text = widget.group.description;
            });
          },
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _updateGroup,
          child: const Text('Save'),
        ),
      ];
    } else {
      return [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
        FilledButton(
          onPressed: widget.group.isSystem
              ? null
              : () {
                  setState(() {
                    _isEditMode = true;
                  });
                },
          child: const Text('Edit'),
        ),
      ];
    }
  }

  void _updateGroup() {
    if (_formKey.currentState!.validate()) {
      context.read<GroupsBloc>().add(
            UpdateGroupRequest(
              id: widget.group.id,
              newName: _nameController.text.trim(),
              displayName: _displayNameController.text.trim(),
              description: _descriptionController.text.trim().isEmpty
                  ? null
                  : _descriptionController.text.trim(),
            ),
          );
      Navigator.of(context).pop();
    }
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

  void _showManagePermissionsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => ManageGroupPermissionsDialog(
        group: widget.group,
      ),
    );
  }

  void _showManageMembersDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => MultiBlocProvider(
        providers: [
          BlocProvider.value(value: context.read<GroupsBloc>()),
          BlocProvider.value(value: context.read<UsersBloc>()),
        ],
        child: ManageGroupMembersDialog(
          group: widget.group,
        ),
      ),
    );
  }
}
