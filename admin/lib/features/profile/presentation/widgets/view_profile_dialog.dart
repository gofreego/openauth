import 'package:flutter/material.dart';
import 'package:openauth/shared/utils/utility_functions.dart';
import 'package:openauth/shared/widgets/info_row_with_copy.dart';
import 'package:openauth/src/generated/openauth/v1/users.pb.dart' as pb;

class ViewProfileDialog extends StatelessWidget {
  final pb.UserProfile profile;
  final String userUuid;
  final VoidCallback? onEdit;

  const ViewProfileDialog({
    super.key,
    required this.profile,
    required this.userUuid,
    this.onEdit,
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
    final screenWidth = MediaQuery.of(context).size.width;
    final dialogWidth = screenWidth * 0.6 < 600 ? 600.0 : screenWidth * 0.6 > 700 ? 700.0 : screenWidth * 0.6;

    return AlertDialog(
      title: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: theme.colorScheme.surfaceContainerHighest,
            backgroundImage: profile.avatarUrl.isNotEmpty 
                ? NetworkImage(profile.avatarUrl)
                : null,
            child: profile.avatarUrl.isEmpty
                ? Icon(
                    Icons.person,
                    color: theme.colorScheme.onSurfaceVariant,
                  )
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _displayName,
                  style: theme.textTheme.headlineSmall,
                ),
                if (profile.profileName.isNotEmpty && profile.displayName.isNotEmpty) ...[
                  Text(
                    profile.profileName,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
      content: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: 600,
          maxWidth: 700,
          maxHeight: MediaQuery.of(context).size.height * 0.7,
        ),
        child: SizedBox(
          width: dialogWidth,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (profile.bio.isNotEmpty) ...[
                  Text(
                    'Bio',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    profile.bio,
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 20),
                ],
                
                // Personal Information
                Text(
                  'Personal Information',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                _buildInfoSection([
                  if (profile.firstName.isNotEmpty) 
                    InfoRowWithCopy(label: 'First Name', value: profile.firstName),
                  if (profile.lastName.isNotEmpty) 
                    InfoRowWithCopy(label: 'Last Name', value: profile.lastName),
                  if (profile.displayName.isNotEmpty) 
                    InfoRowWithCopy(label: 'Display Name', value: profile.displayName),
                  if (profile.gender.isNotEmpty) 
                    InfoRowWithCopy(label: 'Gender', value: profile.gender),
                  if (profile.dateOfBirth.toInt() > 0)
                    InfoRowWithCopy(
                      label: 'Date of Birth',
                      value: UtilityFunctions.formatDate(profile.dateOfBirth),
                    ),
                ]),
                
                // Location Information
                if (profile.country.isNotEmpty || profile.city.isNotEmpty || profile.address.isNotEmpty || profile.postalCode.isNotEmpty) ...[
                  const SizedBox(height: 20),
                  Text(
                    'Location',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildInfoSection([
                    if (profile.country.isNotEmpty) 
                      InfoRowWithCopy(label: 'Country', value: profile.country),
                    if (profile.city.isNotEmpty) 
                      InfoRowWithCopy(label: 'City', value: profile.city),
                    if (profile.address.isNotEmpty) 
                      InfoRowWithCopy(label: 'Address', value: profile.address),
                    if (profile.postalCode.isNotEmpty) 
                      InfoRowWithCopy(label: 'Postal Code', value: profile.postalCode),
                  ]),
                ],
                
                // Contact & Preferences
                if (profile.websiteUrl.isNotEmpty || profile.timezone.isNotEmpty || profile.locale.isNotEmpty) ...[
                  const SizedBox(height: 20),
                  Text(
                    'Contact & Preferences',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildInfoSection([
                    if (profile.websiteUrl.isNotEmpty) 
                      InfoRowWithCopy(label: 'Website', value: profile.websiteUrl),
                    if (profile.timezone.isNotEmpty) 
                      InfoRowWithCopy(label: 'Timezone', value: profile.timezone),
                    if (profile.locale.isNotEmpty) 
                      InfoRowWithCopy(label: 'Locale', value: profile.locale),
                  ]),
                ],
                
                // Metadata
                const SizedBox(height: 20),
                Text(
                  'Profile Information',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                _buildInfoSection([
                  InfoRowWithCopy(
                    label: 'Created',
                    value: UtilityFunctions.formatDateInWords(profile.createdAt),
                  ),
                  if (profile.updatedAt != profile.createdAt)
                    InfoRowWithCopy(
                      label: 'Updated',
                      value: UtilityFunctions.formatDateInWords(profile.updatedAt),
                    ),
                ]),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
        FilledButton.icon(
          onPressed: () {
            Navigator.of(context).pop();
            onEdit?.call();
          },
          icon: const Icon(Icons.edit, size: 16),
          label: const Text('Edit'),
        ),
      ],
    );
  }

  Widget _buildInfoSection(List<Widget> children) {
    if (children.isEmpty) return const SizedBox.shrink();
    
    return Column(
      children: children.map((child) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: child,
      )).toList(),
    );
  }
}
