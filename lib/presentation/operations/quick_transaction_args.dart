class QuickTransactionArgs {
  final String? contactId;
  final String? contactName;
  final bool isVip;
  final String? initialType; // "Sale" or "Purchase"

  const QuickTransactionArgs({
    this.contactId,
    this.contactName,
    this.isVip = false,
    this.initialType,
  });
}

String formatArabicDate(DateTime date) {
  const months = [
    'يناير',
    'فبراير',
    'مارس',
    'أبريل',
    'مايو',
    'يونيو',
    'يوليو',
    'أغسطس',
    'سبتمبر',
    'أكتوبر',
    'نوفمبر',
    'ديسمبر'
  ];
  return "${date.day} ${months[date.month - 1]} ${date.year}";
}

String formatNumericDate(DateTime date) {
  return "${date.year}/${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}";
}
