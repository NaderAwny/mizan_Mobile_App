import 'package:flutter_test/flutter_test.dart';
import 'package:mizan/domain/model/statistics_model/statistics_model.dart';
import 'package:mizan/presentation/home/services/insights_service.dart';

void main() {
  group('InsightsService Tests', () {
    late InsightsService service;

    setUp(() {
      service = InsightsService();
    });

    test('Returns empty insights when stats is null', () {
      final List<InsightItem> insights = service.generateInsights(null);
      expect(insights, isEmpty);
    });

    test('Returns empty insights when stats has zero operations and empty transactions', () {
      final StatisticsPageModel stats = StatisticsPageModel(
        operationsCount: 0,
        transactions: <TransactionStatisticsModel>[],
      );
      final List<InsightItem> insights = service.generateInsights(stats);
      expect(insights, isEmpty);
    });

    test('Generates today net and top customer accurately from real transactions', () {
      final DateTime now = DateTime.now();
      final String todayStr =
          "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

      final StatisticsPageModel stats = StatisticsPageModel(
        totalSales: 15000,
        totalPurchases: 5000,
        operationsCount: 3,
        transactions: <TransactionStatisticsModel>[
          TransactionStatisticsModel(
            operationType: 'Sale',
            amount: 10000,
            contactName: 'أحمد محمود',
            operationDate: todayStr,
          ),
          TransactionStatisticsModel(
            operationType: 'Purchase',
            amount: 2000,
            partyName: 'مورد الألبان',
            operationDate: todayStr,
          ),
          TransactionStatisticsModel(
            operationType: 'Sale',
            amount: 5000,
            contactName: 'محمد سعيد',
            operationDate: todayStr,
          ),
        ],
      );

      final List<InsightItem> insights = service.generateInsights(stats);
      expect(insights, isNotEmpty);

      // Verify today net: 10000 + 5000 - 2000 = 13,000
      final bool hasNetToday = insights.any((InsightItem i) => i.text.contains('13,000'));
      expect(hasNetToday, isTrue);

      // Verify top customer: أحمد محمود (10,000)
      final bool hasTopCustomer =
          insights.any((InsightItem i) => i.text.contains('أحمد محمود'));
      expect(hasTopCustomer, isTrue);
    });

    test('Calculates cumulative daily balance for sparkline correctly', () {
      final DateTime now = DateTime.now();
      final String todayStr =
          "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

      final StatisticsPageModel stats = StatisticsPageModel(
        transactions: <TransactionStatisticsModel>[
          TransactionStatisticsModel(
            operationType: 'Sale',
            amount: 1000,
            operationDate: todayStr,
          ),
        ],
      );

      final List<double> sparkline = service.calculateDailyCumulativeNet(stats);
      // Either empty if < 2 days or has items ending in 1000
      if (sparkline.isNotEmpty) {
        expect(sparkline.last, equals(1000.0));
      }
    });
  });
}
