import 'package:flutter/material.dart';
import 'package:openauth/shared/utils/utility_functions.dart';
import 'package:openauth/shared/widgets/info_row_with_copy.dart';
import 'package:openauth/src/generated/openauth/v1/permissions.pbserver.dart';

class PermissionDetailsDialog extends StatelessWidget {
  final Permission permission;
  final VoidCallback onEdit;

  const PermissionDetailsDialog({
    super.key,
    required this.permission,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(permission.displayName),
      content: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 400,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Name', permission.name),
            const SizedBox(height: 12),
            _buildDetailRow('Description', permission.description),
            const SizedBox(height: 12),
            InfoRowWithCopy(label: 'Created At', value: UtilityFunctions.formatDate(permission.createdAt)),
            const SizedBox(height: 12),
            InfoRowWithCopy(label: 'Updated At', value: UtilityFunctions.formatDate(permission.updatedAt)),
            const SizedBox(height: 12),
            InfoRowWithCopy(label: 'Permission Id', value: permission.id.toString(), copy: true),
            const SizedBox(height: 12),
            InfoRowWithCopy(label: 'Created by Id', value: permission.createdBy.toString(), copy: true),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
        FilledButton(
          onPressed: permission.isSystem?null: () {
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


}
