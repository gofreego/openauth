import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/dashboard_stats_entity.dart';
import '../repositories/stats_repository.dart';

class GetStatsUseCase {
  final StatsRepository repository;

  GetStatsUseCase(this.repository);

  Future<Either<Failure, DashboardStatsEntity>> call() async {
    return await repository.getStats();
  }
}
