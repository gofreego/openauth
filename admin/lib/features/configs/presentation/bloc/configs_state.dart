import 'package:equatable/equatable.dart';
import '../../../../src/generated/openauth/v1/configs.pb.dart';
import '../../../../core/errors/failures.dart';

abstract class ConfigsState extends Equatable {
  const ConfigsState();

  @override
  List<Object?> get props => [];
}

class ConfigsInitial extends ConfigsState {}

class ConfigsLoading extends ConfigsState {}

class ConfigsLoaded extends ConfigsState {
  final List<Config> configs;
  final int totalCount;
  final bool hasReachedMax;
  final bool isLoadingMore;

  const ConfigsLoaded({
    required this.configs,
    this.totalCount = 0,
    this.hasReachedMax = false,
    this.isLoadingMore = false,
  });

  ConfigsLoaded copyWith({
    List<Config>? configs,
    int? totalCount,
    bool? hasReachedMax,
    bool? isLoadingMore,
  }) {
    return ConfigsLoaded(
      configs: configs ?? this.configs,
      totalCount: totalCount ?? this.totalCount,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object?> get props => [configs, totalCount, hasReachedMax, isLoadingMore];
}

class ConfigCreated extends ConfigsState {
  final Config config;

  const ConfigCreated(this.config);

  @override
  List<Object> get props => [config];
}

class ConfigUpdated extends ConfigsState {
  final Config config;

  const ConfigUpdated(this.config);

  @override
  List<Object> get props => [config];
}

class ConfigDeleted extends ConfigsState {}

class ConfigsByKeysLoaded extends ConfigsState {
  final Map<String, Config> configs;

  const ConfigsByKeysLoaded(this.configs);

  @override
  List<Object> get props => [configs];
}

class ConfigsError extends ConfigsState {
  final Failure failure;
  final String message;

  const ConfigsError({
    required this.failure,
    required this.message,
  });

  @override
  List<Object> get props => [failure, message];
}
