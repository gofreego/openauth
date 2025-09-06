import 'package:dartz/dartz.dart';
import 'package:openauth/core/network/api_service.dart';
import 'package:openauth/src/generated/openauth/v1/stats.pb.dart' as pb;
import '../../../../core/errors/failures.dart';
import 'stats_repository.dart';

class StatsRepositoryImpl implements StatsRepository {
  final ApiService _apiService;

  StatsRepositoryImpl({required ApiService apiService})
      : _apiService = apiService;

  @override
  Future<Either<Failure, pb.StatsResponse>> getStats() async {
    try {
      final response = await _apiService.get('/openauth/v1/stats');
      final statsResponse = pb.StatsResponse();
      statsResponse.mergeFromProto3Json(response.data);
      return Right(statsResponse);
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }
}
