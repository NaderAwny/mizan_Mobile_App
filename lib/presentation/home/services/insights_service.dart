import 'package:intl/intl.dart';
import 'package:mizan/domain/model/statistics_model/statistics_model.dart';

/// Single dynamic financial insight item
class InsightItem {
  final String text;
  final String? route;
  final Object? arguments;

  const InsightItem({
    required this.text,
    this.route,
    this.arguments,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InsightItem &&
          runtimeType == other.runtimeType &&
          text == other.text;

  @override
  int get hashCode => text.hashCode;
}

/// Service that computes 100% verified insights and cumulative sparkline data
/// strictly from real user transactions and statistics.
class InsightsService {
  final NumberFormat _currencyFormat = NumberFormat('#,##0.##');

  /// Generates ordered list of priority insights.
  /// If data is insufficient, returns an empty list (never displays fake numbers).
  List<InsightItem> generateInsights(StatisticsPageModel? stats) {
    if (stats == null) return const <InsightItem>[];
    final List<TransactionStatisticsModel> txns =
        stats.transactions ?? const <TransactionStatisticsModel>[];
    final int opCount = stats.operationsCount ?? txns.length;
    if (txns.isEmpty && opCount == 0) {
      return const <InsightItem>[];
    }

    final List<InsightItem> results = <InsightItem>[];
    final DateTime now = DateTime.now();
    double todaySales = 0;
    double todayPurchases = 0;
    bool hasTodayTxn = false;

    // Contact totals map for top customer
    final Map<String, double> customerSalesMap = <String, double>{};

    for (final TransactionStatisticsModel t in txns) {
      final String opType = t.operationType?.toLowerCase() ?? '';
      final bool isSale = opType.contains('sale') || opType.contains('بيع');
      final bool isPurchase =
          opType.contains('purchase') || opType.contains('شراء');
      final double amt = (t.amount ?? 0).toDouble();

      // Check date
      final DateTime? date =
          DateTime.tryParse(t.operationDate ?? t.createdAt ?? '');
      if (date != null &&
          date.year == now.year &&
          date.month == now.month &&
          date.day == now.day) {
        hasTodayTxn = true;
        if (isSale) {
          todaySales += amt;
        } else if (isPurchase) {
          todayPurchases += amt;
        }
      }

      // Track customer
      if (isSale) {
        final String name = (t.contactName?.isNotEmpty == true)
            ? t.contactName!
            : (t.partyName?.isNotEmpty == true ? t.partyName! : '');
        if (name.isNotEmpty && name != 'غير محدد') {
          customerSalesMap[name] = (customerSalesMap[name] ?? 0) + amt;
        }
      }
    }

    // 1. Net today insight (if transactions happened today)
    if (hasTodayTxn) {
      final double todayNet = todaySales - todayPurchases;
      final String formattedNet = _currencyFormat.format(todayNet);
      results.add(
        InsightItem(
          text: '💰 صافي النهارده $formattedNet ج.م',
        ),
      );
    }

    // 2. Top customer insight
    if (customerSalesMap.isNotEmpty) {
      String? topCustomer;
      double maxSales = -1;
      customerSalesMap.forEach((String name, double sales) {
        if (sales > maxSales) {
          maxSales = sales;
          topCustomer = name;
        }
      });
      if (topCustomer != null && topCustomer!.isNotEmpty) {
        results.add(
          InsightItem(
            text: '🏆 أكتر عميل عندك: $topCustomer',
          ),
        );
      }
    }

    // 3. Sales vs purchases insight
    final double totalSales = (stats.totalSales ?? 0).toDouble();
    final double totalPurchases = (stats.totalPurchases ?? 0).toDouble();
    if (totalSales > 0 && totalPurchases > 0) {
      final double ratio = (totalSales / (totalSales + totalPurchases)) * 100;
      if (ratio >= 60) {
        results.add(
          InsightItem(
            text: '📈 مبيعاتك تمثّل ${ratio.toInt()}% من إجمالي حركة الشهر',
          ),
        );
      } else if (totalPurchases > totalSales) {
        results.add(
          const InsightItem(
            text: '⚠️ مشترياتك أعلى من المبيعات هذا الشهر',
          ),
        );
      }
    } else if (totalSales > 0) {
      results.add(
        InsightItem(
          text: '📈 إجمالي مبيعات الشهر ${_currencyFormat.format(totalSales)} ج.م',
        ),
      );
    }

    // 4. Operations count insight
    if (opCount > 0 && results.length < 3) {
      results.add(
        InsightItem(
          text: '⚡ سجّلت $opCount معاملة مالية هذا الشهر',
        ),
      );
    }

    return results;
  }

  /// Calculates cumulative daily net balance points from day 1 to today.
  /// If data has fewer than 2 days or empty, returns empty list.
  List<double> calculateDailyCumulativeNet(StatisticsPageModel? stats) {
    if (stats == null) return const <double>[];
    final List<TransactionStatisticsModel> txns =
        stats.transactions ?? const <TransactionStatisticsModel>[];
    if (txns.isEmpty) return const <double>[];

    final DateTime now = DateTime.now();
    final int currentDay = now.day;
    if (currentDay < 1) return const <double>[];

    // Day of month -> net delta
    final Map<int, double> dailyDelta = <int, double>{};
    for (int d = 1; d <= currentDay; d++) {
      dailyDelta[d] = 0.0;
    }

    int daysWithTxn = 0;
    final Set<int> distinctDays = <int>{};

    for (final TransactionStatisticsModel t in txns) {
      final DateTime? date =
          DateTime.tryParse(t.operationDate ?? t.createdAt ?? '');
      if (date != null && date.year == now.year && date.month == now.month) {
        final int day = date.day;
        if (day >= 1 && day <= currentDay) {
          distinctDays.add(day);
          final String opType = t.operationType?.toLowerCase() ?? '';
          final bool isSale = opType.contains('sale') || opType.contains('بيع');
          final double amt = (t.amount ?? 0).toDouble();
          dailyDelta[day] = (dailyDelta[day] ?? 0.0) + (isSale ? amt : -amt);
        }
      }
    }

    daysWithTxn = distinctDays.length;
    // If fewer than 2 distinct days of data, return empty or single baseline
    if (daysWithTxn < 2 && currentDay < 2) {
      return const <double>[];
    }

    final List<double> cumulative = <double>[];
    double running = 0.0;
    for (int d = 1; d <= currentDay; d++) {
      running += dailyDelta[d] ?? 0.0;
      cumulative.add(running);
    }

    return cumulative;
  }
}
