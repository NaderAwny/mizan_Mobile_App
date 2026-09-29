// ─────────────────────────────────────────────────────────────────────────────
// GetVoiceNoteView — Mizan Voice Notes List (Figma Node #3:1535)
// Responsive, high-performance voice note feed with audio preview and filters
// ─────────────────────────────────────────────────────────────────────────────

import 'dart:async';
import 'dart:math' as math;
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart' as intl;
import 'package:mizan/app/di.dart';
import 'package:mizan/data/request/voice_note_request.dart';
import 'package:mizan/domain/model/voice_note_model/voice_note_model.dart';
import 'package:mizan/presentation/common/state_randrer/state_randrer_impl.dart';
import 'package:mizan/presentation/resources/assets_manager.dart';
import 'package:mizan/presentation/resources/color_manager.dart';
import 'package:mizan/presentation/resources/font_manager.dart';
import 'package:mizan/presentation/resources/strings_manager.dart';
import 'package:mizan/presentation/resources/styles_manager.dart';
import 'package:mizan/presentation/resources/values_manager.dart';
import 'package:mizan/presentation/voice_note/create_voice_note_cubit/create_voice_note_view.dart';
import 'package:mizan/presentation/voice_note/get_voice_note_by_id_cubit/get_voice_note_by_id_view.dart';
import 'package:mizan/presentation/voice_note/get_voice_note_cubit/get_voice_note_cubit.dart';
import 'package:mizan/presentation/voice_note/get_voice_note_cubit/get_voice_note_state.dart';

class GetVoiceNoteView extends StatelessWidget {
  const GetVoiceNoteView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<GetListVoiceNotesCubit>(
      create: (_) => getIt<GetListVoiceNotesCubit>()..getListVoiceNotes(),
      child: const _GetVoiceNoteScreen(),
    );
  }
}

class _GetVoiceNoteScreen extends StatefulWidget {
  const _GetVoiceNoteScreen();

  @override
  State<_GetVoiceNoteScreen> createState() => _GetVoiceNoteScreenState();
}

class _GetVoiceNoteScreenState extends State<_GetVoiceNoteScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  int _selectedFilterIndex = 0;
  String _searchQuery = '';

  // Filter tab definitions
  static const List<String> _filterTabs = [
    AppStrings.allTransactions,
    AppStrings.quickSale,
    AppStrings.quickPurchase,
    "تحصيل قسط",
    "سداد قسط",
  ];

  static const List<String?> _filterTypeValues = [
    null,
    VoiceNoteOperationType.sale,
    VoiceNoteOperationType.purchase,
    VoiceNoteOperationType.installmentCollection,
    VoiceNoteOperationType.installmentPayment,
  ];

  // Global active audio player preview tracker
  String? _currentlyPlayingId;
  double _playbackProgress = 0.0;
  Timer? _playbackTimer;
  Duration _currentAudioDuration = Duration.zero;
  Duration _currentPosition = Duration.zero;
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);

    _audioPlayer.onDurationChanged.listen((dur) {
      if (mounted) setState(() => _currentAudioDuration = dur);
    });

    _audioPlayer.onPositionChanged.listen((pos) {
      if (!mounted) return;
      final totalMs = _currentAudioDuration.inMilliseconds;
      setState(() {
        _currentPosition = pos;
        if (totalMs > 0) {
          _playbackProgress = (pos.inMilliseconds / totalMs).clamp(0.0, 1.0);
        }
      });
    });

    _audioPlayer.onPlayerComplete.listen((_) {
      if (!mounted) return;
      setState(() {
        _currentlyPlayingId = null;
        _playbackProgress = 0.0;
        _currentAudioDuration = Duration.zero;
        _currentPosition = Duration.zero;
      });
    });
  }

  void _onScroll() {
    if (_scrollController.hasClients) {
      final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.position.pixels;
      if (currentScroll >= (maxScroll * 0.8)) {
        context.read<GetListVoiceNotesCubit>().loadMoreVoiceNotes();
      }
    }
  }

  @override
  void dispose() {
    _playbackTimer?.cancel();
    _audioPlayer.dispose();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _toggleAudioPreview(String id, String audioUrl) async {
    if (_currentlyPlayingId == id) {
      // إيقاف التشغيل
      await _audioPlayer.stop();
      setState(() {
        _currentlyPlayingId = null;
        _playbackProgress = 0.0;
        _currentAudioDuration = Duration.zero;
        _currentPosition = Duration.zero;
      });
    } else {
      // إيقاف أي تشغيل سابق
      await _audioPlayer.stop();
      setState(() {
        _currentlyPlayingId = id;
        _playbackProgress = 0.0;
        _currentAudioDuration = Duration.zero;
        _currentPosition = Duration.zero;
      });

      if (audioUrl.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('لا يوجد ملف صوتي لهذه الملاحظة')),
          );
        }
        setState(() => _currentlyPlayingId = null);
        return;
      }

      try {
        await _audioPlayer.play(UrlSource(audioUrl));
      } catch (e) {
        debugPrint('Audio playback error: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('تعذّر تشغيل الملف الصوتي')),
          );
          setState(() {
            _currentlyPlayingId = null;
            _playbackProgress = 0.0;
          });
        }
      }
    }
  }

  List<VoiceNoteModel> _filterItems(List<VoiceNoteModel> allItems) {
    final selectedType = _filterTypeValues[_selectedFilterIndex];
    return allItems.where((item) {
      // Type match
      final matchesType = selectedType == null ||
          item.operationType.toLowerCase() == selectedType.toLowerCase();

      // Search match
      final query = _searchQuery.trim().toLowerCase();
      final matchesSearch = query.isEmpty ||
          item.contactName.toLowerCase().contains(query) ||
          item.notes.toLowerCase().contains(query) ||
          item.operationTypeLabel.toLowerCase().contains(query) ||
          item.amount.toString().contains(query);

      return matchesType && matchesSearch;
    }).toList();
  }

  Future<void> _navigateToCreate() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const CreateVoiceNoteView()),
    );
    if (result == true && mounted) {
      context.read<GetListVoiceNotesCubit>().getListVoiceNotes();
    }
  }

  void _navigateToDetails(String id) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => GetVoiceNoteByIdView(id: id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: ColorManager.background,
        floatingActionButton: _buildFAB(),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        body: SafeArea(
          child: Column(
            children: [
              // ── Top Header ──────────────────────────────────────────────────
              _buildHeader(context),

              // ── Search & Filter Tabs ────────────────────────────────────────
              _buildSearchAndFilters(),

              // ── Main List Content ───────────────────────────────────────────
              Expanded(
                child: BlocBuilder<GetListVoiceNotesCubit, GetListVoiceNotesState>(
                  builder: (context, state) {
                    if (state.flowState is LoadingState &&
                        (state.data == null || state.data!.isEmpty)) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: ColorManager.primary,
                        ),
                      );
                    }

                    if (state.flowState is ErrorState &&
                        (state.data == null || state.data!.isEmpty)) {
                      final error = state.flowState as ErrorState;
                      return _buildErrorState(error.message);
                    }

                    final allItems = state.data ?? [];
                    final filteredItems = _filterItems(allItems);

                    if (filteredItems.isEmpty) {
                      return _buildEmptyState();
                    }

                    return RefreshIndicator(
                      color: ColorManager.primary,
                      backgroundColor: ColorManager.surface,
                      onRefresh: () => context
                          .read<GetListVoiceNotesCubit>()
                          .getListVoiceNotes(),
                      child: ListView.separated(
                        controller: _scrollController,
                        physics: const AlwaysScrollableScrollPhysics(
                          parent: BouncingScrollPhysics(),
                        ),
                        padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 90.h),
                        itemCount: filteredItems.length + (state.isLoadingMore ? 1 : 0),
                        separatorBuilder: (_, _) => SizedBox(height: 12.h),
                        itemBuilder: (context, index) {
                          if (index == filteredItems.length) {
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.all(16.0),
                                child: CircularProgressIndicator(
                                  color: ColorManager.primary,
                                ),
                              ),
                            );
                          }

                          final item = filteredItems[index];
                          final isPlaying = _currentlyPlayingId == item.id;

                          return _VoiceNoteCard(
                            item: item,
                            isPlaying: isPlaying,
                            playbackProgress: isPlaying ? _playbackProgress : 0.0,
                            currentPosition: isPlaying ? _currentPosition : Duration.zero,
                            totalDuration: isPlaying ? _currentAudioDuration : Duration.zero,
                            onTogglePlay: () => _toggleAudioPreview(item.id, item.audioUrl),
                            onTap: () => _navigateToDetails(item.id),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Header ────────────────────────────────────────────────────────────────
  Widget _buildHeader(BuildContext context) {
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
            onPressed: () {
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              }
            },
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
                  AppStrings.voiceNotesTitle,
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
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: ColorManager.lightPrimary,
              borderRadius: BorderRadius.circular(AppRadius.r20.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  IconAssets.mic,
                  width: 14.r,
                  height: 14.r,
                  colorFilter: const ColorFilter.mode(
                    ColorManager.primary,
                    BlendMode.srcIn,
                  ),
                ),
                SizedBox(width: 4.w),
                BlocBuilder<GetListVoiceNotesCubit, GetListVoiceNotesState>(
                  builder: (context, state) {
                    final count = state.data?.length ?? 0;
                    return Text(
                      "$count ملاحظة",
                      style: getBoldStyle(
                        color: ColorManager.primary,
                        fontSize: FontSize.s11,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Search & Filters ──────────────────────────────────────────────────────
  Widget _buildSearchAndFilters() {
    return Container(
      color: ColorManager.surface,
      padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 12.h),
      child: Column(
        children: [
          // Search Field
          Container(
            decoration: BoxDecoration(
              color: ColorManager.surfaceVariant,
              borderRadius: BorderRadius.circular(AppRadius.r12.r),
              border: Border.all(color: ColorManager.border),
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (val) {
                setState(() {
                  _searchQuery = val;
                });
              },
              style: getRegularStyle(
                color: ColorManager.textPrimary,
                fontSize: FontSize.s13,
              ),
              decoration: InputDecoration(
                hintText: "ابحث بالطرف أو الملاحظة أو المبلغ...",
                hintStyle: getRegularStyle(
                  color: ColorManager.textTertiary,
                  fontSize: FontSize.s12,
                ),
                prefixIcon: Padding(
                  padding: EdgeInsets.all(12.r),
                  child: SvgPicture.asset(
                    IconAssets.search,
                    width: 16.r,
                    height: 16.r,
                    colorFilter: const ColorFilter.mode(
                      ColorManager.textSecondary,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded, size: 16),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12.w,
                  vertical: 12.h,
                ),
              ),
            ),
          ),

          SizedBox(height: 10.h),

          // Filter Tabs
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: List.generate(_filterTabs.length, (index) {
                final isSelected = _selectedFilterIndex == index;
                return Padding(
                  padding: EdgeInsets.only(left: 6.w),
                  child: ChoiceChip(
                    label: Text(_filterTabs[index]),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _selectedFilterIndex = index;
                        });
                      }
                    },
                    selectedColor: ColorManager.primary,
                    backgroundColor: ColorManager.surfaceVariant,
                    labelStyle: isSelected
                        ? getBoldStyle(
                            color: ColorManager.white,
                            fontSize: FontSize.s12,
                          )
                        : getMediumStyle(
                            color: ColorManager.textSecondary,
                            fontSize: FontSize.s12,
                          ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 6.h,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.r20.r),
                      side: BorderSide(
                        color: isSelected
                            ? ColorManager.primary
                            : ColorManager.border,
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  // ── Floating Action Button ────────────────────────────────────────────────
  Widget _buildFAB() {
    return Container(
      decoration: BoxDecoration(
        gradient: ColorManager.primaryGradient,
        borderRadius: BorderRadius.circular(AppRadius.r28.r),
        boxShadow: [
          BoxShadow(
            color: ColorManager.primary.withAlpha(90),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _navigateToCreate,
          borderRadius: BorderRadius.circular(AppRadius.r28.r),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 12.h),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  IconAssets.mic,
                  width: 20.r,
                  height: 20.r,
                  colorFilter: const ColorFilter.mode(
                    ColorManager.white,
                    BlendMode.srcIn,
                  ),
                ),
                SizedBox(width: 8.w),
                Text(
                  "تسجيل ملاحظة",
                  style: getBoldStyle(
                    color: ColorManager.white,
                    fontSize: FontSize.s14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Empty State ───────────────────────────────────────────────────────────
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.r),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 72.r,
              height: 72.r,
              decoration: BoxDecoration(
                color: ColorManager.lightPrimary,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: SvgPicture.asset(
                  IconAssets.mic,
                  width: 36.r,
                  height: 36.r,
                  colorFilter: const ColorFilter.mode(
                    ColorManager.primary,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              AppStrings.noVoiceNotesTitle,
              style: getBoldStyle(
                color: ColorManager.textPrimary,
                fontSize: FontSize.s16,
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              AppStrings.noVoiceNotesSubtitle,
              textAlign: TextAlign.center,
              style: getRegularStyle(
                color: ColorManager.textSecondary,
                fontSize: FontSize.s12,
                height: 1.4,
              ),
            ),
            SizedBox(height: 20.h),
            ElevatedButton.icon(
              onPressed: _navigateToCreate,
              icon: const Icon(Icons.mic_rounded, color: ColorManager.white),
              label: Text(
                AppStrings.recordFirstVoiceNote,
                style: getBoldStyle(
                  color: ColorManager.white,
                  fontSize: FontSize.s13,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorManager.primary,
                padding: EdgeInsets.symmetric(
                  horizontal: 20.w,
                  vertical: 12.h,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.r12.r),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Error State ───────────────────────────────────────────────────────────
  Widget _buildErrorState(String message) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.r),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              color: ColorManager.error,
              size: 48,
            ),
            SizedBox(height: 12.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: getMediumStyle(
                color: ColorManager.textPrimary,
                fontSize: FontSize.s14,
              ),
            ),
            SizedBox(height: 16.h),
            ElevatedButton(
              onPressed: () => context
                  .read<GetListVoiceNotesCubit>()
                  .getListVoiceNotes(),
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorManager.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.r10.r),
                ),
              ),
              child: Text(
                AppStrings.retry,
                style: getBoldStyle(
                  color: ColorManager.white,
                  fontSize: FontSize.s13,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Voice Note Card Component (Figma Node 3:1535 compliant)
// ─────────────────────────────────────────────────────────────────────────────
class _VoiceNoteCard extends StatefulWidget {
  final VoiceNoteModel item;
  final bool isPlaying;
  final double playbackProgress;
  final Duration currentPosition;
  final Duration totalDuration;
  final VoidCallback onTogglePlay;
  final VoidCallback onTap;

  const _VoiceNoteCard({
    required this.item,
    required this.isPlaying,
    required this.playbackProgress,
    required this.currentPosition,
    required this.totalDuration,
    required this.onTogglePlay,
    required this.onTap,
  });

  @override
  State<_VoiceNoteCard> createState() => _VoiceNoteCardState();
}

class _VoiceNoteCardState extends State<_VoiceNoteCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _waveController;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    if (widget.isPlaying) _waveController.repeat();
  }

  @override
  void didUpdateWidget(_VoiceNoteCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isPlaying && !oldWidget.isPlaying) {
      _waveController.repeat();
    } else if (!widget.isPlaying && oldWidget.isPlaying) {
      _waveController.stop();
      _waveController.reset();
    }
  }

  @override
  void dispose() {
    _waveController.dispose();
    super.dispose();
  }

  /// الوقت المتبقي بصيغة mm:ss
  String _formatRemaining() {
    if (!widget.isPlaying || widget.totalDuration == Duration.zero) {
      return '--:--';
    }
    final remaining = widget.totalDuration - widget.currentPosition;
    if (remaining.isNegative || remaining == Duration.zero) return '00:00';
    final mins = remaining.inMinutes.remainder(60).toString().padLeft(2, '0');
    final secs = remaining.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$mins:$secs';
  }

  _TypeVisuals _getTypeVisuals(String type) {
    switch (type.toLowerCase()) {
      case 'sale':
        return _TypeVisuals(
          label: AppStrings.quickSale,
          color: ColorManager.success,
          container: ColorManager.successContainer,
          icon: IconAssets.shoppingBag,
        );
      case 'purchase':
        return _TypeVisuals(
          label: AppStrings.quickPurchase,
          color: ColorManager.error,
          container: ColorManager.errorContainer,
          icon: IconAssets.arrowUpRight,
        );
      case 'installmentcollection':
      case 'collection':
        return _TypeVisuals(
          label: "تحصيل قسط",
          color: ColorManager.secondary,
          container: ColorManager.lightSecondary,
          icon: IconAssets.arrowDownLeft,
        );
      case 'installmentpayment':
      case 'payment':
        return _TypeVisuals(
          label: "سداد قسط",
          color: const Color(0xFF5E48B8),
          container: const Color(0xFFF0EDFC),
          icon: IconAssets.walletCards,
        );
      default:
        return _TypeVisuals(
          label: widget.item.operationTypeLabel.isNotEmpty
              ? widget.item.operationTypeLabel
              : "معاملة",
          color: ColorManager.primary,
          container: ColorManager.lightPrimary,
          icon: IconAssets.receiptText,
        );
    }
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

  @override
  Widget build(BuildContext context) {
    final visuals = _getTypeVisuals(widget.item.operationType);
    final formattedDate = _formatDate(widget.item.operationDate.isNotEmpty
        ? widget.item.operationDate
        : widget.item.createdAt);

    return Container(
      decoration: BoxDecoration(
        color: ColorManager.surface,
        borderRadius: BorderRadius.circular(AppRadius.r16.r),
        border: Border.all(
          color: widget.isPlaying ? ColorManager.primary.withAlpha(80) : ColorManager.border,
          width: widget.isPlaying ? 1.5 : 1,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x06000000),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(AppRadius.r16.r),
          child: Padding(
            padding: EdgeInsets.all(14.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Row: Type Badge + Date + Amount
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: visuals.container,
                        borderRadius: BorderRadius.circular(AppRadius.r8.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(
                            visuals.icon,
                            width: 12.r,
                            height: 12.r,
                            colorFilter: ColorFilter.mode(
                              visuals.color,
                              BlendMode.srcIn,
                            ),
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            visuals.label,
                            style: getBoldStyle(
                              color: visuals.color,
                              fontSize: FontSize.s11,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        if (formattedDate.isNotEmpty) ...[
                          Text(
                            formattedDate,
                            style: getRegularStyle(
                              color: ColorManager.textTertiary,
                              fontSize: FontSize.s11,
                            ),
                          ),
                          SizedBox(width: 10.w),
                        ],
                        Text(
                          "${widget.item.amount} ${AppStrings.egp}",
                          style: getBoldStyle(
                            color: ColorManager.textPrimary,
                            fontSize: FontSize.s15,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                SizedBox(height: 12.h),

                // Middle: Contact / Party
                Row(
                  children: [
                    Container(
                      width: 32.r,
                      height: 32.r,
                      decoration: const BoxDecoration(
                        color: ColorManager.surfaceVariant,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          IconAssets.user,
                          width: 16.r,
                          height: 16.r,
                          colorFilter: const ColorFilter.mode(
                            ColorManager.primary,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        widget.item.contactName.isNotEmpty
                            ? widget.item.contactName
                            : "طرف ثانٍ غير محدد",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: getBoldStyle(
                          color: ColorManager.textPrimary,
                          fontSize: FontSize.s13,
                        ),
                      ),
                    ),
                  ],
                ),

                if (widget.item.notes.isNotEmpty) ...[
                  SizedBox(height: 6.h),
                  Padding(
                    padding: EdgeInsets.only(right: 40.w),
                    child: Text(
                      widget.item.notes,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: getRegularStyle(
                        color: ColorManager.textSecondary,
                        fontSize: FontSize.s11,
                        height: 1.3,
                      ),
                    ),
                  ),
                ],

                SizedBox(height: 12.h),

                // Bottom Audio Player Bar
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    color: widget.isPlaying
                        ? ColorManager.primary.withAlpha(12)
                        : ColorManager.surfaceVariant,
                    borderRadius: BorderRadius.circular(AppRadius.r10.r),
                    border: Border.all(
                      color: widget.isPlaying
                          ? ColorManager.primary.withAlpha(60)
                          : ColorManager.border,
                    ),
                  ),
                  child: Row(
                    children: [
                      // زر تشغيل/إيقاف
                      GestureDetector(
                        onTap: widget.onTogglePlay,
                        child: Container(
                          width: 32.r,
                          height: 32.r,
                          decoration: BoxDecoration(
                            color: ColorManager.primary,
                            shape: BoxShape.circle,
                            boxShadow: widget.isPlaying
                                ? [
                                    BoxShadow(
                                      color: ColorManager.primary.withAlpha(80),
                                      blurRadius: 8,
                                      spreadRadius: 1,
                                    )
                                  ]
                                : [],
                          ),
                          child: Center(
                            child: Icon(
                              widget.isPlaying
                                  ? Icons.pause_rounded
                                  : Icons.play_arrow_rounded,
                              color: ColorManager.white,
                              size: 18.r,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10.w),

                      // Waveform + Progress
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Animated Waveform Bars
                            SizedBox(
                              height: 24.h,
                              child: AnimatedBuilder(
                                animation: _waveController,
                                builder: (context, _) {
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: List.generate(18, (i) {
                                      final phase = (i / 18) * 2 * math.pi;
                                      final sinVal = widget.isPlaying
                                          ? (math.sin(
                                                  _waveController.value * 2 * math.pi + phase) +
                                              1) /
                                              2
                                          : 0.25;
                                      final barH = (3.h + sinVal * 18.h)
                                          .clamp(3.h, 21.h);
                                      return AnimatedContainer(
                                        duration: const Duration(milliseconds: 80),
                                        width: 2.5.w,
                                        height: barH,
                                        decoration: BoxDecoration(
                                          color: widget.isPlaying
                                              ? ColorManager.primary
                                                  .withAlpha((155 + (sinVal * 100)).toInt())
                                              : ColorManager.borderDark,
                                          borderRadius: BorderRadius.circular(2.r),
                                        ),
                                      );
                                    }),
                                  );
                                },
                              ),
                            ),
                            SizedBox(height: 3.h),
                            // Progress bar
                            ClipRRect(
                              borderRadius: BorderRadius.circular(3.r),
                              child: LinearProgressIndicator(
                                value: widget.isPlaying ? widget.playbackProgress : 0.0,
                                backgroundColor: ColorManager.borderDark,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  ColorManager.primary,
                                ),
                                minHeight: 2.5.h,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 8.w),

                      // عداد الوقت المتبقي
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            _formatRemaining(),
                            style: getMediumStyle(
                              color: widget.isPlaying
                                  ? ColorManager.primary
                                  : ColorManager.textSecondary,
                              fontSize: FontSize.s10,
                            ),
                          ),
                          if (!widget.isPlaying)
                            Icon(
                              Icons.chevron_left_rounded,
                              color: ColorManager.textSecondary,
                              size: 16.r,
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TypeVisuals {
  final String label;
  final Color color;
  final Color container;
  final String icon;

  _TypeVisuals({
    required this.label,
    required this.color,
    required this.container,
    required this.icon,
  });
}
