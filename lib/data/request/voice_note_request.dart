import 'dart:io';

class VoiceNoteOperationType {
  static const String sale = 'Sale';
  static const String purchase = 'Purchase';
  static const String installmentCollection = 'InstallmentCollection';
  static const String installmentPayment = 'InstallmentPayment';
}

class CreateVoiceNoteRequest {
  final File audioFile;
  final String
  operationType; // Sale | Purchase | InstallmentCollection | InstallmentPayment
  final num amount;
  final String operationDate; // ISO-8601
  final String? contactId;
  final String? partyName;
  final String? notes;

  CreateVoiceNoteRequest({
    required this.audioFile,
    required this.operationType,
    required this.amount,
    required this.operationDate,
    this.contactId,
    this.partyName,
    this.notes,
  });
}
