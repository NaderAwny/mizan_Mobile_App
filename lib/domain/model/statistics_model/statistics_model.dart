class TransactionStatisticsModel {
  String? id;
  String? shopId;
  String? contactId;
  String? contactName;
  String? partyName;
  String? operationType;
  num? amount;
  String? paymentMethod;
  String? operationDate;
  String? createdAt;

  TransactionStatisticsModel({
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
}

class StatisticsPageModel {
  String? date;
  num? totalSales;
  num? totalPurchases;
  int? operationsCount;
  List<TransactionStatisticsModel>? transactions;

  StatisticsPageModel({
    this.date,
    this.totalSales,
    this.totalPurchases,
    this.operationsCount,
    this.transactions,
  });
}
