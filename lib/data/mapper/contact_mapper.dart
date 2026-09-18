import 'package:mizan/app/extensions.dart';
import 'package:mizan/data/response/contact_responses/contact_responses.dart';
import 'package:mizan/domain/model/contact_model.dart';

extension ContactResponseMapper on ContactData? {
  Contact toDomain() {
    return Contact(
      id: this?.id.orEmpty() ?? '',
      name: this?.name.orEmpty() ?? '',
      phoneNumber: this?.phoneNumber.orEmpty() ?? '',
      notes: this?.notes.orEmpty() ?? '',
      isVip: this?.isVip.orFalse() ?? false,
      contactEmail: this?.contactEmail.orEmpty() ?? '',
      createdAt: this?.createdAt.orEmpty() ?? '',
      updatedAt: this?.updatedAt.orEmpty() ?? '',
    );
  }
}

extension ContactsPageResponseMapper on ContactsPageData? {
  ContactsPage toDomain() {
    return ContactsPage(
      items: (this?.items?.map((contact) => contact.toDomain()) ?? const []).toList(),
      totalCount: this?.totalCount.orZero() ?? 0,
      page: this?.page.orZero() ?? 1,
      pageSize: this?.pageSize.orZero() ?? 20,
      totalPages: this?.totalPages.orZero() ?? 1,
    );
  }
}

extension ContactTransactionResponseMapper on ContactTransactionData? {
  ContactTransaction toDomain() {
    return ContactTransaction(
      id: this?.id.orEmpty() ?? '',
      partyName: this?.partyName.orEmpty() ?? '',
      type: this?.type.orEmpty() ?? '',
      amount: this?.amount.orZeroNum() ?? 0,
      paymentMethod: this?.paymentMethod.orEmpty() ?? '',
      transactionDate: this?.transactionDate.orEmpty() ?? '',
    );
  }
}

extension ContactProfileResponseMapper on ContactProfileData? {
  ContactProfile toDomain() {
    return ContactProfile(
      contactId: this?.contactId.orEmpty() ?? '',
      contactName: this?.contactName.orEmpty() ?? '',
      phoneNumber: this?.phoneNumber.orEmpty() ?? '',
      notes: this?.notes.orEmpty() ?? '',
      contactEmail: this?.contactEmail.orEmpty() ?? '',
      isVip: this?.isVip.orFalse() ?? false,
      totalTransactions: this?.totalTransactions.orZero() ?? 0,
      totalAmount: this?.totalAmount.orZeroNum() ?? 0,
      transactions: (this?.transactions?.map((t) => t.toDomain()) ?? const []).toList(),
    );
  }
}
