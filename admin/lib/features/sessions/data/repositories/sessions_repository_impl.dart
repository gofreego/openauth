import 'package:dartz/dartz.dart';
import 'package:openauth/src/generated/openauth/v1/sessions.pb.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/errors/exceptions.dart';
import 'sessions_repository.dart';
import '../datasources/sessions_remote_datasource_impl.dart';

class SessionsRepositoryImpl implements SessionsRepository {
  final SessionsRemoteDataSource _remoteDataSource;

  SessionsRepositoryImpl({
    required SessionsRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  @override
  Future<Either<Failure, List<Session>>> getUserSessions(ListUserSessionsRequest request) async {
    try {
      final response = await _remoteDataSource.getUserSessions(request);
      return Right(response.sessions);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> terminateSession(TerminateSessionRequest request) async {
    try {
      await _remoteDataSource.terminateSession(request);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Unexpected error: $e'));
    }
  }
}
