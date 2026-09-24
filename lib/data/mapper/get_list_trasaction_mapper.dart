import 'package:mizan/app/extensions.dart';
import 'package:mizan/data/response/get_list_transaction_responses/get_list_transaction_responses.dart';
import 'package:mizan/domain/model/get_list_transactions_model.dart';

extension GetListTransactionsModelMapper on GetListTransactionData? {
  GetListTransactionsModel toDomain() {
    return GetListTransactionsModel(
      id: this?.id.orEmpty() ?? '',
      contactId: this?.contactId.orEmpty() ?? '',
      contactName: this?.contactName.orEmpty() ?? '',
      type: this?.type.orEmpty() ?? '',
      amount: this?.amount.orZeroNum() ?? 0,
      paymentMethod: this?.paymentMethod.orEmpty() ?? '',
      transactionDate: this?.transactionDate.orEmpty() ?? '',
      isInstallment: this?.isInstallment.orFalse() ?? false,
      createdAt: this?.createdAt.orEmpty() ?? '',
    );
  }
}

extension TransactionsPageMapper on GetListTransactionsPageData? {
  GetListTransactionsPage toDomain() {
    return GetListTransactionsPage(
      items: (this?.items?.map((contact) => contact.toDomain()) ?? const [])
          .toList(),
      totalCount: this?.totalCount.orZero() ?? 0,
      page: this?.page.orZero() ?? 1,
      pageSize: this?.pageSize.orZero() ?? 20,
      totalPages: this?.totalPages.orZero() ?? 1,
    );
  }
}
