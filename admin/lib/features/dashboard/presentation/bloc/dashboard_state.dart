import 'package:equatable/equatable.dart';
import 'package:openauth/src/generated/openauth/v1/stats.pb.dart' as pb;

abstract class DashboardState extends Equatable {
  const DashboardState();
  
  @override
  List<Object> get props => [];
}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final pb.StatsResponse stats;

  const DashboardLoaded({required this.stats});

  @override
  List<Object> get props => [stats];
}

class DashboardError extends DashboardState {
  final String message;

  const DashboardError({required this.message});

  @override
  List<Object> get props => [message];
}
