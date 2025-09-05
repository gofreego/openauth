import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:openauth/features/dashboard/dashboard.dart';
import 'package:openauth/src/generated/openauth/v1/stats.pb.dart';
import 'package:protobuf/protobuf.dart' as pb;

class DashboardBloc extends Bloc<pb.GeneratedMessage, DashboardState> {
  final StatsRepository repository;

  DashboardBloc({required this.repository}) : super(DashboardInitial()) {
    on<StatsRequest>(_onLoadStats);
  }

  Future<void> _onLoadStats(StatsRequest event, Emitter<DashboardState> emit) async {
    emit(DashboardLoading());

    final result = await repository.getStats();

    result.fold(
      (failure) => emit(DashboardError(message: failure.message)),
      (stats) => emit(DashboardLoaded(stats: stats)),
    );
  }
}
