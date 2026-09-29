import 'package:injectable/injectable.dart';
import 'package:mizan/data/network/app_api.dart';
import 'package:mizan/data/request/voice_note_request.dart';
import 'package:mizan/data/response/voice_notes_response/voice_notes_response.dart';

abstract class VoiceNoteRemoteDataSource {
  Future<VoiceNoteResponse> createVoiceNote(CreateVoiceNoteRequest request);

  Future<VoiceNotesPageResponse> getVoiceNotes({
    required int page,
    required int pageSize,
  });

  Future<VoiceNoteResponse> getVoiceNoteById(String id);
}

@LazySingleton(as: VoiceNoteRemoteDataSource)
class VoiceNoteRemoteDataSourceImpl implements VoiceNoteRemoteDataSource {
  final AppServiceClient _appServiceClient;

  VoiceNoteRemoteDataSourceImpl(this._appServiceClient);

  @override
  Future<VoiceNoteResponse> createVoiceNote(CreateVoiceNoteRequest request) {
    return _appServiceClient.createVoiceNote(
      request.audioFile,
      request.operationType,
      request.amount.toString(),
      request.operationDate,
      request.contactId,
      request.partyName,
      request.notes,
    );
  }

  @override
  Future<VoiceNotesPageResponse> getVoiceNotes({
    required int page,
    required int pageSize,
  }) {
    return _appServiceClient.getVoiceNotes(page, pageSize);
  }

  @override
  Future<VoiceNoteResponse> getVoiceNoteById(String id) {
    return _appServiceClient.getVoiceNoteById(id);
  }
}
