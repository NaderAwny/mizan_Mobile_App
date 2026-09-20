import 'package:json_annotation/json_annotation.dart';
import 'package:mizan/data/response/base_responses/base_responses.dart';

part 'transaction_responses.g.dart';

@JsonSerializable()
class InstallmentData {
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

  InstallmentData({
    this.id,
    this.installmentNumber,
    this.amount,
    this.dueDate,
    this.isPaid,
    this.status,
  });

  factory InstallmentData.fromJson(Map<String, dynamic> json) =>
      _$InstallmentDataFromJson(json);

  Map<String, dynamic> toJson() => _$InstallmentDataToJson(this);
}

@JsonSerializable()
class TransactionData {
  @JsonKey(name: "id")
  String? id;
  @JsonKey(name: "contactId")
  String? contactId;
  @JsonKey(name: "contactName")
  String? contactName;
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
  @JsonKey(name: "installments")
  List<InstallmentData>? installments;
  @JsonKey(name: "createdAt")
  String? createdAt;

  TransactionData({
    this.id,
    this.contactId,
    this.contactName,
    this.type,
    this.amount,
    this.paymentMethod,
    this.transactionDate,
    this.isInstallment,
    this.installments,
    this.createdAt,
  });

  factory TransactionData.fromJson(Map<String, dynamic> json) =>
      _$TransactionDataFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionDataToJson(this);
}

@JsonSerializable()
class TransactionResponse extends BaseResponse {
  @JsonKey(name: "data")
  TransactionData? data;

  TransactionResponse({this.data, super.success, super.message});

  factory TransactionResponse.fromJson(Map<String, dynamic> json) =>
      _$TransactionResponseFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$TransactionResponseToJson(this);
}
