import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:mizan/data/network/failure.dart';
import 'package:mizan/domain/repository/assistant_repository.dart';
import 'package:mizan/domain/use_case/base_usecase.dart';

@injectable
class EndAssistantSessionUseCase implements BaseUsecase<String, void> {
  final AssistantRepository _repository;

  EndAssistantSessionUseCase(this._repository);

  @override
  Future<Either<Failure, void>> execute(String input) {
    return _repository.endSession(input);
  }
}
