import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:openauth/features/dashboard/dashboard.dart';
import 'package:openauth/src/generated/openauth/v1/stats.pb.dart';
import 'package:protobuf/protobuf.dart' as pb;

class DashboardBloc extends Bloc<pb.GeneratedMessage, DashboardState> {
  final StatsRepository repository;

  DashboardBloc({required this.repository}) : super(DashboardInitial()) {
    on<StatsRequest>(_onLoadStats);
    on<BackgroundStatsRequest>(_onBackgroundLoadStats);
  }

  Future<void> _onLoadStats(StatsRequest event, Emitter<DashboardState> emit) async {
    emit(const DashboardLoading(isInitialLoad: true));

    final result = await repository.getStats();

    result.fold(
      (failure) => emit(DashboardError(message: failure.message)),
      (stats) => emit(DashboardLoaded(stats: stats)),
    );
  }

  Future<void> _onBackgroundLoadStats(BackgroundStatsRequest event, Emitter<DashboardState> emit) async {
    final currentState = state;
    
    final result = await repository.getStats();

    result.fold(
      (failure) => emit(DashboardError(message: failure.message)),
      (stats) {
        if (currentState is DashboardLoaded) {
          // Compare with previous stats to determine what changed
          final changedValues = <String, bool>{
            'totalUsers': stats.totalUsers != currentState.stats.totalUsers,
            'activeUsers': stats.activeUsers != currentState.stats.activeUsers,
            'totalPermissions': stats.totalPermissions != currentState.stats.totalPermissions,
            'totalGroups': stats.totalGroups != currentState.stats.totalGroups,
          };

          emit(DashboardLoaded(
            stats: stats,
            previousStats: currentState.stats,
            changedValues: changedValues,
          ));
        } else {
          // First load or after error
          emit(DashboardLoaded(stats: stats));
        }
      },
    );
  }
}

// Add new event for background refresh
class BackgroundStatsRequest extends pb.GeneratedMessage {
  @override
  BackgroundStatsRequest createEmptyInstance() => BackgroundStatsRequest();
  
  @override
  BackgroundStatsRequest clone() => BackgroundStatsRequest();
  
  @override
  pb.BuilderInfo get info_ => _i;
  
  static final pb.BuilderInfo _i = pb.BuilderInfo('BackgroundStatsRequest');
}
