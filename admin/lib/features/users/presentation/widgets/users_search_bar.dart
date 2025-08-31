import 'package:flutter/material.dart';

class UsersSearchBar extends StatelessWidget {
  final String searchQuery;
  final bool showActiveOnly;
  final bool showInactiveOnly;
  final ValueChanged<String>? onSearchChanged;
  final ValueChanged<bool>? onActiveFilterChanged;
  final ValueChanged<bool>? onInactiveFilterChanged;

  const UsersSearchBar({
    super.key,
    required this.searchQuery,
    required this.showActiveOnly,
    required this.showInactiveOnly,
    this.onSearchChanged,
    this.onActiveFilterChanged,
    this.onInactiveFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SearchBar(
            hintText: 'Search users...',
            leading: const Icon(Icons.search),
            onChanged: onSearchChanged,
          ),
        ),
        const SizedBox(width: 16),
        FilterChip(
          label: const Text('Active'),
          selected: showActiveOnly,
          onSelected: onActiveFilterChanged,
        ),
        const SizedBox(width: 8),
        FilterChip(
          label: const Text('Inactive'),
          selected: showInactiveOnly,
          onSelected: onInactiveFilterChanged,
        ),
      ],
    );
  }
}
