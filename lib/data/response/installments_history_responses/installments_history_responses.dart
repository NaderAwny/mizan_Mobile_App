import 'package:json_annotation/json_annotation.dart';
import 'package:mizan/data/response/base_responses/base_responses.dart';

part 'installments_history_responses.g.dart';

@JsonSerializable()
class InstallmentHistoryItemData {
  @JsonKey(name: "installmentId")
  String? installmentId;
  @JsonKey(name: "transactionId")
  String? transactionId;
  @JsonKey(name: "contactId")
  String? contactId;
  @JsonKey(name: "contactName")
  String? contactName;
  @JsonKey(name: "phoneNumber")
  String? phoneNumber;
  @JsonKey(name: "amount")
  num? amount;
  @JsonKey(name: "dueDate")
  String? dueDate;
  @JsonKey(name: "isPaid")
  bool? isPaid;
  @JsonKey(name: "paidAt")
  String? paidAt;
  @JsonKey(name: "status")
  String? status;
  @JsonKey(name: "daysOverdue")
  int? daysOverdue;

  InstallmentHistoryItemData({
    this.installmentId,
    this.transactionId,
    this.contactId,
    this.contactName,
    this.phoneNumber,
    this.amount,
    this.dueDate,
    this.isPaid,
    this.paidAt,
    this.status,
    this.daysOverdue,
  });

  factory InstallmentHistoryItemData.fromJson(Map<String, dynamic> json) =>
      _$InstallmentHistoryItemDataFromJson(json);

  Map<String, dynamic> toJson() => _$InstallmentHistoryItemDataToJson(this);
}

@JsonSerializable()
class InstallmentsHistoryPageData {
  @JsonKey(name: "items")
  List<InstallmentHistoryItemData>? items;
  @JsonKey(name: "page")
  int? page;
  @JsonKey(name: "pageSize")
  int? pageSize;
  @JsonKey(name: "totalCount")
  int? totalCount;
  @JsonKey(name: "totalPages")
  int? totalPages;
  @JsonKey(name: "hasPreviousPage")
  bool? hasPreviousPage;
  @JsonKey(name: "hasNextPage")
  bool? hasNextPage;

  InstallmentsHistoryPageData({
    this.items,
    this.page,
    this.pageSize,
    this.totalCount,
    this.totalPages,
    this.hasPreviousPage,
    this.hasNextPage,
  });

  factory InstallmentsHistoryPageData.fromJson(Map<String, dynamic> json) =>
      _$InstallmentsHistoryPageDataFromJson(json);

  Map<String, dynamic> toJson() => _$InstallmentsHistoryPageDataToJson(this);
}

@JsonSerializable()
class InstallmentsHistoryResponse extends BaseResponse {
  @JsonKey(name: "data")
  InstallmentsHistoryPageData? data;

  InstallmentsHistoryResponse({this.data, super.success, super.message});

  factory InstallmentsHistoryResponse.fromJson(Map<String, dynamic> json) =>
      _$InstallmentsHistoryResponseFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$InstallmentsHistoryResponseToJson(this);
}
