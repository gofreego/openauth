import 'package:flutter/material.dart';
import '../widgets/users_header.dart';
import '../widgets/users_search_bar.dart';
import '../widgets/users_table.dart';
import '../widgets/create_user_dialog.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  String _searchQuery = '';
  bool _showActiveOnly = true;
  bool _showInactiveOnly = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          UsersHeader(
            onAddUser: _showCreateUserDialog,
          ),
          const SizedBox(height: 32),

          // Search and filters
          UsersSearchBar(
            searchQuery: _searchQuery,
            showActiveOnly: _showActiveOnly,
            showInactiveOnly: _showInactiveOnly,
            onSearchChanged: (query) {
              setState(() {
                _searchQuery = query;
              });
            },
            onActiveFilterChanged: (value) {
              setState(() {
                _showActiveOnly = value;
              });
            },
            onInactiveFilterChanged: (value) {
              setState(() {
                _showInactiveOnly = value;
              });
            },
          ),
          const SizedBox(height: 24),

          // Users table
          Expanded(
            child: UsersTable(
              searchQuery: _searchQuery,
              showActiveOnly: _showActiveOnly,
              showInactiveOnly: _showInactiveOnly,
            ),
          ),
        ],
      ),
    );
  }

  void _showCreateUserDialog() {
    showDialog(
      context: context,
      builder: (context) => CreateUserDialog(
        onUserCreated: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User created successfully')),
          );
        },
      ),
    );
  }
}
