import 'package:mizan/app/extensions.dart';
import 'package:mizan/data/response/transaction_responses/transaction_responses.dart';
import 'package:mizan/domain/model/transaction_model.dart';

extension InstallmentResponseMapper on InstallmentData? {
  Installment toDomain() {
    return Installment(
      id: this?.id.orEmpty() ?? '',
      installmentNumber: this?.installmentNumber.orZero() ?? 0,
      amount: this?.amount.orZeroNum() ?? 0,
      dueDate: this?.dueDate.orEmpty() ?? '',
      isPaid: this?.isPaid.orFalse() ?? false,
      status: this?.status.orEmpty() ?? '',
    );
  }
}

extension TransactionResponseMapper on TransactionData? {
  Transaction toDomain() {
    return Transaction(
      id: this?.id.orEmpty() ?? '',
      contactId: this?.contactId.orEmpty() ?? '',
      contactName: this?.contactName.orEmpty() ?? '',
      type: this?.type.orEmpty() ?? '',
      amount: this?.amount.orZeroNum() ?? 0,
      paymentMethod: this?.paymentMethod.orEmpty() ?? '',
      transactionDate: this?.transactionDate.orEmpty() ?? '',
      isInstallment: this?.isInstallment.orFalse() ?? false,
      installments:
          (this?.installments?.map((i) => i.toDomain()) ?? const []).toList(),
      createdAt: this?.createdAt.orEmpty() ?? '',
    );
  }
}
