import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:openauth/shared/widgets/widgets.dart';
import 'package:openauth/shared/utils/toast_utils.dart';
import 'package:openauth/src/generated/openauth/v1/configs.pb.dart';
import '../../../../core/constants/app_constants.dart';
import '../bloc/config_entities_bloc.dart';
import '../bloc/config_entities_state.dart';

class ConfigEntitiesTab extends StatefulWidget {
  final String searchQuery;

  const ConfigEntitiesTab({
    super.key,
    required this.searchQuery,
  });

  @override
  State<ConfigEntitiesTab> createState() => _ConfigEntitiesTabState();
}

class _ConfigEntitiesTabState extends State<ConfigEntitiesTab> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ConfigEntitiesBloc, ConfigEntitiesState>(
      listener: (context, state) {
        if (state is ConfigEntitiesError) {
          ToastUtils.showError(state.message);
        } else if (state is ConfigEntityCreated) {
          ToastUtils.showSuccess('Config entity created successfully');
          // Refresh the list
          context.read<ConfigEntitiesBloc>().add(ListConfigEntitiesRequest(
            limit: PaginationConstants.defaultPageLimit,
            offset: 0,
            search: widget.searchQuery.isNotEmpty ? widget.searchQuery : null,
          ));
        } else if (state is ConfigEntityUpdated) {
          ToastUtils.showSuccess('Config entity updated successfully');
          // Refresh the list
          context.read<ConfigEntitiesBloc>().add(ListConfigEntitiesRequest(
            limit: PaginationConstants.defaultPageLimit,
            offset: 0,
            search: widget.searchQuery.isNotEmpty ? widget.searchQuery : null,
          ));
        } else if (state is ConfigEntityDeleted) {
          ToastUtils.showSuccess('Config entity deleted successfully');
          // Refresh the list
          context.read<ConfigEntitiesBloc>().add(ListConfigEntitiesRequest(
            limit: PaginationConstants.defaultPageLimit,
            offset: 0,
            search: widget.searchQuery.isNotEmpty ? widget.searchQuery : null,
          ));
        }
      },
      builder: (context, state) {
        if (state is ConfigEntitiesLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ConfigEntitiesLoaded) {
          return _buildConfigEntitiesList(state);
        } else if (state is ConfigEntitiesError) {
          return Center(
            child: CustomErrorWidget(
              failure: state.failure,
              onRetry: () {
                context.read<ConfigEntitiesBloc>().add(ListConfigEntitiesRequest(
                  limit: PaginationConstants.defaultPageLimit,
                  offset: 0,
                  search: widget.searchQuery.isNotEmpty ? widget.searchQuery : null,
                ));
              },
            ),
          );
        }
        // Initial state
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _buildConfigEntitiesList(ConfigEntitiesLoaded state) {
    if (state.entities.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.category_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              widget.searchQuery.isEmpty
                  ? 'No config entities found'
                  : 'No config entities match your search',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              widget.searchQuery.isEmpty
                  ? 'Create your first config entity to get started'
                  : 'Try adjusting your search query',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: state.entities.length + (state.isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= state.entities.length) {
          // Loading indicator for load more
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: CircularProgressIndicator(),
            ),
          );
        }

        final entity = state.entities[index];
        return _buildConfigEntityCard(entity);
      },
    );
  }

  Widget _buildConfigEntityCard(ConfigEntity entity) {
    final theme = Theme.of(context);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.1),
          child: Icon(
            Icons.category,
            color: theme.colorScheme.primary,
          ),
        ),
        title: Text(
          entity.displayName.isNotEmpty ? entity.displayName : entity.name,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (entity.description.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                entity.description,
                style: theme.textTheme.bodySmall,
              ),
            ],
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.fingerprint,
                  size: 14,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 4),
                Text(
                  'ID: ${entity.name}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                    fontFamily: 'monospace',
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            switch (value) {
              case 'edit':
                // TODO: Implement edit dialog
                break;
              case 'delete':
                _showDeleteConfirmation(entity);
                break;
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'edit',
              child: ListTile(
                leading: Icon(Icons.edit),
                title: Text('Edit'),
                dense: true,
              ),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: ListTile(
                leading: Icon(Icons.delete, color: Colors.red),
                title: Text('Delete', style: TextStyle(color: Colors.red)),
                dense: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(ConfigEntity entity) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Config Entity'),
        content: Text(
          'Are you sure you want to delete "${entity.displayName.isNotEmpty ? entity.displayName : entity.name}"?\n\n'
          'This action cannot be undone and will also delete all associated configurations.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<ConfigEntitiesBloc>().add(
                DeleteConfigEntityRequest(id: entity.id),
              );
            },
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
