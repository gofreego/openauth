import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../src/generated/openauth/v1/configs.pb.dart';
import '../../../../core/constants/app_constants.dart';
import '../bloc/config_entities_bloc.dart';
import '../bloc/config_entities_state.dart';
import 'config_entity_row.dart';
import 'edit_config_entity_dialog.dart';
import 'delete_config_entity_dialog.dart';
import '../../../../shared/widgets/error_widget.dart';

class ConfigEntitiesTable extends StatefulWidget {
  const ConfigEntitiesTable({super.key});

  @override
  State<ConfigEntitiesTable> createState() => _ConfigEntitiesTableState();
}

class _ConfigEntitiesTableState extends State<ConfigEntitiesTable> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      final state = context.read<ConfigEntitiesBloc>().state;
      if (state is ConfigEntitiesLoaded && !state.hasReachedMax && !state.isLoadingMore) {
        context.read<ConfigEntitiesBloc>().add(ListConfigEntitiesRequest(
          limit: PaginationConstants.defaultPageLimit,
          offset: state.entities.length,
        ));
      }
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      margin: EdgeInsets.zero,
      child: Column(
        children: [
          // Table header
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
               
                Expanded(
                  flex: 2,
                  child: Text(
                    'Display Name',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    'Description',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Configs',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 48), // For actions
              ],
            ),
          ),
          // Table content
          Expanded(
            child: BlocConsumer<ConfigEntitiesBloc, ConfigEntitiesState>(
              listener: (context, state) {
                if (state is ConfigEntityCreated) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Config entity created successfully')),
                  );
                  // Refresh the list
                  context.read<ConfigEntitiesBloc>().add(ListConfigEntitiesRequest(
                    limit: PaginationConstants.defaultPageLimit,
                    offset: 0,
                  ));
                } else if (state is ConfigEntityUpdated) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Config entity updated successfully')),
                  );
                  // Refresh the list
                  context.read<ConfigEntitiesBloc>().add(ListConfigEntitiesRequest(
                    limit: PaginationConstants.defaultPageLimit,
                    offset: 0,
                  ));
                } else if (state is ConfigEntityDeleted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Config entity deleted successfully')),
                  );
                  // Refresh the list
                  context.read<ConfigEntitiesBloc>().add(ListConfigEntitiesRequest(
                    limit: PaginationConstants.defaultPageLimit,
                    offset: 0,
                  ));
                } else if (state is ConfigEntitiesListError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error loading entities: ${state.message}')),
                  );
                } else if (state is ConfigEntityCreateError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error creating entity: ${state.message}')),
                  );
                } else if (state is ConfigEntityUpdateError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error updating entity: ${state.message}')),
                  );
                } else if (state is ConfigEntityDeleteError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error deleting entity: ${state.message}')),
                  );
                }
              },
              builder: (context, state) {
                if (state is ConfigEntitiesLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                
                if (state is ConfigEntitiesLoaded) {
                  if (state.entities.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.settings_outlined,
                            size: 64,
                            color: theme.colorScheme.outline,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No config entities found',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Create your first config entity to get started',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    controller: _scrollController,
                    itemCount: state.entities.length + (state.isLoadingMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index >= state.entities.length) {
                        return const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }

                      final entity = state.entities[index];
                      return ConfigEntityRow(
                        entity: entity,
                        onEdit: () => _showEditDialog(context, entity),
                        onDelete: () => _showDeleteDialog(context, entity),
                      );
                    },
                  );
                }
                
                if (state is ConfigEntitiesListError) {
                  return CustomErrorWidget(
                    failure: state.failure,
                    onRetry: () {
                      context.read<ConfigEntitiesBloc>().add(ListConfigEntitiesRequest(
                        limit: PaginationConstants.defaultPageLimit,
                        offset: 0,
                      ));
                    },
                  );
                }
                
                return const Center(
                  child: Text('Unknown state'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context, ConfigEntity entity) {
    EditConfigEntityDialog.show(context, entity);
  }

  void _showDeleteDialog(BuildContext context, ConfigEntity entity) {
    DeleteConfigEntityDialog.show(context, entity);
  }
}
