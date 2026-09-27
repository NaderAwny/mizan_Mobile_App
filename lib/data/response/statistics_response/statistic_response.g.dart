// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'statistic_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionStatisticsData _$TransactionStatisticsDataFromJson(
  Map<String, dynamic> json,
) => TransactionStatisticsData(
  id: json['id'] as String?,
  shopId: json['shopId'] as String?,
  contactId: json['contactId'] as String?,
  contactName: json['contactName'] as String?,
  partyName: json['partyName'] as String?,
  operationType: json['operationType'] as String?,
  amount: json['amount'] as num?,
  paymentMethod: json['paymentMethod'] as String?,
  operationDate: json['operationDate'] as String?,
  createdAt: json['createdAt'] as String?,
);

Map<String, dynamic> _$TransactionStatisticsDataToJson(
  TransactionStatisticsData instance,
) => <String, dynamic>{
  'id': instance.id,
  'shopId': instance.shopId,
  'contactId': instance.contactId,
  'contactName': instance.contactName,
  'partyName': instance.partyName,
  'operationType': instance.operationType,
  'amount': instance.amount,
  'paymentMethod': instance.paymentMethod,
  'operationDate': instance.operationDate,
  'createdAt': instance.createdAt,
};

StatisticData _$StatisticDataFromJson(Map<String, dynamic> json) =>
    StatisticData(
      date: json['date'] as String?,
      totalSales: json['totalSales'] as num?,
      totalPurchases: json['totalPurchases'] as num?,
      operationsCount: (json['operationsCount'] as num?)?.toInt(),
      transactions: (json['transactions'] as List<dynamic>?)
          ?.map(
            (e) =>
                TransactionStatisticsData.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
    );

Map<String, dynamic> _$StatisticDataToJson(StatisticData instance) =>
    <String, dynamic>{
      'date': instance.date,
      'totalSales': instance.totalSales,
      'totalPurchases': instance.totalPurchases,
      'operationsCount': instance.operationsCount,
      'transactions': instance.transactions,
    };

StatisticsResponse _$StatisticsResponseFromJson(Map<String, dynamic> json) =>
    StatisticsResponse(
      data: json['data'] == null
          ? null
          : StatisticData.fromJson(json['data'] as Map<String, dynamic>),
      success: json['success'] as bool?,
      message: json['message'] as String?,
    );

Map<String, dynamic> _$StatisticsResponseToJson(StatisticsResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'data': instance.data,
    };
