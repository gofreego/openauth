import 'package:flutter/material.dart';

/// A reusable search bar widget with consistent styling across the app
class CustomSearchBar extends StatefulWidget {
  /// The initial search query
  final String initialQuery;
  
  /// Placeholder text for the search input
  final String hintText;
  
  /// Callback when search is triggered (click or Enter key)
  final ValueChanged<String>? onSearch;
  
  /// Optional controller for external control
  final TextEditingController? controller;
  
  /// Whether to show the search icon on the right side
  final bool showSearchIcon;
  
  /// Custom width for the search bar
  final double? width;
  
  /// Whether to call onSearch on each keystroke
  final bool onKeyStroke;

  const CustomSearchBar({
    super.key,
    this.initialQuery = '',
    this.hintText = 'Search...',
    this.onSearch,
    this.controller,
    this.showSearchIcon = true,
    this.width,
    this.onKeyStroke = false,
  });

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  late final TextEditingController _controller;
  late final bool _isControllerProvided;

  @override
  void initState() {
    super.initState();
    _isControllerProvided = widget.controller != null;
    _controller = widget.controller ?? TextEditingController(text: widget.initialQuery);
  }

  @override
  void dispose() {
    // Only dispose the controller if we created it internally
    if (!_isControllerProvided) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _performSearch() {
    widget.onSearch?.call(_controller.text);
  }

  @override
  Widget build(BuildContext context) {
    final searchBar = TextField(
      controller: _controller,
      decoration: InputDecoration(
        hintText: widget.hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 2,
          ),
        ),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        suffixIcon: widget.showSearchIcon
            ? IconButton(
                icon: const Icon(Icons.search, size: 20),
                onPressed: _performSearch,
                tooltip: 'Search',
                iconSize: 20,
              )
            : null,
      ),
      onSubmitted: (_) => _performSearch(),
      onChanged: widget.onKeyStroke ? (value) => widget.onSearch?.call(value) : null,
    );

    return widget.width != null 
        ? SizedBox(width: widget.width, child: searchBar)
        : searchBar;
  }
}
