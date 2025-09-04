import 'package:dartz/dartz.dart';
import 'package:openauth/src/generated/openauth/v1/stats.pb.dart' as pb;
import '../../../../core/errors/failures.dart';
import '../../../../core/errors/exceptions.dart';
import 'stats_repository.dart';
import '../datasources/stats_remote_datasource.dart';

class StatsRepositoryImpl implements StatsRepository {
  final StatsRemoteDataSource remoteDataSource;

  StatsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, pb.StatsResponse>> getStats() async {
    try {
      return Right(await remoteDataSource.getStats());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Unexpected error: ${e.toString()}'));
    }
  }
}
