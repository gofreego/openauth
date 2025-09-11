import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:openauth/features/configs/data/repositories/configs_repository.dart';
import 'package:openauth/src/generated/openauth/v1/configs.pb.dart';
import 'package:protobuf/protobuf.dart';
import '../../../../core/constants/app_constants.dart';
import 'config_entities_state.dart';

class ConfigEntitiesBloc extends Bloc<GeneratedMessage, ConfigEntitiesState> {
  final ConfigsRepository repository;

  ConfigEntitiesBloc({
    required this.repository,
  }) : super(ConfigEntitiesInitial()) {
    on<ListConfigEntitiesRequest>(_onLoadConfigEntities);
    on<CreateConfigEntityRequest>(_onCreateConfigEntity);
    on<UpdateConfigEntityRequest>(_onUpdateConfigEntity);
    on<DeleteConfigEntityRequest>(_onDeleteConfigEntity);
  }

  Future<void> _onLoadConfigEntities(ListConfigEntitiesRequest event, Emitter<ConfigEntitiesState> emit) async {
    final currentState = state;
    final isLoadMore = event.hasOffset() && event.offset > 0;
    
    if (!isLoadMore) {
      emit(ConfigEntitiesLoading());
    } else if (currentState is ConfigEntitiesLoaded) {
      // Set loading more state
      emit(currentState.copyWith(isLoadingMore: true));
    }

    final result = await repository.getConfigEntities(event);
    
    result.fold(
      (failure) => emit(ConfigEntitiesListError(
        failure: failure,
        message: failure.message,
      )),
      (entities) {
        if (isLoadMore && currentState is ConfigEntitiesLoaded) {
          // Append new entities to existing ones
          final allEntities = [...currentState.entities, ...entities];
          emit(ConfigEntitiesLoaded(
            entities: allEntities,
            hasReachedMax: entities.length < (event.hasLimit() ? event.limit : PaginationConstants.defaultPageLimit),
            isLoadingMore: false,
          ));
        } else {
          // Replace entities (first load or refresh)
          emit(ConfigEntitiesLoaded(
            entities: entities,
            hasReachedMax: entities.length < (event.hasLimit() ? event.limit : PaginationConstants.defaultPageLimit),
            isLoadingMore: false,
          ));
        }
      },
    );
  }

  Future<void> _onCreateConfigEntity(CreateConfigEntityRequest event, Emitter<ConfigEntitiesState> emit) async {
    final result = await repository.createConfigEntity(event);
    
    result.fold(
      (failure) => emit(ConfigEntityCreateError(
        failure: failure,
        message: failure.message,
      )),
      (entity) => emit(ConfigEntityCreated(entity)),
    );
  }

  Future<void> _onUpdateConfigEntity(UpdateConfigEntityRequest event, Emitter<ConfigEntitiesState> emit) async {
    final result = await repository.updateConfigEntity(event);
    
    result.fold(
      (failure) => emit(ConfigEntityUpdateError(
        failure: failure,
        message: failure.message,
      )),
      (entity) => emit(ConfigEntityUpdated(entity)),
    );
  }

  Future<void> _onDeleteConfigEntity(DeleteConfigEntityRequest event, Emitter<ConfigEntitiesState> emit) async {
    final result = await repository.deleteConfigEntity(event);
    
    result.fold(
      (failure) => emit(ConfigEntityDeleteError(
        failure: failure,
        message: failure.message,
      )),
      (_) => emit(ConfigEntityDeleted()),
    );
  }
}
