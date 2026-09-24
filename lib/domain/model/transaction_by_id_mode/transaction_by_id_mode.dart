class InstallmentbyidModel {
  final String? id;
  final int? installmentNumber;
  final num? amount;
  final String? dueDate;
  final bool? isPaid;
  final String? status; // "Pending" | "Paid" | "Overdue"
  final String? paidAt; // "" when null

  const InstallmentbyidModel({
    this.id,
    this.installmentNumber,
    this.amount,
    this.dueDate,
    this.isPaid,
    this.status,
    this.paidAt,
  });
}

class TransactionbyidModel {
  final String? id;
  final String? shopId;
  final String? contactId;
  final String? contactName;
  final String? partyName;
  final String? type;
  final num? amount;
  final String? paymentMethod;
  final String? transactionDate;
  final bool? isInstallment;
  final String? installmentPlanMode; // "Automatic" | "Custom" | ""
  final String? noteType;
  final String? noteText;
  final bool? hasVoiceNote;
  final List<InstallmentbyidModel>? installments;
  final num? totalPaid;
  final num? totalRemaining;
  final bool? isActive;
  final String? createdAt;
  final String? updatedAt;

  const TransactionbyidModel({
    this.id,
    this.shopId,
    this.contactId,
    this.contactName,
    this.partyName,
    this.type,
    this.amount,
    this.paymentMethod,
    this.transactionDate,
    this.isInstallment,
    this.installmentPlanMode,
    this.noteType,
    this.noteText,
    this.hasVoiceNote,
    this.installments,
    this.totalPaid,
    this.totalRemaining,
    this.isActive,
    this.createdAt,
    this.updatedAt,
  });
}
