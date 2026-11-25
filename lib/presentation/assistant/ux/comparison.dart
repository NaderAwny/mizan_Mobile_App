/// Available tones for comparison chips
enum ComparisonTone { up, down, neutral }

class ComparisonChipData {
  const ComparisonChipData(this.text, this.tone);
  final String text;
  final ComparisonTone tone;
}

/// Defines what statistical period to query for comparison. null = no comparison.
class ComparisonSource {
  const ComparisonSource.daily(this.date)
      : year = null,
        month = null;
  const ComparisonSource.monthly(this.year, this.month) : date = null;

  final DateTime? date;
  final int? year;
  final int? month;
}

/// Determines the comparison source period based on the assistant period
ComparisonSource? comparisonSourceFor(String period, DateTime egyptToday) {
  switch (period) {
    case 'today':
      return ComparisonSource.daily(
        egyptToday.subtract(const Duration(days: 1)),
      );
    case 'yesterday':
      return ComparisonSource.daily(
        egyptToday.subtract(const Duration(days: 2)),
      );
    case 'last_month':
      final DateTime d = DateTime(egyptToday.year, egyptToday.month - 2, 1);
      return ComparisonSource.monthly(d.year, d.month);
    case 'this_month':
      final DateTime d = DateTime(egyptToday.year, egyptToday.month - 1, 1);
      return ComparisonSource.monthly(d.year, d.month);
    default:
      return null;
  }
}

/// Verifies device is in Egypt time zone (UTC+2 or UTC+3 for DST) to prevent date skew
bool isEgyptTimezone(DateTime now) {
  final int hours = now.timeZoneOffset.inHours;
  return hours == 2 || hours == 3;
}

/// Builds comparison chip data following the strict truth & accuracy rules in Section 7
ComparisonChipData? buildComparison({
  required String period,
  required bool isPurchases,
  required double current,
  required double? previous, // null = fetch failed or not available
  required String Function(double) format,
}) {
  if (previous == null) return null;

  // Rule 3: Today is always neutral compared to yesterday without misleading percentage
  if (period == 'today') {
    return ComparisonChipData(
      'امبارح كان ${format(previous)}',
      ComparisonTone.neutral,
    );
  }

  // Rule 5: If previous was 0
  if (previous == 0) {
    return current == 0
        ? null
        : const ComparisonChipData('جديد', ComparisonTone.neutral);
  }

  final double pct = (current - previous) / previous * 100.0;
  if (pct.abs() < 1.0) {
    return const ComparisonChipData('ثابت تقريباً', ComparisonTone.neutral);
  }

  final bool up = pct > 0;
  // Rule 4: Purchases is neutral in both cases; sales is green for up, amber for down
  final ComparisonTone tone = isPurchases
      ? ComparisonTone.neutral
      : (up ? ComparisonTone.up : ComparisonTone.down);

  final String label =
      period == 'yesterday' ? 'عن اليوم اللي قبله' : 'عن الفترة اللي قبلها';
  return ComparisonChipData(
    '${up ? '▲' : '▼'} ${pct.abs().round()}% $label',
    tone,
  );
}
