import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:mizan/presentation/resources/color_manager.dart';

/// Animated sparkline widget showing cumulative daily balance progression.
class SparklineWidget extends StatelessWidget {
  final List<double> points;
  final double progress; // 0.0 to 1.0

  const SparklineWidget({
    super.key,
    required this.points,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    if (points.length < 2) {
      return const SizedBox.shrink();
    }

    return RepaintBoundary(
      child: CustomPaint(
        painter: _SparklinePainter(
          points: points,
          progress: progress,
        ),
      ),
    );
  }
}

class _SparklinePainter extends CustomPainter {
  final List<double> points;
  final double progress;

  _SparklinePainter({
    required this.points,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty || progress <= 0.0) return;

    final double minVal = points.reduce((double a, double b) => a < b ? a : b);
    final double maxVal = points.reduce((double a, double b) => a > b ? a : b);
    final double valRange = (maxVal - minVal).abs();

    final double width = size.width;
    final double height = size.height;
    final double paddingY = height * 0.15;
    final double usableHeight = height - (paddingY * 2);

    final Path fullPath = Path();
    final List<Offset> coordinates = <Offset>[];

    final int n = points.length;
    final double dx = n > 1 ? width / (n - 1) : width;

    for (int i = 0; i < n; i++) {
      final double normalized =
          valRange > 0.0001 ? (points[i] - minVal) / valRange : 0.5;
      // Invert Y so higher values are higher up visually
      final double y = height - paddingY - (normalized * usableHeight);
      final double x = i * dx;
      coordinates.add(Offset(x, y));
    }

    if (coordinates.length == 1) {
      return;
    }

    // Build smooth cubic bezier curve
    fullPath.moveTo(coordinates[0].dx, coordinates[0].dy);
    for (int i = 0; i < coordinates.length - 1; i++) {
      final Offset p0 = coordinates[i];
      final Offset p1 = coordinates[i + 1];
      final double midX = (p0.dx + p1.dx) / 2;
      fullPath.cubicTo(midX, p0.dy, midX, p1.dy, p1.dx, p1.dy);
    }

    // Path trim animation
    final ui.PathMetric metric = fullPath.computeMetrics().first;
    final double currentLength = metric.length * progress.clamp(0.0, 1.0);
    final Path trimmedPath = metric.extractPath(0.0, currentLength);

    final Paint linePaint = Paint()
      ..color = ColorManager.white.withValues(alpha: 0.45)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(trimmedPath, linePaint);

    // Glowing dot at the end of the trimmed path
    if (currentLength > 0) {
      final ui.Tangent? tangent = metric.getTangentForOffset(currentLength);
      if (tangent != null) {
        final Offset dotPos = tangent.position;

        // Outer glow
        final Paint glowPaint = Paint()
          ..color = ColorManager.white.withValues(alpha: 0.25)
          ..style = PaintingStyle.fill;
        canvas.drawCircle(dotPos, 5.5, glowPaint);

        // Solid core
        final Paint corePaint = Paint()
          ..color = ColorManager.white.withValues(alpha: 0.95)
          ..style = PaintingStyle.fill;
        canvas.drawCircle(dotPos, 2.5, corePaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _SparklinePainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.points != points;
  }
}
