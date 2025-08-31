import 'package:flutter/material.dart';
import '../widgets/permissions_header.dart';
import '../widgets/permissions_search_bar.dart';
import '../widgets/permissions_grid.dart';
import '../widgets/create_permission_dialog.dart';

class PermissionsPage extends StatefulWidget {
  const PermissionsPage({super.key});

  @override
  State<PermissionsPage> createState() => _PermissionsPageState();
}

class _PermissionsPageState extends State<PermissionsPage> {
  String _searchQuery = '';
  bool _showSystemOnly = true;
  bool _showCustomOnly = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          PermissionsHeader(
            onAddPermission: _showCreatePermissionDialog,
          ),
          const SizedBox(height: 32),

          // Search and filters
          PermissionsSearchBar(
            searchQuery: _searchQuery,
            showSystemOnly: _showSystemOnly,
            showCustomOnly: _showCustomOnly,
            onSearchChanged: (query) {
              setState(() {
                _searchQuery = query;
              });
            },
            onSystemFilterChanged: (value) {
              setState(() {
                _showSystemOnly = value;
              });
            },
            onCustomFilterChanged: (value) {
              setState(() {
                _showCustomOnly = value;
              });
            },
          ),
          const SizedBox(height: 24),

          // Permissions grid
          Expanded(
            child: PermissionsGrid(
              searchQuery: _searchQuery,
              showSystemOnly: _showSystemOnly,
              showCustomOnly: _showCustomOnly,
            ),
          ),
        ],
      ),
    );
  }

  void _showCreatePermissionDialog() {
    showDialog(
      context: context,
      builder: (context) => CreatePermissionDialog(
        onPermissionCreated: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Permission created successfully')),
          );
        },
      ),
    );
  }
}
