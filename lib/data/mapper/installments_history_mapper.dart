import 'package:mizan/app/extensions.dart';
import 'package:mizan/data/response/installments_history_responses/installments_history_responses.dart';
import 'package:mizan/domain/model/installments_history_model.dart';

extension InstallmentHistoryItemMapper on InstallmentHistoryItemData? {
  InstallmentHistoryItemModel toDomain() {
    return InstallmentHistoryItemModel(
      installmentId: this?.installmentId.orEmpty() ?? '',
      transactionId: this?.transactionId.orEmpty() ?? '',
      contactId: this?.contactId.orEmpty() ?? '',
      contactName: this?.contactName.orEmpty() ?? '',
      phoneNumber: this?.phoneNumber.orEmpty() ?? '',
      amount: this?.amount.orZeroNum() ?? 0,
      dueDate: this?.dueDate.orEmpty() ?? '',
      isPaid: this?.isPaid.orFalse() ?? false,
      paidAt: this?.paidAt.orEmpty() ?? '',
      status: this?.status.orEmpty() ?? '',
      daysOverdue: this?.daysOverdue.orZero() ?? 0,
    );
  }
}

extension InstallmentsHistoryPageMapper on InstallmentsHistoryPageData? {
  InstallmentsHistoryPage toDomain() {
    return InstallmentsHistoryPage(
      items: (this?.items?.map((i) => i.toDomain()) ?? const []).toList(),
      page: this?.page.orZero() ?? 1,
      pageSize: this?.pageSize.orZero() ?? 20,
      totalCount: this?.totalCount.orZero() ?? 0,
      totalPages: this?.totalPages.orZero() ?? 1,
      hasPreviousPage: this?.hasPreviousPage.orFalse() ?? false,
      hasNextPage: this?.hasNextPage.orFalse() ?? false,
    );
  }
}
