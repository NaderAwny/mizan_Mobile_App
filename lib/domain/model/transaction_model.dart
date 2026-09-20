class Installment {
  final String id;
  final int installmentNumber;
  final num amount;
  final String dueDate;
  final bool isPaid;
  final String status;

  const Installment({
    required this.id,
    required this.installmentNumber,
    required this.amount,
    required this.dueDate,
    required this.isPaid,
    required this.status,
  });
}

class Transaction {
  final String id;
  final String contactId;
  final String contactName;
  final String type;
  final num amount;
  final String paymentMethod;
  final String transactionDate;
  final bool isInstallment;
  final List<Installment> installments;
  final String createdAt;

  const Transaction({
    required this.id,
    required this.contactId,
    required this.contactName,
    required this.type,
    required this.amount,
    required this.paymentMethod,
    required this.transactionDate,
    required this.isInstallment,
    required this.installments,
    required this.createdAt,
  });
}
