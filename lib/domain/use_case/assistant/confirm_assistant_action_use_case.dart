import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:mizan/data/network/failure.dart';
import 'package:mizan/domain/model/assistant_model.dart';
import 'package:mizan/domain/repository/assistant_repository.dart';
import 'package:mizan/domain/use_case/base_usecase.dart';

class AssistantActionParams {
  final String sessionId;
  final String actionId;

  const AssistantActionParams({
    required this.sessionId,
    required this.actionId,
  });
}

@injectable
class ConfirmAssistantActionUseCase
    implements BaseUsecase<AssistantActionParams, AssistantReply> {
  final AssistantRepository _repository;

  ConfirmAssistantActionUseCase(this._repository);

  @override
  Future<Either<Failure, AssistantReply>> execute(AssistantActionParams input) {
    return _repository.confirmAction(input.sessionId, input.actionId);
  }
}
