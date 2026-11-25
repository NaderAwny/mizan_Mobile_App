import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:mizan/data/network/failure.dart';
import 'package:mizan/domain/model/assistant_model.dart';
import 'package:mizan/domain/repository/assistant_repository.dart';
import 'package:mizan/domain/use_case/base_usecase.dart';

class SendAssistantCommandParams {
  final String? sessionId;
  final String text;

  const SendAssistantCommandParams({
    this.sessionId,
    required this.text,
  });
}

@injectable
class SendAssistantCommandUseCase
    implements BaseUsecase<SendAssistantCommandParams, AssistantReply> {
  final AssistantRepository _repository;

  SendAssistantCommandUseCase(this._repository);

  @override
  Future<Either<Failure, AssistantReply>> execute(
    SendAssistantCommandParams input,
  ) {
    return _repository.sendCommand(input.sessionId, input.text);
  }
}
