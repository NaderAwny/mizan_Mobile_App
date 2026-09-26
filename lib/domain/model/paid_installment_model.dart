/// Domain model for a successfully paid installment
class PaidInstallmentModel {
  final String id;
  final int installmentNumber;
  final num amount;
  final String dueDate;
  final bool isPaid;
  final String paidAt;
  final String status; // "Paid"

  const PaidInstallmentModel({
    required this.id,
    required this.installmentNumber,
    required this.amount,
    required this.dueDate,
    required this.isPaid,
    required this.paidAt,
    required this.status,
  });
}
