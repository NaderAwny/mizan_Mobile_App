import 'package:json_annotation/json_annotation.dart';
import 'package:mizan/data/response/base_responses/base_responses.dart';

part 'get_list_transaction_responses.g.dart';

@JsonSerializable()
class GetListTransactionData {
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
  @JsonKey(name: "createdAt")
  String? createdAt;

  GetListTransactionData({
    this.id,
    this.contactId,
    this.contactName,
    this.type,
    this.amount,
    this.paymentMethod,
    this.transactionDate,
    this.isInstallment,
    this.createdAt,
  });

  factory GetListTransactionData.fromJson(Map<String, dynamic> json) =>
      _$GetListTransactionDataFromJson(json);

  Map<String, dynamic> toJson() => _$GetListTransactionDataToJson(this);
}

@JsonSerializable()
class GetListTransactionsPageData {
  @JsonKey(name: "items")
  List<GetListTransactionData>? items;
  @JsonKey(name: "totalCount")
  int? totalCount;
  @JsonKey(name: "page")
  int? page;
  @JsonKey(name: "pageSize")
  int? pageSize;
  @JsonKey(name: "totalPages")
  int? totalPages;

  GetListTransactionsPageData({
    this.items,
    this.totalCount,
    this.page,
    this.pageSize,
    this.totalPages,
  });

  factory GetListTransactionsPageData.fromJson(Map<String, dynamic> json) =>
      _$GetListTransactionsPageDataFromJson(json);

  Map<String, dynamic> toJson() => _$GetListTransactionsPageDataToJson(this);
}

@JsonSerializable()
class GetListTransactionsResponse extends BaseResponse {
  @JsonKey(name: "data")
  GetListTransactionsPageData? data;

  GetListTransactionsResponse({this.data, super.success, super.message});

  factory GetListTransactionsResponse.fromJson(Map<String, dynamic> json) =>
      _$GetListTransactionsResponseFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$GetListTransactionsResponseToJson(this);
}
