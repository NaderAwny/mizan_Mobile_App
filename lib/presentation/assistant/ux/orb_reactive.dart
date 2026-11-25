import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mizan/presentation/assistant/ux/assistant_ui_signals.dart';

class _Frame {
  const _Frame(this.scale, this.angle, this.dx, this.level, this.phase);
  final double scale;
  final double angle;
  final double dx;
  final double level;
  final double phase;
}

/// OrbReactive — Wraps [orb] and dynamically animates scale, rotation, shaking,
/// ripples, and countdown arcs based on reactive [signals].
/// Follows strict 60fps performance budget (Transform and Opacity, RepaintBoundary, single ticker).
class OrbReactive extends StatefulWidget {
  const OrbReactive({
    super.key,
    required this.signals,
    required this.orb,
    required this.ringColor,
    this.size = 200,
  });

  final AssistantUiSignals signals;
  final Widget orb;
  final Color ringColor;
  final double size;

  @override
  State<OrbReactive> createState() => _OrbReactiveState();
}

class _OrbReactiveState extends State<OrbReactive>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  static const double _twoPi = 2 * math.pi;
  late final AnimationController _ticker;
  final Stopwatch _sw = Stopwatch()..start();
  final ValueNotifier<_Frame> _frame =
      ValueNotifier<_Frame>(const _Frame(1.0, 0.0, 0.0, 0.0, 0.0));

  double _level = 0.0;
  double _angle = 0.0;
  double _lastT = 0.0;
  double _errorStart = -10.0;
  DateTime _lastInteraction = DateTime.now();
  bool _reduceMotion = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _ticker = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..addListener(_onTick);

    widget.signals.voiceState.addListener(_onState);
    widget.signals.soundLevel.addListener(_wake);
    _wake();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _reduceMotion = MediaQuery.disableAnimationsOf(context);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState s) {
    if (s == AppLifecycleState.resumed) {
      _wake();
    } else {
      _ticker.stop();
    }
  }

  void _onState() {
    _lastInteraction = DateTime.now();
    if (widget.signals.voiceState.value == VoiceUiState.error) {
      _errorStart = _sw.elapsedMilliseconds / 1000.0;
    }
    _wake();
  }

  void _wake() {
    if (!_ticker.isAnimating) {
      _ticker.repeat();
    }
  }

  void _onTick() {
    final double t = _sw.elapsedMilliseconds / 1000.0;
    final double dt = (t - _lastT).clamp(0.0, 0.05);
    _lastT = t;
    final VoiceUiState st = widget.signals.voiceState.value;

    final double target =
        st == VoiceUiState.listening ? widget.signals.soundLevel.value : 0.0;
    // Fast rise (0.35), smooth descent (0.08)
    _level += (target - _level) * (target > _level ? 0.35 : 0.08);

    final bool breathing =
        DateTime.now().difference(_lastInteraction).inSeconds < 10;

    double scale = switch (st) {
      VoiceUiState.listening => 1.0 + 0.14 * _level,
      VoiceUiState.speaking => 1.04 + 0.03 * math.sin(_twoPi * 2.2 * t),
      VoiceUiState.thinking => 1.0 + 0.02 * math.sin(_twoPi * 1.2 * t),
      VoiceUiState.silenceCountdown => 1.02,
      _ => breathing ? 1.0 + 0.015 * math.sin(_twoPi * t / 3.5) : 1.0,
    };
    if (_reduceMotion) scale = 1.0;

    // Smooth rotation: completes full revolution on exit to avoid jumps
    if (st == VoiceUiState.thinking && !_reduceMotion) {
      _angle = (_angle + _twoPi * dt / 2.4) % _twoPi;
    } else if (_angle != 0.0) {
      _angle += (_twoPi - _angle) * 0.12;
      if (_twoPi - _angle < 0.01) _angle = 0.0;
    }

    double dx = 0.0;
    if (st == VoiceUiState.error && !_reduceMotion) {
      final double e = t - _errorStart;
      if (e >= 0.0 && e < 0.4) {
        dx = math.sin(e * 50) * 4.0 * (1.0 - e / 0.4);
      }
    }

    _frame.value = _Frame(scale, _angle, dx, _level, (t * 0.8) % 1.0);

    // Stop ticker if completely idle to conserve battery
    final bool idle =
        st == VoiceUiState.idle || st == VoiceUiState.error;
    final bool settled =
        _level < 0.01 && _angle == 0.0 && (t - _errorStart) > 0.5;
    if (idle && settled && !breathing) {
      _ticker.stop();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    widget.signals.voiceState.removeListener(_onState);
    widget.signals.soundLevel.removeListener(_wake);
    _ticker.dispose();
    _frame.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: widget.size,
      child: RepaintBoundary(
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Positioned.fill(
              child: CustomPaint(
                painter: _RingsPainter(
                  frame: _frame,
                  state: widget.signals.voiceState,
                  countdown: widget.signals.countdown,
                  color: widget.ringColor,
                ),
              ),
            ),
            ValueListenableBuilder<_Frame>(
              valueListenable: _frame,
              child: widget.orb,
              builder: (BuildContext context, _Frame f, Widget? child) =>
                  Transform.translate(
                offset: Offset(f.dx, 0.0),
                child: Transform.scale(
                  scale: f.scale,
                  child: Transform.rotate(
                    angle: f.angle,
                    child: child,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RingsPainter extends CustomPainter {
  _RingsPainter({
    required this.frame,
    required this.state,
    required this.countdown,
    required this.color,
  }) : super(repaint: Listenable.merge(<Listenable>[frame, countdown]));

  final ValueNotifier<_Frame> frame;
  final ValueListenable<VoiceUiState> state;
  final ValueListenable<double> countdown;
  final Color color;
  final Paint _p = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1.3;

  @override
  void paint(Canvas canvas, Size size) {
    final VoiceUiState s = state.value;
    final Offset center = size.center(Offset.zero);
    final double base = size.width * 0.35;

    // 1. In silenceCountdown: draw thin golden arc that decreases with the countdown
    if (s == VoiceUiState.silenceCountdown) {
      final double progress = countdown.value.clamp(0.0, 1.0);
      if (progress > 0.0) {
        final Paint arcPaint = Paint()
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeWidth = 2.0
          ..color = color.withValues(alpha: 0.85);

        final Rect arcRect = Rect.fromCircle(center: center, radius: base * 1.08);
        canvas.drawArc(
          arcRect,
          -math.pi / 2,
          2 * math.pi * progress,
          false,
          arcPaint,
        );
      }
      return;
    }

    // 2. Active voice ripples when listening or speaking
    final bool active = s == VoiceUiState.listening || s == VoiceUiState.speaking;
    final _Frame f = frame.value;
    if (!active && f.level < 0.02) return;

    final double strength = s == VoiceUiState.speaking ? 0.35 : f.level;
    for (int i = 0; i < 3; i++) {
      final double p = (f.phase + i / 3.0) % 1.0;
      final double r = base * (1.0 + 0.55 * p * (0.4 + strength));
      final double a = ((1.0 - p) * (0.10 + 0.35 * strength)).clamp(0.0, 1.0);
      _p.color = color.withValues(alpha: a);
      canvas.drawCircle(center, r, _p);
    }
  }

  @override
  bool shouldRepaint(covariant _RingsPainter old) => old.color != color;
}
