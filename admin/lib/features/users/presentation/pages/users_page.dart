import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:openauth/shared/widgets/custom_search_bar.dart';
import '../widgets/users_header.dart';
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
          CustomSearchBar(
            onSearch: (query) {
              setState(() {
                _searchQuery = query;
              });
              context.read<UsersBloc>().add(SearchUsersEvent(query));
            },
          ),
          const SizedBox(height: 24),

          // Users table
          Expanded(
            child: UsersTable(
              searchQuery: _searchQuery,
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
