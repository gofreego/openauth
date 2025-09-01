import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/dashboard_stats_entity.dart';

abstract class StatsRepository {
  Future<Either<Failure, DashboardStatsEntity>> getStats();
}
