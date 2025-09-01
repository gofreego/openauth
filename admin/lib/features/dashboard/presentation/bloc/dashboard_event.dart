import 'package:equatable/equatable.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object> get props => [];
}

class LoadStatsEvent extends DashboardEvent {
  const LoadStatsEvent();
}

class RefreshStatsEvent extends DashboardEvent {
  const RefreshStatsEvent();
}
