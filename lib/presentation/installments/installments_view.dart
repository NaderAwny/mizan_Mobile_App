// ─────────────────────────────────────────────────────────────
// InstallmentsView — Installments & Debts Tracking Dashboard
// Mizan Design System — Figma Node #3:300 compliant
// ─────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mizan/app/di.dart';
import 'package:mizan/domain/model/installments_dashboard_model.dart';
import 'package:mizan/presentation/common/state_randrer/state_randrer_impl.dart';
import 'package:mizan/presentation/home.dart';
import 'package:mizan/presentation/installments/installments_dashboard/installments_dashboard_cubit.dart';
import 'package:mizan/presentation/installments/installments_dashboard/installments_dashboard_state.dart';
import 'package:mizan/presentation/installments/widgets/active_plans_banner.dart';
import 'package:mizan/presentation/installments/widgets/installment_plan_card.dart';
import 'package:mizan/presentation/installments/widgets/installment_summary_grid.dart';
import 'package:mizan/presentation/resources/assets_manager.dart';
import 'package:mizan/presentation/resources/color_manager.dart';
import 'package:mizan/presentation/resources/font_manager.dart';
import 'package:mizan/presentation/resources/routes_manager.dart';
import 'package:mizan/presentation/resources/strings_manager.dart';
import 'package:mizan/presentation/resources/styles_manager.dart';
import 'package:mizan/presentation/resources/values_manager.dart';

class InstallmentsView extends StatelessWidget {
  const InstallmentsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<InstallmentsDashboardCubit>(
      create: (_) =>
          getIt<InstallmentsDashboardCubit>()..getInstallmentsDashboard(),
      child: const _InstallmentsDashboardScreen(),
    );
  }
}

class _InstallmentsDashboardScreen extends StatelessWidget {
  const _InstallmentsDashboardScreen();

  void _handleBack(BuildContext context) {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
      return;
    }
    const SwitchHomeTabNotification(0).dispatch(context);
  }

  void _navigateToHistory(BuildContext context) {
    Navigator.pushNamed(context, Routes.installmentsHistoryRoute).then((_) {
      if (context.mounted) {
        context.read<InstallmentsDashboardCubit>().getInstallmentsDashboard();
      }
    });
  }

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
                onPressed: () => _handleBack(context),
              ),
            ),
          ),
          title: Text(
            AppStrings.installmentsDashboardTitle,
            style: getBoldStyle(
              color: ColorManager.textPrimary,
              fontSize: FontSize.s16,
            ),
          ),
          actions: [
            Padding(
              padding: EdgeInsets.only(left: 12.w),
              child: Container(
                width: 38.r,
                height: 38.r,
                decoration: BoxDecoration(
                  color: ColorManager.surfaceVariant,
                  shape: BoxShape.circle,
                  border: Border.all(color: ColorManager.border, width: 1),
                ),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: SvgPicture.asset(
                    IconAssets.receiptText,
                    width: 18.r,
                    height: 18.r,
                    colorFilter: const ColorFilter.mode(
                      ColorManager.textPrimary,
                      BlendMode.srcIn,
                    ),
                  ),
                  tooltip: AppStrings.installmentsHistoryTitle,
                  onPressed: () => _navigateToHistory(context),
                ),
              ),
            ),
          ],
        ),
        body:
            BlocBuilder<InstallmentsDashboardCubit, InstallmentsDashboardState>(
              builder: (context, state) {
                return state.flowState?.getScreenWidget(
                      context,
                      _buildBody(context, state.data),
                      () => context
                          .read<InstallmentsDashboardCubit>()
                          .getInstallmentsDashboard(),
                    ) ??
                    _buildBody(context, state.data);
              },
            ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, InstallmentsDashboardModel? data) {
    if (data == null) {
      return const SizedBox.shrink();
    }

    return RefreshIndicator(
      color: ColorManager.primary,
      onRefresh: () =>
          context.read<InstallmentsDashboardCubit>().getInstallmentsDashboard(),
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        slivers: [
          // ── Top Spacing & Summary Grid ──
          SliverPadding(
            padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 0),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 2x2 Summary Cards Grid
                  InstallmentSummaryGrid(data: data),
                  SizedBox(height: 14.h),
                  // Active Plans Banner
                  ActivePlansBanner(
                    totalDebtsCount: data.totalDebtsCount,
                    activeClientsCount: data.plans.length,
                  ),
                  SizedBox(height: 20.h),
                  // Section Header: "خطط التقسيط" + "عرض السجل الكامل"
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppStrings.installmentPlansSection,
                        style: getBoldStyle(
                          color: ColorManager.textPrimary,
                          fontSize: FontSize.s14,
                        ),
                      ),
                      InkWell(
                        onTap: () => _navigateToHistory(context),
                        borderRadius: BorderRadius.circular(AppRadius.r6.r),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 6.w,
                            vertical: 4.h,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                AppStrings.viewFullHistory,
                                style: getBoldStyle(
                                  color: ColorManager.primary,
                                  fontSize: FontSize.s12,
                                ),
                              ),
                              SizedBox(width: 4.w),
                              SvgPicture.asset(
                                IconAssets.chevronLeft,
                                width: 12.r,
                                height: 12.r,
                                colorFilter: const ColorFilter.mode(
                                  ColorManager.primary,
                                  BlendMode.srcIn,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                ],
              ),
            ),
          ),

          // ── Plans List ──
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            sliver: SliverList.separated(
              itemCount: data.plans.length,
              itemBuilder: (context, index) {
                final plan = data.plans[index];
                return InstallmentPlanCard(
                  key: ValueKey(plan.transactionId),
                  plan: plan,
                );
              },
              separatorBuilder: (_, _) => SizedBox(height: 14.h),
            ),
          ),

          // ── Bottom Safe Spacing ──
          SliverToBoxAdapter(child: SizedBox(height: 32.h)),
        ],
      ),
    );
  }
}
