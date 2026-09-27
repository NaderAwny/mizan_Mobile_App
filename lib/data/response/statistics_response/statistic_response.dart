import 'package:mizan/data/response/base_responses/base_responses.dart';
import 'package:json_annotation/json_annotation.dart';
part 'statistic_response.g.dart';

@JsonSerializable()
class TransactionStatisticsData {
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
  @JsonKey(name: "operationType")
  String? operationType;
  @JsonKey(name: "amount")
  num? amount;
  @JsonKey(name: "paymentMethod")
  String? paymentMethod;
  @JsonKey(name: "operationDate")
  String? operationDate;
  @JsonKey(name: "createdAt")
  String? createdAt;

  TransactionStatisticsData({
    this.id,
    this.shopId,
    this.contactId,
    this.contactName,
    this.partyName,
    this.operationType,
    this.amount,
    this.paymentMethod,
    this.operationDate,
    this.createdAt,
  });

  factory TransactionStatisticsData.fromJson(Map<String, dynamic> json) =>
      _$TransactionStatisticsDataFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionStatisticsDataToJson(this);
}

@JsonSerializable()
class StatisticData {
  @JsonKey(name: "date")
  String? date;
  @JsonKey(name: "totalSales")
  num? totalSales;
  @JsonKey(name: "totalPurchases")
  num? totalPurchases;
  @JsonKey(name: "operationsCount")
  int? operationsCount;
  @JsonKey(name: "transactions")
  List<TransactionStatisticsData>? transactions;

  StatisticData({
    this.date,
    this.totalSales,
    this.totalPurchases,
    this.operationsCount,
    this.transactions,
  });

  factory StatisticData.fromJson(Map<String, dynamic> json) =>
      _$StatisticDataFromJson(json);

  Map<String, dynamic> toJson() => _$StatisticDataToJson(this);
}

@JsonSerializable()
class StatisticsResponse extends BaseResponse {
  @JsonKey(name: "data")
  StatisticData? data;

  StatisticsResponse({this.data, super.success, super.message});

  factory StatisticsResponse.fromJson(Map<String, dynamic> json) =>
      _$StatisticsResponseFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$StatisticsResponseToJson(this);
}
