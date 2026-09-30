import 'package:mizan/app/extensions.dart';
import 'package:mizan/data/response/installments_dashboard_responses/installments_dashboard_responses.dart';
import 'package:mizan/domain/model/installments_dashboard_model.dart';

extension DashboardInstallmentMapper on DashboardInstallmentData? {
  DashboardInstallmentModel toDomain() {
    return DashboardInstallmentModel(
      installmentId: this?.installmentId.orEmpty() ?? '',
      amount: this?.amount.orZeroNum() ?? 0,
      dueDate: this?.dueDate.orEmpty() ?? '',
      isPaid: this?.isPaid.orFalse() ?? false,
      paidAt: this?.paidAt.orEmpty() ?? '',
      status: this?.status.orEmpty() ?? '',
      daysOverdue: this?.daysOverdue.orZero() ?? 0,
    );
  }
}

extension InstallmentPlanMapper on InstallmentPlanData? {
  InstallmentPlanModel toDomain() {
    return InstallmentPlanModel(
      transactionId: this?.transactionId.orEmpty() ?? '',
      contactId: this?.contactId.orEmpty() ?? '',
      contactName: this?.contactName.orEmpty() ?? '',
      phoneNumber: this?.phoneNumber.orEmpty() ?? '',
      totalAmount: this?.totalAmount.orZeroNum() ?? 0,
      remainingAmount: this?.remainingAmount.orZeroNum() ?? 0,
      totalInstallmentsCount: this?.totalInstallmentsCount.orZero() ?? 0,
      paidInstallmentsCount: this?.paidInstallmentsCount.orZero() ?? 0,
      nextDueDate: this?.nextDueDate.orEmpty() ?? '',
      status: this?.status.orEmpty() ?? '',
      isOverdue: this?.isOverdue.orFalse() ?? false,
      isDueToday: this?.isDueToday.orFalse() ?? false,
      daysOverdue: this?.daysOverdue.orZero() ?? 0,
      installments: (this?.installments?.map((i) => i.toDomain()) ?? const [])
          .toList(),
    );
  }
}

extension InstallmentsDashboardMapper on InstallmentsDashboardData? {
  InstallmentsDashboardModel toDomain() {
    return InstallmentsDashboardModel(
      totalOverdueAmount: this?.totalOverdueAmount.orZeroNum() ?? 0,
      totalDueTodayAmount: this?.totalDueTodayAmount.orZeroNum() ?? 0,
      totalUpcomingAmount: this?.totalUpcomingAmount.orZeroNum() ?? 0,
      totalPaidAmount: this?.totalPaidAmount.orZeroNum() ?? 0,
      totalDebtsCount: this?.totalDebtsCount.orZero() ?? 0,
      plans: (this?.plans?.map((p) => p.toDomain()) ?? const []).toList(),
    );
  }
}
