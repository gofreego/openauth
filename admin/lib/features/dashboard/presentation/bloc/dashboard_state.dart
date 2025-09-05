import 'package:equatable/equatable.dart';
import 'package:openauth/src/generated/openauth/v1/stats.pb.dart' as pb;

abstract class DashboardState extends Equatable {
  const DashboardState();
  
  @override
  List<Object> get props => [];
}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {
  final bool isInitialLoad;

  const DashboardLoading({this.isInitialLoad = true});

  @override
  List<Object> get props => [isInitialLoad];
}

class DashboardLoaded extends DashboardState {
  final pb.StatsResponse stats;
  final pb.StatsResponse? previousStats;
  final Map<String, bool> changedValues;

  const DashboardLoaded({
    required this.stats,
    this.previousStats,
    this.changedValues = const {},
  });

  @override
  List<Object> get props => [stats, previousStats ?? const {}, changedValues];

  // Helper methods to check if specific values changed
  bool get totalUsersChanged => changedValues['totalUsers'] ?? false;
  bool get activeUsersChanged => changedValues['activeUsers'] ?? false;
  bool get totalPermissionsChanged => changedValues['totalPermissions'] ?? false;
  bool get totalGroupsChanged => changedValues['totalGroups'] ?? false;
}

class DashboardError extends DashboardState {
  final String message;

  const DashboardError({required this.message});

  @override
  List<Object> get props => [message];
}
