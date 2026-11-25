/// Service that handles smart domain post-processing, number normalization,
/// terminology correction, and customer name fuzzy matching.
class DomainTextNormalizer {
  // Eastern Arabic/Indic numerals to Western Arabic (0-9)
  static const Map<String, String> _indicToArabicDigits = <String, String>{
    '٠': '0',
    '١': '1',
    '٢': '2',
    '٣': '3',
    '٤': '4',
    '٥': '5',
    '٦': '6',
    '٧': '7',
    '٨': '8',
    '٩': '9',
  };

  /// Common Arabic spoken number word replacements
  static final Map<String, String> _spokenNumbersMap = <String, String>{
    'مليون': '1000000',
    'ألفين ومية': '2100',
    'الفين ومية': '2100',
    'ألفين وخمسمية': '2500',
    'الفين وخمسمية': '2500',
    'ألفين': '2000',
    'الفين': '2000',
    'ألف ومية': '1100',
    'الف ومية': '1100',
    'ألف وخمسمية': '1500',
    'الف وخمسمية': '1500',
    'ثلاثة آلاف': '3000',
    'تلات آلاف': '3000',
    'تلت تلاف': '3000',
    'أربعة آلاف': '4000',
    'اربعة الاف': '4000',
    'خمسة آلاف': '5000',
    'خمس تلاف': '5000',
    'عشرة آلاف': '10000',
    'عشر تلاف': '10000',
    'ألف': '1000',
    'الف': '1000',
    'تسعمية': '900',
    'تمنمية': '800',
    'سبعمية': '700',
    'ستمية': '600',
    'خمسمية': '500',
    'أربعمية': '400',
    'اربعمية': '400',
    'تلتمية': '300',
    'تلتماية': '300',
    'ميتين': '200',
    'متين': '200',
    'مائتين': '200',
    'مية': '100',
    'ميه': '100',
    'مائة': '100',
  };

  /// Domain terms dictionary for speech misrecognition correction
  static final Map<String, String> _domainTerms = <String, String>{
    'اجل': 'آجل',
    'اجلا': 'آجل',
    'نقدا': 'نقدي',
    'نقدى': 'نقدي',
    'اقساط': 'أقساط',
    'فواتير': 'فاتورة',
    'مبيعاته': 'مبيعات',
    'مشترياته': 'مشتريات',
    'متاخرات': 'متأخرات',
  };

  /// Normalizes all Eastern/Indic numerals to standard 0-9 digits
  String normalizeDigits(String text) {
    if (text.isEmpty) return text;
    final StringBuffer buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      final String ch = text[i];
      buffer.write(_indicToArabicDigits[ch] ?? ch);
    }
    return buffer.toString();
  }

  /// Normalizes spoken Arabic numbers into numeric digits
  String normalizeSpokenNumbers(String text) {
    if (text.isEmpty) return text;
    String result = text;
    _spokenNumbersMap.forEach((String spoken, String digit) {
      final RegExp reg = RegExp(r'\b' + RegExp.escape(spoken) + r'\b');
      result = result.replaceAll(reg, digit);
    });
    return result;
  }

  /// Corrects common speech-to-text misrecognitions in commercial terminology
  String correctDomainTerms(String text) {
    if (text.isEmpty) return text;
    String result = text;
    _domainTerms.forEach((String misrecognized, String corrected) {
      final RegExp reg = RegExp(r'\b' + RegExp.escape(misrecognized) + r'\b');
      result = result.replaceAll(reg, corrected);
    });
    return result;
  }

  /// Master normalization pipeline combining digits, numbers, and domain terms
  String process(String rawText) {
    if (rawText.isEmpty) return rawText;
    final String withDigits = normalizeDigits(rawText);
    final String withNumbers = normalizeSpokenNumbers(withDigits);
    final String withTerms = correctDomainTerms(withNumbers);
    return withTerms.trim();
  }

  /// Computes Levenshtein distance between two strings
  int levenshtein(String a, String b) {
    if (a == b) return 0;
    if (a.isEmpty) return b.length;
    if (b.isEmpty) return a.length;

    List<int> v0 = List<int>.generate(b.length + 1, (int i) => i);
    List<int> v1 = List<int>.filled(b.length + 1, 0);

    for (int i = 0; i < a.length; i++) {
      v1[0] = i + 1;
      for (int j = 0; j < b.length; j++) {
        final int cost = (a[i] == b[j]) ? 0 : 1;
        v1[j + 1] = <int>[
          v1[j] + 1,
          v0[j + 1] + 1,
          v0[j] + cost,
        ].reduce((int curr, int next) => curr < next ? curr : next);
      }
      v0 = List<int>.from(v1);
    }
    return v1[b.length];
  }

  /// Finds fuzzy suggestions for words close to customer names in the database
  Map<String, List<String>> findCustomerSuggestions(
    String text,
    List<String> knownCustomers,
  ) {
    if (text.isEmpty || knownCustomers.isEmpty) return const <String, List<String>>{};

    final Map<String, List<String>> suggestions = <String, List<String>>{};
    final List<String> words = text.split(RegExp(r'\s+'));

    for (final String word in words) {
      final String cleanWord = word.replaceAll(RegExp(r'[^\w\u0600-\u06FF]'), '');
      if (cleanWord.length < 3) continue;

      for (final String customer in knownCustomers) {
        final String cleanCust = customer.trim();
        if (cleanCust.isEmpty) continue;

        // Compare with full customer name or single words in customer name
        final List<String> custWords = cleanCust.split(RegExp(r'\s+'));
        for (final String cWord in custWords) {
          if (cWord.length < 3) continue;
          final int dist = levenshtein(cleanWord, cWord);
          if (dist > 0 && dist <= 2) {
            suggestions.putIfAbsent(word, () => <String>[]).add(cleanCust);
            break;
          }
        }
      }
    }

    return suggestions;
  }

  /// Detects if the transcript represents a financial operation that requires
  /// explicit pre-execution user confirmation
  bool isFinancialOperation(String text) {
    final String lower = text.toLowerCase();
    final List<String> keywords = <String>[
      'بيع',
      'شراء',
      'اشتريت',
      'تحصيل',
      'حصلت',
      'استلمت',
      'دفع',
      'دفعت',
      'سددت',
      'سجل بيع',
      'سجل شراء',
      'احذف',
      'حذف',
      'قسط',
    ];

    for (final String kw in keywords) {
      if (lower.contains(kw)) return true;
    }
    return false;
  }
}
