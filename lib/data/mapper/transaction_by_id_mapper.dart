import 'package:mizan/app/extensions.dart';
import 'package:mizan/data/response/transaction_by_id_responses/transaction_by_id_responses.dart';
import 'package:mizan/domain/model/transaction_by_id_mode/transaction_by_id_mode.dart';
import 'package:mizan/app/constants.dart';

extension InstallmentResponseMapper on InstallmentDataById? {
  InstallmentbyidModel toDomain() {
    final status = this?.status.orEmpty() ?? Constants.empty;
    final paidAt = this?.paidAt.orEmpty() ?? Constants.empty;
    return InstallmentbyidModel(
      id: this?.id.orEmpty() ?? Constants.empty,
      installmentNumber: this?.installmentNumber.orZero() ?? 0,
      amount: this?.amount.orZeroNum() ?? 0,
      dueDate: this?.dueDate.orEmpty() ?? Constants.empty,
      // The API returns `status` + `paidAt` (no `isPaid` on GET by id).
      isPaid: this?.isPaid ?? (status == 'Paid' || paidAt.isNotEmpty),
      status: status,
      paidAt: paidAt,
    );
  }
}

extension TransactionResponseMapper on TransactionDataById? {
  TransactionbyidModel toDomain() {
    return TransactionbyidModel(
      id: this?.id.orEmpty() ?? '',
      shopId: this?.shopId.orEmpty() ?? '',
      contactId: this?.contactId.orEmpty() ?? '',
      contactName: this?.contactName.orEmpty() ?? '',
      partyName: this?.partyName.orEmpty() ?? '',
      type: this?.type.orEmpty() ?? '',
      amount: this?.amount.orZeroNum() ?? 0,
      paymentMethod: this?.paymentMethod.orEmpty() ?? '',
      transactionDate: this?.transactionDate.orEmpty() ?? '',
      isInstallment: this?.isInstallment.orFalse() ?? false,
      installmentPlanMode: this?.installmentPlanMode.orEmpty() ?? '',
      noteType: this?.noteType.orEmpty() ?? '',
      noteText: this?.noteText.orEmpty() ?? '',
      hasVoiceNote: this?.hasVoiceNote.orFalse() ?? false,
      installments: (this?.installments?.map((i) => i.toDomain()) ?? const [])
          .toList(),
      totalPaid: this?.totalPaid.orZeroNum() ?? 0,
      totalRemaining: this?.totalRemaining.orZeroNum() ?? 0,
      isActive: this?.isActive.orFalse() ?? false,
      createdAt: this?.createdAt.orEmpty() ?? '',
      updatedAt: this?.updatedAt.orEmpty() ?? '',
    );
  }
}
