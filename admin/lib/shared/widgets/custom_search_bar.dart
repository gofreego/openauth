import 'package:flutter/material.dart';

/// A reusable search bar widget with consistent styling across the app
class CustomSearchBar extends StatefulWidget {
  /// The initial search query
  final String initialQuery;
  
  /// Placeholder text for the search input
  final String hintText;
  
  /// Callback when search is triggered (click or Enter key)
  final ValueChanged<String>? onSearch;

  final VoidCallback? onClear;
  
  /// Optional controller for external control
  
  /// Whether to show the search icon on the right side
  final bool showSearchIcon;
  
  /// Custom width for the search bar
  final double? width;
  
  /// Whether to call onSearch on each keystroke
  final bool triggerSearchOnKeyStroke;

  final ValueChanged<String>? onKeyStrokeChanged;

  const CustomSearchBar({
    super.key,
    this.initialQuery = '',
    this.hintText = 'Search...',
    this.onSearch,
    this.showSearchIcon = true,
    this.width,
    this.triggerSearchOnKeyStroke = false,
    this.onKeyStrokeChanged,
    this.onClear,
  });

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller =  TextEditingController(text: widget.initialQuery);
  }

  @override
  void dispose() {
     _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: widget.hintText,
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _controller.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _controller.clear();
                              widget.onClear?.call();
                            },
                          )
                        : null,
                    border: const OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                      if (widget.triggerSearchOnKeyStroke) {
                        widget.onSearch?.call(_controller.text);
                      }
                      widget.onKeyStrokeChanged?.call(_controller.text);
                  },
                  onSubmitted: (value) => widget.onSearch?.call(value),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                onPressed: () => widget.onSearch?.call(_controller.text),
                // icon: const Icon(Icons.search),
                label: const Text('Search'),
              ),
            ],
          );
  }
}
