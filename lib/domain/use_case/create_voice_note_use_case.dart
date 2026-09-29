import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:mizan/data/network/failure.dart';
import 'package:mizan/data/request/voice_note_request.dart';
import 'package:mizan/domain/model/voice_note_model/voice_note_model.dart';
import 'package:mizan/domain/repository/voice_note_repository.dart';
import 'package:mizan/domain/use_case/base_usecase.dart';

@injectable
class CreateVoiceNoteUseCase
    extends BaseUsecase<CreateVoiceNoteRequest, VoiceNoteModel> {
  final VoiceNoteRepository _repository;

  CreateVoiceNoteUseCase(this._repository);

  @override
  Future<Either<Failure, VoiceNoteModel>> execute(
    CreateVoiceNoteRequest input,
  ) => _repository.createVoiceNote(input);
}
