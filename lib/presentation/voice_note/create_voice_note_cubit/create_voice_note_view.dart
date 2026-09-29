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
import 'package:mizan/presentation/resources/strings_manager.dart';
import 'package:mizan/presentation/resources/styles_manager.dart';
import 'package:mizan/presentation/resources/values_manager.dart';
import 'package:mizan/presentation/voice_note/create_voice_note_cubit/create_voice_note_cubit.dart';
import 'package:mizan/presentation/voice_note/create_voice_note_cubit/create_voice_note_state.dart';
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
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();

  // Selected Operation Type
  String _selectedOperationType = VoiceNoteOperationType.sale;

  // Selected Contact
  String? _selectedContactId;
  String? _selectedPartyName;
  bool _isPartyVip = false;

  // Operation Date
  DateTime _operationDate = DateTime.now();

  // Real Audio Recording & Playback State
  final AudioRecorder _audioRecorder = AudioRecorder();
  final AudioPlayer _audioPlayer = AudioPlayer();

  bool _isRecording = false;
  int _recordSeconds = 0;
  Timer? _recordTimer;
  File? _recordedAudioFile;

  bool _isPlayingPreview = false;
  double _previewProgress = 0.0;
  Duration _totalAudioDuration = Duration.zero;

  // Animation controller for pulsing mic button
  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;

  final List<num> _quickAmountChips = [50, 100, 250, 500, 1000, 2000];

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

    _audioPlayer.onPositionChanged.listen((pos) {
      if (mounted && _recordedAudioFile != null) {
        final totalMs = _totalAudioDuration.inMilliseconds > 0
            ? _totalAudioDuration.inMilliseconds
            : (_recordSeconds * 1000);
        if (totalMs > 0) {
          setState(() {
            _previewProgress = (pos.inMilliseconds / totalMs).clamp(0.0, 1.0);
          });
        }
      }
    });

    _audioPlayer.onDurationChanged.listen((dur) {
      if (mounted) {
        setState(() {
          _totalAudioDuration = dur;
        });
      }
    });

    _audioPlayer.onPlayerComplete.listen((_) {
      if (mounted) {
        setState(() {
          _isPlayingPreview = false;
          _previewProgress = 0.0;
        });
      }
    });

    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted) {
        setState(() {
          _isPlayingPreview = state == PlayerState.playing;
        });
      }
    });
  }

  @override
  void dispose() {
    _recordTimer?.cancel();
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
        final tempDir = await getTemporaryDirectory();
        final filePath =
            '${tempDir.path}/mizan_voice_${DateTime.now().millisecondsSinceEpoch}.m4a';

        await _audioRecorder.start(
          const RecordConfig(
            encoder: AudioEncoder.aacLc,
            bitRate: 128000,
            sampleRate: 44100,
          ),
          path: filePath,
        );

        setState(() {
          _isRecording = true;
          _recordSeconds = 0;
          _recordedAudioFile = null;
          _isPlayingPreview = false;
          _previewProgress = 0.0;
          _totalAudioDuration = Duration.zero;
        });
        _pulseController.repeat(reverse: true);

        _recordTimer?.cancel();
        _recordTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
          if (mounted) {
            setState(() {
              _recordSeconds++;
            });
          }
        });
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
    _recordTimer?.cancel();
    _pulseController.stop();
    _pulseController.reset();

    try {
      final path = await _audioRecorder.stop();
      if (path != null && mounted) {
        final file = File(path);
        setState(() {
          _isRecording = false;
          _recordedAudioFile = file;
          if (_recordSeconds == 0) _recordSeconds = 1;
        });
      } else if (mounted) {
        setState(() {
          _isRecording = false;
        });
      }
    } catch (e) {
      debugPrint('Error stopping audio recording: $e');
      if (mounted) {
        setState(() {
          _isRecording = false;
        });
      }
    }
  }

  Future<void> _cancelRecording() async {
    _recordTimer?.cancel();
    _pulseController.stop();
    _pulseController.reset();
    try {
      await _audioRecorder.stop();
    } catch (_) {}
    if (_isPlayingPreview) {
      await _audioPlayer.stop();
    }
    setState(() {
      _isRecording = false;
      _recordSeconds = 0;
      _recordedAudioFile = null;
      _isPlayingPreview = false;
      _previewProgress = 0.0;
      _totalAudioDuration = Duration.zero;
    });
  }

  Future<void> _togglePreviewPlay() async {
    if (_recordedAudioFile == null) return;

    if (_isPlayingPreview) {
      await _audioPlayer.pause();
      setState(() => _isPlayingPreview = false);
    } else {
      if (_previewProgress >= 0.99) {
        _previewProgress = 0.0;
      }
      await _audioPlayer.play(DeviceFileSource(_recordedAudioFile!.path));
      setState(() => _isPlayingPreview = true);
    }
  }

  String _formatDuration(int seconds) {
    final mins = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$mins:$secs';
  }

  // ── Contact Picker ────────────────────────────────────────────────────────
  Future<void> _pickContact() async {
    final result = await ContactPickerBottomSheet.show(
      context,
      selectedContactId: _selectedContactId,
      selectedName: _selectedPartyName,
    );

    if (result != null && mounted) {
      setState(() {
        _selectedContactId = result.contactId;
        _selectedPartyName = result.name;
        _isPartyVip = result.isVip;
      });
    }
  }

  // ── Date Picker ───────────────────────────────────────────────────────────
  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _operationDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
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
      setState(() {
        _operationDate = picked;
      });
    }
  }

  // ── Submit Voice Note ─────────────────────────────────────────────────────
  void _submitForm() {
    if (_recordedAudioFile == null) {
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

    final amount = num.tryParse(_amountController.text.trim()) ?? 0;
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

    final hasContact = _selectedContactId != null && _selectedContactId!.isNotEmpty;
    final hasPartyName = _selectedPartyName != null && _selectedPartyName!.trim().isNotEmpty;
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

    final request = CreateVoiceNoteRequest(
      audioFile: _recordedAudioFile!,
      operationType: _selectedOperationType,
      amount: amount,
      operationDate: _operationDate.toIso8601String(),
      contactId: _selectedContactId,
      partyName: _selectedPartyName,
      notes: _notesController.text.trim().isNotEmpty
          ? _notesController.text.trim()
          : null,
    );

    context.read<VoiceNoteFormCubit>().submit(request);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<VoiceNoteFormCubit, VoiceNoteFormState>(
      listener: (context, state) {
        if (state.isActionSuccess && state.savedVoiceNote != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.check_circle_rounded, color: Colors.white),
                  SizedBox(width: 8.w),
                  Text(
                    AppStrings.voiceNoteSavedSuccess,
                    style: getBoldStyle(
                      color: ColorManager.white,
                      fontSize: FontSize.s13,
                    ),
                  ),
                ],
              ),
              backgroundColor: ColorManager.success,
              behavior: SnackBarBehavior.floating,
            ),
          );
          Navigator.of(context).pop(true);
        }
      },
      builder: (context, state) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            backgroundColor: ColorManager.background,
            body: SafeArea(
              child: state.flowState?.getScreenWidget(
                    context,
                    _buildScreenBody(context),
                    () => _submitForm(),
                  ) ??
                  _buildScreenBody(context),
            ),
          ),
        );
      },
    );
  }

  Widget _buildScreenBody(BuildContext context) {
    return Column(
      children: [
        // ── Custom AppBar ─────────────────────────────────────────────────────
        _buildAppBar(context),

        // ── Scrollable Form Content ───────────────────────────────────────────
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 1. Audio Recorder / Player Card
                  _buildAudioRecorderCard(),

                  SizedBox(height: 16.h),

                  // 2. Operation Type Selector
                  _buildOperationTypeSelector(),

                  SizedBox(height: 16.h),

                  // 3. Amount Input & Quick Chips
                  _buildAmountSection(),

                  SizedBox(height: 16.h),

                  // 4. Contact / Party Selection
                  _buildContactSection(),

                  SizedBox(height: 16.h),

                  // 5. Operation Date Picker
                  _buildDateSection(),

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
  Widget _buildAppBar(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: ColorManager.surface,
        border: Border(
          bottom: BorderSide(color: ColorManager.border, width: 1),
        ),
      ),
      child: Row(
        children: [
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
              children: [
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
  Widget _buildAudioRecorderCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: ColorManager.surface,
        borderRadius: BorderRadius.circular(AppRadius.r18.r),
        border: Border.all(
          color: _isRecording
              ? ColorManager.primary
              : _recordedAudioFile != null
                  ? ColorManager.success
                  : ColorManager.border,
          width: _isRecording || _recordedAudioFile != null ? 1.5 : 1.0,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          if (!_isRecording && _recordedAudioFile == null) ...[
            // State A: Idle (Ready to record)
            GestureDetector(
              onTap: _startRecording,
              child: Container(
                width: 76.r,
                height: 76.r,
                decoration: BoxDecoration(
                  gradient: ColorManager.primaryGradient,
                  shape: BoxShape.circle,
                  boxShadow: [
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
          ] else if (_isRecording) ...[
            // State B: Active Recording
            AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _pulseAnimation.value,
                  child: Container(
                    width: 76.r,
                    height: 76.r,
                    decoration: BoxDecoration(
                      color: ColorManager.primary,
                      shape: BoxShape.circle,
                      boxShadow: [
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
              _formatDuration(_recordSeconds),
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
              children: List.generate(18, (index) {
                final heights = [12, 22, 34, 18, 28, 42, 16, 30, 48, 24, 38, 14, 26, 44, 20, 32, 18, 10];
                final h = heights[index % heights.length];
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
              children: [
                OutlinedButton.icon(
                  onPressed: _cancelRecording,
                  icon: const Icon(Icons.close_rounded, size: 16, color: ColorManager.textSecondary),
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
                  icon: const Icon(Icons.stop_rounded, size: 18, color: ColorManager.white),
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
          ] else ...[
            // State C: Recorded Audio Ready
            Row(
              children: [
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
                        _isPlayingPreview
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
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
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
                              borderRadius: BorderRadius.circular(AppRadius.r6.r),
                            ),
                            child: Text(
                              _formatDuration(_recordSeconds),
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
                          value: _previewProgress,
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
            Divider(color: ColorManager.border, height: 1),
            SizedBox(height: 8.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton.icon(
                  onPressed: _startRecording,
                  icon: const Icon(Icons.refresh_rounded, size: 16, color: ColorManager.textSecondary),
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
  Widget _buildOperationTypeSelector() {
    final types = [
      {
        'key': VoiceNoteOperationType.sale,
        'label': AppStrings.quickSale,
        'color': ColorManager.success,
        'container': ColorManager.successContainer,
        'icon': IconAssets.shoppingBag,
      },
      {
        'key': VoiceNoteOperationType.purchase,
        'label': AppStrings.quickPurchase,
        'color': ColorManager.error,
        'container': ColorManager.errorContainer,
        'icon': IconAssets.arrowUpRight,
      },
      {
        'key': VoiceNoteOperationType.installmentCollection,
        'label': "تحصيل قسط",
        'color': ColorManager.secondary,
        'container': ColorManager.lightSecondary,
        'icon': IconAssets.arrowDownLeft,
      },
      {
        'key': VoiceNoteOperationType.installmentPayment,
        'label': "سداد قسط",
        'color': const Color(0xFF5E48B8),
        'container': const Color(0xFFF0EDFC),
        'icon': IconAssets.walletCards,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
          itemBuilder: (context, index) {
            final t = types[index];
            final isSelected = _selectedOperationType == t['key'];
            final color = t['color'] as Color;
            final containerColor = t['container'] as Color;

            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedOperationType = t['key'] as String;
                });
              },
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
                  children: [
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
                          isSelected ? ColorManager.white : ColorManager.textSecondary,
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
                      Icon(Icons.check_circle_rounded, color: color, size: 16.r),
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
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
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
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return AppStrings.amountRequired;
              }
              final numVal = num.tryParse(value.trim());
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
              children: _quickAmountChips.map((chipVal) {
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
  Widget _buildContactSection() {
    final hasSelectedContact =
        (_selectedPartyName != null && _selectedPartyName!.isNotEmpty) ||
        (_selectedContactId != null && _selectedContactId!.isNotEmpty);

    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: ColorManager.surface,
        borderRadius: BorderRadius.circular(AppRadius.r14.r),
        border: Border.all(color: ColorManager.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
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
                    setState(() {
                      _selectedContactId = null;
                      _selectedPartyName = null;
                      _isPartyVip = false;
                    });
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
                children: [
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
                            children: [
                              Flexible(
                                child: Text(
                                  _selectedPartyName ?? "طرف مجهول",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: getBoldStyle(
                                    color: ColorManager.textPrimary,
                                    fontSize: FontSize.s13,
                                  ),
                                ),
                              ),
                              if (_isPartyVip) ...[
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
  Widget _buildDateSection() {
    final formattedDate =
        intl.DateFormat('yyyy/MM/dd', 'ar').format(_operationDate);

    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: ColorManager.surface,
        borderRadius: BorderRadius.circular(AppRadius.r14.r),
        border: Border.all(color: ColorManager.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                children: [
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
        children: [
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
      height: 52.h,
      decoration: BoxDecoration(
        gradient: ColorManager.primaryGradient,
        borderRadius: BorderRadius.circular(AppRadius.r14.r),
        boxShadow: [
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
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.r14.r),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
