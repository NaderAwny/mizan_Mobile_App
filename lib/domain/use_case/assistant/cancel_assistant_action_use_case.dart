import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:mizan/data/network/failure.dart';
import 'package:mizan/domain/model/assistant_model.dart';
import 'package:mizan/domain/repository/assistant_repository.dart';
import 'package:mizan/domain/use_case/base_usecase.dart';
import 'confirm_assistant_action_use_case.dart';

@injectable
class CancelAssistantActionUseCase
    implements BaseUsecase<AssistantActionParams, AssistantReply> {
  final AssistantRepository _repository;

  CancelAssistantActionUseCase(this._repository);

  @override
  Future<Either<Failure, AssistantReply>> execute(AssistantActionParams input) {
    return _repository.cancelAction(input.sessionId, input.actionId);
  }
}
