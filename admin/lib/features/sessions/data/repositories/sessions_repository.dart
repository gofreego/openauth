import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../src/generated/openauth/v1/sessions.pb.dart' as pb;

abstract class SessionsRepository {
  Future<Either<Failure, List<pb.Session>>> getUserSessions(pb.ListUserSessionsRequest userId);
  Future<Either<Failure, void>> terminateSession(pb.TerminateSessionRequest sessionId);
}
