class GetListTransactionsModel {
  final String id;
  final String contactId;
  final String contactName;
  final String type;
  final num amount;
  final String paymentMethod;
  final String transactionDate;
  final bool isInstallment;
  final String createdAt;
  GetListTransactionsModel({
    required this.id,
    required this.contactId,
    required this.contactName,
    required this.type,
    required this.amount,
    required this.paymentMethod,
    required this.transactionDate,
    required this.isInstallment,
    required this.createdAt,
  });
}

class GetListTransactionsPage {
  final List<GetListTransactionsModel> items;
  final int totalCount;
  final int page;
  final int pageSize;
  final int totalPages;

  GetListTransactionsPage({
    required this.items,
    required this.totalCount,
    required this.page,
    required this.pageSize,
    required this.totalPages,
  });

  bool get hasNextPage => page < totalPages;
}
