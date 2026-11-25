import 'package:dartz/dartz.dart';
import 'package:mizan/data/network/failure.dart';
import 'package:mizan/domain/model/assistant_model.dart';

abstract class AssistantRepository {
  Future<Either<Failure, AssistantSession>> startSession();
  Future<Either<Failure, AssistantReply>> sendCommand(String? sessionId, String text);
  Future<Either<Failure, AssistantReply>> confirmAction(String sessionId, String actionId);
  Future<Either<Failure, AssistantReply>> cancelAction(String sessionId, String actionId);
  Future<Either<Failure, void>> endSession(String sessionId);
}
