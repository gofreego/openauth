import 'package:flutter/material.dart';
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

  String get _initials {
    if (profile.firstName.isNotEmpty && profile.lastName.isNotEmpty) {
      return '${profile.firstName[0]}${profile.lastName[0]}'.toUpperCase();
    } else if (profile.firstName.isNotEmpty) {
      return profile.firstName[0].toUpperCase();
    } else if (profile.lastName.isNotEmpty) {
      return profile.lastName[0].toUpperCase();
    } else if (profile.displayName.isNotEmpty) {
      final parts = profile.displayName.split(' ');
      if (parts.length >= 2) {
        return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
      } else {
        return profile.displayName[0].toUpperCase();
      }
    } else if (profile.profileName.isNotEmpty) {
      return profile.profileName[0].toUpperCase();
    } else {
      return 'U';
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
              CircleAvatar(
                radius: 24,
                backgroundColor: theme.colorScheme.surfaceContainerHighest,
                child: ClipOval(
                  child: Image.network(
                    profile.avatarUrl,
                    width: 48,
                    height: 48,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Center(
                        child: Text(
                          _initials,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      );
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                          strokeWidth: 2,
                        ),
                      );
                    },
                  ),
                ),
              ),
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
