import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:openauth/features/configs/data/repositories/configs_repository.dart';
import 'package:openauth/src/generated/openauth/v1/configs.pb.dart';
import 'package:protobuf/protobuf.dart';
import '../../../../core/constants/app_constants.dart';
import 'configs_state.dart';

class ConfigsBloc extends Bloc<GeneratedMessage, ConfigsState> {
  final ConfigsRepository repository;

  ConfigsBloc({
    required this.repository,
  }) : super(ConfigsInitial()) {
    on<ListConfigsRequest>(_onLoadConfigs);
    on<CreateConfigRequest>(_onCreateConfig);
    on<UpdateConfigRequest>(_onUpdateConfig);
    on<DeleteConfigRequest>(_onDeleteConfig);
    on<GetConfigsByKeysRequest>(_onGetConfigsByKeys);
  }

  Future<void> _onLoadConfigs(ListConfigsRequest event, Emitter<ConfigsState> emit) async {
    final currentState = state;
    final isLoadMore = event.hasOffset() && event.offset > 0;
    
    if (!isLoadMore) {
      emit(ConfigsLoading());
    } else if (currentState is ConfigsLoaded) {
      // Set loading more state
      emit(currentState.copyWith(isLoadingMore: true));
    }

    final result = await repository.getConfigs(event);
    
    result.fold(
      (failure) => emit(ConfigsListError(
        failure: failure,
        message: failure.message,
      )),
      (configs) {
        if (isLoadMore && currentState is ConfigsLoaded) {
          // Append new configs to existing ones
          final allConfigs = [...currentState.configs, ...configs];
          emit(ConfigsLoaded(
            configs: allConfigs,
            totalCount: currentState.totalCount + configs.length,
            hasReachedMax: configs.length < (event.hasLimit() ? event.limit : PaginationConstants.defaultPageLimit),
            isLoadingMore: false,
          ));
        } else {
          // Replace configs (first load or refresh)
          emit(ConfigsLoaded(
            configs: configs,
            totalCount: configs.length,
            hasReachedMax: configs.length < (event.hasLimit() ? event.limit : PaginationConstants.defaultPageLimit),
            isLoadingMore: false,
          ));
        }
      },
    );
  }

  Future<void> _onCreateConfig(CreateConfigRequest event, Emitter<ConfigsState> emit) async {
    final result = await repository.createConfig(event);
    
    result.fold(
      (failure) => emit(ConfigCreateError(
        failure: failure,
        message: failure.message,
      )),
      (config) => emit(ConfigCreated(config)),
    );
  }

  Future<void> _onUpdateConfig(UpdateConfigRequest event, Emitter<ConfigsState> emit) async {
    final result = await repository.updateConfig(event);
    
    result.fold(
      (failure) => emit(ConfigUpdateError(
        failure: failure,
        message: failure.message,
      )),
      (config) => emit(ConfigUpdated(config)),
    );
  }

  Future<void> _onDeleteConfig(DeleteConfigRequest event, Emitter<ConfigsState> emit) async {
    final result = await repository.deleteConfig(event);
    
    result.fold(
      (failure) => emit(ConfigDeleteError(
        failure: failure,
        message: failure.message,
      )),
      (_) => emit(ConfigDeleted()),
    );
  }

  Future<void> _onGetConfigsByKeys(GetConfigsByKeysRequest event, Emitter<ConfigsState> emit) async {
    final result = await repository.getConfigsByKeys(event);
    
    result.fold(
      (failure) => emit(ConfigsByKeysError(
        failure: failure,
        message: failure.message,
      )),
      (configs) => emit(ConfigsByKeysLoaded(configs)),
    );
  }
}
