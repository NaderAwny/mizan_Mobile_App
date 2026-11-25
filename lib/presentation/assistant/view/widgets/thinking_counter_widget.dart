import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mizan/presentation/assistant/view/widgets/assistant_orb.dart';
import 'package:mizan/presentation/resources/color_manager.dart';
import 'package:mizan/presentation/resources/font_manager.dart';
import 'package:mizan/presentation/resources/strings_manager.dart';
import 'package:mizan/presentation/resources/styles_manager.dart';
import 'package:mizan/presentation/resources/values_manager.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// ThinkingCounterWidget — Self-contained isolated seconds ticker for AI thinking
/// Does not rebuild the parent chat view or message list.
/// ─────────────────────────────────────────────────────────────────────────────
class ThinkingCounterWidget extends StatefulWidget {
  final VoidCallback? onTimeoutRetry;

  const ThinkingCounterWidget({
    super.key,
    this.onTimeoutRetry,
  });

  @override
  State<ThinkingCounterWidget> createState() => _ThinkingCounterWidgetState();
}

class _ThinkingCounterWidgetState extends State<ThinkingCounterWidget> {
  late final Timer _timer;
  final ValueNotifier<int> _secondsNotifier = ValueNotifier<int>(0);

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      if (mounted) {
        _secondsNotifier.value++;
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _secondsNotifier.dispose();
    super.dispose();
  }

  String _formatSeconds(int totalSecs) {
    final int minutes = totalSecs ~/ 60;
    final int secs = totalSecs % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Container(
        margin: EdgeInsets.only(top: 8.h, bottom: 8.h, left: 16.w, right: 60.w),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: ColorManager.surface,
          borderRadius: BorderRadius.circular(AppRadius.r16.r),
          border: Border.all(color: ColorManager.border),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ValueListenableBuilder<int>(
          valueListenable: _secondsNotifier,
          builder: (BuildContext context, int seconds, Widget? child) {
            final bool isDelayed = seconds >= 15;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    AssistantOrb(
                      size: OrbSize.small,
                      state: OrbState.thinking,
                      diameter: 24.r,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      AppStrings.assistantThinking,
                      style: getMediumStyle(
                        color: ColorManager.textPrimary,
                        fontSize: FontSize.s13,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                      decoration: BoxDecoration(
                        color: ColorManager.surfaceVariant,
                        borderRadius: BorderRadius.circular(AppRadius.r8.r),
                      ),
                      child: Text(
                        _formatSeconds(seconds),
                        style: getBoldStyle(
                          color: isDelayed
                              ? ColorManager.secondary
                              : ColorManager.primary,
                          fontSize: FontSize.s11,
                        ),
                      ),
                    ),
                  ],
                ),
                if (isDelayed) ...<Widget>[
                  SizedBox(height: 6.h),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        "استغرق وقتاً أطول من المعتاد...",
                        style: getRegularStyle(
                          color: ColorManager.textSecondary,
                          fontSize: FontSize.s11,
                        ),
                      ),
                      if (widget.onTimeoutRetry != null) ...<Widget>[
                        SizedBox(width: 6.w),
                        GestureDetector(
                          onTap: widget.onTimeoutRetry,
                          child: Text(
                            "إعادة المحاولة",
                            style: getBoldStyle(
                              color: ColorManager.primary,
                              fontSize: FontSize.s11,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}
