import 'package:json_annotation/json_annotation.dart';
import 'package:mizan/data/response/base_responses/base_responses.dart';

part 'transaction_by_id_responses.g.dart';

@JsonSerializable()
class InstallmentDataById {
  @JsonKey(name: "id")
  String? id;
  @JsonKey(name: "installmentNumber")
  int? installmentNumber;
  @JsonKey(name: "amount")
  num? amount;
  @JsonKey(name: "dueDate")
  String? dueDate;
  @JsonKey(name: "isPaid")
  bool? isPaid;
  @JsonKey(name: "status")
  String? status;
  @JsonKey(name: "paidAt")
  String? paidAt;

  InstallmentDataById({
    this.id,
    this.installmentNumber,
    this.amount,
    this.dueDate,
    this.isPaid,
    this.status,
    this.paidAt,
  });

  factory InstallmentDataById.fromJson(Map<String, dynamic> json) =>
      _$InstallmentDataByIdFromJson(json);

  Map<String, dynamic> toJson() => _$InstallmentDataByIdToJson(this);
}

@JsonSerializable()
class TransactionDataById {
  @JsonKey(name: "id")
  String? id;
  @JsonKey(name: "shopId")
  String? shopId;
  @JsonKey(name: "contactId")
  String? contactId;
  @JsonKey(name: "contactName")
  String? contactName;
  @JsonKey(name: "partyName")
  String? partyName;
  @JsonKey(name: "type")
  String? type;
  @JsonKey(name: "amount")
  num? amount;
  @JsonKey(name: "paymentMethod")
  String? paymentMethod;
  @JsonKey(name: "transactionDate")
  String? transactionDate;
  @JsonKey(name: "isInstallment")
  bool? isInstallment;
  @JsonKey(name: "installmentPlanMode")
  String? installmentPlanMode;
  @JsonKey(name: "noteType")
  String? noteType;
  @JsonKey(name: "noteText")
  String? noteText;
  @JsonKey(name: "hasVoiceNote")
  bool? hasVoiceNote;
  @JsonKey(name: "installments")
  List<InstallmentDataById>? installments;
  @JsonKey(name: "totalPaid")
  num? totalPaid;
  @JsonKey(name: "totalRemaining")
  num? totalRemaining;
  @JsonKey(name: "isActive")
  bool? isActive;
  @JsonKey(name: "createdAt")
  String? createdAt;
  @JsonKey(name: "updatedAt")
  String? updatedAt;

  TransactionDataById({
    this.id,
    this.shopId,
    this.contactId,
    this.contactName,
    this.partyName,
    this.type,
    this.amount,
    this.paymentMethod,
    this.transactionDate,
    this.isInstallment,
    this.installmentPlanMode,
    this.noteType,
    this.noteText,
    this.hasVoiceNote,
    this.installments,
    this.totalPaid,
    this.totalRemaining,
    this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  factory TransactionDataById.fromJson(Map<String, dynamic> json) =>
      _$TransactionDataByIdFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionDataByIdToJson(this);
}

@JsonSerializable()
class TransactionResponseById extends BaseResponse {
  @JsonKey(name: "data")
  TransactionDataById? data;

  TransactionResponseById({this.data, super.success, super.message});

  factory TransactionResponseById.fromJson(Map<String, dynamic> json) =>
      _$TransactionResponseByIdFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$TransactionResponseByIdToJson(this);
}
