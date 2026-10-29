// ─────────────────────────────────────────────────────────────────────────────
// CreateVoiceNoteView — Mizan Voice Note Recording (Figma Node #2281:2)
// High-performance, responsive, zero-overflow voice note creator
// ─────────────────────────────────────────────────────────────────────────────

import 'dart:async';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart' as intl;
import 'package:mizan/app/di.dart';
import 'package:mizan/data/request/voice_note_request.dart';
import 'package:mizan/presentation/common/state_randrer/state_randrer_impl.dart';
import 'package:mizan/presentation/operations/widgets/contact_picker_bottom_sheet.dart';
import 'package:mizan/presentation/resources/assets_manager.dart';
import 'package:mizan/presentation/resources/color_manager.dart';
import 'package:mizan/presentation/resources/font_manager.dart';
import 'package:mizan/presentation/resources/routes_manager.dart';
import 'package:mizan/presentation/resources/strings_manager.dart';
import 'package:mizan/presentation/resources/styles_manager.dart';
import 'package:mizan/presentation/resources/values_manager.dart';
import 'package:mizan/presentation/voice_note/create_voice_note_cubit/create_voice_note_cubit.dart';
import 'package:mizan/presentation/voice_note/create_voice_note_cubit/create_voice_note_state.dart';
import 'package:mizan/app/voice_note_audio_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

class CreateVoiceNoteView extends StatelessWidget {
  const CreateVoiceNoteView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<VoiceNoteFormCubit>(
      create: (_) => getIt<VoiceNoteFormCubit>(),
      child: const _CreateVoiceNoteScreen(),
    );
  }
}

class _CreateVoiceNoteScreen extends StatefulWidget {
  const _CreateVoiceNoteScreen();

  @override
  State<_CreateVoiceNoteScreen> createState() => _CreateVoiceNoteScreenState();
}

class _CreateVoiceNoteScreenState extends State<_CreateVoiceNoteScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  final AudioRecorder _audioRecorder = AudioRecorder();
  final AudioPlayer _audioPlayer = AudioPlayer();

  // Animation controller for pulsing mic button
  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;

  final List<num> _quickAmountChips = <num>[50, 100, 250, 500, 1000, 2000];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.25).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _audioPlayer.onPositionChanged.listen((Duration pos) {
      if (mounted) {
        final VoiceNoteFormState st = context.read<VoiceNoteFormCubit>().state;
        if (st.recordedAudioPath != null) {
          final int totalMs = st.totalAudioDuration.inMilliseconds > 0
              ? st.totalAudioDuration.inMilliseconds
              : (st.recordSeconds * 1000);
          if (totalMs > 0) {
            final double prog = (pos.inMilliseconds / totalMs).clamp(0.0, 1.0);
            context.read<VoiceNoteFormCubit>().updatePlayback(progress: prog);
          }
        }
      }
    });

    _audioPlayer.onDurationChanged.listen((Duration dur) {
      if (mounted) {
        context.read<VoiceNoteFormCubit>().updatePlayback(duration: dur);
      }
    });

    _audioPlayer.onPlayerComplete.listen((_) {
      if (mounted) {
        context.read<VoiceNoteFormCubit>().updatePlayback(
          isPlaying: false,
          progress: 0.0,
        );
      }
    });

    _audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      if (mounted) {
        context.read<VoiceNoteFormCubit>().updatePlayback(
          isPlaying: state == PlayerState.playing,
        );
      }
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _audioRecorder.dispose();
    _audioPlayer.dispose();
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  // ── Real Audio Recording Methods ───────────────────────────────────────────
  Future<void> _startRecording() async {
    try {
      if (await _audioRecorder.hasPermission()) {
        final Directory tempDir = await getTemporaryDirectory();
        final String filePath =
            '${tempDir.path}/mizan_voice_${DateTime.now().millisecondsSinceEpoch}.m4a';

        await _audioRecorder.start(
          const RecordConfig(
            encoder: AudioEncoder.aacLc,
            bitRate: 128000,
            sampleRate: 44100,
          ),
          path: filePath,
        );

        if (mounted) {
          context.read<VoiceNoteFormCubit>().startRecordingTimer();
        }
        _pulseController.repeat(reverse: true);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('يرجى منح إذن الميكروفون لتسجيل الملاحظة الصوتية'),
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('Error starting audio recording: $e');
    }
  }

  Future<void> _stopRecording() async {
    _pulseController.stop();
    _pulseController.reset();

    try {
      final String? path = await _audioRecorder.stop();
      if (mounted) {
        context.read<VoiceNoteFormCubit>().stopRecordingTimer(path);
      }
    } catch (e) {
      debugPrint('Error stopping audio recording: $e');
      if (mounted) {
        context.read<VoiceNoteFormCubit>().stopRecordingTimer(null);
      }
    }
  }

  Future<void> _cancelRecording() async {
    _pulseController.stop();
    _pulseController.reset();
    try {
      await _audioRecorder.stop();
    } catch (_) {}
    if (!mounted) return;
    if (context.read<VoiceNoteFormCubit>().state.isPlayingPreview) {
      await _audioPlayer.stop();
    }
    if (mounted) {
      context.read<VoiceNoteFormCubit>().resetRecording();
    }
  }

  Future<void> _togglePreviewPlay() async {
    final VoiceNoteFormState state = context.read<VoiceNoteFormCubit>().state;
    if (state.recordedAudioPath == null) return;

    if (state.isPlayingPreview) {
      await _audioPlayer.pause();
      if (mounted) {
        context.read<VoiceNoteFormCubit>().updatePlayback(isPlaying: false);
      }
    } else {
      if (state.previewProgress >= 0.99) {
        context.read<VoiceNoteFormCubit>().updatePlayback(progress: 0.0);
      }
      await _audioPlayer.play(DeviceFileSource(state.recordedAudioPath!));
      if (mounted) {
        context.read<VoiceNoteFormCubit>().updatePlayback(isPlaying: true);
      }
    }
  }

  String _formatDuration(int seconds) {
    final String mins = (seconds ~/ 60).toString().padLeft(2, '0');
    final String secs = (seconds % 60).toString().padLeft(2, '0');
    return '$mins:$secs';
  }

  // ── Contact Picker ────────────────────────────────────────────────────────
  Future<void> _pickContact() async {
    final VoiceNoteFormState state = context.read<VoiceNoteFormCubit>().state;
    final ContactPickerResult? result = await ContactPickerBottomSheet.show(
      context,
      selectedContactId: state.contactId,
      selectedName: state.partyName,
    );

    if (result != null && mounted) {
      context.read<VoiceNoteFormCubit>().setContact(
        contactId: result.contactId,
        partyName: result.name,
        isVip: result.isVip,
      );
    }
  }

  // ── Date Picker ───────────────────────────────────────────────────────────
  Future<void> _selectDate() async {
    final VoiceNoteFormState state = context.read<VoiceNoteFormCubit>().state;
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: state.operationDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: ColorManager.primary,
              onPrimary: ColorManager.white,
              onSurface: ColorManager.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && mounted) {
      context.read<VoiceNoteFormCubit>().setOperationDate(picked);
    }
  }

  // ── Submit Voice Note ─────────────────────────────────────────────────────
  void _submitForm() {
    final VoiceNoteFormState state = context.read<VoiceNoteFormCubit>().state;
    if (state.recordedAudioPath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "يرجى تسجيل الصوت أولاً قبل حفظ الملاحظة",
            style: getMediumStyle(
              color: ColorManager.white,
              fontSize: FontSize.s13,
            ),
          ),
          backgroundColor: ColorManager.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (!_formKey.currentState!.validate()) return;

    final num amount = num.tryParse(_amountController.text.trim()) ?? 0;
    if (amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppStrings.amountRequired,
            style: getMediumStyle(
              color: ColorManager.white,
              fontSize: FontSize.s13,
            ),
          ),
          backgroundColor: ColorManager.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final bool hasContact =
        state.contactId != null && state.contactId!.isNotEmpty;
    final bool hasPartyName =
        state.partyName != null && state.partyName!.trim().isNotEmpty;
    if (!hasContact && !hasPartyName) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "يرجى اختيار الطرف الثاني أو كتابة اسمه",
            style: getMediumStyle(
              color: ColorManager.white,
              fontSize: FontSize.s13,
            ),
          ),
          backgroundColor: ColorManager.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final CreateVoiceNoteRequest request = CreateVoiceNoteRequest(
      audioFile: File(state.recordedAudioPath!),
      operationType: state.operationType,
      amount: amount,
      operationDate: (state.operationDate ?? DateTime.now()).toIso8601String(),
      contactId: state.contactId,
      partyName: state.partyName,
      notes: _notesController.text.trim().isNotEmpty
          ? _notesController.text.trim()
          : null,
    );

    context.read<VoiceNoteFormCubit>().submit(request);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<VoiceNoteFormCubit, VoiceNoteFormState>(
      listener: (BuildContext context, VoiceNoteFormState state) {
        if (state.isActionSuccess && state.savedVoiceNote != null) {
          if (state.recordedAudioPath != null) {
            unawaited(
              VoiceNoteAudioService.cacheLocalRecording(
                voiceNoteId: state.savedVoiceNote!.id,
                audioPath: state.savedVoiceNote!.audioPath,
                recordedFilePath: state.recordedAudioPath!,
              ),
            );
          }
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: <Widget>[
                  const Icon(
                    Icons.check_circle_rounded,
                    color: ColorManager.white,
                  ),
                  SizedBox(width: 5.w),
                  Expanded(
                    child: Text(
                      AppStrings.voiceNoteSavedSuccess,
                      style: getBoldStyle(
                        color: ColorManager.white,
                        fontSize: FontSize.s12.sp,
                      ),
                    ),
                  ),
                ],
              ),
              backgroundColor: ColorManager.success,
              behavior: SnackBarBehavior.floating,
            ),
          );
          Navigator.of(
            context,
          ).pushReplacementNamed(Routes.voiceNotesListRoute);
        }
      },
      builder: (BuildContext context, VoiceNoteFormState state) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            backgroundColor: ColorManager.background,
            body: SafeArea(
              child:
                  state.flowState?.getScreenWidget(
                    context,
                    _buildScreenBody(context, state),
                    () => _submitForm(),
                  ) ??
                  _buildScreenBody(context, state),
            ),
          ),
        );
      },
    );
  }

  Widget _buildScreenBody(BuildContext context, VoiceNoteFormState state) {
    return Column(
      children: <Widget>[
        // ── Custom AppBar ─────────────────────────────────────────────────────
        _buildAppBar(context, state),

        // ── Scrollable Form Content ───────────────────────────────────────────
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  // 1. Audio Recorder / Player Card
                  _buildAudioRecorderCard(state),

                  SizedBox(height: 16.h),

                  // 2. Operation Type Selector
                  _buildOperationTypeSelector(state),

                  SizedBox(height: 16.h),

                  // 3. Amount Input & Quick Chips
                  _buildAmountSection(),

                  SizedBox(height: 16.h),

                  // 4. Contact / Party Selection
                  _buildContactSection(state),

                  SizedBox(height: 16.h),

                  // 5. Operation Date Picker
                  _buildDateSection(state),

                  SizedBox(height: 16.h),

                  // 6. Notes & Voice Transcription Field
                  _buildNotesSection(),

                  SizedBox(height: 24.h),

                  // 7. Submit Action Button
                  _buildSubmitButton(),

                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ── AppBar ────────────────────────────────────────────────────────────────
  Widget _buildAppBar(BuildContext context, VoiceNoteFormState state) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: const BoxDecoration(
        color: ColorManager.surface,
        border: Border(
          bottom: BorderSide(color: ColorManager.border, width: 1),
        ),
      ),
      child: Row(
        children: <Widget>[
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            style: IconButton.styleFrom(
              backgroundColor: ColorManager.surfaceVariant,
              shape: const CircleBorder(),
            ),
            icon: SvgPicture.asset(
              IconAssets.arrowLeft,
              width: 18.r,
              height: 18.r,
              colorFilter: const ColorFilter.mode(
                ColorManager.textPrimary,
                BlendMode.srcIn,
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  AppStrings.newVoiceNote,
                  style: getBoldStyle(
                    color: ColorManager.textPrimary,
                    fontSize: FontSize.s16,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  AppStrings.voiceNotesSubtitle,
                  style: getRegularStyle(
                    color: ColorManager.textSecondary,
                    fontSize: FontSize.s11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── 1. Audio Recorder / Player Card ───────────────────────────────────────
  Widget _buildAudioRecorderCard(VoiceNoteFormState state) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: ColorManager.surface,
        borderRadius: BorderRadius.circular(AppRadius.r18.r),
        border: Border.all(
          color: state.isRecording
              ? ColorManager.primary
              : state.recordedAudioPath != null
              ? ColorManager.success
              : ColorManager.border,
          width: state.isRecording || state.recordedAudioPath != null
              ? 1.5
              : 1.0,
        ),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: ColorManager.shadowMedium,
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: <Widget>[
          if (!state.isRecording &&
              state.recordedAudioPath == null) ...<Widget>[
            // State A: Idle (Ready to record)
            GestureDetector(
              onTap: _startRecording,
              child: Container(
                width: 76.r,
                height: 76.r,
                decoration: BoxDecoration(
                  gradient: ColorManager.primaryGradient,
                  shape: BoxShape.circle,
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: ColorManager.primary.withAlpha(70),
                      blurRadius: 18,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Center(
                  child: SvgPicture.asset(
                    IconAssets.mic,
                    width: 36.r,
                    height: 36.r,
                    colorFilter: const ColorFilter.mode(
                      ColorManager.white,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 14.h),
            Text(
              AppStrings.tapToRecord,
              style: getBoldStyle(
                color: ColorManager.textPrimary,
                fontSize: FontSize.s15,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              "تحدث بوضوح واذكر المبلغ والطرف ونوع المعاملة",
              textAlign: TextAlign.center,
              style: getRegularStyle(
                color: ColorManager.textSecondary,
                fontSize: FontSize.s11,
              ),
            ),
          ] else if (state.isRecording) ...<Widget>[
            // State B: Active Recording
            AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (BuildContext context, Widget? child) {
                return Transform.scale(
                  scale: _pulseAnimation.value,
                  child: Container(
                    width: 76.r,
                    height: 76.r,
                    decoration: BoxDecoration(
                      color: ColorManager.primary,
                      shape: BoxShape.circle,
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: ColorManager.primary.withAlpha(120),
                          blurRadius: 24,
                          spreadRadius: 4,
                        ),
                      ],
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        IconAssets.mic,
                        width: 36.r,
                        height: 36.r,
                        colorFilter: const ColorFilter.mode(
                          ColorManager.white,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 14.h),
            Text(
              _formatDuration(state.recordSeconds),
              style: getBoldStyle(
                color: ColorManager.primary,
                fontSize: FontSize.s22,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              AppStrings.recordingInProgress,
              style: getMediumStyle(
                color: ColorManager.textSecondary,
                fontSize: FontSize.s12,
              ),
            ),
            SizedBox(height: 16.h),
            // Waveform simulation bars
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List<Widget>.generate(18, (int index) {
                final List<int> heights = <int>[
                  12,
                  22,
                  34,
                  18,
                  28,
                  42,
                  16,
                  30,
                  48,
                  24,
                  38,
                  14,
                  26,
                  44,
                  20,
                  32,
                  18,
                  10,
                ];
                final int h = heights[index % heights.length];
                return Container(
                  width: 3.5.w,
                  height: h.h * 0.7,
                  margin: EdgeInsets.symmetric(horizontal: 2.w),
                  decoration: BoxDecoration(
                    color: ColorManager.primary,
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                );
              }),
            ),
            SizedBox(height: 18.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                OutlinedButton.icon(
                  onPressed: _cancelRecording,
                  icon: const Icon(
                    Icons.close_rounded,
                    size: 16,
                    color: ColorManager.textSecondary,
                  ),
                  label: Text(
                    "إلغاء",
                    style: getMediumStyle(
                      color: ColorManager.textSecondary,
                      fontSize: FontSize.s12,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: ColorManager.border),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.r10.r),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                ElevatedButton.icon(
                  onPressed: _stopRecording,
                  icon: const Icon(
                    Icons.stop_rounded,
                    size: 18,
                    color: ColorManager.white,
                  ),
                  label: Text(
                    AppStrings.stopRecording,
                    style: getBoldStyle(
                      color: ColorManager.white,
                      fontSize: FontSize.s12,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorManager.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.r10.r),
                    ),
                  ),
                ),
              ],
            ),
          ] else ...<Widget>[
            // State C: Recorded Audio Ready
            Row(
              children: <Widget>[
                // Play / Pause Circle Button
                GestureDetector(
                  onTap: _togglePreviewPlay,
                  child: Container(
                    width: 48.r,
                    height: 48.r,
                    decoration: const BoxDecoration(
                      color: ColorManager.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Icon(
                        state.isPlayingPreview
                            ? Icons.pause_rounded
                            : Icons.play_arrow_rounded,
                        color: ColorManager.white,
                        size: 28.r,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "التسجيل جاهز للحفظ",
                            style: getBoldStyle(
                              color: ColorManager.textPrimary,
                              fontSize: FontSize.s13,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 2.h,
                            ),
                            decoration: BoxDecoration(
                              color: ColorManager.successContainer,
                              borderRadius: BorderRadius.circular(
                                AppRadius.r6.r,
                              ),
                            ),
                            child: Text(
                              _formatDuration(state.recordSeconds),
                              style: getBoldStyle(
                                color: ColorManager.success,
                                fontSize: FontSize.s11,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      // Progress Bar
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4.r),
                        child: LinearProgressIndicator(
                          value: state.previewProgress,
                          backgroundColor: ColorManager.surfaceVariant,
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            ColorManager.primary,
                          ),
                          minHeight: 6.h,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            const Divider(color: ColorManager.border, height: 1),
            SizedBox(height: 8.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                TextButton.icon(
                  onPressed: _startRecording,
                  icon: const Icon(
                    Icons.refresh_rounded,
                    size: 16,
                    color: ColorManager.textSecondary,
                  ),
                  label: Text(
                    AppStrings.rerecord,
                    style: getMediumStyle(
                      color: ColorManager.textSecondary,
                      fontSize: FontSize.s11,
                    ),
                  ),
                ),
                Text(
                  "ملف صوتي (.m4a)",
                  style: getRegularStyle(
                    color: ColorManager.textTertiary,
                    fontSize: FontSize.s10,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  // ── 2. Operation Type Selector ────────────────────────────────────────────
  Widget _buildOperationTypeSelector(VoiceNoteFormState state) {
    final List<Map<String, Object>> types = <Map<String, Object>>[
      <String, Object>{
        'key': VoiceNoteOperationType.sale,
        'label': AppStrings.quickSale,
        'color': ColorManager.success,
        'container': ColorManager.successContainer,
        'icon': IconAssets.shoppingBag,
      },
      <String, Object>{
        'key': VoiceNoteOperationType.purchase,
        'label': AppStrings.quickPurchase,
        'color': ColorManager.error,
        'container': ColorManager.errorContainer,
        'icon': IconAssets.arrowUpRight,
      },
      <String, Object>{
        'key': VoiceNoteOperationType.installmentCollection,
        'label': "تحصيل قسط",
        'color': ColorManager.secondary,
        'container': ColorManager.lightSecondary,
        'icon': IconAssets.arrowDownLeft,
      },
      <String, Object>{
        'key': VoiceNoteOperationType.installmentPayment,
        'label': "سداد قسط",
        'color': ColorManager.voiceNotePurple,
        'container': ColorManager.voiceNoteContainer,
        'icon': IconAssets.walletCards,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          AppStrings.operationTypeLabel,
          style: getBoldStyle(
            color: ColorManager.textPrimary,
            fontSize: FontSize.s13,
          ),
        ),
        SizedBox(height: 8.h),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 8.h,
            crossAxisSpacing: 8.w,
            childAspectRatio: 2.6,
          ),
          itemCount: types.length,
          itemBuilder: (BuildContext context, int index) {
            final Map<String, Object> t = types[index];
            final bool isSelected = state.operationType == t['key'];
            final Color color = t['color'] as Color;
            final Color containerColor = t['container'] as Color;

            return GestureDetector(
              onTap: () => context.read<VoiceNoteFormCubit>().setOperationType(
                t['key'] as String,
              ),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: isSelected ? containerColor : ColorManager.surface,
                  borderRadius: BorderRadius.circular(AppRadius.r12.r),
                  border: Border.all(
                    color: isSelected ? color : ColorManager.border,
                    width: isSelected ? 1.5 : 1.0,
                  ),
                ),
                child: Row(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(6.r),
                      decoration: BoxDecoration(
                        color: isSelected ? color : ColorManager.surfaceVariant,
                        borderRadius: BorderRadius.circular(AppRadius.r8.r),
                      ),
                      child: SvgPicture.asset(
                        t['icon'] as String,
                        width: 14.r,
                        height: 14.r,
                        colorFilter: ColorFilter.mode(
                          isSelected
                              ? ColorManager.white
                              : ColorManager.textSecondary,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        t['label'] as String,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: getBoldStyle(
                          color: isSelected ? color : ColorManager.textPrimary,
                          fontSize: FontSize.s12,
                        ),
                      ),
                    ),
                    if (isSelected)
                      Icon(
                        Icons.check_circle_rounded,
                        color: color,
                        size: 16.r,
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  // ── 3. Amount Section ─────────────────────────────────────────────────────
  Widget _buildAmountSection() {
    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: ColorManager.surface,
        borderRadius: BorderRadius.circular(AppRadius.r14.r),
        border: Border.all(color: ColorManager.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                AppStrings.amountLabel,
                style: getBoldStyle(
                  color: ColorManager.textPrimary,
                  fontSize: FontSize.s13,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: ColorManager.lightPrimary,
                  borderRadius: BorderRadius.circular(AppRadius.r6.r),
                ),
                child: Text(
                  AppStrings.egp,
                  style: getBoldStyle(
                    color: ColorManager.primary,
                    fontSize: FontSize.s11,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          TextFormField(
            controller: _amountController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            style: getBoldStyle(
              color: ColorManager.textPrimary,
              fontSize: FontSize.s20,
            ),
            decoration: InputDecoration(
              hintText: "0.00",
              hintStyle: getRegularStyle(
                color: ColorManager.textTertiary,
                fontSize: FontSize.s20,
              ),
              filled: true,
              fillColor: ColorManager.surfaceVariant,
              prefixIcon: Padding(
                padding: EdgeInsets.all(12.r),
                child: SvgPicture.asset(
                  IconAssets.wallet2,
                  width: 18.r,
                  height: 18.r,
                  colorFilter: const ColorFilter.mode(
                    ColorManager.primary,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.r10.r),
                borderSide: BorderSide.none,
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 14.w,
                vertical: 12.h,
              ),
            ),
            validator: (String? value) {
              if (value == null || value.trim().isEmpty) {
                return AppStrings.amountRequired;
              }
              final num? numVal = num.tryParse(value.trim());
              if (numVal == null || numVal <= 0) {
                return AppStrings.amountRequired;
              }
              return null;
            },
          ),
          SizedBox(height: 10.h),
          // Quick amount chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: _quickAmountChips.map((num chipVal) {
                return Padding(
                  padding: EdgeInsets.only(left: 6.w),
                  child: InkWell(
                    onTap: () {
                      _amountController.text = chipVal.toString();
                    },
                    borderRadius: BorderRadius.circular(AppRadius.r8.r),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        color: ColorManager.surfaceVariant,
                        borderRadius: BorderRadius.circular(AppRadius.r8.r),
                        border: Border.all(color: ColorManager.border),
                      ),
                      child: Text(
                        "+$chipVal",
                        style: getMediumStyle(
                          color: ColorManager.textPrimary,
                          fontSize: FontSize.s11,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  // ── 4. Contact Section ────────────────────────────────────────────────────
  Widget _buildContactSection(VoiceNoteFormState state) {
    final bool hasSelectedContact =
        (state.partyName != null && state.partyName!.isNotEmpty) ||
        (state.contactId != null && state.contactId!.isNotEmpty);

    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: ColorManager.surface,
        borderRadius: BorderRadius.circular(AppRadius.r14.r),
        border: Border.all(color: ColorManager.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                AppStrings.partyNameLabel,
                style: getBoldStyle(
                  color: ColorManager.textPrimary,
                  fontSize: FontSize.s13,
                ),
              ),
              if (hasSelectedContact)
                GestureDetector(
                  onTap: () {
                    context.read<VoiceNoteFormCubit>().setContact(
                      contactId: null,
                      partyName: null,
                      isVip: false,
                    );
                  },
                  child: Text(
                    "مسح",
                    style: getMediumStyle(
                      color: ColorManager.error,
                      fontSize: FontSize.s11,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 8.h),
          InkWell(
            onTap: _pickContact,
            borderRadius: BorderRadius.circular(AppRadius.r10.r),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: ColorManager.surfaceVariant,
                borderRadius: BorderRadius.circular(AppRadius.r10.r),
              ),
              child: Row(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(6.r),
                    decoration: BoxDecoration(
                      color: hasSelectedContact
                          ? ColorManager.lightPrimary
                          : ColorManager.surface,
                      shape: BoxShape.circle,
                    ),
                    child: SvgPicture.asset(
                      IconAssets.user,
                      width: 16.r,
                      height: 16.r,
                      colorFilter: ColorFilter.mode(
                        hasSelectedContact
                            ? ColorManager.primary
                            : ColorManager.textTertiary,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: hasSelectedContact
                        ? Row(
                            children: <Widget>[
                              Flexible(
                                child: Text(
                                  state.partyName ?? "طرف مجهول",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: getBoldStyle(
                                    color: ColorManager.textPrimary,
                                    fontSize: FontSize.s13,
                                  ),
                                ),
                              ),
                              if (state.isPartyVip) ...<Widget>[
                                SizedBox(width: 6.w),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 6.w,
                                    vertical: 2.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: ColorManager.lightSecondary,
                                    borderRadius: BorderRadius.circular(
                                      AppRadius.r4.r,
                                    ),
                                  ),
                                  child: Text(
                                    "VIP",
                                    style: getBoldStyle(
                                      color: ColorManager.darkSecondary,
                                      fontSize: FontSize.s9,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          )
                        : Text(
                            "اضغط لاختيار الطرف الثاني أو كتابة اسمه...",
                            style: getRegularStyle(
                              color: ColorManager.textTertiary,
                              fontSize: FontSize.s12,
                            ),
                          ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 14.r,
                    color: ColorManager.textSecondary,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── 5. Date Section ───────────────────────────────────────────────────────
  Widget _buildDateSection(VoiceNoteFormState state) {
    final DateTime date = state.operationDate ?? DateTime.now();
    final String formattedDate = intl.DateFormat(
      'yyyy/MM/dd',
      'ar',
    ).format(date);
    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: ColorManager.surface,
        borderRadius: BorderRadius.circular(AppRadius.r14.r),
        border: Border.all(color: ColorManager.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            AppStrings.operationDateLabel,
            style: getBoldStyle(
              color: ColorManager.textPrimary,
              fontSize: FontSize.s13,
            ),
          ),
          SizedBox(height: 8.h),
          InkWell(
            onTap: _selectDate,
            borderRadius: BorderRadius.circular(AppRadius.r10.r),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: ColorManager.surfaceVariant,
                borderRadius: BorderRadius.circular(AppRadius.r10.r),
              ),
              child: Row(
                children: <Widget>[
                  SvgPicture.asset(
                    IconAssets.calendar,
                    width: 16.r,
                    height: 16.r,
                    colorFilter: const ColorFilter.mode(
                      ColorManager.primary,
                      BlendMode.srcIn,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Text(
                      formattedDate,
                      style: getMediumStyle(
                        color: ColorManager.textPrimary,
                        fontSize: FontSize.s13,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.calendar_month_rounded,
                    size: 16.r,
                    color: ColorManager.textSecondary,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── 6. Notes Section ──────────────────────────────────────────────────────
  Widget _buildNotesSection() {
    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: ColorManager.surface,
        borderRadius: BorderRadius.circular(AppRadius.r14.r),
        border: Border.all(color: ColorManager.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            AppStrings.voiceNoteNotesLabel,
            style: getBoldStyle(
              color: ColorManager.textPrimary,
              fontSize: FontSize.s13,
            ),
          ),
          SizedBox(height: 8.h),
          TextFormField(
            controller: _notesController,
            maxLines: 3,
            style: getRegularStyle(
              color: ColorManager.textPrimary,
              fontSize: FontSize.s13,
            ),
            decoration: InputDecoration(
              hintText: AppStrings.voiceNoteNotesHint,
              hintStyle: getRegularStyle(
                color: ColorManager.textTertiary,
                fontSize: FontSize.s12,
              ),
              filled: true,
              fillColor: ColorManager.surfaceVariant,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.r10.r),
                borderSide: BorderSide.none,
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 12.w,
                vertical: 10.h,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── 7. Submit Button ──────────────────────────────────────────────────────
  Widget _buildSubmitButton() {
    return Container(
      width: double.infinity,
      height: 72.h,
      decoration: BoxDecoration(
        gradient: ColorManager.primaryGradient,
        borderRadius: BorderRadius.circular(AppRadius.r14.r),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: ColorManager.primary.withAlpha(70),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: _submitForm,
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorManager.transparent,
          shadowColor: ColorManager.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.r14.r),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SvgPicture.asset(
              IconAssets.mic,
              width: 18.r,
              height: 18.r,
              colorFilter: const ColorFilter.mode(
                ColorManager.white,
                BlendMode.srcIn,
              ),
            ),
            SizedBox(width: 8.w),
            Text(
              AppStrings.saveVoiceNote,
              style: getBoldStyle(
                color: ColorManager.white,
                fontSize: FontSize.s15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
