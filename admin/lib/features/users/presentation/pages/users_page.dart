import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:openauth/shared/widgets/widgets.dart';
import 'package:openauth/src/generated/openauth/v1/users.pb.dart';
import '../../../../core/constants/app_constants.dart';
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
            onAddUser: () {
              CreateUserDialog.show(context);
            },
          ),
          const SizedBox(height: 32),

          // Enhanced search with ID support
          CustomSearchBar(
            hintText: 'Search by name, mobile, email, username, ID, or UUID...',
            onSearch: (query) {
             _performSearch(query);
            },
            onClear: () {
              context.read<UsersBloc>().add(ListUsersRequest(
                limit: PaginationConstants.defaultPageLimit,
                offset: 0,
              ));
            },
          ),
          const SizedBox(height: 16),
          // Users table
          const Expanded(
            child: UsersTable(),
          ),
        ],
      ),
    );
  }

  void _performSearch(String query) {
    final trimmedQuery = query.trim();
    context.read<UsersBloc>().add(ListUsersRequest(
      limit: PaginationConstants.defaultPageLimit,
      offset: 0,
      search: trimmedQuery.isNotEmpty ? trimmedQuery : null,
    ));
  }
}
