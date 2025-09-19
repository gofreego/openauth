import 'package:flutter/material.dart';
import 'package:openauth/shared/widgets/avatar.dart';
import 'package:openauth/src/generated/openauth/v1/users.pb.dart' as pb;

class ProfileCard extends StatelessWidget {
  final pb.UserProfile profile;
  final Function(String action, pb.UserProfile profile) onProfileAction;

  const ProfileCard({
    super.key,
    required this.profile,
    required this.onProfileAction,
  });

  String get _displayName {
    if (profile.displayName.isNotEmpty) {
      return profile.displayName;
    } else if (profile.firstName.isNotEmpty || profile.lastName.isNotEmpty) {
      return '${profile.firstName} ${profile.lastName}'.trim();
    } else if (profile.profileName.isNotEmpty) {
      return profile.profileName;
    } else {
      return 'Unnamed Profile';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return InkWell(
      onTap: () => onProfileAction('view', profile),
      borderRadius: BorderRadius.circular(12),
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CustomAvatar(imageUrl: profile.avatarUrl, name: _displayName, radius: 24,),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _displayName,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (profile.profileName.isNotEmpty && profile.displayName.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        profile.profileName,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              PopupMenuButton<String>(
                onSelected: (value) => onProfileAction(value, profile),
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit_outlined, size: 16),
                        SizedBox(width: 8),
                        Text('Edit'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete_outline, size: 16, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Delete', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
                child: const Icon(Icons.more_vert),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
