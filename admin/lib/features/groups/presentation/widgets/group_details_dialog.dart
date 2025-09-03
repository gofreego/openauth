import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:openauth/shared/widgets/info_row_with_copy.dart';
import '../../../../src/generated/openauth/v1/groups.pb.dart';
import 'manage_group_permissions_dialog.dart';
import 'manage_group_members_dialog.dart';

class GroupDetailsDialog extends StatelessWidget {
  final Group group;
  final VoidCallback onEdit;

  const GroupDetailsDialog({
    super.key,
    required this.group,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(group.displayName),
      content: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 400,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Name', group.name),
            const SizedBox(height: 12),
            _buildDetailRow('Description', group.description),
            const SizedBox(height: 12),
            InfoRowWithCopy(label: 'Created', value: _formatDate(group.createdAt)),
            const SizedBox(height: 12),
            InfoRowWithCopy(label: 'Last Updated', value: _formatDate(group.updatedAt)),
            const SizedBox(height: 12),
            InfoRowWithCopy(label: 'Created by', value: group.createdBy.toString(), copy: true),
            const SizedBox(height: 12),
            _buildDetailRow('Members', '0'), // TODO: Get actual member count
            const SizedBox(height: 24),
            
            // Management buttons
            if (!group.isSystem) ...[
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _showManagePermissionsDialog(context),
                      icon: const Icon(Icons.security),
                      label: const Text('Manage Permissions'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _showManageMembersDialog(context),
                      icon: const Icon(Icons.people),
                      label: const Text('Manage Members'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
            ],
            
            const SizedBox(height: 12),
            if (group.isSystem)
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  border: Border.all(color: Colors.orange.shade200),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  children: [
                    Icon(Icons.warning, color: Colors.orange.shade600, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'This is a system group and cannot be modified',
                        style: TextStyle(
                          color: Colors.orange.shade600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
        FilledButton(
          onPressed: group.isSystem ? null : () {
            Navigator.of(context).pop();
            onEdit();
          },
          child: const Text('Edit'),
        ),
      ],
    );
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
        group: group,
      ),
    );
  }

  void _showManageMembersDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => ManageGroupMembersDialog(
        group: group,
      ),
    );
  }

  String _formatDate(Int64 millis) {
    if (millis == 0) return '—';
    
    try {
      final date = DateTime.fromMillisecondsSinceEpoch(millis.toInt() * 1000);
      return '${date.day}/${date.month}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return '—';
    }
  }
}
