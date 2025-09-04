import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:openauth/features/dashboard/dashboard.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final StatsRepository repository;

  DashboardBloc({required this.repository}) : super(DashboardInitial()) {
    on<LoadStatsEvent>(_onLoadStats);
    on<RefreshStatsEvent>(_onRefreshStats);
  }

  Future<void> _onLoadStats(LoadStatsEvent event, Emitter<DashboardState> emit) async {
    emit(DashboardLoading());

    final result = await repository.getStats();

    result.fold(
      (failure) => emit(DashboardError(message: failure.message)),
      (stats) => emit(DashboardLoaded(stats: stats)),
    );
  }

  Future<void> _onRefreshStats(RefreshStatsEvent event, Emitter<DashboardState> emit) async {
    // Keep current state if already loaded, show loading for initial load
    if (state is! DashboardLoaded) {
      emit(DashboardLoading());
    }

    final result = await repository.getStats();

    result.fold(
      (failure) => emit(DashboardError(message: failure.message)),
      (stats) => emit(DashboardLoaded(stats: stats)),
    );
  }
}
