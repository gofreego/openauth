import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:openauth/shared/utils/utility_functions.dart';
import 'package:openauth/shared/widgets/widgets.dart';
import 'package:openauth/src/generated/openauth/v1/users.pb.dart';
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
      context.read<UsersBloc>().add(ListUsersRequest());
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
              context.read<UsersBloc>().add(ListUsersRequest());
            },
            onKeyStrokeChanged: (value) => {
              setState(() {
                _searchQuery = value;
              })
            },
          ),
          const SizedBox(height: 16),
          
          // Search info and results
          if (_searchQuery.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                border: Border.all(color: Colors.blue.shade200),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.blue.shade600, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _getSearchInfo(_searchQuery),
                      style: TextStyle(
                        color: Colors.blue.shade600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
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
    context.read<UsersBloc>().add(ListUsersRequest());
  }

  

  String _getSearchInfo(String query) {
    if (query.isEmpty) return '';
    
// Check if it looks like a mobile number
    if (UtilityFunctions.isMobile(query)) {
      return 'Searching by mobile: $query, if you are searching by id then add id:$query';
    }

    // Check if it has id: prefix
    if (UtilityFunctions.isNumber(query) || query.startsWith("id:") && UtilityFunctions.isNumber(query.replaceAll("id:", ""))) {
      return 'Searching by ID: ${query.replaceAll("id:", "")}';
    }

    // Check if it looks like a UUID
    if (UtilityFunctions.isUUID(query)) {
      return 'Searching by UUID: $query';
    }
    
    // Check if it looks like an email
    if (RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(query)) {
      return 'Searching by email: $query';
    }
    
    // Default to general search
    return 'Searching for: $query (name, username, email, or ID)';
  }
}
