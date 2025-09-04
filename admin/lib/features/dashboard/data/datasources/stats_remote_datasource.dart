import 'package:dio/dio.dart';
import '../../../../src/generated/openauth/v1/stats.pb.dart' as pb;
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/api_service.dart';

abstract class StatsRemoteDataSource {
  Future<pb.StatsResponse> getStats();
}

class StatsRemoteDataSourceImpl implements StatsRemoteDataSource {
  final ApiService _apiService;

  StatsRemoteDataSourceImpl(this._apiService);

  @override
  Future<pb.StatsResponse> getStats() async {
    try {
      final response = await _apiService.get('/openauth/v1/stats');
      final statsResponse = pb.StatsResponse();
      statsResponse.mergeFromProto3Json(response.data);
      return statsResponse;
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'Failed to fetch stats',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw NetworkException(message: 'Network error: ${e.toString()}');
    }
  }
}
