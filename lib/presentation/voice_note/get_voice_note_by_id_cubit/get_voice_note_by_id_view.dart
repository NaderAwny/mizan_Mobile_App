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
import 'package:mizan/core/utils/date_utils.dart';
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

  const GetVoiceNoteByIdView({super.key, required this.id});

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

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();

    _audioPlayer.onDurationChanged.listen((Duration dur) {
      if (mounted) {
        context.read<GetVoiceNoteByIdCubit>().updatePlayback(
          totalDuration: dur,
        );
      }
    });

    _audioPlayer.onPositionChanged.listen((Duration pos) {
      if (mounted) {
        context.read<GetVoiceNoteByIdCubit>().updatePlayback(
          currentPosition: pos,
        );
      }
    });

    _audioPlayer.onPlayerComplete.listen((_) {
      if (mounted) {
        context.read<GetVoiceNoteByIdCubit>().updatePlayback(
          isPlaying: false,
          currentPosition: Duration.zero,
        );
      }
    });

    _audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      if (mounted) {
        context.read<GetVoiceNoteByIdCubit>().updatePlayback(
          isPlaying: state == PlayerState.playing,
        );
      }
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _togglePlayback(
    VoiceNoteModel data,
    GetVoiceNoteByIdState state,
  ) async {
    if (state.isPlaying) {
      await _audioPlayer.pause();
    } else {
      if (data.audioPath.isEmpty) return;
      final String rawPath = data.audioPath;
      final String url = rawPath.startsWith('http')
          ? rawPath
          : '${Constants.baseUrl}${rawPath.startsWith('/') ? '' : '/'}$rawPath';
      if (state.currentPosition > Duration.zero && !state.isPlaying) {
        await _audioPlayer.resume();
      } else {
        await _audioPlayer.play(UrlSource(url));
      }
    }
  }

  Future<void> _seekRelative(int seconds, GetVoiceNoteByIdState state) async {
    final int totalMs = state.totalDuration.inMilliseconds;
    if (totalMs <= 0) return;
    final int targetMs = (state.currentPosition.inMilliseconds + seconds * 1000)
        .clamp(0, totalMs);
    await _audioPlayer.seek(Duration(milliseconds: targetMs));
  }

  double _getPlaybackPosition(GetVoiceNoteByIdState state) {
    final int total = state.totalDuration.inMilliseconds;
    if (total <= 0) return 0.0;
    return (state.currentPosition.inMilliseconds / total).clamp(0.0, 1.0);
  }

  String _formatDuration(Duration duration) {
    final String mins = duration.inMinutes
        .remainder(60)
        .toString()
        .padLeft(2, '0');
    final String secs = duration.inSeconds
        .remainder(60)
        .toString()
        .padLeft(2, '0');
    return '$mins:$secs';
  }

  DateTime _parseToLocal(String raw) => parseServerTime(raw);

  String _formatDate(String dateString) {
    if (dateString.isEmpty) return '';
    try {
      final DateTime parsed = _parseToLocal(dateString);
      return intl.DateFormat('yyyy/MM/dd', 'ar').format(parsed);
    } catch (_) {
      return dateString;
    }
  }

  String _formatDateTime(String dateString) {
    if (dateString.isEmpty) return '';
    try {
      final DateTime parsed = _parseToLocal(dateString);
      return intl.DateFormat('yyyy/MM/dd - hh:mm a', 'ar').format(parsed);
    } catch (_) {
      return dateString;
    }
  }

  // ── Convert to Registered Transaction ─────────────────────────────────────
  // ignore: unused_element
  void _convertToTransaction(VoiceNoteModel data) {
    final QuickTransactionArgs args = QuickTransactionArgs(
      contactId: data.contactId.isNotEmpty ? data.contactId : null,
      contactName: data.contactName.isNotEmpty ? data.contactName : null,
      isVip: false,
    );

    switch (data.operationType.toLowerCase()) {
      case 'sale':
        Navigator.of(context).pushNamed(Routes.quickSaleRoute, arguments: args);
        break;
      case 'purchase':
        Navigator.of(
          context,
        ).pushNamed(Routes.quickPurchaseRoute, arguments: args);
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

  // ── Show Delete Dialog ───────────────────────────────────────────────────
  void _showDeleteDialog(BuildContext context, VoiceNoteModel data) {
    showDialog<void>(
      context: context,
      builder: (BuildContext ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.r20.r),
          ),
          backgroundColor: ColorManager.surface,
          title: Row(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(8.r),
                decoration: const BoxDecoration(
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
                  fontSize: FontSize.s16.sp,
                ),
              ),
            ],
          ),
          content: Text(
            "هل أنت متأكد من رغبتك في حذف هذه الملاحظة الصوتية نهائياً؟ لا يمكن التراجع عن هذا الإجراء.",
            style: getRegularStyle(
              color: ColorManager.textSecondary,
              fontSize: FontSize.s13.sp,
              height: 1.5,
            ),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(ctx).pop(),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: ColorManager.textSecondary,
                      side: const BorderSide(color: ColorManager.border),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.r12.r),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                    ),
                    child: Text(
                      AppStrings.cancel,
                      style: getSemiBoldStyle(
                        color: ColorManager.textSecondary,
                        fontSize: FontSize.s14.sp,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 14.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                      context.read<GetVoiceNoteByIdCubit>().deleteVoiceNote();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorManager.error,
                      foregroundColor: ColorManager.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.r12.r),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                    ),
                    child: Text(
                      AppStrings.delete,
                      style: getBoldStyle(
                        color: ColorManager.white,
                        fontSize: FontSize.s14.sp,
                      ),
                    ),
                  ),
                ),
              ],
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
          child: BlocConsumer<GetVoiceNoteByIdCubit, GetVoiceNoteByIdState>(
            listenWhen:
                (GetVoiceNoteByIdState prev, GetVoiceNoteByIdState curr) =>
                    curr.isDeleted && !prev.isDeleted,
            listener: (BuildContext context, GetVoiceNoteByIdState state) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (context.mounted) {
                  Navigator.of(context).pop(true);
                }
              });
            },
            builder: (BuildContext context, GetVoiceNoteByIdState state) {
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
      children: <Widget>[
        // ── Header ───────────────────────────────────────────────────────────
        _buildHeader(context, data),

        // ── Body Content ──────────────────────────────────────────────────────
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
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
                if (data.notes.isNotEmpty) ...<Widget>[
                  _buildNotesCard(data),
                  SizedBox(height: 24.h),
                ],

                // 5. Action Buttons
                //  _buildActionButtons(data),
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
            onPressed: () => _showDeleteDialog(context, data),
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
    return BlocBuilder<GetVoiceNoteByIdCubit, GetVoiceNoteByIdState>(
      buildWhen: (GetVoiceNoteByIdState p, GetVoiceNoteByIdState c) =>
          p.isPlaying != c.isPlaying ||
          p.currentPosition != c.currentPosition ||
          p.totalDuration != c.totalDuration,
      builder: (BuildContext context, GetVoiceNoteByIdState state) {
        final double playbackPosition = _getPlaybackPosition(state);
        return Container(
          width: double.infinity,
          padding: EdgeInsets.all(18.r),
          decoration: BoxDecoration(
            color: ColorManager.surface,
            borderRadius: BorderRadius.circular(AppRadius.r20.r),
            border: Border.all(color: ColorManager.border),
            boxShadow: const <BoxShadow>[
              BoxShadow(
                color: ColorManager.shadowMedium,
                blurRadius: 16,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: <Widget>[
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
                  children: List<Widget>.generate(24, (int index) {
                    final List<int> barHeights = <int>[
                      16,
                      24,
                      38,
                      20,
                      32,
                      48,
                      26,
                      42,
                      54,
                      30,
                      44,
                      22,
                      36,
                      50,
                      28,
                      40,
                      18,
                      34,
                      46,
                      24,
                      38,
                      20,
                      28,
                      14,
                    ];
                    final double normalizedIndex = index / 24.0;
                    final bool isActive = normalizedIndex <= playbackPosition;
                    final int h = barHeights[index % barHeights.length];

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
                  value: playbackPosition,
                  onChanged: (double val) {
                    final int totalMs = state.totalDuration.inMilliseconds;
                    if (totalMs > 0) {
                      _audioPlayer.seek(
                        Duration(milliseconds: (val * totalMs).toInt()),
                      );
                    }
                  },
                ),
              ),

              // Duration Timestamps
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      _formatDuration(state.currentPosition),
                      style: getBoldStyle(
                        color: ColorManager.primary,
                        fontSize: FontSize.s11,
                      ),
                    ),
                    Text(
                      _formatDuration(state.totalDuration),
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
                children: <Widget>[
                  // Rewind 5s
                  IconButton(
                    onPressed: () => _seekRelative(-5, state),
                    icon: SvgPicture.asset(
                      IconAssets.audioMins,
                      width: 50.r,
                      height: 50.r,
                      // colorFilter: const ColorFilter.mode(
                      //   ColorManager.primary,
                      //   BlendMode.srcIn,
                    ),
                  ),

                  SizedBox(width: 25.w),

                  // Play / Pause Circle
                  GestureDetector(
                    onTap: () => _togglePlayback(data, state),
                    child: Container(
                      width: 60.r,
                      height: 60.r,
                      decoration: BoxDecoration(
                        gradient: ColorManager.primaryGradient,
                        shape: BoxShape.circle,
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: ColorManager.primary.withAlpha(80),
                            blurRadius: 14,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Icon(
                          state.isPlaying
                              ? Icons.pause_rounded
                              : Icons.play_arrow_rounded,
                          color: ColorManager.white,
                          size: 32.r,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(width: 25.w),

                  // Forward 5s
                  IconButton(
                    onPressed: () => _seekRelative(5, state),
                    icon: SvgPicture.asset(
                      IconAssets.audioPlus,
                      width: 50.r,
                      height: 50.r,
                      // colorFilter: const ColorFilter.mode(
                      //   ColorManager.textSecondary,
                      //   BlendMode.srcIn,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
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
        typeColor = ColorManager.voiceNotePurple;
        typeBg = ColorManager.voiceNoteContainer;
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
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
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
                children: <Widget>[
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
              style: getBoldStyle(color: typeColor, fontSize: FontSize.s13),
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
        children: <Widget>[
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
          children: <Widget>[
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
            SizedBox(width: 8.w),
            Expanded(
              child: Text(
                value,
                textAlign: TextAlign.end,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: getBoldStyle(
                  color: ColorManager.textPrimary,
                  fontSize: FontSize.s12,
                ),
              ),
            ),
            if (hasNavigation) ...<Widget>[
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
        children: <Widget>[
          Row(
            children: <Widget>[
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
  // Widget _buildActionButtons(VoiceNoteModel data) {
  //   return Column(
  //     children: <Widget>[
  //       // Primary: Convert to transaction
  //       Container(
  //         width: double.infinity,
  //         height: 52.h,
  //         decoration: BoxDecoration(
  //           gradient: ColorManager.primaryGradient,
  //           borderRadius: BorderRadius.circular(AppRadius.r14.r),
  //           boxShadow: <BoxShadow>[
  //             BoxShadow(
  //               color: ColorManager.primary.withAlpha(70),
  //               blurRadius: 12,
  //               offset: const Offset(0, 4),
  //             ),
  //           ],
  //         ),
  //         child: ElevatedButton(
  //           onPressed: () => _convertToTransaction(data),
  //           style: ElevatedButton.styleFrom(
  //             backgroundColor: ColorManager.transparent,
  //             shadowColor: ColorManager.transparent,
  //             shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.circular(AppRadius.r14.r),
  //             ),
  //           ),
  //           child: Row(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: <Widget>[
  //               SvgPicture.asset(
  //                 IconAssets.receiptText,
  //                 width: 18.r,
  //                 height: 18.r,
  //                 colorFilter: const ColorFilter.mode(
  //                   ColorManager.white,
  //                   BlendMode.srcIn,
  //                 ),
  //               ),
  //               SizedBox(width: 8.w),
  //               Text(
  //                 AppStrings.convertToTransaction,
  //                 style: getBoldStyle(
  //                   color: ColorManager.white,
  //                   fontSize: FontSize.s14,
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }
}
