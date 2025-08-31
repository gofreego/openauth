import 'package:flutter/material.dart';

class PermissionsSearchBar extends StatelessWidget {
  final String searchQuery;
  final bool showSystemOnly;
  final bool showCustomOnly;
  final ValueChanged<String>? onSearchChanged;
  final ValueChanged<bool>? onSystemFilterChanged;
  final ValueChanged<bool>? onCustomFilterChanged;

  const PermissionsSearchBar({
    super.key,
    required this.searchQuery,
    required this.showSystemOnly,
    required this.showCustomOnly,
    this.onSearchChanged,
    this.onSystemFilterChanged,
    this.onCustomFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SearchBar(
            hintText: 'Search permissions...',
            leading: const Icon(Icons.search),
            onChanged: onSearchChanged,
          ),
        ),
        const SizedBox(width: 16),
        FilterChip(
          label: const Text('System'),
          selected: showSystemOnly,
          onSelected: onSystemFilterChanged,
        ),
        const SizedBox(width: 8),
        FilterChip(
          label: const Text('Custom'),
          selected: showCustomOnly,
          onSelected: onCustomFilterChanged,
        ),
      ],
    );
  }
}
