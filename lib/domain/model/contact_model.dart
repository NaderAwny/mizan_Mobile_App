class Contact {
  final String id;
  final String name;
  final String phoneNumber;
  final String notes;
  final bool isVip;
  final String contactEmail;
  final String createdAt;
  final String updatedAt;

  const Contact({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.notes,
    required this.isVip,
    required this.contactEmail,
    required this.createdAt,
    required this.updatedAt,
  });
}

class ContactsPage {
  final List<Contact> items;
  final int totalCount;
  final int page;
  final int pageSize;
  final int totalPages;

  const ContactsPage({
    required this.items,
    required this.totalCount,
    required this.page,
    required this.pageSize,
    required this.totalPages,
  });
}

class ContactProfile {
  final String contactId;
  final String contactName;
  final String phoneNumber;
  final String notes;
  final String contactEmail;
  final bool isVip;
  final int totalTransactions;
  final num totalAmount;
  final List<ContactTransaction> transactions;

  const ContactProfile({
    required this.contactId,
    required this.contactName,
    required this.phoneNumber,
    this.notes = '',
    required this.contactEmail,
    required this.isVip,
    required this.totalTransactions,
    required this.totalAmount,
    required this.transactions,
  });

  ContactProfile copyWith({
    String? contactId,
    String? contactName,
    String? phoneNumber,
    String? notes,
    String? contactEmail,
    bool? isVip,
    int? totalTransactions,
    num? totalAmount,
    List<ContactTransaction>? transactions,
  }) {
    return ContactProfile(
      contactId: contactId ?? this.contactId,
      contactName: contactName ?? this.contactName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      notes: notes ?? this.notes,
      contactEmail: contactEmail ?? this.contactEmail,
      isVip: isVip ?? this.isVip,
      totalTransactions: totalTransactions ?? this.totalTransactions,
      totalAmount: totalAmount ?? this.totalAmount,
      transactions: transactions ?? this.transactions,
    );
  }
}

class ContactTransaction {
  final String id;
  final String partyName;
  final String type;
  final num amount;
  final String paymentMethod;
  final String transactionDate;

  const ContactTransaction({
    required this.id,
    required this.partyName,
    required this.type,
    required this.amount,
    required this.paymentMethod,
    required this.transactionDate,
  });
}
