import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:mizan/data/network/failure.dart';
import 'package:mizan/domain/repository/voice_note_repository.dart';
import 'package:mizan/domain/use_case/base_usecase.dart';

@injectable
class DeleteVoiceNoteUseCase extends BaseUsecase<String, void> {
  final VoiceNoteRepository _repository;

  DeleteVoiceNoteUseCase(this._repository);

  @override
  Future<Either<Failure, void>> execute(String input) =>
      _repository.deleteVoiceNote(input);
}
