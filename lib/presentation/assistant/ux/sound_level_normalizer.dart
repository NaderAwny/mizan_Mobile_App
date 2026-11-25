import 'dart:collection';
import 'dart:math' as math;

/// SoundLevelNormalizer — Normalizes raw microphone levels over a sliding time window (default 3 seconds)
/// to produce a smooth, calibrated 0.0 .. 1.0 value regardless of device hardware differences.
class SoundLevelNormalizer {
  SoundLevelNormalizer({
    this.window = const Duration(seconds: 3),
    this.minRange = 3.0,
  });

  final Duration window;
  final double minRange; // Minimum dynamic range to prevent amplifying ambient silence
  final Queue<(DateTime, double)> _samples = Queue<(DateTime, double)>();

  double normalize(double raw, DateTime now) {
    _samples.addLast((now, raw));
    while (_samples.isNotEmpty && now.difference(_samples.first.$1) > window) {
      _samples.removeFirst();
    }

    double lo = raw;
    double hi = raw;
    for (final (DateTime, double) s in _samples) {
      if (s.$2 < lo) lo = s.$2;
      if (s.$2 > hi) hi = s.$2;
    }

    final double range = math.max(hi - lo, minRange);
    return ((raw - lo) / range).clamp(0.0, 1.0);
  }

  void reset() {
    _samples.clear();
  }
}
