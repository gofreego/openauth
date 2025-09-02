import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../src/generated/openauth/v1/sessions.pb.dart' as pb;
import 'sessions_repository.dart';
import '../datasources/sessions_remote_datasource_impl.dart';

class SessionsRepositoryImpl implements SessionsRepository {
  final SessionsRemoteDataSource _remoteDataSource;

  SessionsRepositoryImpl({
    required SessionsRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  @override
  Future<Either<Failure, List<pb.Session>>> getUserSessions(String userId) async {
    try {
      final response = await _remoteDataSource.getUserSessions(userId);
      return Right(response.sessions);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> terminateSession(String sessionId) async {
    try {
      await _remoteDataSource.terminateSession(sessionId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> terminateAllUserSessions(String userId) async {
    try {
      await _remoteDataSource.terminateAllUserSessions(userId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Unexpected error: $e'));
    }
  }
}
