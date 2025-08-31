import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/users_header.dart';
import '../widgets/users_search_bar.dart';
import '../widgets/users_table.dart';
import '../widgets/create_user_dialog.dart';
import '../bloc/users_bloc.dart';
import '../bloc/users_event.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  String _searchQuery = '';
  bool _showActiveOnly = false;
  bool _showInactiveOnly = false;

  @override
  void initState() {
    super.initState();
    // Load users when the page is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UsersBloc>().add(const LoadUsersEvent());
    });
  }

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
              context.read<UsersBloc>().add(SearchUsersEvent(query));
            },
            onActiveFilterChanged: (value) {
              setState(() {
                _showActiveOnly = value;
                if (value) _showInactiveOnly = false;
              });
              _updateFilter();
            },
            onInactiveFilterChanged: (value) {
              setState(() {
                _showInactiveOnly = value;
                if (value) _showActiveOnly = false;
              });
              _updateFilter();
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

  void _updateFilter() {
    bool? filterValue;
    if (_showActiveOnly) {
      filterValue = true;
    } else if (_showInactiveOnly) {
      filterValue = false;
    }
    context.read<UsersBloc>().add(FilterUsersEvent(filterValue));
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
