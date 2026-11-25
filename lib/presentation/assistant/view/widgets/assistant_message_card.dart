import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart' as intl;
import 'package:mizan/domain/model/assistant_model.dart';
import 'package:mizan/presentation/assistant/ux/comparison.dart';
import 'package:mizan/presentation/assistant/ux/comparison_fetcher.dart';
import 'package:mizan/presentation/assistant/ux/count_up_number.dart';
import 'package:mizan/presentation/assistant/ux/suggestions.dart';
import 'package:mizan/presentation/assistant/view/widgets/assistant_orb.dart';
import 'package:mizan/presentation/resources/color_manager.dart';
import 'package:mizan/presentation/resources/font_manager.dart';
import 'package:mizan/presentation/resources/styles_manager.dart';
import 'package:mizan/presentation/resources/values_manager.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// AssistantMessageCard — Displays assistant replies, animated count-up numbers,
/// comparison chips, formatted lists, confirmation receipts, and dynamic suggestions.
/// ─────────────────────────────────────────────────────────────────────────────
class AssistantMessageCard extends StatelessWidget {
  final ChatMessage message;
  final bool isActionExpired;
  final bool isExecutingAction;
  final bool isLastMessage;
  final String? lastUserText;
  final bool isAnimated;
  final VoidCallback? onAnimated;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final ValueChanged<String>? onOptionSelected;
  final ValueChanged<Suggestion>? onSuggestionTap;

  const AssistantMessageCard({
    super.key,
    required this.message,
    this.isActionExpired = false,
    this.isExecutingAction = false,
    this.isLastMessage = false,
    this.lastUserText,
    this.isAnimated = false,
    this.onAnimated,
    this.onConfirm,
    this.onCancel,
    this.onOptionSelected,
    this.onSuggestionTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasMetric = _hasMetric(message.payload);

    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Container(
        margin: EdgeInsets.only(
          top: 6.h,
          bottom: 8.h,
          right: 48.w,
          left: 16.w,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Header with mini orb & title
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                AssistantOrb(
                  size: OrbSize.small,
                  state: message.type == AssistantReplyType.success
                      ? OrbState.success
                      : OrbState.idle,
                  diameter: 22.r,
                ),
                SizedBox(width: 8.w),
                Text(
                  "يا ميزان",
                  style: getBoldStyle(
                    color: ColorManager.textPrimary,
                    fontSize: FontSize.s12,
                  ),
                ),
                SizedBox(width: 8.w),
                Text(
                  intl.DateFormat('hh:mm a', 'ar').format(message.timestamp),
                  style: getRegularStyle(
                    color: ColorManager.textTertiary,
                    fontSize: FontSize.s10,
                  ),
                ),
              ],
            ),
            SizedBox(height: 6.h),

            // Feature 2: Big count-up number + comparison chip if metric is present
            if (hasMetric) ...<Widget>[
              _MetricSummaryCard(
                payload: message.payload as Map<String, dynamic>,
                isAnimated: isAnimated,
                onAnimated: onAnimated,
              ),
              SizedBox(height: 6.h),
            ],

            // Main message text bubble
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: ColorManager.surface,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(AppRadius.r4.r),
                  topRight: Radius.circular(AppRadius.r18.r),
                  bottomLeft: Radius.circular(AppRadius.r18.r),
                  bottomRight: Radius.circular(AppRadius.r18.r),
                ),
                border: Border.all(color: ColorManager.border),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                message.text,
                style: getMediumStyle(
                  color: ColorManager.textPrimary,
                  fontSize: FontSize.s13,
                ),
              ),
            ),

            // If payload contains items list (e.g. debts, installments, transactions)
            if (_hasPayloadItems(message.payload)) ...<Widget>[
              SizedBox(height: 8.h),
              _buildPayloadItemsList(_extractItems(message.payload)),
            ],

            // If message has pendingAction -> Confirmation Receipt Card
            if (message.pendingAction != null) ...<Widget>[
              SizedBox(height: 8.h),
              _buildConfirmationCard(message.pendingAction!),
            ],

            // If message has quick options (from clarification/question)
            if (message.options.isNotEmpty) ...<Widget>[
              SizedBox(height: 8.h),
              Wrap(
                spacing: 8.w,
                runSpacing: 6.h,
                children: message.options.map((String opt) {
                  return ActionChip(
                    label: Text(
                      opt,
                      style: getMediumStyle(
                        color: ColorManager.primary,
                        fontSize: FontSize.s12,
                      ),
                    ),
                    backgroundColor: ColorManager.lightPrimary,
                    side: BorderSide(
                      color: ColorManager.primary.withValues(alpha: 0.4),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.r16.r),
                    ),
                    onPressed: () => onOptionSelected?.call(opt),
                  );
                }).toList(),
              ),
            ],

            // Feature 3: Dynamic context-aware suggestions (only on latest assistant reply)
            if (isLastMessage) ...<Widget>[
              _buildSuggestionsRow(),
            ],
          ],
        ),
      ),
    );
  }

  bool _hasMetric(dynamic payload) {
    if (payload is Map<String, dynamic>) {
      return payload.containsKey('metric');
    }
    return false;
  }

  bool _hasPayloadItems(dynamic payload) {
    if (payload is Map<String, dynamic>) {
      final dynamic items = payload['items'];
      return items is List && items.isNotEmpty;
    }
    return false;
  }

  List<dynamic> _extractItems(dynamic payload) {
    if (payload is Map<String, dynamic>) {
      final dynamic items = payload['items'];
      if (items is List) return items;
    }
    return <dynamic>[];
  }

  Widget _buildSuggestionsRow() {
    final List<Suggestion> suggestions = suggestionsFor(
      type: message.type.name,
      data: message.payload,
      lastUserText: lastUserText,
    );

    if (suggestions.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.only(top: 10.h),
      child: SuggestionRow(
        items: suggestions,
        onTap: (Suggestion s) => onSuggestionTap?.call(s),
        chipBuilder: (String label, VoidCallback onTap) {
          return ActionChip(
            label: Text(
              label,
              style: getMediumStyle(
                color: ColorManager.textPrimary,
                fontSize: FontSize.s12,
              ),
            ),
            backgroundColor: ColorManager.surface,
            elevation: 0,
            side: const BorderSide(color: ColorManager.border),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.r20.r),
            ),
            onPressed: onTap,
          );
        },
      ),
    );
  }

  Widget _buildPayloadItemsList(List<dynamic> items) {
    return Container(
      decoration: BoxDecoration(
        color: ColorManager.surface,
        borderRadius: BorderRadius.circular(AppRadius.r16.r),
        border: Border.all(color: ColorManager.border),
      ),
      child: Column(
        children: items.take(5).map((dynamic raw) {
          if (raw is! Map<String, dynamic>) return const SizedBox.shrink();
          final String name = raw['contactName']?.toString() ??
              raw['partyName']?.toString() ??
              'عميل';
          final dynamic amount = raw['amount'] ?? 0;
          final String? dueDateStr = raw['dueDate']?.toString();

          return Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: ColorManager.border.withValues(alpha: 0.5),
                ),
              ),
            ),
            child: Row(
              children: <Widget>[
                CircleAvatar(
                  radius: 16.r,
                  backgroundColor: ColorManager.lightSecondary,
                  child: Text(
                    name.isNotEmpty ? name[0] : '؟',
                    style: getBoldStyle(
                      color: ColorManager.darkSecondary,
                      fontSize: FontSize.s12,
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        name,
                        style: getBoldStyle(
                          color: ColorManager.textPrimary,
                          fontSize: FontSize.s12,
                        ),
                      ),
                      if (dueDateStr != null) ...<Widget>[
                        Text(
                          "استحقاق: ${_formatDate(dueDateStr)}",
                          style: getRegularStyle(
                            color: ColorManager.textSecondary,
                            fontSize: FontSize.s10,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: ColorManager.lightPrimary,
                    borderRadius: BorderRadius.circular(AppRadius.r8.r),
                  ),
                  child: Text(
                    "$amount ج.م",
                    style: getBoldStyle(
                      color: ColorManager.primary,
                      fontSize: FontSize.s12,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  String _formatDate(String isoStr) {
    try {
      final DateTime dt = DateTime.parse(isoStr);
      return intl.DateFormat('d MMMM yyyy', 'ar').format(dt);
    } catch (_) {
      return isoStr.split('T').first;
    }
  }

  Widget _buildConfirmationCard(AssistantPendingAction action) {
    final bool expired = isActionExpired || action.isExpired;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: ColorManager.surface,
        borderRadius: BorderRadius.circular(AppRadius.r16.r),
        border: Border.all(
          color: expired
              ? ColorManager.border
              : ColorManager.secondary.withValues(alpha: 0.6),
          width: 1.2,
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: ColorManager.secondary.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(
                Icons.assignment_turned_in_outlined,
                color: expired
                    ? ColorManager.textTertiary
                    : ColorManager.secondary,
                size: 18.r,
              ),
              SizedBox(width: 8.w),
              Text(
                "مراجعة وتأكيد العملية",
                style: getBoldStyle(
                  color: expired
                      ? ColorManager.textSecondary
                      : ColorManager.textPrimary,
                  fontSize: FontSize.s13,
                ),
              ),
              const Spacer(),
              if (!expired && action.expiresAt != null)
                _ConfirmationCountdown(expiresAt: action.expiresAt!)
              else if (expired)
                Text(
                  "انتهت الصلاحية",
                  style: getBoldStyle(
                    color: ColorManager.error,
                    fontSize: FontSize.s11,
                  ),
                ),
            ],
          ),
          SizedBox(height: 10.h),
          Text(
            action.summary,
            style: getRegularStyle(
              color: ColorManager.textPrimary,
              fontSize: FontSize.s13,
            ),
          ),
          SizedBox(height: 14.h),

          // Action Buttons
          if (!expired) ...<Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: ElevatedButton(
                    onPressed: isExecutingAction ? null : onConfirm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorManager.success,
                      foregroundColor: ColorManager.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.r12.r),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                    ),
                    child: isExecutingAction
                        ? SizedBox(
                            width: 16.r,
                            height: 16.r,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                              color: ColorManager.white,
                            ),
                          )
                        : Text(
                            "تأكيد وحفظ",
                            style: getBoldStyle(
                              color: ColorManager.white,
                              fontSize: FontSize.s13,
                            ),
                          ),
                  ),
                ),
                SizedBox(width: 10.w),
                OutlinedButton(
                  onPressed: isExecutingAction ? null : onCancel,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: ColorManager.error,
                    side: BorderSide(
                      color: ColorManager.error.withValues(alpha: 0.5),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.r12.r),
                    ),
                    padding: EdgeInsets.symmetric(
                      vertical: 10.h,
                      horizontal: 16.w,
                    ),
                  ),
                  child: Text(
                    "إلغاء",
                    style: getBoldStyle(
                      color: ColorManager.error,
                      fontSize: FontSize.s13,
                    ),
                  ),
                ),
              ],
            ),
          ] else ...<Widget>[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: ColorManager.surfaceVariant,
                borderRadius: BorderRadius.circular(AppRadius.r8.r),
              ),
              child: Text(
                "لم يتم تسجيل المعاملة لانتهاء المهلة الزمنية. أعد الطلب مرة أخرى.",
                style: getRegularStyle(
                  color: ColorManager.textSecondary,
                  fontSize: FontSize.s11,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// ─────────────────────────────────────────────────────────────────────────────
/// _MetricSummaryCard — Displays big animated count-up numbers and comparison chips
/// ─────────────────────────────────────────────────────────────────────────────
class _MetricSummaryCard extends StatefulWidget {
  final Map<String, dynamic> payload;
  final bool isAnimated;
  final VoidCallback? onAnimated;

  const _MetricSummaryCard({
    required this.payload,
    required this.isAnimated,
    this.onAnimated,
  });

  @override
  State<_MetricSummaryCard> createState() => _MetricSummaryCardState();
}

class _MetricSummaryCardState extends State<_MetricSummaryCard> {
  bool _showComparison = false;
  ComparisonChipData? _comparisonData;

  @override
  void initState() {
    super.initState();
    if (widget.isAnimated) {
      _showComparison = true;
    }
    _loadComparison();
  }

  Future<void> _loadComparison() async {
    final DateTime now = DateTime.now();
    if (!isEgyptTimezone(now)) return;

    final String period = widget.payload['period']?.toString() ?? '';
    final String metric = widget.payload['metric']?.toString() ?? 'sales';
    final bool isPurchases = metric == 'purchases';

    final ComparisonSource? source = comparisonSourceFor(period, now);
    if (source == null) return;

    final double? previous = await ComparisonFetcher.fetchPreviousValue(
      source: source,
      isPurchases: isPurchases,
    );

    if (previous == null || !mounted) return;

    final double current = isPurchases
        ? ((widget.payload['totalPurchases'] as num?)?.toDouble() ?? 0.0)
        : ((widget.payload['totalSales'] as num?)?.toDouble() ?? 0.0);

    final ComparisonChipData? chip = buildComparison(
      period: period,
      isPurchases: isPurchases,
      current: current,
      previous: previous,
      format: (double v) =>
          intl.NumberFormat.decimalPattern('en').format(v.round()),
    );

    if (mounted && chip != null) {
      setState(() {
        _comparisonData = chip;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final String metric = widget.payload['metric']?.toString() ?? 'sales';
    final String? label = widget.payload['label']?.toString();
    final num totalSales = widget.payload['totalSales'] as num? ?? 0;
    final num totalPurchases = widget.payload['totalPurchases'] as num? ?? 0;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: ColorManager.surface,
        borderRadius: BorderRadius.circular(AppRadius.r16.r),
        border: Border.all(color: ColorManager.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (label != null) ...<Widget>[
            Text(
              label,
              style: getMediumStyle(
                color: ColorManager.textSecondary,
                fontSize: FontSize.s12,
              ),
            ),
            SizedBox(height: 2.h),
          ],

          if (metric == 'both') ...<Widget>[
            // Sales line
            Text(
              "المبيعات",
              style: getRegularStyle(
                color: ColorManager.textSecondary,
                fontSize: FontSize.s11,
              ),
            ),
            CountUpNumber(
              value: totalSales,
              animate: !widget.isAnimated,
              onDone: () {
                widget.onAnimated?.call();
                if (mounted) setState(() => _showComparison = true);
              },
              style: getBoldStyle(
                color: ColorManager.primary,
                fontSize: FontSize.s24,
              ),
            ),
            SizedBox(height: 8.h),
            // Purchases line
            Text(
              "المشتريات",
              style: getRegularStyle(
                color: ColorManager.textSecondary,
                fontSize: FontSize.s11,
              ),
            ),
            CountUpNumber(
              value: totalPurchases,
              animate: !widget.isAnimated,
              onDone: () {},
              style: getBoldStyle(
                color: ColorManager.primary,
                fontSize: FontSize.s24,
              ),
            ),
          ] else ...<Widget>[
            CountUpNumber(
              value: metric == 'purchases' ? totalPurchases : totalSales,
              animate: !widget.isAnimated,
              onDone: () {
                widget.onAnimated?.call();
                if (mounted) setState(() => _showComparison = true);
              },
              style: getBoldStyle(
                color: ColorManager.primary,
                fontSize: FontSize.s26,
              ),
            ),
          ],

          if (_comparisonData != null) ...<Widget>[
            ComparisonChipWidget(
              data: _comparisonData!,
              visible: _showComparison,
            ),
          ],
        ],
      ),
    );
  }
}

class _ConfirmationCountdown extends StatefulWidget {
  final DateTime expiresAt;

  const _ConfirmationCountdown({required this.expiresAt});

  @override
  State<_ConfirmationCountdown> createState() => _ConfirmationCountdownState();
}

class _ConfirmationCountdownState extends State<_ConfirmationCountdown> {
  Timer? _timer;
  late Duration _remaining;

  @override
  void initState() {
    super.initState();
    _remaining = widget.expiresAt.difference(DateTime.now());
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      final Duration diff = widget.expiresAt.difference(DateTime.now());
      if (diff <= Duration.zero) {
        _timer?.cancel();
        if (mounted) {
          setState(() {
            _remaining = Duration.zero;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _remaining = diff;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final int minutes = _remaining.inMinutes;
    final int seconds = _remaining.inSeconds % 60;
    final String timeStr =
        '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: ColorManager.lightSecondary,
        borderRadius: BorderRadius.circular(AppRadius.r8.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(
            Icons.timer_outlined,
            size: 12.r,
            color: ColorManager.darkSecondary,
          ),
          SizedBox(width: 4.w),
          Text(
            timeStr,
            style: getBoldStyle(
              color: ColorManager.darkSecondary,
              fontSize: FontSize.s11,
            ),
          ),
        ],
      ),
    );
  }
}
