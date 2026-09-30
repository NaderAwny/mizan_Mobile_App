class DashboardInstallmentModel {
  final String installmentId;
  final num amount;
  final String dueDate;
  final bool isPaid;
  final String paidAt; // "" when null
  final String status; // "Paid" | "Pending" | "Overdue" ...
  final int daysOverdue;

  const DashboardInstallmentModel({
    required this.installmentId,
    required this.amount,
    required this.dueDate,
    required this.isPaid,
    required this.paidAt,
    required this.status,
    required this.daysOverdue,
  });
}

class InstallmentPlanModel {
  final String transactionId;
  final String contactId;
  final String contactName;
  final String phoneNumber;
  final num totalAmount;
  final num remainingAmount;
  final int totalInstallmentsCount;
  final int paidInstallmentsCount;
  final String nextDueDate; // "" when all paid
  final String status; // "Overdue" | "DueToday" | "Upcoming" ...
  final bool isOverdue;
  final bool isDueToday;
  final int daysOverdue;
  final List<DashboardInstallmentModel> installments;

  const InstallmentPlanModel({
    required this.transactionId,
    required this.contactId,
    required this.contactName,
    required this.phoneNumber,
    required this.totalAmount,
    required this.remainingAmount,
    required this.totalInstallmentsCount,
    required this.paidInstallmentsCount,
    required this.nextDueDate,
    required this.status,
    required this.isOverdue,
    required this.isDueToday,
    required this.daysOverdue,
    required this.installments,
  });

  /// المبلغ المسدد فعلياً (للعرض بجانب "مسدد")
  num get paidAmount => totalAmount - remainingAmount;

  /// نسبة التقدم من 0.0 إلى 1.0 (للـ progress bar)
  double get progress {
    if (totalAmount <= 0) return 0;
    return (paidAmount / totalAmount).clamp(0.0, 1.0).toDouble();
  }
}

class InstallmentsDashboardModel {
  final num totalOverdueAmount;
  final num totalDueTodayAmount;
  final num totalUpcomingAmount;
  final num totalPaidAmount;
  final int totalDebtsCount;
  final List<InstallmentPlanModel> plans;

  const InstallmentsDashboardModel({
    required this.totalOverdueAmount,
    required this.totalDueTodayAmount,
    required this.totalUpcomingAmount,
    required this.totalPaidAmount,
    required this.totalDebtsCount,
    required this.plans,
  });
}
