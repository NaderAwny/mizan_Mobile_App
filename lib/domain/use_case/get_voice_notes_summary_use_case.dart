import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:mizan/data/network/failure.dart';
import 'package:mizan/domain/model/voice_note_model/voice_note_model.dart';
import 'package:mizan/domain/repository/voice_note_repository.dart';
import 'package:mizan/domain/use_case/base_usecase.dart';

class GetVoiceNotesSummaryParams {
  final String period;
  final String? from;
  final String? to;

  const GetVoiceNotesSummaryParams({
    required this.period,
    this.from,
    this.to,
  });
}

@lazySingleton
class GetVoiceNotesSummaryUseCase
    implements BaseUsecase<GetVoiceNotesSummaryParams, VoiceNoteSummaryModel> {
  final VoiceNoteRepository _repository;

  GetVoiceNotesSummaryUseCase(this._repository);

  @override
  Future<Either<Failure, VoiceNoteSummaryModel>> execute(
    GetVoiceNotesSummaryParams input,
  ) {
    return _repository.getVoiceNotesSummary(
      period: input.period,
      from: input.from,
      to: input.to,
    );
  }
}
