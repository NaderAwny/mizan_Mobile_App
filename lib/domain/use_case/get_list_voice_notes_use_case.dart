import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:mizan/data/network/failure.dart';
import 'package:mizan/domain/model/voice_note_model/voice_note_model.dart';
import 'package:mizan/domain/repository/voice_note_repository.dart';
import 'package:mizan/domain/use_case/base_usecase.dart';

@lazySingleton
class GetListVoiceNotesUseCase
    implements BaseUsecase<GetListVoiceNotesParams, VoiceNotesPage> {
  final VoiceNoteRepository _repository;

  GetListVoiceNotesUseCase(this._repository);

  @override
  Future<Either<Failure, VoiceNotesPage>> execute(
    GetListVoiceNotesParams params,
  ) async {
    return await _repository.getVoiceNotes(
      page: params.page,
      pageSize: params.pageSize,
    );
  }
}

class GetListVoiceNotesParams {
  final int page;
  final int pageSize;

  GetListVoiceNotesParams({required this.page, required this.pageSize});
}
