import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';
import 'package:openauth/shared/utils/toast_utils.dart';
import 'package:openauth/shared/widgets/widgets.dart';
import 'package:openauth/src/generated/openauth/v1/permissions.pbserver.dart';
import '../../../../core/constants/app_constants.dart';
import '../bloc/permissions_bloc.dart';
import '../widgets/permissions_header.dart';
import '../widgets/permissions_grid.dart';
import '../widgets/create_permission_dialog.dart';

class PermissionsPage extends StatefulWidget {
  const PermissionsPage({super.key});

  @override
  State<PermissionsPage> createState() => _PermissionsPageState();
}

class _PermissionsPageState extends State<PermissionsPage> {
  String _searchQuery = '';
  Timer? _debounceTimer;
  static const Duration _debounceDuration = Duration(milliseconds: 500);

  @override
  void initState() {
    super.initState();
    // Load permissions when the page is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PermissionsBloc>().add(ListPermissionsRequest(
        limit: PaginationConstants.defaultPageLimit,
        offset: 0,
      ));
    });
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _buildPermissionsContent();
  }

  Widget _buildPermissionsContent() {
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
            CustomSearchBar(
              showSearchIcon: true,
              onSearch: (query) {
                setState(() {
                  _searchQuery = query;
                });
                
                // Cancel any existing timer
                _debounceTimer?.cancel();
                
                // Start a new timer for debouncing
                _debounceTimer = Timer(_debounceDuration, () {
                  if (mounted) {
                    final bloc = context.read<PermissionsBloc>();
                    if (!bloc.isClosed) {
                      bloc.add(ListPermissionsRequest(
                        search: query.isNotEmpty ? query : null,
                        limit: PaginationConstants.defaultPageLimit,
                        offset: 0,
                      ));
                    }
                  }
                });
              },
            ),
            const SizedBox(height: 24),

            // Permissions grid with API integration
            Expanded(
              child: BlocConsumer<PermissionsBloc, PermissionsState>(
                listener: (context, state) {
                  if (state is PermissionError) {
                    ToastUtils.showError(state.message);
                  } else if (state is PermissionCreated) {
                    ToastUtils.showSuccess('Permission created successfully');
                  } else if (state is PermissionUpdated) {
                    ToastUtils.showSuccess('Permission updated successfully');
                  } else if (state is PermissionDeleted) {
                    ToastUtils.showSuccess('Permission deleted successfully');
                  }
                },
                builder: (context, state) {
                  if (state is PermissionsLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is PermissionsLoaded) {
                    return PermissionsGrid(
                      permissions: state.permissions,
                      searchQuery: _searchQuery,
                      hasReachedMax: state.hasReachedMax,
                      isLoadingMore: state.isLoadingMore,
                      onLoadMore: () {
                        if (mounted && !state.hasReachedMax && !state.isLoadingMore) {
                          final bloc = context.read<PermissionsBloc>();
                          if (!bloc.isClosed) {
                            final nextOffset = state.permissions.length;
                            bloc.add(ListPermissionsRequest(
                              limit: PaginationConstants.defaultPageLimit, 
                              offset: nextOffset,
                              search: _searchQuery.isNotEmpty ? _searchQuery : null,
                            ));
                          }
                        }
                      },
                    );
                  } else if (state is PermissionsError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 64,
                            color: Colors.red.shade300,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Error loading permissions',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            state.message,
                            style: Theme.of(context).textTheme.bodyMedium,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              if (mounted) {
                                final bloc = context.read<PermissionsBloc>();
                                if (!bloc.isClosed) {
                                  bloc.add(ListPermissionsRequest(
                                    limit: PaginationConstants.defaultPageLimit,
                                    offset: 0,
                                    search: _searchQuery.isNotEmpty ? _searchQuery : null,
                                  ));
                                }
                              }
                            },
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }
                  // Initial state or other states
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
          ],
        ),
      );
    }

    void _showCreatePermissionDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: context.read<PermissionsBloc>(),
        child: CreatePermissionDialog(
          onPermissionCreated: () {
            // The BlocConsumer above will handle the success message
          },
        ),
      ),
    );
  }
}
