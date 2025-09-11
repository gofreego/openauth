import 'package:equatable/equatable.dart';
import '../../../../src/generated/openauth/v1/configs.pb.dart';
import '../../../../core/errors/failures.dart';

abstract class ConfigEntitiesState extends Equatable {
  const ConfigEntitiesState();

  @override
  List<Object?> get props => [];
}

class ConfigEntitiesInitial extends ConfigEntitiesState {}

class ConfigEntitiesLoading extends ConfigEntitiesState {}

class ConfigEntitiesLoaded extends ConfigEntitiesState {
  final List<ConfigEntity> entities;
  final bool hasReachedMax;
  final bool isLoadingMore;

  const ConfigEntitiesLoaded({
    required this.entities,
    this.hasReachedMax = false,
    this.isLoadingMore = false,
  });

  ConfigEntitiesLoaded copyWith({
    List<ConfigEntity>? entities,
    bool? hasReachedMax,
    bool? isLoadingMore,
  }) {
    return ConfigEntitiesLoaded(
      entities: entities ?? this.entities,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object?> get props => [entities, hasReachedMax, isLoadingMore];
}

class ConfigEntityCreated extends ConfigEntitiesState {
  final ConfigEntity entity;

  const ConfigEntityCreated(this.entity);

  @override
  List<Object> get props => [entity];
}

class ConfigEntityUpdated extends ConfigEntitiesState {
  final ConfigEntity entity;

  const ConfigEntityUpdated(this.entity);

  @override
  List<Object> get props => [entity];
}

class ConfigEntityDeleted extends ConfigEntitiesState {}

class ConfigEntitiesError extends ConfigEntitiesState {
  final Failure failure;
  final String message;

  const ConfigEntitiesError({
    required this.failure,
    required this.message,
  });

  @override
  List<Object> get props => [failure, message];
}
