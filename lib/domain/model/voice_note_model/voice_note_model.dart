import 'package:mizan/app/constants.dart';

class VoiceNoteModel {
  final String id;
  final String audioPath;
  final String operationType;
  final String operationTypeLabel;
  final num amount;
  final String operationDate;
  final String contactName;
  final String contactId;
  final String notes;
  final String createdAt;

  const VoiceNoteModel({
    required this.id,
    required this.audioPath,
    required this.operationType,
    required this.operationTypeLabel,
    required this.amount,
    required this.operationDate,
    required this.contactName,
    required this.contactId,
    required this.notes,
    required this.createdAt,
  });

  /// الرابط الكامل لملف الصوت (الـ API بيرجّع path نسبي)
  String get audioUrl {
    if (audioPath.isEmpty) return '';
    if (audioPath.startsWith('http')) return audioPath;
    return '${Constants.baseUrl}$audioPath';
  }
}

class VoiceNotesPage {
  final List<VoiceNoteModel> items;
  final int totalCount;
  final int page;
  final int pageSize;
  final int totalPages;

  const VoiceNotesPage({
    required this.items,
    required this.totalCount,
    required this.page,
    required this.pageSize,
    required this.totalPages,
  });

  bool get hasNextPage => page < totalPages;
}
