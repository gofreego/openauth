import 'package:flutter/material.dart';
import 'package:openauth/features/groups/presentation/widgets/group_action_dialogs.dart';
import '../../../../src/generated/openauth/v1/groups.pb.dart';

class GroupCard extends StatelessWidget {
  final Group group;
  final VoidCallback onTap;

  const GroupCard({
    super.key,
    required this.group,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.group,
                    size: 24,
                    color: Colors.blue,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      group.displayName,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert, size: 20),
                    onSelected: (action) {
                      switch (action) {
                        case 'edit':
                          GroupActionDialogs.showGroupDetails(context, group, editMode: true);
                          break;
                        case 'manage_members':
                          GroupActionDialogs.showManageMembersDialog(context, group);
                          break;
                        case 'manage_permissions':
                          GroupActionDialogs.showManagePermissionsDialog(context, group);
                          break;
                        case 'delete':
                          GroupActionDialogs.showDeleteGroupDialog(context, group);
                          break;
                      }
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'edit',
                        enabled: !group.isSystem,
                        child: const Row(
                          children: [
                            Icon(Icons.edit),
                            SizedBox(width: 8),
                            Text('Edit'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'manage_members',
                        child: Row(
                          children: [
                            Icon(Icons.people),
                            SizedBox(width: 8),
                            Text('Manage Members'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'manage_permissions',
                        child: Row(
                          children: [
                            Icon(Icons.security),
                            SizedBox(width: 8),
                            Text('Manage Permissions'),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'delete',
                        enabled: !group.isSystem,
                        child: const Row(
                          children: [
                            Icon(Icons.delete, color: Colors.red),
                            SizedBox(width: 8),
                            Text('Delete', style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                group.description,
                style: Theme.of(context).textTheme.bodyMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
