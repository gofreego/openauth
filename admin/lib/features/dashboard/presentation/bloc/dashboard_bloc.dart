import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:openauth/features/dashboard/dashboard.dart';
import 'package:protobuf/protobuf.dart' as pb;

import 'package:openauth/src/generated/openauth/v1/stats.pb.dart' as statsPb;

class DashboardBloc extends Bloc<pb.GeneratedMessage, DashboardState> {
  final StatsRepository repository;

  DashboardBloc({required this.repository}) : super(DashboardInitial()) {
    on<statsPb.StatsRequest>(_onLoadStats);
  }

  Future<void> _onLoadStats(statsPb.StatsRequest event, Emitter<DashboardState> emit) async {
    emit(DashboardLoading());

    final result = await repository.getStats();

    result.fold(
      (failure) => emit(DashboardError(message: failure.message)),
      (stats) => emit(DashboardLoaded(stats: stats)),
    );
  }
}
