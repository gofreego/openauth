import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:openauth/shared/widgets/widgets.dart';
import 'package:openauth/src/generated/openauth/v1/users.pb.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../shared/shared.dart';
import '../widgets/users_header.dart';
import '../widgets/users_table.dart';
import '../widgets/create_user_dialog.dart';
import '../bloc/users_bloc.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load users when the page is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UsersBloc>().add(ListUsersRequest(
        limit: PaginationConstants.defaultPageLimit,
        offset: 0,
      ));
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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

          // Enhanced search with ID support
          CustomSearchBar(
            initialQuery: _searchQuery,
            hintText: 'Search by name, mobile, email, username, ID, or UUID...',
            onSearch: (query) {
             _performSearch(query);
            },
            onClear: () {
              setState(() {
                _searchQuery = '';
              });
              context.read<UsersBloc>().add(ListUsersRequest(
                limit: PaginationConstants.defaultPageLimit,
                offset: 0,
              ));
            },
            onKeyStrokeChanged: (value) => {
              setState(() {
                _searchQuery = value;
              })
            },
          ),
          const SizedBox(height: 16),
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
          ToastUtils.showSuccess('User created successfully');
        },
      ),
    );
  }

  void _performSearch(String query) {
    final trimmedQuery = query.trim();
    
    setState(() {
      _searchQuery = trimmedQuery;
    });
    context.read<UsersBloc>().add(ListUsersRequest(
      limit: PaginationConstants.defaultPageLimit,
      offset: 0,
      search: trimmedQuery.isNotEmpty ? trimmedQuery : null,
    ));
  }
}
