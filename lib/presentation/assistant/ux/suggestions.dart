import 'package:flutter/material.dart';

/// Suggestion item — either sends text to the assistant or routes locally
class Suggestion {
  Suggestion.send(this.label, [String? text])
      : sendText = text ?? label,
        route = null;
  Suggestion.go(this.label, this.route) : sendText = null;

  final String label;
  final String? sendText;
  final String? route;
}

/// Evaluates context-aware follow-up suggestions from assistant reply payload
List<Suggestion> suggestionsFor({
  required String type,
  required Object? data,
  String? lastUserText,
}) {
  if (const <String>{
    'question',
    'confirmation',
    'clarification',
    'error',
    'cancelled',
  }.contains(type)) {
    return const <Suggestion>[];
  }

  if (data is List) return const <Suggestion>[];

  final Map<String, dynamic>? m = data is Map
      ? Map<String, dynamic>.from(data)
      : null;

  List<Suggestion> out;

  if (type == 'success') {
    out = <Suggestion>[
      Suggestion.send('مبيعات النهارده كام؟'),
      Suggestion.send('مين متأخر عليا؟'),
    ];
  } else if (m != null && m.containsKey('metric')) {
    final String? period = m['period']?.toString();
    final String? metric = m['metric']?.toString();
    out = switch (period) {
      'today' => <Suggestion>[
          Suggestion.send('امبارح حصل إيه؟'),
          if (metric == 'sales')
            Suggestion.send('المشتريات النهارده كام؟')
          else
            Suggestion.send('مبيعات النهارده كام؟'),
          Suggestion.send('مين متأخر عليا؟'),
        ],
      'yesterday' => <Suggestion>[
          Suggestion.send('مبيعات النهارده كام؟'),
          Suggestion.send('اشتريت بكام الشهر ده؟'),
        ],
      'this_month' => <Suggestion>[
          Suggestion.send('مبيعات الشهر اللي فات؟'),
          Suggestion.send('مين متأخر عليا؟'),
          Suggestion.send('الديون كام؟'),
        ],
      'last_month' => <Suggestion>[
          Suggestion.send('اشتريت بكام الشهر ده؟'),
          Suggestion.send('الديون كام؟'),
        ],
      'this_week' => <Suggestion>[
          Suggestion.send('امبارح حصل إيه؟'),
          Suggestion.send('مين متأخر عليا؟'),
        ],
      _ => const <Suggestion>[],
    };
  } else if (m != null && m.containsKey('items') && m.containsKey('totalCount')) {
    final int n = (m['totalCount'] as num?)?.toInt() ?? 0;
    out = n > 0
        ? <Suggestion>[
            Suggestion.send('الديون كام؟'),
            Suggestion.send('إيه الأقساط الجاية؟'),
          ]
        : <Suggestion>[
            Suggestion.send('إيه الأقساط الجاية؟'),
          ];
  } else if (m != null &&
      (m.containsKey('remainingDebt') || m.containsKey('balance'))) {
    final Map<String, dynamic> bal = m['balance'] is Map
        ? Map<String, dynamic>.from(m['balance'] as Map)
        : m;
    final String? name = bal['contactName']?.toString();
    final double debt = (bal['remainingDebt'] as num?)?.toDouble() ?? 0.0;
    out = (name != null && debt > 0.0)
        ? <Suggestion>[
            Suggestion.send('مين متأخر عليا؟'),
            Suggestion.send('الديون كام؟'),
          ]
        : const <Suggestion>[];
  } else if (m != null && m.containsKey('totalRemaining')) {
    out = <Suggestion>[
      Suggestion.send('مين متأخر عليا؟'),
      Suggestion.send('إيه الأقساط الجاية؟'),
    ];
  } else if (m != null && m.containsKey('unreadOnly')) {
    out = <Suggestion>[
      Suggestion.go('افتح الإشعارات', '/notifications'),
    ];
  } else {
    out = const <Suggestion>[];
  }

  final String? last = lastUserText?.trim();
  return out.where((Suggestion s) => s.label != last).take(3).toList();
}

/// SuggestionRow — Smooth staggered entrance of up to 3 chips
class SuggestionRow extends StatefulWidget {
  const SuggestionRow({
    super.key,
    required this.items,
    required this.onTap,
    required this.chipBuilder,
  });

  final List<Suggestion> items;
  final void Function(Suggestion) onTap;
  final Widget Function(String label, VoidCallback onTap) chipBuilder;

  @override
  State<SuggestionRow> createState() => _SuggestionRowState();
}

class _SuggestionRowState extends State<SuggestionRow>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool _started = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 520),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    if (MediaQuery.disableAnimationsOf(context)) {
      _controller.value = 1.0;
    } else {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final int n = widget.items.length;
    if (n == 0) return const SizedBox.shrink();

    return RepaintBoundary(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          children: <Widget>[
            for (int i = 0; i < n; i++)
              Padding(
                padding: const EdgeInsetsDirectional.only(end: 8.0),
                child: _Staggered(
                  animation: CurvedAnimation(
                    parent: _controller,
                    curve: Interval(
                      i * 0.2,
                      (0.6 + i * 0.2).clamp(0.0, 1.0),
                      curve: Curves.easeOutCubic,
                    ),
                  ),
                  child: widget.chipBuilder(
                    widget.items[i].label,
                    () => widget.onTap(widget.items[i]),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _Staggered extends AnimatedWidget {
  const _Staggered({
    required Animation<double> animation,
    required this.child,
  }) : super(listenable: animation);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final double v = (listenable as Animation<double>).value;
    return Opacity(
      opacity: v,
      child: Transform.translate(
        offset: Offset(0.0, 8.0 * (1.0 - v)),
        child: child,
      ),
    );
  }
}
