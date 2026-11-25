import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:mizan/data/network/failure.dart';
import 'package:mizan/domain/model/assistant_model.dart';
import 'package:mizan/domain/repository/assistant_repository.dart';
import 'package:mizan/domain/use_case/base_usecase.dart';

@injectable
class StartAssistantSessionUseCase implements BaseUsecase<void, AssistantSession> {
  final AssistantRepository _repository;

  StartAssistantSessionUseCase(this._repository);

  @override
  Future<Either<Failure, AssistantSession>> execute([void input]) {
    return _repository.startSession();
  }
}
