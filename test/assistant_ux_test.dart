import 'package:flutter_test/flutter_test.dart';
import 'package:mizan/presentation/assistant/ux/comparison.dart';
import 'package:mizan/presentation/assistant/ux/sound_level_normalizer.dart';
import 'package:mizan/presentation/assistant/ux/suggestions.dart';

void main() {
  group('SoundLevelNormalizer Tests', () {
    test('normalizes raw level within range 0.0 to 1.0', () {
      final normalizer = SoundLevelNormalizer(
        window: const Duration(seconds: 3),
        minRange: 10.0,
      );
      final now = DateTime.now();

      final val1 = normalizer.normalize(0.0, now);
      final val2 = normalizer.normalize(10.0, now.add(const Duration(milliseconds: 100)));
      final val3 = normalizer.normalize(5.0, now.add(const Duration(milliseconds: 200)));

      expect(val1, inInclusiveRange(0.0, 1.0));
      expect(val2, equals(1.0));
      expect(val3, equals(0.5));
    });

    test('evicts samples older than window duration', () {
      final normalizer = SoundLevelNormalizer(
        window: const Duration(seconds: 1),
        minRange: 5.0,
      );
      final t0 = DateTime.now();

      normalizer.normalize(100.0, t0);
      // Advance by 2 seconds
      final t1 = t0.add(const Duration(seconds: 2));
      final val = normalizer.normalize(2.0, t1);

      // Old 100.0 is evicted
      expect(val, inInclusiveRange(0.0, 1.0));
    });
  });

  group('Comparison Logic Tests (Truth & Rules)', () {
    test('today returns neutral comparison without percentage', () {
      final chip = buildComparison(
        period: 'today',
        isPurchases: false,
        current: 6270.0,
        previous: 5200.0,
        format: (v) => v.toStringAsFixed(0),
      );

      expect(chip, isNotNull);
      expect(chip!.tone, equals(ComparisonTone.neutral));
      expect(chip.text, equals('امبارح كان 5200'));
    });

    test('yesterday returns percentage with up tone for sales', () {
      final chip = buildComparison(
        period: 'yesterday',
        isPurchases: false,
        current: 6000.0,
        previous: 5000.0,
        format: (v) => v.toStringAsFixed(0),
      );

      expect(chip, isNotNull);
      expect(chip!.tone, equals(ComparisonTone.up));
      expect(chip.text, contains('▲ 20% عن اليوم اللي قبله'));
    });

    test('yesterday returns down tone for sales decrease', () {
      final chip = buildComparison(
        period: 'yesterday',
        isPurchases: false,
        current: 4000.0,
        previous: 5000.0,
        format: (v) => v.toStringAsFixed(0),
      );

      expect(chip, isNotNull);
      expect(chip!.tone, equals(ComparisonTone.down));
      expect(chip.text, contains('▼ 20% عن اليوم اللي قبله'));
    });

    test('purchases comparison is always neutral tone', () {
      final chipUp = buildComparison(
        period: 'yesterday',
        isPurchases: true,
        current: 6000.0,
        previous: 5000.0,
        format: (v) => v.toStringAsFixed(0),
      );
      final chipDown = buildComparison(
        period: 'yesterday',
        isPurchases: true,
        current: 4000.0,
        previous: 5000.0,
        format: (v) => v.toStringAsFixed(0),
      );

      expect(chipUp!.tone, equals(ComparisonTone.neutral));
      expect(chipDown!.tone, equals(ComparisonTone.neutral));
    });

    test('returns null if previous value is null', () {
      final chip = buildComparison(
        period: 'today',
        isPurchases: false,
        current: 1000.0,
        previous: null,
        format: (v) => v.toStringAsFixed(0),
      );

      expect(chip, isNull);
    });

    test('returns جديد if previous was 0 and current > 0', () {
      final chip = buildComparison(
        period: 'yesterday',
        isPurchases: false,
        current: 1000.0,
        previous: 0.0,
        format: (v) => v.toStringAsFixed(0),
      );

      expect(chip, isNotNull);
      expect(chip!.text, equals('جديد'));
      expect(chip.tone, equals(ComparisonTone.neutral));
    });

    test('returns ثابت تقريباً if percentage difference is < 1%', () {
      final chip = buildComparison(
        period: 'yesterday',
        isPurchases: false,
        current: 1000.5,
        previous: 1000.0,
        format: (v) => v.toStringAsFixed(0),
      );

      expect(chip, isNotNull);
      expect(chip!.text, equals('ثابت تقريباً'));
    });

    test('comparisonSourceFor maps periods accurately', () {
      final now = DateTime(2026, 11, 23);
      final sToday = comparisonSourceFor('today', now);
      expect(sToday?.date, equals(DateTime(2026, 11, 22)));

      final sYest = comparisonSourceFor('yesterday', now);
      expect(sYest?.date, equals(DateTime(2026, 11, 21)));

      final sMonth = comparisonSourceFor('this_month', now);
      expect(sMonth?.month, equals(10));
      expect(sMonth?.year, equals(2026));

      final sUnsupported = comparisonSourceFor('this_week', now);
      expect(sUnsupported, isNull);
    });
  });

  group('Suggestions Logic Tests', () {
    test('does not return suggestions for confirmation, error, or question', () {
      expect(suggestionsFor(type: 'confirmation', data: {}), isEmpty);
      expect(suggestionsFor(type: 'question', data: {}), isEmpty);
      expect(suggestionsFor(type: 'error', data: {}), isEmpty);
      expect(suggestionsFor(type: 'clarification', data: {}), isEmpty);
      expect(suggestionsFor(type: 'cancelled', data: {}), isEmpty);
    });

    test('does not return suggestions when data is a list (multi-tool)', () {
      expect(suggestionsFor(type: 'answer', data: [1, 2, 3]), isEmpty);
    });

    test('returns suggestions for today sales and filters lastUserText', () {
      final suggestions = suggestionsFor(
        type: 'answer',
        data: {'metric': 'sales', 'period': 'today'},
        lastUserText: 'امبارح حصل إيه؟',
      );

      expect(suggestions, isNotEmpty);
      expect(suggestions.length, lessThanOrEqualTo(3));
      // Should not include the same text user just asked
      expect(suggestions.any((s) => s.label == 'امبارح حصل إيه؟'), isFalse);
    });

    test('returns success suggestions after action is completed', () {
      final suggestions = suggestionsFor(
        type: 'success',
        data: {},
      );

      expect(suggestions.length, equals(2));
      expect(suggestions[0].label, equals('مبيعات النهارده كام؟'));
      expect(suggestions[1].label, equals('مين متأخر عليا؟'));
    });
  });
}
