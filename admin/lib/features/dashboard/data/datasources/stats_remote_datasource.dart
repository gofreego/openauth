import 'package:dio/dio.dart';
import 'package:fixnum/fixnum.dart';
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
      
      // Parse the response data into StatsResponse
      final statsResponse = pb.StatsResponse();
      if (response.data != null) {
        // If the API returns protobuf data, merge it
        if (response.data is Map<String, dynamic>) {
          statsResponse.mergeFromProto3Json(response.data);
        } else {
          // If the API returns raw JSON, parse it manually
          final data = response.data as Map<String, dynamic>;
          statsResponse
            ..totalUsers = Int64(data['total_users'] ?? data['totalUsers'] ?? 0)
            ..totalPermissions = Int64(data['total_permissions'] ?? data['totalPermissions'] ?? 0)
            ..totalGroups = Int64(data['total_groups'] ?? data['totalGroups'] ?? 0)
            ..activeUsers = Int64(data['active_users'] ?? data['activeUsers'] ?? 0);
        }
      }
      
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
