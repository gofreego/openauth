import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:openauth/src/generated/openauth/v1/users.pb.dart' as pb;
import '../bloc/profiles_bloc.dart';
import '../bloc/profiles_state.dart';

class CreateEditProfileDialog extends StatefulWidget {
  final String userUuid;
  final pb.UserProfile? profile;

  const CreateEditProfileDialog({
    super.key,
    required this.userUuid,
    this.profile,
  });

  @override
  State<CreateEditProfileDialog> createState() => _CreateEditProfileDialogState();
}

class _CreateEditProfileDialogState extends State<CreateEditProfileDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _profileNameController;
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _displayNameController;
  late final TextEditingController _bioController;
  late final TextEditingController _avatarUrlController;
  late final TextEditingController _countryController;
  late final TextEditingController _cityController;
  late final TextEditingController _timezoneController;
  late final TextEditingController _localeController;
  late final TextEditingController _websiteUrlController;

  bool get isEditing => widget.profile != null;

  @override
  void initState() {
    super.initState();
    final profile = widget.profile;
    _profileNameController = TextEditingController(text: profile?.profileName ?? '');
    _firstNameController = TextEditingController(text: profile?.firstName ?? '');
    _lastNameController = TextEditingController(text: profile?.lastName ?? '');
    _displayNameController = TextEditingController(text: profile?.displayName ?? '');
    _bioController = TextEditingController(text: profile?.bio ?? '');
    _avatarUrlController = TextEditingController(text: profile?.avatarUrl ?? '');
    _countryController = TextEditingController(text: profile?.country ?? '');
    _cityController = TextEditingController(text: profile?.city ?? '');
    _timezoneController = TextEditingController(text: profile?.timezone ?? '');
    _localeController = TextEditingController(text: profile?.locale ?? '');
    _websiteUrlController = TextEditingController(text: profile?.websiteUrl ?? '');
  }

  @override
  void dispose() {
    _profileNameController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _displayNameController.dispose();
    _bioController.dispose();
    _avatarUrlController.dispose();
    _countryController.dispose();
    _cityController.dispose();
    _timezoneController.dispose();
    _localeController.dispose();
    _websiteUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(isEditing ? 'Edit Profile' : 'Create Profile'),
      content: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 700,
          maxHeight: 750,
        ),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _profileNameController,
                  decoration: const InputDecoration(
                    labelText: 'Profile Name *',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.badge_outlined),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Profile name is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _firstNameController,
                        decoration: const InputDecoration(
                          labelText: 'First Name',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.person_outline),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _lastNameController,
                        decoration: const InputDecoration(
                          labelText: 'Last Name',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.person_outline),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _displayNameController,
                  decoration: const InputDecoration(
                    labelText: 'Display Name',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.display_settings_outlined),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _bioController,
                  decoration: const InputDecoration(
                    labelText: 'Bio',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.info_outline),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _avatarUrlController,
                  decoration: const InputDecoration(
                    labelText: 'Avatar URL',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.image_outlined),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _countryController,
                        decoration: const InputDecoration(
                          labelText: 'Country',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.flag_outlined),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _cityController,
                        decoration: const InputDecoration(
                          labelText: 'City',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.location_city_outlined),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _timezoneController,
                        decoration: const InputDecoration(
                          labelText: 'Timezone',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.access_time_outlined),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _localeController,
                        decoration: const InputDecoration(
                          labelText: 'Locale',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.language_outlined),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _websiteUrlController,
                  decoration: const InputDecoration(
                    labelText: 'Website URL',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.web_outlined),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        BlocBuilder<ProfilesBloc, ProfilesState>(
          builder: (context, state) {
            final isLoading = state is ProfileCreating || state is ProfileUpdating;
            return FilledButton(
              onPressed: isLoading ? null : _handleSave,
              child: isLoading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(isEditing ? 'Update' : 'Create'),
            );
          },
        ),
      ],
    );
  }

  void _handleSave() {
    if (_formKey.currentState!.validate()) {
      if (isEditing) {
        context.read<ProfilesBloc>().add(
          pb.UpdateProfileRequest(
            profileUuid: widget.profile!.uuid,
            profileName: _profileNameController.text.trim().isNotEmpty 
                ? _profileNameController.text.trim() 
                : null,
            firstName: _firstNameController.text.trim().isNotEmpty 
                ? _firstNameController.text.trim() 
                : null,
            lastName: _lastNameController.text.trim().isNotEmpty 
                ? _lastNameController.text.trim() 
                : null,
            displayName: _displayNameController.text.trim().isNotEmpty 
                ? _displayNameController.text.trim() 
                : null,
            bio: _bioController.text.trim().isNotEmpty 
                ? _bioController.text.trim() 
                : null,
            avatarUrl: _avatarUrlController.text.trim().isNotEmpty 
                ? _avatarUrlController.text.trim() 
                : null,
            country: _countryController.text.trim().isNotEmpty 
                ? _countryController.text.trim() 
                : null,
            city: _cityController.text.trim().isNotEmpty 
                ? _cityController.text.trim() 
                : null,
            timezone: _timezoneController.text.trim().isNotEmpty 
                ? _timezoneController.text.trim() 
                : null,
            locale: _localeController.text.trim().isNotEmpty 
                ? _localeController.text.trim() 
                : null,
            websiteUrl: _websiteUrlController.text.trim().isNotEmpty 
                ? _websiteUrlController.text.trim() 
                : null,
          ),
        );
      } else {
        context.read<ProfilesBloc>().add(
          pb.CreateProfileRequest(
            userUuid: widget.userUuid,
            profileName: _profileNameController.text.trim().isNotEmpty 
                ? _profileNameController.text.trim() 
                : null,
            firstName: _firstNameController.text.trim().isNotEmpty 
                ? _firstNameController.text.trim() 
                : null,
            lastName: _lastNameController.text.trim().isNotEmpty 
                ? _lastNameController.text.trim() 
                : null,
            displayName: _displayNameController.text.trim().isNotEmpty 
                ? _displayNameController.text.trim() 
                : null,
            bio: _bioController.text.trim().isNotEmpty 
                ? _bioController.text.trim() 
                : null,
            avatarUrl: _avatarUrlController.text.trim().isNotEmpty 
                ? _avatarUrlController.text.trim() 
                : null,
            country: _countryController.text.trim().isNotEmpty 
                ? _countryController.text.trim() 
                : null,
            city: _cityController.text.trim().isNotEmpty 
                ? _cityController.text.trim() 
                : null,
            timezone: _timezoneController.text.trim().isNotEmpty 
                ? _timezoneController.text.trim() 
                : null,
            locale: _localeController.text.trim().isNotEmpty 
                ? _localeController.text.trim() 
                : null,
            websiteUrl: _websiteUrlController.text.trim().isNotEmpty 
                ? _websiteUrlController.text.trim() 
                : null,
          ),
        );
      }
      Navigator.of(context).pop();
    }
  }
}
