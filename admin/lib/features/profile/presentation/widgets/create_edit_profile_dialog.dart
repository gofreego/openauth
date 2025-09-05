import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fixnum/fixnum.dart';
import 'package:openauth/src/generated/openauth/v1/users.pb.dart' as pb;
import '../bloc/profiles_bloc.dart';
import '../bloc/profiles_state.dart';

class CreateEditProfileDialog extends StatefulWidget {
  final String userUuid;
  final pb.UserProfile? profile;
  final bool isViewMode;

  const CreateEditProfileDialog({
    super.key,
    required this.userUuid,
    this.profile,
    this.isViewMode = false,
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
  late final TextEditingController _genderController;
  late final TextEditingController _addressController;
  late final TextEditingController _postalCodeController;
  
  DateTime? _selectedDateOfBirth;
  late bool _isCurrentlyInViewMode;

  bool get isEditing => widget.profile != null;
  bool get isCreating => widget.profile == null;

  @override
  void initState() {
    super.initState();
    _isCurrentlyInViewMode = widget.isViewMode && widget.profile != null;
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
    _genderController = TextEditingController(text: profile?.gender ?? '');
    _addressController = TextEditingController(text: profile?.address ?? '');
    _postalCodeController = TextEditingController(text: profile?.postalCode ?? '');
    
    // Handle date of birth - convert from timestamp if it exists
    if (profile?.dateOfBirth != null && profile!.dateOfBirth.toInt() > 0) {
      _selectedDateOfBirth = DateTime.fromMillisecondsSinceEpoch(profile.dateOfBirth.toInt() * 1000);
    }
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
    _genderController.dispose();
    _addressController.dispose();
    _postalCodeController.dispose();
    super.dispose();
  }

  void _toggleEditMode() {
    setState(() {
      _isCurrentlyInViewMode = !_isCurrentlyInViewMode;
    });
  }

  String get _dialogTitle {
    if (isCreating) return 'Create Profile';
    if (_isCurrentlyInViewMode) return 'View Profile';
    return 'Edit Profile';
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final dialogWidth = screenWidth * 0.6 < 600 ? 600.0 : screenWidth * 0.6 > 700 ? 700.0 : screenWidth * 0.6;
    
    return BlocListener<ProfilesBloc, ProfilesState>(
      listener: (context, state) {
        if (state is ProfileCreated || state is ProfileUpdated) {
          Navigator.of(context).pop();
        }
      },
      child: AlertDialog(
        title: Text(_dialogTitle),
        content: ConstrainedBox(
          constraints: const BoxConstraints(
            minWidth: 600,
            maxWidth: 700,
            maxHeight: 750,
          ),
          child: SizedBox(
            width: dialogWidth,
            child: Form(
              key: _formKey,
            child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 8),
                TextFormField(
                  controller: _profileNameController,
                  readOnly: _isCurrentlyInViewMode,
                  decoration: const InputDecoration(
                    labelText: 'Profile Name *',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.badge_outlined),
                  ),
                  validator: (value) {
                    if (!_isCurrentlyInViewMode && (value == null || value.trim().isEmpty)) {
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
                        readOnly: _isCurrentlyInViewMode,
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
                        readOnly: _isCurrentlyInViewMode,
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
                  readOnly: _isCurrentlyInViewMode,
                  decoration: const InputDecoration(
                    labelText: 'Display Name',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.display_settings_outlined),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _bioController,
                  readOnly: _isCurrentlyInViewMode,
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
                  readOnly: _isCurrentlyInViewMode,
                  decoration: const InputDecoration(
                    labelText: 'Avatar URL',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.image_outlined),
                  ),
                ),
                const SizedBox(height: 16),
                // Date of Birth picker
                InkWell(
                  onTap: _isCurrentlyInViewMode ? null : () => _selectDateOfBirth(context),
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Date of Birth',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.cake_outlined),
                    ),
                    child: Text(
                      _selectedDateOfBirth != null
                          ? '${_selectedDateOfBirth!.day}/${_selectedDateOfBirth!.month}/${_selectedDateOfBirth!.year}'
                          : 'Select date of birth',
                      style: TextStyle(
                        color: _selectedDateOfBirth != null 
                            ? Theme.of(context).textTheme.bodyLarge?.color
                            : Theme.of(context).hintColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Gender field
                TextFormField(
                  controller: _genderController,
                  readOnly: _isCurrentlyInViewMode,
                  decoration: const InputDecoration(
                    labelText: 'Gender',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person_4_outlined),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _countryController,
                        readOnly: _isCurrentlyInViewMode,
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
                        readOnly: _isCurrentlyInViewMode,
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
                // Address field
                TextFormField(
                  controller: _addressController,
                  readOnly: _isCurrentlyInViewMode,
                  decoration: const InputDecoration(
                    labelText: 'Address',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.home_outlined),
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 16),
                // Postal Code field
                TextFormField(
                  controller: _postalCodeController,
                  readOnly: _isCurrentlyInViewMode,
                  decoration: const InputDecoration(
                    labelText: 'Postal Code',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.local_post_office_outlined),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _timezoneController,
                        readOnly: _isCurrentlyInViewMode,
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
                        readOnly: _isCurrentlyInViewMode,
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
                  readOnly: _isCurrentlyInViewMode,
                  decoration: const InputDecoration(
                    labelText: 'Website URL',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.link_outlined),
                  ),
                  validator: (value) {
                    if (value != null && value.isNotEmpty) {
                      final urlPattern = RegExp(
                          r'^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$');
                      if (!urlPattern.hasMatch(value)) {
                        return 'Please enter a valid URL';
                      }
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(_isCurrentlyInViewMode ? 'Close' : 'Cancel'),
        ),
        if (_isCurrentlyInViewMode) ...[
          FilledButton.icon(
            onPressed: _toggleEditMode,
            icon: const Icon(Icons.edit, size: 16),
            label: const Text('Edit'),
          ),
        ] else ...[
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
                    : Text(isCreating ? 'Create' : 'Update'),
              );
            },
          ),
        ],
      ],
      ),
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
            dateOfBirth: _selectedDateOfBirth != null 
                ? Int64(_selectedDateOfBirth!.millisecondsSinceEpoch ~/ 1000)
                : null,
            gender: _genderController.text.trim().isNotEmpty 
                ? _genderController.text.trim() 
                : null,
            address: _addressController.text.trim().isNotEmpty 
                ? _addressController.text.trim() 
                : null,
            postalCode: _postalCodeController.text.trim().isNotEmpty 
                ? _postalCodeController.text.trim() 
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
            dateOfBirth: _selectedDateOfBirth != null 
                ? Int64(_selectedDateOfBirth!.millisecondsSinceEpoch ~/ 1000)
                : null,
            gender: _genderController.text.trim().isNotEmpty 
                ? _genderController.text.trim() 
                : null,
            address: _addressController.text.trim().isNotEmpty 
                ? _addressController.text.trim() 
                : null,
            postalCode: _postalCodeController.text.trim().isNotEmpty 
                ? _postalCodeController.text.trim() 
                : null,
          ),
        );
      }
    }
  }

  Future<void> _selectDateOfBirth(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDateOfBirth ?? DateTime.now().subtract(const Duration(days: 365 * 25)), // Default to 25 years ago
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDateOfBirth) {
      setState(() {
        _selectedDateOfBirth = picked;
      });
    }
  }
}
