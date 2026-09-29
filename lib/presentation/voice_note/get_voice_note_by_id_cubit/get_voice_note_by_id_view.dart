// ─────────────────────────────────────────────────────────────────────────────
// GetVoiceNoteByIdView — Voice Note Details (Figma Node #2025:811)
// Responsive, high-performance details screen with audio playback & action bar
// ─────────────────────────────────────────────────────────────────────────────

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart' as intl;
import 'package:mizan/app/constants.dart';
import 'package:mizan/app/di.dart';
import 'package:mizan/domain/model/voice_note_model/voice_note_model.dart';
import 'package:mizan/presentation/common/state_randrer/state_randrer_impl.dart';
import 'package:mizan/presentation/operations/quick_transaction_args.dart';
import 'package:mizan/presentation/resources/assets_manager.dart';
import 'package:mizan/presentation/resources/color_manager.dart';
import 'package:mizan/presentation/resources/font_manager.dart';
import 'package:mizan/presentation/resources/routes_manager.dart';
import 'package:mizan/presentation/resources/strings_manager.dart';
import 'package:mizan/presentation/resources/styles_manager.dart';
import 'package:mizan/presentation/resources/values_manager.dart';
import 'package:mizan/presentation/voice_note/get_voice_note_by_id_cubit/get_voice_note_by_id_cubit.dart';
import 'package:mizan/presentation/voice_note/get_voice_note_by_id_cubit/get_voice_note_by_id_state.dart';

class GetVoiceNoteByIdView extends StatelessWidget {
  final String id;

  const GetVoiceNoteByIdView({
    super.key,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<GetVoiceNoteByIdCubit>(
      create: (_) => getIt<GetVoiceNoteByIdCubit>()..getVoiceNoteById(id),
      child: _VoiceNoteDetailsScreen(id: id),
    );
  }
}

class _VoiceNoteDetailsScreen extends StatefulWidget {
  final String id;

  const _VoiceNoteDetailsScreen({required this.id});

  @override
  State<_VoiceNoteDetailsScreen> createState() =>
      _VoiceNoteDetailsScreenState();
}

class _VoiceNoteDetailsScreenState extends State<_VoiceNoteDetailsScreen> {
  late final AudioPlayer _audioPlayer;
  bool _isPlaying = false;
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();

    _audioPlayer.onDurationChanged.listen((dur) {
      if (mounted) setState(() => _totalDuration = dur);
    });

    _audioPlayer.onPositionChanged.listen((pos) {
      if (mounted) setState(() => _currentPosition = pos);
    });

    _audioPlayer.onPlayerComplete.listen((_) {
      if (mounted) {
        setState(() {
          _isPlaying = false;
          _currentPosition = Duration.zero;
        });
      }
    });

    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted) setState(() => _isPlaying = state == PlayerState.playing);
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _togglePlayback(VoiceNoteModel data) async {
    if (_isPlaying) {
      await _audioPlayer.pause();
    } else {
      if (data.audioPath.isEmpty) return;
      final rawPath = data.audioPath;
      final url = rawPath.startsWith('http')
          ? rawPath
          : '${Constants.baseUrl}${rawPath.startsWith('/') ? '' : '/'}$rawPath';
      if (_currentPosition > Duration.zero && !_isPlaying) {
        await _audioPlayer.resume();
      } else {
        await _audioPlayer.play(UrlSource(url));
      }
    }
  }

  Future<void> _seekRelative(int seconds) async {
    final totalMs = _totalDuration.inMilliseconds;
    if (totalMs <= 0) return;
    final targetMs =
        (_currentPosition.inMilliseconds + seconds * 1000).clamp(0, totalMs);
    await _audioPlayer.seek(Duration(milliseconds: targetMs));
  }

  double get _playbackPosition {
    final total = _totalDuration.inMilliseconds;
    if (total <= 0) return 0.0;
    return (_currentPosition.inMilliseconds / total).clamp(0.0, 1.0);
  }

  String _formatDuration(Duration duration) {
    final mins = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final secs = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$mins:$secs';
  }

  String _formatDate(String dateString) {
    if (dateString.isEmpty) return '';
    try {
      final parsed = DateTime.parse(dateString);
      return intl.DateFormat('yyyy/MM/dd', 'ar').format(parsed);
    } catch (_) {
      return dateString;
    }
  }

  String _formatDateTime(String dateString) {
    if (dateString.isEmpty) return '';
    try {
      final parsed = DateTime.parse(dateString);
      return intl.DateFormat('yyyy/MM/dd - hh:mm a', 'ar').format(parsed);
    } catch (_) {
      return dateString;
    }
  }

  // ── Convert to Registered Transaction ─────────────────────────────────────
  void _convertToTransaction(VoiceNoteModel data) {
    final args = QuickTransactionArgs(
      contactId: data.contactId.isNotEmpty ? data.contactId : null,
      contactName: data.contactName.isNotEmpty ? data.contactName : null,
      isVip: false,
    );

    switch (data.operationType.toLowerCase()) {
      case 'sale':
        Navigator.of(context).pushNamed(Routes.quickSaleRoute, arguments: args);
        break;
      case 'purchase':
        Navigator.of(context).pushNamed(Routes.quickPurchaseRoute, arguments: args);
        break;
      case 'installmentcollection':
      case 'collection':
        Navigator.of(context).pushNamed(Routes.quickCollectRoute);
        break;
      case 'installmentpayment':
      case 'payment':
        Navigator.of(context).pushNamed(Routes.quickPayRoute);
        break;
      default:
        Navigator.of(context).pushNamed(Routes.quickSaleRoute, arguments: args);
        break;
    }
  }

  // ── Show Delete Notice Dialog ─────────────────────────────────────────────
  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.r16.r),
          ),
          backgroundColor: ColorManager.surface,
          title: Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  color: ColorManager.errorContainer,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.delete_outline_rounded,
                  color: ColorManager.error,
                  size: 20,
                ),
              ),
              SizedBox(width: 10.w),
              Text(
                AppStrings.deleteVoiceNote,
                style: getBoldStyle(
                  color: ColorManager.textPrimary,
                  fontSize: FontSize.s15,
                ),
              ),
            ],
          ),
          content: Text(
            "سيتم تفعيل ميزة حذف الملاحظات الصوتية في التحديث القادم بمجرد توفير نقطة الاتصال بالخادم.",
            style: getRegularStyle(
              color: ColorManager.textSecondary,
              fontSize: FontSize.s13,
              height: 1.4,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text(
                AppStrings.ok,
                style: getBoldStyle(
                  color: ColorManager.primary,
                  fontSize: FontSize.s13,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: ColorManager.background,
        body: SafeArea(
          child: BlocBuilder<GetVoiceNoteByIdCubit, GetVoiceNoteByIdState>(
            builder: (context, state) {
              return state.flowState?.getScreenWidget(
                    context,
                    _buildContent(context, state.data),
                    () => context
                        .read<GetVoiceNoteByIdCubit>()
                        .getVoiceNoteById(widget.id),
                  ) ??
                  _buildContent(context, state.data);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, VoiceNoteModel? data) {
    if (data == null) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        // ── Header ───────────────────────────────────────────────────────────
        _buildHeader(context, data),

        // ── Body Content ──────────────────────────────────────────────────────
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Hero Audio Player Card
                _buildHeroAudioPlayerCard(data),

                SizedBox(height: 16.h),

                // 2. Financial Amount Summary Card
                _buildAmountSummaryCard(data),

                SizedBox(height: 16.h),

                // 3. Information & Details Table
                _buildDetailsCard(data),

                SizedBox(height: 16.h),

                // 4. Transcription & Notes Card
                if (data.notes.isNotEmpty) ...[
                  _buildNotesCard(data),
                  SizedBox(height: 24.h),
                ],

                // 5. Action Buttons
                _buildActionButtons(data),

                SizedBox(height: 16.h),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ── Header ────────────────────────────────────────────────────────────────
  Widget _buildHeader(BuildContext context, VoiceNoteModel data) {
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
                  AppStrings.voiceNoteDetails,
                  style: getBoldStyle(
                    color: ColorManager.textPrimary,
                    fontSize: FontSize.s16,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  "ملاحظة صوتية #${data.id.length > 8 ? data.id.substring(0, 8) : data.id}",
                  style: getRegularStyle(
                    color: ColorManager.textSecondary,
                    fontSize: FontSize.s11,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: _showDeleteDialog,
            style: IconButton.styleFrom(
              backgroundColor: ColorManager.errorContainer,
              shape: const CircleBorder(),
            ),
            icon: SvgPicture.asset(
              IconAssets.trash,
              width: 16.r,
              height: 16.r,
              colorFilter: const ColorFilter.mode(
                ColorManager.error,
                BlendMode.srcIn,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── 1. Hero Audio Player Card (Figma Node #2025:811) ───────────────────────
  Widget _buildHeroAudioPlayerCard(VoiceNoteModel data) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.r),
      decoration: BoxDecoration(
        color: ColorManager.surface,
        borderRadius: BorderRadius.circular(AppRadius.r20.r),
        border: Border.all(color: ColorManager.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Waveform Animation Visualizer
          Container(
            height: 64.h,
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: ColorManager.surfaceVariant,
              borderRadius: BorderRadius.circular(AppRadius.r14.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(24, (index) {
                final barHeights = [
                  16, 24, 38, 20, 32, 48, 26, 42, 54, 30, 44, 22,
                  36, 50, 28, 40, 18, 34, 46, 24, 38, 20, 28, 14,
                ];
                final normalizedIndex = index / 24.0;
                final isActive = normalizedIndex <= _playbackPosition;
                final h = barHeights[index % barHeights.length];

                return Container(
                  width: 3.5.w,
                  height: h.h * 0.7,
                  decoration: BoxDecoration(
                    color: isActive
                        ? ColorManager.primary
                        : ColorManager.textTertiary.withAlpha(90),
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                );
              }),
            ),
          ),

          SizedBox(height: 12.h),

          // Time Scrubber Slider
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: ColorManager.primary,
              inactiveTrackColor: ColorManager.borderDark,
              thumbColor: ColorManager.primary,
              trackHeight: 4.h,
              thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6.r),
              overlayShape: RoundSliderOverlayShape(overlayRadius: 14.r),
            ),
            child: Slider(
              value: _playbackPosition,
              onChanged: (val) {
                final totalMs = _totalDuration.inMilliseconds;
                if (totalMs > 0) {
                  _audioPlayer.seek(Duration(milliseconds: (val * totalMs).toInt()));
                }
              },
            ),
          ),

          // Duration Timestamps
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 6.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatDuration(_currentPosition),
                  style: getBoldStyle(
                    color: ColorManager.primary,
                    fontSize: FontSize.s11,
                  ),
                ),
                Text(
                  _formatDuration(_totalDuration),
                  style: getRegularStyle(
                    color: ColorManager.textSecondary,
                    fontSize: FontSize.s11,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 16.h),

          // Audio Controls (Rewind 5s, Play/Pause, Forward 5s)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Rewind 5s
              IconButton(
                onPressed: () => _seekRelative(-5),
                icon: SvgPicture.asset(
                  IconAssets.rewind,
                  width: 24.r,
                  height: 24.r,
                  colorFilter: const ColorFilter.mode(
                    ColorManager.textSecondary,
                    BlendMode.srcIn,
                  ),
                ),
              ),

              SizedBox(width: 16.w),

              // Play / Pause Circle
              GestureDetector(
                onTap: () => _togglePlayback(data),
                child: Container(
                  width: 56.r,
                  height: 56.r,
                  decoration: BoxDecoration(
                    gradient: ColorManager.primaryGradient,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: ColorManager.primary.withAlpha(80),
                        blurRadius: 14,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Icon(
                      _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                      color: ColorManager.white,
                      size: 32.r,
                    ),
                  ),
                ),
              ),

              SizedBox(width: 16.w),

              // Forward 5s
              IconButton(
                onPressed: () => _seekRelative(5),
                icon: SvgPicture.asset(
                  IconAssets.forward,
                  width: 24.r,
                  height: 24.r,
                  colorFilter: const ColorFilter.mode(
                    ColorManager.textSecondary,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── 2. Financial Amount Summary Card ───────────────────────────────────────
  Widget _buildAmountSummaryCard(VoiceNoteModel data) {
    Color typeColor;
    Color typeBg;
    String typeLabel;

    switch (data.operationType.toLowerCase()) {
      case 'sale':
        typeColor = ColorManager.success;
        typeBg = ColorManager.successContainer;
        typeLabel = AppStrings.quickSale;
        break;
      case 'purchase':
        typeColor = ColorManager.error;
        typeBg = ColorManager.errorContainer;
        typeLabel = AppStrings.quickPurchase;
        break;
      case 'installmentcollection':
      case 'collection':
        typeColor = ColorManager.secondary;
        typeBg = ColorManager.lightSecondary;
        typeLabel = "تحصيل قسط";
        break;
      case 'installmentpayment':
      case 'payment':
        typeColor = const Color(0xFF5E48B8);
        typeBg = const Color(0xFFF0EDFC);
        typeLabel = "سداد قسط";
        break;
      default:
        typeColor = ColorManager.primary;
        typeBg = ColorManager.lightPrimary;
        typeLabel = data.operationTypeLabel.isNotEmpty
            ? data.operationTypeLabel
            : "معاملة";
        break;
    }

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: ColorManager.surface,
        borderRadius: BorderRadius.circular(AppRadius.r16.r),
        border: Border.all(color: ColorManager.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.amountLabel,
                style: getRegularStyle(
                  color: ColorManager.textSecondary,
                  fontSize: FontSize.s12,
                ),
              ),
              SizedBox(height: 4.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    "${data.amount}",
                    style: getExtraBoldStyle(
                      color: ColorManager.textPrimary,
                      fontSize: FontSize.s24,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    AppStrings.egp,
                    style: getBoldStyle(
                      color: ColorManager.primary,
                      fontSize: FontSize.s13,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: typeBg,
              borderRadius: BorderRadius.circular(AppRadius.r10.r),
            ),
            child: Text(
              typeLabel,
              style: getBoldStyle(
                color: typeColor,
                fontSize: FontSize.s13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── 3. Information & Details Table Card ────────────────────────────────────
  Widget _buildDetailsCard(VoiceNoteModel data) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: ColorManager.surface,
        borderRadius: BorderRadius.circular(AppRadius.r16.r),
        border: Border.all(color: ColorManager.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "معلومات الملاحظة",
            style: getBoldStyle(
              color: ColorManager.textPrimary,
              fontSize: FontSize.s14,
            ),
          ),
          SizedBox(height: 12.h),

          // Contact / Party Row
          _buildInfoRow(
            icon: IconAssets.user,
            label: AppStrings.partyNameLabel,
            value: data.contactName.isNotEmpty
                ? data.contactName
                : "طرف ثانٍ غير محدد",
            hasNavigation: data.contactId.isNotEmpty,
            onTap: data.contactId.isNotEmpty
                ? () {
                    Navigator.of(context).pushNamed(
                      Routes.contactProfileRoute,
                      arguments: data.contactId,
                    );
                  }
                : null,
          ),

          Divider(color: ColorManager.border, height: 20.h),

          // Operation Date
          _buildInfoRow(
            icon: IconAssets.calendar,
            label: AppStrings.operationDateLabel,
            value: _formatDate(data.operationDate),
          ),

          Divider(color: ColorManager.border, height: 20.h),

          // Creation Time
          _buildInfoRow(
            icon: IconAssets.alarmClock,
            label: "تاريخ التسجيل",
            value: _formatDateTime(data.createdAt),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required String icon,
    required String label,
    required String value,
    bool hasNavigation = false,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.r8.r),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 2.h),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(6.r),
              decoration: BoxDecoration(
                color: ColorManager.surfaceVariant,
                borderRadius: BorderRadius.circular(AppRadius.r8.r),
              ),
              child: SvgPicture.asset(
                icon,
                width: 16.r,
                height: 16.r,
                colorFilter: const ColorFilter.mode(
                  ColorManager.primary,
                  BlendMode.srcIn,
                ),
              ),
            ),
            SizedBox(width: 10.w),
            Text(
              label,
              style: getRegularStyle(
                color: ColorManager.textSecondary,
                fontSize: FontSize.s12,
              ),
            ),
            const Spacer(),
            Text(
              value,
              style: getBoldStyle(
                color: ColorManager.textPrimary,
                fontSize: FontSize.s13,
              ),
            ),
            if (hasNavigation) ...[
              SizedBox(width: 4.w),
              Icon(
                Icons.chevron_left_rounded,
                size: 16.r,
                color: ColorManager.textSecondary,
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ── 4. Transcription & Notes Card ─────────────────────────────────────────
  Widget _buildNotesCard(VoiceNoteModel data) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: ColorManager.surface,
        borderRadius: BorderRadius.circular(AppRadius.r16.r),
        border: Border.all(color: ColorManager.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SvgPicture.asset(
                IconAssets.waveform,
                width: 16.r,
                height: 16.r,
                colorFilter: const ColorFilter.mode(
                  ColorManager.primary,
                  BlendMode.srcIn,
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                AppStrings.voiceNoteNotesLabel,
                style: getBoldStyle(
                  color: ColorManager.textPrimary,
                  fontSize: FontSize.s14,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              color: ColorManager.surfaceVariant,
              borderRadius: BorderRadius.circular(AppRadius.r12.r),
            ),
            child: Text(
              data.notes,
              style: getRegularStyle(
                color: ColorManager.textPrimary,
                fontSize: FontSize.s12,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── 5. Bottom Action Buttons ──────────────────────────────────────────────
  Widget _buildActionButtons(VoiceNoteModel data) {
    return Column(
      children: [
        // Primary: Convert to transaction
        Container(
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
            onPressed: () => _convertToTransaction(data),
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
                  IconAssets.receiptText,
                  width: 18.r,
                  height: 18.r,
                  colorFilter: const ColorFilter.mode(
                    ColorManager.white,
                    BlendMode.srcIn,
                  ),
                ),
                SizedBox(width: 8.w),
                Text(
                  AppStrings.convertToTransaction,
                  style: getBoldStyle(
                    color: ColorManager.white,
                    fontSize: FontSize.s14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
