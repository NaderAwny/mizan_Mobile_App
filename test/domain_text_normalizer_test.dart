import 'package:flutter_test/flutter_test.dart';
import 'package:mizan/app/domain_text_normalizer.dart';

void main() {
  group('DomainTextNormalizer Tests', () {
    late DomainTextNormalizer normalizer;

    setUp(() {
      normalizer = DomainTextNormalizer();
    });

    test('Normalizes Indic/Arabic digits accurately', () {
      expect(normalizer.normalizeDigits('١٢٣٤٥٦٧٨٩٠'), '1234567890');
      expect(normalizer.normalizeDigits('المبلغ ٥٠٠ ج.م'), 'المبلغ 500 ج.م');
    });

    test('Normalizes spoken Arabic numbers into digits', () {
      expect(normalizer.normalizeSpokenNumbers('سجل بيع ألفين ومية'), 'سجل بيع 2100');
      expect(normalizer.normalizeSpokenNumbers('حصلت خمسمية من أحمد'), 'حصلت 500 من أحمد');
      expect(normalizer.normalizeSpokenNumbers('خمسة آلاف'), '5000');
    });

    test('Corrects commercial domain terms', () {
      expect(normalizer.correctDomainTerms('بيع اجل نقدا'), 'بيع آجل نقدي');
      expect(normalizer.correctDomainTerms('فواتير واقساط ومتاخرات'), 'فاتورة وأقساط ومتأخرات');
    });

    test('Identifies financial operations correctly', () {
      expect(normalizer.isFinancialOperation('سجل بيع ب 500 جنيه لمحمد'), isTrue);
      expect(normalizer.isFinancialOperation('دفعت للمورد 2000'), isTrue);
      expect(normalizer.isFinancialOperation('احذف المعاملة رقم 12'), isTrue);
      expect(normalizer.isFinancialOperation('إجمالي مبيعات النهارده كام؟'), isFalse);
    });

    test('Fuzzy matches customer names accurately', () {
      final List<String> customers = <String>['أحمد محمود', 'إبراهيم علي', 'مينا فؤاد'];
      // 'احمد' (without hamza) vs 'أحمد' has distance 1
      final Map<String, List<String>> suggestions =
          normalizer.findCustomerSuggestions('بيع ل احمد ب 100', customers);
      expect(suggestions.isNotEmpty, isTrue);
      expect(suggestions.values.first, contains('أحمد محمود'));
    });
  });
}
