class CustomInstallmentItem {
  final num amount;
  final String dueDate; // ISO-8601

  CustomInstallmentItem({required this.amount, required this.dueDate});

  Map<String, dynamic> toJson() => {
    'amount': amount,
    'dueDate': dueDate,
  };
}

class CreateTransactionRequest {
  final String? contactId;
  final String? partyName;
  final String type; // "Sale" | "Purchase"
  final num amount;
  final String paymentMethod; // "Cash" | "Installments"
  final String transactionDate; // ISO-8601
  final String? noteText;

  final bool isInstallment;
  final String? installmentPlanMode; // "Automatic" | "Custom" | null

  // Automatic فقط
  final int? installmentCount;
  final String? frequency; // "Weekly" | "Monthly" | "Yearly"
  final String? firstInstallmentDate;

  // Custom فقط
  final List<CustomInstallmentItem>? customInstallments;

  CreateTransactionRequest({
    this.contactId,
    this.partyName,
    required this.type,
    required this.amount,
    required this.paymentMethod,
    required this.transactionDate,
    this.noteText,
    this.isInstallment = false,
    this.installmentPlanMode,
    this.installmentCount,
    this.frequency,
    this.firstInstallmentDate,
    this.customInstallments,
  });

  Map<String, dynamic> toBody() => {
    if (contactId != null) 'contactId': contactId,
    if (partyName != null) 'partyName': partyName,
    'type': type,
    'amount': amount,
    'paymentMethod': paymentMethod,
    'transactionDate': transactionDate,
    if (noteText != null) 'noteText': noteText,
    'isInstallment': isInstallment,
    if (installmentPlanMode != null) 'installmentPlanMode': installmentPlanMode,
    if (installmentCount != null) 'installmentCount': installmentCount,
    if (frequency != null) 'frequency': frequency,
    if (firstInstallmentDate != null)
      'firstInstallmentDate': firstInstallmentDate,
    if (customInstallments != null)
      'customInstallments':
          customInstallments!.map((e) => e.toJson()).toList(),
  };
}
