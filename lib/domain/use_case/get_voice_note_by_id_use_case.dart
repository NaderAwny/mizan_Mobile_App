import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:mizan/data/network/failure.dart';
import 'package:mizan/domain/model/voice_note_model/voice_note_model.dart';
import 'package:mizan/domain/repository/voice_note_repository.dart';
import 'package:mizan/domain/use_case/base_usecase.dart';

@injectable
class GetVoiceNoteByIdUseCase extends BaseUsecase<String, VoiceNoteModel> {
  final VoiceNoteRepository _repository;

  GetVoiceNoteByIdUseCase(this._repository);

  @override
  Future<Either<Failure, VoiceNoteModel>> execute(String input) =>
      _repository.getVoiceNoteById(input);
}
