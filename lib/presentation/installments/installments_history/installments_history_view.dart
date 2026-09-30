// ─────────────────────────────────────────────────────────────
// InstallmentsHistoryView — Installments Timeline & History
// Mizan Design System — Figma Node #2303:4184 compliant
// ─────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mizan/app/di.dart';
import 'package:mizan/presentation/common/state_randrer/state_randrer_impl.dart';
import 'package:mizan/presentation/installments/installments_history/installments_history_cubit.dart';
import 'package:mizan/presentation/installments/installments_history/installments_history_state.dart';
import 'package:mizan/presentation/installments/installments_history/widgets/installment_history_filter_tabs.dart';
import 'package:mizan/presentation/installments/installments_history/widgets/installment_timeline_card.dart';
import 'package:mizan/presentation/installments/widgets/installment_status_style.dart';
import 'package:mizan/presentation/resources/assets_manager.dart';
import 'package:mizan/presentation/resources/color_manager.dart';
import 'package:mizan/presentation/resources/font_manager.dart';
import 'package:mizan/presentation/resources/strings_manager.dart';
import 'package:mizan/presentation/resources/styles_manager.dart';
import 'package:mizan/presentation/resources/values_manager.dart';

class InstallmentsHistoryView extends StatelessWidget {
  const InstallmentsHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<InstallmentsHistoryCubit>(
      create: (_) => getIt<InstallmentsHistoryCubit>()..getInstallmentsHistory(),
      child: const _InstallmentsHistoryScreen(),
    );
  }
}

class _InstallmentsHistoryScreen extends StatelessWidget {
  const _InstallmentsHistoryScreen();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: ColorManager.background,
        appBar: AppBar(
          backgroundColor: ColorManager.surface,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: true,
          leading: Padding(
            padding: EdgeInsets.all(8.r),
            child: Container(
              decoration: BoxDecoration(
                color: ColorManager.surfaceVariant,
                shape: BoxShape.circle,
                border: Border.all(color: ColorManager.border, width: 1),
              ),
              child: IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: ColorManager.textPrimary,
                  size: 16.r,
                ),
                onPressed: () => Navigator.maybePop(context),
              ),
            ),
          ),
          title: Column(
            children: [
              Text(
                AppStrings.installmentsHistoryTitle,
                style: getBoldStyle(
                  color: ColorManager.textPrimary,
                  fontSize: FontSize.s16,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                AppStrings.installmentsHistorySubtitle,
                style: getRegularStyle(
                  color: ColorManager.textSecondary,
                  fontSize: FontSize.s11,
                ),
              ),
            ],
          ),
        ),
        body: BlocBuilder<InstallmentsHistoryCubit, InstallmentsHistoryState>(
          builder: (context, state) {
            return Column(
              children: [
                // ── Pinned Horizontal Filters ──
                Container(
                  color: ColorManager.surface,
                  padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 12.h),
                  child: Column(
                    children: [
                      InstallmentHistoryFilterTabs(
                        selectedStatus: state.status,
                        onStatusSelected: (status) {
                          context
                              .read<InstallmentsHistoryCubit>()
                              .changeStatusFilter(status);
                        },
                      ),
                      SizedBox(height: 10.h),
                      // Count & Date Header Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${state.totalCount} ${AppStrings.installmentsCountSuffix}',
                            style: getBoldStyle(
                              color: ColorManager.textPrimary,
                              fontSize: FontSize.s12,
                            ),
                          ),
                          Text(
                            '${AppStrings.untilDate} ${InstallmentFormatters.getTodayFormatted()}',
                            style: getRegularStyle(
                              color: ColorManager.textTertiary,
                              fontSize: FontSize.s11,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                Divider(color: ColorManager.border, height: 1.h),

                // ── Main Timeline List with State Renderer ──
                Expanded(
                  child: state.flowState?.getScreenWidget(
                        context,
                        _buildTimelineList(context, state),
                        () => context
                            .read<InstallmentsHistoryCubit>()
                            .getInstallmentsHistory(),
                      ) ??
                      _buildTimelineList(context, state),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildTimelineList(BuildContext context, InstallmentsHistoryState state) {
    final items = state.data ?? [];

    return RefreshIndicator(
      color: ColorManager.primary,
      onRefresh: () =>
          context.read<InstallmentsHistoryCubit>().getInstallmentsHistory(),
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        slivers: [
          if (items.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(24.r),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 76.r,
                        height: 76.r,
                        decoration: const BoxDecoration(
                          color: ColorManager.surfaceVariant,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: SvgPicture.asset(
                            ImageAssets.illustrationEmpty,
                            width: 44.r,
                            height: 44.r,
                          ),
                        ),
                      ),
                      SizedBox(height: 18.h),
                      Text(
                        AppStrings.noHistoryItems,
                        textAlign: TextAlign.center,
                        style: getBoldStyle(
                          color: ColorManager.textPrimary,
                          fontSize: FontSize.s15,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          else ...[
            SliverPadding(
              padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 8.h),
              sliver: SliverList.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return InstallmentTimelineCard(
                    key: ValueKey(item.installmentId),
                    item: item,
                    isFirst: index == 0,
                    isLast: index == items.length - 1,
                  );
                },
              ),
            ),

            // ── Pagination Footer ──
            if (state.hasMore || state.totalPages > 1)
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 32.h),
                  child: Column(
                    children: [
                      if (state.hasMore)
                        SizedBox(
                          width: double.infinity,
                          height: 44.h,
                          child: OutlinedButton(
                            onPressed: state.isLoadingMore
                                ? null
                                : () => context
                                    .read<InstallmentsHistoryCubit>()
                                    .loadMoreInstallments(),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(
                                color: ColorManager.primary,
                                width: 1.0,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(AppRadius.r12.r),
                              ),
                            ),
                            child: state.isLoadingMore
                                ? SizedBox(
                                    width: 20.r,
                                    height: 20.r,
                                    child: const CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: ColorManager.primary,
                                    ),
                                  )
                                : Text(
                                    AppStrings.loadMore,
                                    style: getBoldStyle(
                                      color: ColorManager.primary,
                                      fontSize: FontSize.s13,
                                    ),
                                  ),
                          ),
                        ),
                      if (state.totalPages > 1) ...[
                        SizedBox(height: 8.h),
                        Text(
                          '${AppStrings.pagePrefix} ${state.currentPage} ${AppStrings.ofPages} ${state.totalPages}',
                          style: getRegularStyle(
                            color: ColorManager.textTertiary,
                            fontSize: FontSize.s11,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              )
            else
              SliverToBoxAdapter(
                child: SizedBox(height: 24.h),
              ),
          ],
        ],
      ),
    );
  }
}
