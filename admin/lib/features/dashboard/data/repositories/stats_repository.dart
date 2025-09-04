import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import 'package:openauth/src/generated/openauth/v1/stats.pb.dart' as pb;

abstract class StatsRepository {
  Future<Either<Failure, pb.StatsResponse>> getStats();
}
