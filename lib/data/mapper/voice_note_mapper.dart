import 'package:mizan/app/extensions.dart';
import 'package:mizan/data/response/voice_notes_response/voice_notes_response.dart';
import 'package:mizan/domain/model/voice_note_model/voice_note_model.dart';

extension VoiceNoteMapper on VoiceNoteData? {
  VoiceNoteModel toDomain() {
    return VoiceNoteModel(
      id: this?.id.orEmpty() ?? '',
      audioPath: this?.audioPath.orEmpty() ?? '',
      operationType: this?.operationType.orEmpty() ?? '',
      operationTypeLabel: this?.operationTypeLabel.orEmpty() ?? '',
      amount: this?.amount.orZeroNum() ?? 0,
      operationDate: this?.operationDate.orEmpty() ?? '',
      contactName: this?.contactName.orEmpty() ?? '',
      contactId: this?.contactId.orEmpty() ?? '',
      notes: this?.notes.orEmpty() ?? '',
      createdAt: this?.createdAt.orEmpty() ?? '',
    );
  }
}

extension VoiceNotesPageMapper on VoiceNotesPageData? {
  VoiceNotesPage toDomain() {
    final totalCount = this?.totalCount.orZero() ?? 0;
    final rawPageSize = this?.pageSize.orZero() ?? 0;
    final pageSize = rawPageSize > 0 ? rawPageSize : 20;
    // الـ API مش بيرجّع totalPages فبنحسبها من totalCount / pageSize
    final totalPages = totalCount == 0 ? 1 : (totalCount / pageSize).ceil();

    return VoiceNotesPage(
      items: (this?.items?.map((e) => e.toDomain()) ?? const []).toList(),
      totalCount: totalCount,
      page: this?.page.orZero() ?? 1,
      pageSize: pageSize,
      totalPages: totalPages,
    );
  }
}
