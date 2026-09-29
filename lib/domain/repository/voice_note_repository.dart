import 'package:dartz/dartz.dart';
import 'package:mizan/data/network/failure.dart';
import 'package:mizan/data/request/voice_note_request.dart';
import 'package:mizan/domain/model/voice_note_model/voice_note_model.dart';

abstract class VoiceNoteRepository {
  Future<Either<Failure, VoiceNoteModel>> createVoiceNote(
    CreateVoiceNoteRequest request,
  );

  Future<Either<Failure, VoiceNotesPage>> getVoiceNotes({
    required int page,
    required int pageSize,
  });

  Future<Either<Failure, VoiceNoteModel>> getVoiceNoteById(String id);
}
