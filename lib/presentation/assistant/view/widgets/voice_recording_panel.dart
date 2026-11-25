import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mizan/app/domain_text_normalizer.dart';
import 'package:mizan/presentation/assistant/assistant_voice_cubit/assistant_voice_state.dart';
import 'package:mizan/presentation/resources/color_manager.dart';
import 'package:mizan/presentation/resources/font_manager.dart';
import 'package:mizan/presentation/resources/styles_manager.dart';
import 'package:mizan/presentation/resources/values_manager.dart';
import 'package:permission_handler/permission_handler.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// VoiceRecordingPanel — Overlay bottom panel showing live transcription,
/// interactive editable transcript, customer suggestions, and quick actions:
/// (🎤 كمّل كلام | 🔄 أعد التسجيل | ✕ إلغاء | ➤ إرسال)
/// ─────────────────────────────────────────────────────────────────────────────
class VoiceRecordingPanel extends StatefulWidget {
  final AssistantVoiceState state;
  final VoidCallback onCancel;
  final ValueChanged<String>? onSend;
  final VoidCallback? onAppend;
  final VoidCallback? onReRecord;
  final ValueChanged<String>? onTextEdited;
  final List<String> knownCustomers;

  const VoiceRecordingPanel({
    super.key,
    required this.state,
    required this.onCancel,
    this.onSend,
    this.onAppend,
    this.onReRecord,
    this.onTextEdited,
    this.knownCustomers = const <String>[],
  });

  @override
  State<VoiceRecordingPanel> createState() => _VoiceRecordingPanelState();
}

class _VoiceRecordingPanelState extends State<VoiceRecordingPanel> {
  late final TextEditingController _editController;
  late final FocusNode _editFocusNode;
  final DomainTextNormalizer _normalizer = DomainTextNormalizer();

  @override
  void initState() {
    super.initState();
    _editController = TextEditingController();
    _editFocusNode = FocusNode();
  }

  @override
  void didUpdateWidget(covariant VoiceRecordingPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    widget.state.maybeWhen(
      reviewing: (String text, _) {
        if (_editController.text != text) {
          _editController.text = text;
          _editController.selection = TextSelection.fromPosition(
            TextPosition(offset: text.length),
          );
        }
      },
      orElse: () {},
    );
  }

  @override
  void dispose() {
    _editController.dispose();
    _editFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.state.maybeWhen(
      listening: (String partialText, double soundLevel) {
        return _buildListeningCard(partialText, soundLevel);
      },
      reviewing: (String recognizedText, double countdown) {
        return _buildReviewingCard(recognizedText, countdown);
      },
      permissionDenied: (bool isPermanent) {
        return _buildPermissionCard(isPermanent);
      },
      error: (AssistantVoiceErrorKind kind, String? message) {
        return _buildErrorCard(message ?? "حدث خطأ أثناء التسجيل");
      },
      orElse: () => const SizedBox.shrink(),
    );
  }

  Widget _buildListeningCard(String partialText, double soundLevel) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: ColorManager.surface,
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(AppRadius.r24.r)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: <Widget>[
              // Pulsing recording indicator
              Container(
                width: 12.r,
                height: 12.r,
                decoration: const BoxDecoration(
                  color: ColorManager.error,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                "بسمعك… تكلّم الآن",
                style: getBoldStyle(
                  color: ColorManager.textPrimary,
                  fontSize: FontSize.s13,
                ),
              ),
              const Spacer(),
              // Cancel Button
              GestureDetector(
                onTap: widget.onCancel,
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: ColorManager.lightError,
                    borderRadius: BorderRadius.circular(AppRadius.r12.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(Icons.close_rounded,
                          size: 14.r, color: ColorManager.error),
                      SizedBox(width: 4.w),
                      Text(
                        "إلغاء",
                        style: getBoldStyle(
                          color: ColorManager.error,
                          fontSize: FontSize.s11,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),

          // Live Transcript Box (Partial results)
          Container(
            width: double.infinity,
            constraints: BoxConstraints(minHeight: 52.h),
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: ColorManager.surfaceVariant,
              borderRadius: BorderRadius.circular(AppRadius.r14.r),
            ),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 150),
              child: Text(
                partialText.isEmpty
                    ? "جارِ الاستماع وتحويل صوتك لكلام..."
                    : partialText,
                key: ValueKey<String>(partialText),
                style: getMediumStyle(
                  color: partialText.isEmpty
                      ? ColorManager.textTertiary
                      : ColorManager.textPrimary,
                  fontSize: FontSize.s14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewingCard(String text, double countdown) {
    if (_editController.text.isEmpty && text.isNotEmpty) {
      _editController.text = text;
      _editController.selection = TextSelection.fromPosition(
        TextPosition(offset: text.length),
      );
    }

    final Map<String, List<String>> customerSuggestions =
        _normalizer.findCustomerSuggestions(
      _editController.text,
      widget.knownCustomers,
    );

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: ColorManager.surface,
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(AppRadius.r24.r)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(Icons.edit_note_rounded,
                  color: ColorManager.primary, size: 20.r),
              SizedBox(width: 8.w),
              Text(
                "راجع الكلام وعدّل لو عايز",
                style: getBoldStyle(
                  color: ColorManager.textPrimary,
                  fontSize: FontSize.s13,
                ),
              ),
              const Spacer(),
              // Cancel Button
              GestureDetector(
                onTap: widget.onCancel,
                child: Padding(
                  padding: EdgeInsets.all(4.r),
                  child: Icon(
                    Icons.close_rounded,
                    size: 18.r,
                    color: ColorManager.textTertiary,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),

          // Editable Text Field with cursor at the end
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: ColorManager.surfaceVariant,
              borderRadius: BorderRadius.circular(AppRadius.r12.r),
              border: Border.all(
                color: ColorManager.border,
                width: 1,
              ),
            ),
            child: TextField(
              controller: _editController,
              focusNode: _editFocusNode,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.send,
              style: getMediumStyle(
                color: ColorManager.textPrimary,
                fontSize: FontSize.s14,
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                isDense: true,
                hintText: "اكتب أو عدّل النص هنا...",
              ),
              onChanged: (String val) {
                widget.onTextEdited?.call(val);
              },
              onSubmitted: (String val) {
                if (val.trim().isNotEmpty) {
                  widget.onSend?.call(val.trim());
                }
              },
            ),
          ),

          // Customer Suggestions Chips (if any fuzzy matches detected)
          if (customerSuggestions.isNotEmpty) ...<Widget>[
            SizedBox(height: 8.h),
            Wrap(
              spacing: 6.w,
              runSpacing: 4.h,
              children: customerSuggestions.entries.expand((MapEntry<String, List<String>> e) {
                return e.value.map((String candidate) {
                  return ActionChip(
                    avatar: Icon(Icons.person_outline_rounded,
                        size: 13.r, color: ColorManager.primary),
                    label: Text(
                      candidate,
                      style: getRegularStyle(
                        color: ColorManager.primary,
                        fontSize: FontSize.s11,
                      ),
                    ),
                    backgroundColor: ColorManager.lightPrimary,
                    side: BorderSide.none,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.r12.r),
                    ),
                    onPressed: () {
                      final String replaced =
                          _editController.text.replaceAll(e.key, candidate);
                      setState(() {
                        _editController.text = replaced;
                      });
                      widget.onTextEdited?.call(replaced);
                    },
                  );
                });
              }).toList(),
            ),
          ],

          SizedBox(height: 12.h),

          // 4 Quick Action Buttons:
          // 🎤 "كمّل كلام" | 🔄 "أعد التسجيل" | ✕ "إلغاء" | ➤ "إرسال"
          Row(
            children: <Widget>[
              // 1. "كمّل كلام" (Append)
              OutlinedButton.icon(
                onPressed: widget.onAppend,
                icon: Icon(Icons.mic_rounded, size: 15.r),
                label: Text(
                  "كمّل كلام",
                  style: getBoldStyle(
                    color: ColorManager.primary,
                    fontSize: FontSize.s11,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: ColorManager.primary,
                  side: const BorderSide(color: ColorManager.primary, width: 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.r12.r),
                  ),
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
                ),
              ),

              SizedBox(width: 8.w),

              // 2. "أعد التسجيل" (Re-record)
              OutlinedButton.icon(
                onPressed: widget.onReRecord,
                icon: Icon(Icons.replay_rounded, size: 15.r),
                label: Text(
                  "أعد التسجيل",
                  style: getBoldStyle(
                    color: ColorManager.textSecondary,
                    fontSize: FontSize.s11,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: ColorManager.textSecondary,
                  side: const BorderSide(color: ColorManager.border, width: 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.r12.r),
                  ),
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
                ),
              ),

              const Spacer(),

              // 3. "إرسال" (Send)
              ElevatedButton.icon(
                onPressed: () {
                  final String trimmed = _editController.text.trim();
                  if (trimmed.isNotEmpty) {
                    widget.onSend?.call(trimmed);
                  }
                },
                icon: const Icon(Icons.send_rounded, size: 15),
                label: Text(
                  "إرسال",
                  style: getBoldStyle(
                    color: ColorManager.white,
                    fontSize: FontSize.s12,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorManager.primary,
                  foregroundColor: ColorManager.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.r12.r),
                  ),
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPermissionCard(bool isPermanent) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: ColorManager.surface,
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(AppRadius.r24.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(Icons.mic_off_rounded,
              size: 36.r, color: ColorManager.secondary),
          SizedBox(height: 8.h),
          Text(
            "إذن الميكروفون مطلوب",
            style: getBoldStyle(
                color: ColorManager.textPrimary, fontSize: FontSize.s14),
          ),
          SizedBox(height: 4.h),
          Text(
            "يحتاج المساعد الذكي لإذن الميكروفون لتحويل كلامك لنصوص واستعلامات.",
            textAlign: TextAlign.center,
            style: getRegularStyle(
              color: ColorManager.textSecondary,
              fontSize: FontSize.s12,
            ),
          ),
          SizedBox(height: 12.h),
          ElevatedButton(
            onPressed: () {
              if (isPermanent) {
                openAppSettings();
              } else {
                Permission.microphone.request();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorManager.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.r12.r),
              ),
            ),
            child: Text(
              isPermanent ? "فتح إعدادات الهاتف" : "منح الإذن",
              style: getBoldStyle(
                  color: ColorManager.white, fontSize: FontSize.s12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorCard(String errorMsg) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      color: ColorManager.lightError,
      child: Row(
        children: <Widget>[
          Icon(Icons.error_outline_rounded,
              color: ColorManager.error, size: 18.r),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              errorMsg,
              style: getMediumStyle(
                  color: ColorManager.error, fontSize: FontSize.s12),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close_rounded, size: 16),
            onPressed: widget.onCancel,
          ),
        ],
      ),
    );
  }
}
