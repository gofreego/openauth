import 'package:flutter/material.dart';
import '../../../../shared/widgets/custom_search_bar.dart';

class UsersSearchBar extends StatefulWidget {
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
  State<UsersSearchBar> createState() => _UsersSearchBarState();
}

class _UsersSearchBarState extends State<UsersSearchBar> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.searchQuery);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch(String query) {
    widget.onSearchChanged?.call(query);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: CustomSearchBar(
              controller: _searchController,
              hintText: 'Search users...',
              onSearch: _performSearch,
            ),
          ),
          const SizedBox(width: 16),
          FilterChip(
            label: const Text('Active'),
            selected: widget.showActiveOnly,
            onSelected: widget.onActiveFilterChanged,
          ),
          const SizedBox(width: 8),
          FilterChip(
            label: const Text('Inactive'),
            selected: widget.showInactiveOnly,
            onSelected: widget.onInactiveFilterChanged,
          ),
        ],
      ),
    );
  }
}
