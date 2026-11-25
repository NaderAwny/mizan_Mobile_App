import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mizan/presentation/resources/color_manager.dart';

/// Available states for the Assistant Orb
enum OrbState {
  idle,
  listening,
  thinking,
  speaking,
  success,
  error,
}

/// Available sizes for the Assistant Orb
enum OrbSize {
  small, // For bottom navigation bar (~48dp)
  large, // For chat screen header (~172dp)
}

/// ─────────────────────────────────────────────────────────────────────────────
/// AssistantOrb — Living Celestial AI Sphere for "يا ميزان"
/// Faithfully reproduces the exact visual design from Figma & reference image:
/// - Core sphere: Warm Terracotta (#C57B57) with radiant golden center (#D19F5D)
/// - Right side: Distinct, prominent deep dark green crescent (#1C4A38 / #3D6952)
///   with a subtle luminous cyan-white reflection on the lower-right edge
/// - 3 Concentric orbital rings (#D1A153 / #D4A663)
/// - Two glowing planetary satellites with white core and warm golden halos
/// - Soft breathing outer atmosphere
/// ─────────────────────────────────────────────────────────────────────────────
class AssistantOrb extends StatefulWidget {
  final OrbSize size;
  final OrbState state;
  final double? diameter;
  final double soundLevel; // 0.0 to 1.0 for listening state
  final String? heroTag;
  final VoidCallback? onTap;

  const AssistantOrb({
    super.key,
    this.size = OrbSize.large,
    this.state = OrbState.idle,
    this.diameter,
    this.soundLevel = 0.0,
    this.heroTag,
    this.onTap,
  });

  @override
  State<AssistantOrb> createState() => _AssistantOrbState();
}

class _AssistantOrbState extends State<AssistantOrb>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late final AnimationController _controller;
  bool _isAppActive = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _controller = AnimationController(
      vsync: this,
      duration: _getDurationForState(widget.state),
    )..repeat();
  }

  @override
  void didUpdateWidget(covariant AssistantOrb oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.state != widget.state) {
      _controller.duration = _getDurationForState(widget.state);
      if (!_controller.isAnimating && _isAppActive) {
        _controller.repeat();
      }
    }
  }

  Duration _getDurationForState(OrbState state) {
    switch (state) {
      case OrbState.thinking:
        return const Duration(milliseconds: 2400);
      case OrbState.listening:
        return const Duration(milliseconds: 3600);
      case OrbState.speaking:
        return const Duration(milliseconds: 4000);
      case OrbState.success:
      case OrbState.error:
        return const Duration(milliseconds: 5000);
      case OrbState.idle:
        return widget.size == OrbSize.small
            ? const Duration(milliseconds: 9000)
            : const Duration(milliseconds: 7000);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _isAppActive = state == AppLifecycleState.resumed;
    if (_isAppActive) {
      if (!_controller.isAnimating) {
        _controller.repeat();
      }
    } else {
      if (_controller.isAnimating) {
        _controller.stop();
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool disableAnimations = MediaQuery.disableAnimationsOf(context);
    final double targetDiameter = widget.diameter ??
        (widget.size == OrbSize.small ? 48.r : 172.r);

    Widget content = SizedBox(
      width: targetDiameter,
      height: targetDiameter,
      child: RepaintBoundary(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (BuildContext context, Widget? child) {
            final double t = disableAnimations ? 0.0 : _controller.value;
            return CustomPaint(
              size: Size(targetDiameter, targetDiameter),
              painter: _OrbPainter(
                progress: t,
                state: widget.state,
                size: widget.size,
                soundLevel: widget.soundLevel,
              ),
            );
          },
        ),
      ),
    );

    if (widget.heroTag != null) {
      content = Hero(
        tag: widget.heroTag!,
        child: content,
      );
    }

    if (widget.onTap != null) {
      content = GestureDetector(
        onTap: widget.onTap,
        behavior: HitTestBehavior.opaque,
        child: content,
      );
    }

    return content;
  }
}

/// ─────────────────────────────────────────────────────────────────────────────
/// _OrbPainter — High-performance 3D Celestial Painter
/// ─────────────────────────────────────────────────────────────────────────────
class _OrbPainter extends CustomPainter {
  final double progress; // 0.0 .. 1.0
  final OrbState state;
  final OrbSize size;
  final double soundLevel;

  _OrbPainter({
    required this.progress,
    required this.state,
    required this.size,
    required this.soundLevel,
  });

  @override
  void paint(Canvas canvas, Size canvasSize) {
    final Offset center = Offset(canvasSize.width / 2, canvasSize.height / 2);
    // Sphere radius is ~36% of total container so rings and satellites fit comfortably
    final double sphereRadius = canvasSize.width * 0.35;

    // 1. Soft Breathing Outer Atmosphere Glow (Terracotta & Gold)
    _paintAtmosphereGlow(canvas, center, sphereRadius);

    if (state == OrbState.success) {
      _paintSuccessOrb(canvas, center, sphereRadius);
      return;
    }

    // 2. Three Concentric Orbital Rings
    _paintConcentricRings(canvas, center, sphereRadius);

    // 3. The Core Sphere (Planet with golden glowing core + bold dark green crescent)
    _paintCoreSphere(canvas, center, sphereRadius);

    // 4. Two Luminous Satellites (White core + golden radiant halo)
    _paintSatellites(canvas, center, sphereRadius);
  }

  void _paintAtmosphereGlow(Canvas canvas, Offset center, double sphereRadius) {
    final double pulse = 0.5 + 0.5 * math.sin(progress * 2 * math.pi);
    final double soundFactor = (state == OrbState.listening) ? (soundLevel * 0.35) : 0.0;
    final double glowRadius = sphereRadius * (1.45 + 0.15 * pulse + soundFactor);

    Color glowColor;
    if (state == OrbState.error) {
      glowColor = ColorManager.error.withValues(alpha: 0.28);
    } else {
      glowColor = const Color(0xFFC57B57).withValues(alpha: 0.25 + 0.10 * pulse + soundFactor * 0.2);
    }

    final Paint glowPaint = Paint()
      ..shader = RadialGradient(
        colors: <Color>[
          glowColor,
          const Color(0xFFD1A153).withValues(alpha: 0.10 * (1.0 - pulse * 0.4)),
          Colors.transparent,
        ],
        stops: const <double>[0.0, 0.65, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: glowRadius));

    canvas.drawCircle(center, glowRadius, glowPaint);
  }

  void _paintConcentricRings(Canvas canvas, Offset center, double sphereRadius) {
    // 3 Concentric rings expanding with speech amplitude (sound level)
    final double soundFactor = (state == OrbState.listening) ? (soundLevel * 0.40) : 0.0;
    final double ringBase = sphereRadius * (1.0 + soundFactor * 0.25);
    final List<double> radii = <double>[
      ringBase * 1.15,
      ringBase * 1.30,
      ringBase * 1.45,
    ];

    final Paint ringPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = (size == OrbSize.small ? 0.9 : 1.3).w
      ..color = const Color(0xFFD1A153).withValues(alpha: 0.45);

    for (final double r in radii) {
      canvas.drawCircle(center, r, ringPaint);
    }
  }

  void _paintCoreSphere(Canvas canvas, Offset center, double radius) {
    // Save layer to clip strictly to the circular planet body
    canvas.save();
    final Rect sphereRect = Rect.fromCircle(center: center, radius: radius);
    canvas.clipPath(Path()..addOval(sphereRect));

    // Dynamic 3D lighting animation:
    // The core golden hotspot rotates slowly in an elliptical path
    final double angle = progress * 2 * math.pi;
    final double wobbleX = radius * 0.08 * math.cos(angle);
    final double wobbleY = radius * 0.05 * math.sin(angle);
    final Offset coreCenter = Offset(
      center.dx - radius * 0.12 + wobbleX,
      center.dy + wobbleY,
    );

    // Layer 1: Base Warm Terracotta & Glowing Amber/Gold Core
    final Paint basePaint = Paint()
      ..shader = RadialGradient(
        center: Alignment(
          (coreCenter.dx - center.dx) / radius,
          (coreCenter.dy - center.dy) / radius,
        ),
        radius: 0.95,
        colors: const <Color>[
          Color(0xFFD49E58), // 0% Center glowing gold highlight
          Color(0xFFCD9160), // 35% Golden amber
          Color(0xFFC57B57), // 65% Primary Terracotta
          Color(0xFFA25E3B), // 90% Deep Terracotta shadow
          Color(0xFF8B4725), // 100% Dark rim
        ],
        stops: const <double>[0.0, 0.35, 0.65, 0.88, 1.0],
      ).createShader(sphereRect);

    canvas.drawCircle(center, radius, basePaint);

    // Layer 2: Prominent Dark Green Crescent on the Right (مطابقة لحافة خضراء غامقة على اليمين)
    // Drawn via a smooth horizontal linear gradient that rises on the right 40% of the sphere
    final Paint greenCrescentPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        stops: const <double>[0.0, 0.42, 0.60, 0.78, 1.0],
        colors: <Color>[
          Colors.transparent,
          Colors.transparent,
          const Color(0xFF35684E).withValues(alpha: 0.75), // Soft blend into terracotta
          const Color(0xFF24543C),                        // Rich emerald deep green
          const Color(0xFF163C2A),                        // Dark forest edge
        ],
      ).createShader(sphereRect);

    canvas.drawCircle(center, radius, greenCrescentPaint);

    // Layer 3: Lower-Right Specular Luminous Reflection (Light Mint / Cyan Glow)
    // Matches the glowing rim seen on the lower right of the green crescent in the image
    final Offset specCenter = Offset(
      center.dx + radius * 0.55,
      center.dy + radius * 0.55,
    );
    final Paint specPaint = Paint()
      ..shader = RadialGradient(
        colors: <Color>[
          const Color(0xFF90DFC6).withValues(alpha: 0.60), // Luminous mint reflection
          const Color(0xFF35684E).withValues(alpha: 0.20),
          Colors.transparent,
        ],
        stops: const <double>[0.0, 0.50, 1.0],
      ).createShader(Rect.fromCircle(center: specCenter, radius: radius * 0.50));

    canvas.drawCircle(center, radius, specPaint);

    // Layer 4: Upper-Left Soft Ambient Highlight
    final Offset ambientCenter = Offset(
      center.dx - radius * 0.35,
      center.dy - radius * 0.35,
    );
    final Paint ambientPaint = Paint()
      ..shader = RadialGradient(
        colors: <Color>[
          Colors.white.withValues(alpha: 0.30),
          Colors.white.withValues(alpha: 0.08),
          Colors.transparent,
        ],
        stops: const <double>[0.0, 0.45, 1.0],
      ).createShader(Rect.fromCircle(center: ambientCenter, radius: radius * 0.70));

    canvas.drawCircle(center, radius, ambientPaint);

    canvas.restore(); // End clipping to sphere

    // Subtle crisp rim around the sphere
    final Paint rimPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8.w
      ..color = const Color(0xFFD1A153).withValues(alpha: 0.35);
    canvas.drawCircle(center, radius, rimPaint);
  }

  void _paintSatellites(Canvas canvas, Offset center, double sphereRadius) {
    // Two primary satellites on the middle ring (radius * 1.30)
    final double orbitRadius = sphereRadius * 1.30;

    // Movement: satellites orbit slowly with the animation controller
    final double angle1 = progress * 2 * math.pi;
    final double angle2 = angle1 + math.pi; // Opposite side (180 degrees)

    final Offset dot1 = Offset(
      center.dx + orbitRadius * math.cos(angle1),
      center.dy + orbitRadius * math.sin(angle1) * 0.85, // slight perspective
    );

    final Offset dot2 = Offset(
      center.dx + orbitRadius * math.cos(angle2),
      center.dy + orbitRadius * math.sin(angle2) * 0.85,
    );

    _drawGlowingDot(canvas, dot1, size == OrbSize.small ? 2.2.r : 4.0.r);
    _drawGlowingDot(canvas, dot2, size == OrbSize.small ? 2.2.r : 4.0.r);
  }

  void _drawGlowingDot(Canvas canvas, Offset position, double dotRadius) {
    // 1. Radiant Golden Glow Halo
    final double haloRadius = dotRadius * 2.8;
    final Paint haloPaint = Paint()
      ..shader = RadialGradient(
        colors: <Color>[
          const Color(0xFFD1A153).withValues(alpha: 0.85),
          const Color(0xFFD1A153).withValues(alpha: 0.30),
          Colors.transparent,
        ],
        stops: const <double>[0.0, 0.50, 1.0],
      ).createShader(Rect.fromCircle(center: position, radius: haloRadius));

    canvas.drawCircle(position, haloRadius, haloPaint);

    // 2. Pure White Core
    final Paint corePaint = Paint()..color = Colors.white;
    canvas.drawCircle(position, dotRadius, corePaint);
  }

  void _paintSuccessOrb(Canvas canvas, Offset center, double radius) {
    // Solid success green sphere
    final Paint greenPaint = Paint()
      ..color = ColorManager.success
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius, greenPaint);

    // Subtle highlight rim
    final Paint rim = Paint()
      ..color = Colors.white.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2.w;
    canvas.drawCircle(center, radius, rim);

    // Draw checkmark ✓
    final Paint checkPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = (size == OrbSize.small ? 2.5 : 4.5).w;

    final Path checkPath = Path();
    final double checkScale = radius * 0.45;
    checkPath.moveTo(center.dx - checkScale * 0.7, center.dy);
    checkPath.lineTo(center.dx - checkScale * 0.1, center.dy + checkScale * 0.6);
    checkPath.lineTo(center.dx + checkScale * 0.8, center.dy - checkScale * 0.5);

    canvas.drawPath(checkPath, checkPaint);
  }

  @override
  bool shouldRepaint(covariant _OrbPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.state != state ||
        oldDelegate.soundLevel != soundLevel;
  }
}
