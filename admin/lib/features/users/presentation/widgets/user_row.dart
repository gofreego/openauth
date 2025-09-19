import 'package:flutter/material.dart';
import 'package:openauth/shared/utils/utility_functions.dart';
import 'package:openauth/shared/widgets/avatar.dart';
import '../../../../src/generated/openauth/v1/users.pb.dart' as pb;
import 'edit_user_dialog.dart';

class UserRow extends StatelessWidget {
  final pb.User user;
  final int index;
  final Function(String action, pb.User user, BuildContext context) onUserAction;

  const UserRow({
    super.key,
    required this.user,
    required this.index,
    required this.onUserAction,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEven = index % 2 == 0;
    
    return InkWell(
      onTap: () => EditUserDialog.show(context, user, onUserAction),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: isEven ? null : theme.colorScheme.surface,
        ),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  CustomAvatar(
                    imageUrl: user.avatarUrl,
                    name: user.name,
                    radius: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          user.name,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          '@${user.username}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Text(
                user.email,
                style: theme.textTheme.bodyMedium,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: user.isActive ? Colors.green.withValues(alpha: 0.1) : Colors.red.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  user.isActive ? 'Active' : 'Inactive',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: user.isActive ? Colors.green : Colors.red,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                UtilityFunctions.formatDateInWords(user.lastLoginAt),
                style: theme.textTheme.bodyMedium,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(
              width: 50,
              child: PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, size: 20),
                onSelected: (action) => onUserAction(action, user, context),
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'permissions',
                    child: Row(
                      children: [
                        Icon(Icons.security_outlined, size: 16),
                        SizedBox(width: 8),
                        Text('Permissions'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'sessions',
                    child: Row(
                      children: [
                        Icon(Icons.schedule_outlined, size: 16),
                        SizedBox(width: 8),
                        Text('Sessions'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: user.isActive ? 'deactivate' : 'activate',
                    child: Row(
                      children: [
                        Icon(
                          user.isActive ? Icons.block_outlined : Icons.check_circle_outline,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Text(user.isActive ? 'Deactivate' : 'Activate'),
                      ],
                    ),
                  ),
                  const PopupMenuDivider(),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete_outline, color: Colors.red, size: 16),
                        SizedBox(width: 8),
                        Text('Delete', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
