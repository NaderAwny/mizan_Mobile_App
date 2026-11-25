import 'package:intl/intl.dart';
import 'package:mizan/app/di.dart';
import 'package:mizan/domain/model/statistics_model/statistics_model.dart';
import 'package:mizan/domain/use_case/get_daily_statistics.dart';
import 'package:mizan/domain/use_case/monthly_statistics_use_case.dart';
import 'package:mizan/presentation/assistant/ux/comparison.dart';

/// ComparisonFetcher — Asynchronously fetches historical statistics for comparison chips
/// with a 60-second in-memory cache and non-blocking failure tolerance.
class ComparisonFetcher {
  static final Map<String, (DateTime, double)> _cache =
      <String, (DateTime, double)>{};

  static Future<double?> fetchPreviousValue({
    required ComparisonSource source,
    required bool isPurchases,
  }) async {
    final String cacheKey =
        '${source.date?.toIso8601String()}_${source.year}_${source.month}_$isPurchases';
    final DateTime now = DateTime.now();

    // Check 60-second cache
    if (_cache.containsKey(cacheKey)) {
      final (DateTime cachedAt, double cachedVal) = _cache[cacheKey]!;
      if (now.difference(cachedAt).inSeconds < 60) {
        return cachedVal;
      }
    }

    try {
      if (source.date != null) {
        final String dateStr = DateFormat('yyyy-MM-dd').format(source.date!);
        final DailyStatisticsUseCase useCase = getIt<DailyStatisticsUseCase>();
        final res = await useCase.execute(dateStr);
        return res.fold(
          (_) => null,
          (StatisticsPageModel stats) {
            final double val = isPurchases
                ? (stats.totalPurchases?.toDouble() ?? 0.0)
                : (stats.totalSales?.toDouble() ?? 0.0);
            _cache[cacheKey] = (now, val);
            return val;
          },
        );
      } else if (source.year != null && source.month != null) {
        final MonthlyStatisticsUseCase useCase =
            getIt<MonthlyStatisticsUseCase>();
        final res = await useCase.execute(
          MonthlyStatisticsInput(
            year: source.year.toString(),
            month: source.month.toString(),
          ),
        );
        return res.fold(
          (_) => null,
          (StatisticsPageModel stats) {
            final double val = isPurchases
                ? (stats.totalPurchases?.toDouble() ?? 0.0)
                : (stats.totalSales?.toDouble() ?? 0.0);
            _cache[cacheKey] = (now, val);
            return val;
          },
        );
      }
    } catch (_) {
      return null;
    }
    return null;
  }
}
