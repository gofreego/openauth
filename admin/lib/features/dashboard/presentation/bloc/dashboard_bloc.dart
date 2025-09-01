import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_stats_usecase.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final GetStatsUseCase getStatsUseCase;

  DashboardBloc({required this.getStatsUseCase}) : super(DashboardInitial()) {
    on<LoadStatsEvent>(_onLoadStats);
    on<RefreshStatsEvent>(_onRefreshStats);
  }

  Future<void> _onLoadStats(LoadStatsEvent event, Emitter<DashboardState> emit) async {
    emit(DashboardLoading());
    
    final result = await getStatsUseCase.call();
    
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
    
    final result = await getStatsUseCase.call();
    
    result.fold(
      (failure) => emit(DashboardError(message: failure.message)),
      (stats) => emit(DashboardLoaded(stats: stats)),
    );
  }
}
