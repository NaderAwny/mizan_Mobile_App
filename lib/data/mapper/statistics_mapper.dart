import 'package:mizan/app/constants.dart';
import 'package:mizan/app/extensions.dart';
import 'package:mizan/data/response/statistics_response/statistic_response.dart';
import 'package:mizan/domain/model/statistics_model/statistics_model.dart';

extension StatisticsMapper on TransactionStatisticsData {
  TransactionStatisticsModel toDomain() {
    return TransactionStatisticsModel(
      id: id?.orEmpty() ?? Constants.empty,
      shopId: shopId?.orEmpty() ?? Constants.empty,
      contactId: contactId?.orEmpty() ?? Constants.empty,
      contactName: contactName?.orEmpty() ?? Constants.empty,
      partyName: partyName?.orEmpty() ?? Constants.empty,
      operationType: operationType?.orEmpty() ?? Constants.empty,
      amount: amount?.orZeroNum() ?? 0,
      paymentMethod: paymentMethod?.orEmpty() ?? Constants.empty,
      operationDate: operationDate?.orEmpty() ?? Constants.empty,
      createdAt: createdAt?.orEmpty() ?? Constants.empty,
    );
  }
}

extension StatisticsPageMapper on StatisticsResponse {
  StatisticsPageModel toDomain() {
    return StatisticsPageModel(
      date: data?.date?.orEmpty() ?? Constants.empty,
      totalSales: data?.totalSales?.orZeroNum() ?? 0,
      totalPurchases: data?.totalPurchases?.orZeroNum() ?? 0,
      operationsCount: data?.operationsCount?.orZero() ?? 0,
      transactions: data?.transactions?.map((e) => e.toDomain()).toList(),
    );
  }
}
