class InstallmentHistoryItemModel {
  final String installmentId;
  final String transactionId;
  final String contactId;
  final String contactName;
  final String phoneNumber;
  final num amount;
  final String dueDate;
  final bool isPaid;
  final String paidAt; // "" when null
  final String status; // "Paid" | "Overdue" | "DueToday" | "Upcoming"
  final int daysOverdue;

  const InstallmentHistoryItemModel({
    required this.installmentId,
    required this.transactionId,
    required this.contactId,
    required this.contactName,
    required this.phoneNumber,
    required this.amount,
    required this.dueDate,
    required this.isPaid,
    required this.paidAt,
    required this.status,
    required this.daysOverdue,
  });
}

class InstallmentsHistoryPage {
  final List<InstallmentHistoryItemModel> items;
  final int page;
  final int pageSize;
  final int totalCount;
  final int totalPages;
  final bool hasPreviousPage;
  final bool hasNextPage;

  const InstallmentsHistoryPage({
    required this.items,
    required this.page,
    required this.pageSize,
    required this.totalCount,
    required this.totalPages,
    required this.hasPreviousPage,
    required this.hasNextPage,
  });
}
