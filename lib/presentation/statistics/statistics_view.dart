// ─────────────────────────────────────────────────────────────
// StatisticsView — Mizan design system & Figma Node #3:382 compliant
// ─────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:mizan/app/di.dart';
import 'package:mizan/app/date_utils.dart';
import 'package:mizan/domain/model/statistics_model/statistics_model.dart';
import 'package:mizan/presentation/common/state_randrer/state_randrer_impl.dart';
import 'package:mizan/presentation/resources/color_manager.dart';
import 'package:mizan/presentation/resources/font_manager.dart';
import 'package:mizan/presentation/resources/routes_manager.dart';
import 'package:mizan/presentation/resources/styles_manager.dart';
import 'package:mizan/presentation/resources/values_manager.dart';
import 'package:mizan/presentation/statistics/cubit/statistics_cubit.dart';
import 'package:mizan/presentation/statistics/cubit/statistics_state.dart';

// ─── Entry Point ──────────────────────────────────────────────
class StatisticsView extends StatelessWidget {
  const StatisticsView({super.key});

  @override
  Widget build(BuildContext context) {
    final DateTime now = DateTime.now();
    return BlocProvider<StatisticsCubit>(
      create: (_) =>
          getIt<StatisticsCubit>()
            ..getMonthlyStatistics(now.year.toString(), now.month.toString()),
      child: const _StatisticsScreen(),
    );
  }
}

// ─── Screen ───────────────────────────────────────────────────
class _StatisticsScreen extends StatelessWidget {
  const _StatisticsScreen();

  static const List<String> _tabs = <String>['يوم محدد', 'شهر محدد', 'اليوم'];

  static const List<String> _arabicMonths = <String>[
    'يناير',
    'فبراير',
    'مارس',
    'أبريل',
    'مايو',
    'يونيو',
    'يوليو',
    'أغسطس',
    'سبتمبر',
    'أكتوبر',
    'نوفمبر',
    'ديسمبر',
  ];

  static String _formatMonthYearDisplay(String raw) {
    final List<String> parts = raw.split('-');
    if (parts.length == 2) {
      final String year = parts[0];
      final int monthInt = int.tryParse(parts[1]) ?? 1;
      if (monthInt >= 1 && monthInt <= 12) {
        final String monthName = _arabicMonths[monthInt - 1];
        return '$monthName $year (شهر $monthInt)';
      }
    }
    return raw;
  }

  Future<void> _openDatePicker(BuildContext context) async {
    try {
      final StatisticsCubit cubit = context.read<StatisticsCubit>();
      DateTime initial = DateTime.now();
      if (cubit.state.selectedDate != null) {
        try {
          initial = DateFormat('yyyy-MM-dd').parse(cubit.state.selectedDate!);
        } catch (_) {}
      }

      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: initial,
        firstDate: DateTime(2020),
        lastDate: DateTime.now(),
        locale: const Locale('ar'),
        builder: (BuildContext ctx, Widget? child) => Theme(
          data: Theme.of(ctx).copyWith(
            colorScheme: const ColorScheme.light(
              primary: ColorManager.primary,
              onPrimary: ColorManager.white,
              surface: ColorManager.surface,
              onSurface: ColorManager.textPrimary,
            ),
            dialogTheme: DialogThemeData(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.r20.r),
              ),
            ),
          ),
          child: child!,
        ),
      );

      if (picked != null && context.mounted) {
        final String formatted = DateFormat('yyyy-MM-dd').format(picked);
        cubit.getDailyStatistics(formatted, tabIndex: 0);
      }
    } catch (_) {}
  }

  Future<void> _openMonthPicker(BuildContext context) async {
    try {
      final StatisticsCubit cubit = context.read<StatisticsCubit>();
      int initialYear = DateTime.now().year;
      int initialMonth = DateTime.now().month;

      if (cubit.state.selectedMonthYear != null) {
        final List<String> parts = cubit.state.selectedMonthYear!.split('-');
        if (parts.length == 2) {
          initialYear = int.tryParse(parts[0]) ?? initialYear;
          initialMonth = int.tryParse(parts[1]) ?? initialMonth;
        }
      }

      final Map<String, int>? result = await showDialog<Map<String, int>>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext ctx) => _MonthYearPickerDialog(
          initialYear: initialYear,
          initialMonth: initialMonth,
        ),
      );

      if (result != null && context.mounted) {
        final String y = (result['year'] ?? initialYear).toString();
        final String m = (result['month'] ?? initialMonth).toString().padLeft(
          2,
          '0',
        );
        cubit.getMonthlyStatistics(y, m, tabIndex: 1);
      }
    } catch (_) {}
  }

  void _onTabSelected(BuildContext context, int index) {
    final StatisticsCubit cubit = context.read<StatisticsCubit>();

    if (index == 0) {
      // "يوم محدد" -> Open DatePicker
      _openDatePicker(context);
    } else if (index == 1) {
      // "شهر محدد" -> Open Month Picker
      cubit.selectTab(index);
      _openMonthPicker(context);
    } else {
      // "اليوم" -> Today's Daily statistics
      cubit.selectTab(index);
      final String todayStr = DateFormat('yyyy-MM-dd').format(DateTime.now());
      cubit.getDailyStatistics(todayStr, tabIndex: index);
    }
  }

  Future<void> _onRefresh(BuildContext context) async {
    final StatisticsCubit cubit = context.read<StatisticsCubit>();
    if (cubit.state.selectedDate != null) {
      await cubit.getDailyStatistics(cubit.state.selectedDate!);
    } else if (cubit.state.isMonthlyMode &&
        cubit.state.selectedMonthYear != null) {
      final List<String> parts = cubit.state.selectedMonthYear!.split('-');
      if (parts.length == 2) {
        await cubit.getMonthlyStatistics(parts[0], parts[1]);
      } else {
        final DateTime now = DateTime.now();
        await cubit.getMonthlyStatistics(
          now.year.toString(),
          now.month.toString(),
        );
      }
    } else {
      final DateTime now = DateTime.now();
      await cubit.getMonthlyStatistics(
        now.year.toString(),
        now.month.toString(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StatisticsCubit, StatisticsState>(
      listener: (BuildContext context, StatisticsState state) {},
      builder: (BuildContext context, StatisticsState state) {
        return Scaffold(
          backgroundColor: ColorManager.background,
          appBar: _buildAppBar(context, state),
          body: SafeArea(
            child: Column(
              children: <Widget>[
                // ── Filter Segmented Tabs ─────────────────────────────
                _buildFilterTabs(context, state),

                // ── Selected Date Banner (if in Daily mode) ───────────
                if (state.selectedDate != null)
                  _buildSelectedDateBanner(context, state.selectedDate!),

                // ── Selected Month Banner (if in Monthly mode) ────────
                if (state.isMonthlyMode && state.selectedMonthYear != null)
                  _buildSelectedMonthBanner(context, state.selectedMonthYear!),

                // ── Content Area with FlowState (Loading, Error, Content) ──
                Expanded(
                  child:
                      state.flowState?.getScreenWidget(
                        context,
                        _buildScrollableDashboard(context, state),
                        () => context.read<StatisticsCubit>().retry(),
                      ) ??
                      _buildScrollableDashboard(context, state),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ─── App Bar ────────────────────────────────────────────────
  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    StatisticsState state,
  ) {
    final String subtitle;
    if (state.selectedDate != null) {
      subtitle = 'تقرير يوم: ${state.selectedDate}';
    } else if (state.isMonthlyMode && state.selectedMonthYear != null) {
      subtitle =
          'تقرير شهر: ${_formatMonthYearDisplay(state.selectedMonthYear!)}';
    } else {
      subtitle = 'تقرير اليوم الحالي';
    }

    final bool canPop = Navigator.canPop(context);

    return AppBar(
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
              canPop
                  ? Icons.arrow_forward_ios_rounded
                  : Icons.notifications_none_rounded,
              color: ColorManager.textPrimary,
              size: 18.r,
            ),
            onPressed: () {
              if (canPop) {
                Navigator.pop(context);
              } else {
                Navigator.pushNamed(context, Routes.notificationsRoute);
              }
            },
          ),
        ),
      ),
      title: Column(
        children: <Widget>[
          Text(
            'التقارير والإحصائيات',
            style: getBoldStyle(
              color: ColorManager.textPrimary,
              fontSize: FontSize.s16,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            subtitle,
            style: getRegularStyle(
              color: ColorManager.textSecondary,
              fontSize: FontSize.s11,
            ),
          ),
        ],
      ),
      actions: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          child: Container(
            decoration: BoxDecoration(
              color: ColorManager.surfaceVariant,
              shape: BoxShape.circle,
              border: Border.all(color: ColorManager.border, width: 1),
            ),
            child: IconButton(
              icon: Icon(
                state.selectedTabIndex == 1
                    ? Icons.calendar_month_rounded
                    : Icons.event_available_rounded,
                color: ColorManager.primary,
                size: 20.r,
              ),
              onPressed: () {
                if (state.selectedTabIndex == 1) {
                  _openMonthPicker(context);
                } else {
                  _openDatePicker(context);
                }
              },
              tooltip: state.selectedTabIndex == 1
                  ? 'اختيار شهر محدد'
                  : 'اختيار يوم محدد',
            ),
          ),
        ),
      ],
    );
  }

  // ─── Filter Tabs ────────────────────────────────────────────
  Widget _buildFilterTabs(BuildContext context, StatisticsState state) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppPadding.p16.w,
        vertical: AppPadding.p12.h,
      ),
      child: Container(
        padding: EdgeInsets.all(4.r),
        decoration: BoxDecoration(
          color: ColorManager.surfaceVariant,
          borderRadius: AppBorderRadius.r16,
          border: Border.all(color: ColorManager.border.withAlpha(50)),
        ),
        child: Row(
          children: List<Widget>.generate(_tabs.length, (int index) {
            final bool isSelected = state.selectedTabIndex == index;
            return Expanded(
              child: GestureDetector(
                onTap: () => _onTabSelected(context, index),
                behavior: HitTestBehavior.opaque,
                child: AnimatedContainer(
                  duration: AppDuration.d200,
                  curve: Curves.easeInOut,
                  padding: EdgeInsets.symmetric(vertical: 9.h),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? ColorManager.primary
                        : ColorManager.transparent,
                    borderRadius: AppBorderRadius.r12,
                    boxShadow: isSelected
                        ? <BoxShadow>[
                            BoxShadow(
                              color: ColorManager.primary.withAlpha(50),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      if (index == 0) ...<Widget>[
                        Icon(
                          Icons.event_available_rounded,
                          size: 14.r,
                          color: isSelected
                              ? ColorManager.white
                              : ColorManager.textSecondary,
                        ),
                        SizedBox(width: 4.w),
                      ] else if (index == 1) ...<Widget>[
                        Icon(
                          Icons.calendar_month_rounded,
                          size: 14.r,
                          color: isSelected
                              ? ColorManager.white
                              : ColorManager.textSecondary,
                        ),
                        SizedBox(width: 4.w),
                      ],
                      Text(
                        _tabs[index],
                        textAlign: TextAlign.center,
                        style: isSelected
                            ? getBoldStyle(
                                color: ColorManager.white,
                                fontSize: FontSize.s13,
                              )
                            : getMediumStyle(
                                color: ColorManager.textSecondary,
                                fontSize: FontSize.s13,
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  // ─── Selected Date Banner (Daily) ───────────────────────────
  Widget _buildSelectedDateBanner(BuildContext context, String date) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppPadding.p16.w,
        0,
        AppPadding.p16.w,
        AppPadding.p8.h,
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: ColorManager.primary.withAlpha(15),
          borderRadius: AppBorderRadius.r12,
          border: Border.all(color: ColorManager.primary.withAlpha(40)),
        ),
        child: Row(
          children: <Widget>[
            InkWell(
              onTap: () => _openDatePicker(context),
              borderRadius: BorderRadius.circular(AppRadius.r8.r),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: ColorManager.primary,
                  borderRadius: BorderRadius.circular(AppRadius.r8.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(
                      Icons.edit_calendar_rounded,
                      size: 12.r,
                      color: ColorManager.white,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      'تغيير اليوم',
                      style: getSemiBoldStyle(
                        color: ColorManager.white,
                        fontSize: FontSize.s10,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            Text(
              'بيانات يوم: $date',
              style: getSemiBoldStyle(
                color: ColorManager.primary,
                fontSize: FontSize.s12,
              ),
            ),
            SizedBox(width: 6.w),
            Icon(
              Icons.calendar_today_rounded,
              size: 14.r,
              color: ColorManager.primary,
            ),
          ],
        ),
      ),
    );
  }

  // ─── Selected Month Banner (Monthly) ────────────────────────
  Widget _buildSelectedMonthBanner(BuildContext context, String monthYear) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppPadding.p16.w,
        0,
        AppPadding.p16.w,
        AppPadding.p8.h,
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: ColorManager.primary.withAlpha(15),
          borderRadius: AppBorderRadius.r12,
          border: Border.all(color: ColorManager.primary.withAlpha(40)),
        ),
        child: Row(
          children: <Widget>[
            InkWell(
              onTap: () => _openMonthPicker(context),
              borderRadius: BorderRadius.circular(AppRadius.r8.r),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: ColorManager.primary,
                  borderRadius: BorderRadius.circular(AppRadius.r8.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(
                      Icons.calendar_month_rounded,
                      size: 12.r,
                      color: ColorManager.white,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      'تغيير الشهر',
                      style: getSemiBoldStyle(
                        color: ColorManager.white,
                        fontSize: FontSize.s10,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            Flexible(
              child: Text(
                'بيانات شهر: ${_formatMonthYearDisplay(monthYear)}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: getSemiBoldStyle(
                  color: ColorManager.primary,
                  fontSize: FontSize.s12,
                ),
              ),
            ),
            SizedBox(width: 6.w),
            Icon(
              Icons.date_range_rounded,
              size: 14.r,
              color: ColorManager.primary,
            ),
          ],
        ),
      ),
    );
  }

  // ─── Scrollable Dashboard Content ───────────────────────────
  Widget _buildScrollableDashboard(
    BuildContext context,
    StatisticsState state,
  ) {
    final StatisticsPageModel? data = state.data;

    return RefreshIndicator(
      onRefresh: () => _onRefresh(context),
      color: ColorManager.primary,
      backgroundColor: ColorManager.surface,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        padding: EdgeInsets.symmetric(horizontal: AppPadding.p16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(height: 6.h),

            // 1. KPI Cards (Sales & Purchases)
            _buildKpiCards(data),

            SizedBox(height: 12.h),

            // 2. Net Balance & Operations Count Banner
            _buildNetAndOperationsBanner(data),

            SizedBox(height: 14.h),

            // 3. Cost & Sales Structure Analysis
            _buildCostStructure(data),

            SizedBox(height: 14.h),

            // 4. Most Active Partners / Transactions List
            _buildActivePartners(context, data),

            SizedBox(height: 36.h),
          ],
        ),
      ),
    );
  }

  // ─── 1. Summary KPI Cards (Figma Side-by-Side) ───────────────
  Widget _buildKpiCards(StatisticsPageModel? data) {
    final double totalSales = (data?.totalSales ?? 0).toDouble();
    final double totalPurchases = (data?.totalPurchases ?? 0).toDouble();
    final double totalTurnover = totalPurchases + totalSales;

    return Column(
      children: <Widget>[
        _KpiCard(
          label: 'إجمالي التداول',
          amount: totalTurnover,
          badgeLabel: 'إجمالي التداول',
          isPositive: true,
        ),

        SizedBox(height: 10.h),
        Row(
          children: <Widget>[
            // Total Sales / Revenue
            Expanded(
              child: _KpiCard(
                label: 'إجمالي الإيرادات',
                amount: totalSales,
                badgeLabel: 'المبيعات',
                isPositive: true,
              ),
            ),
            SizedBox(width: 12.w),
            // Total Purchases / Expenses
            Expanded(
              child: _KpiCard(
                label: 'إجمالي المصروفات',
                amount: totalPurchases,
                badgeLabel: 'المشتريات',
                isPositive: false,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ─── 2. Net & Operations Count Banner ───────────────────────
  Widget _buildNetAndOperationsBanner(StatisticsPageModel? data) {
    final double totalSales = (data?.totalSales ?? 0).toDouble();
    final double totalPurchases = (data?.totalPurchases ?? 0).toDouble();
    final double netAmount = totalSales - totalPurchases;
    final bool isSurplus = netAmount >= 0;
    final int operationsCount =
        data?.operationsCount ?? (data?.transactions?.length ?? 0);

    final Color netColor = isSurplus
        ? ColorManager.success
        : ColorManager.error;
    final Color netBg = isSurplus
        ? ColorManager.successContainer
        : ColorManager.errorContainer;
    final String formattedNet = NumberFormat(
      '#,##0.##',
    ).format(netAmount.abs());

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: ColorManager.surface,
        borderRadius: AppBorderRadius.r20,
        boxShadow: const <BoxShadow>[AppShadows.cardShadow],
        border: Border.all(color: ColorManager.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          // Operations Count
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'عدد العمليات',
                style: getRegularStyle(
                  color: ColorManager.textSecondary,
                  fontSize: FontSize.s11,
                ),
              ),
              SizedBox(height: 4.h),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(
                    Icons.receipt_long_rounded,
                    size: 16.r,
                    color: ColorManager.primary,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    '$operationsCount عملية',
                    style: getBoldStyle(
                      color: ColorManager.textPrimary,
                      fontSize: FontSize.s14,
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Divider
          Container(height: 36.h, width: 1, color: ColorManager.border),

          // Net Balance
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 6.w,
                      vertical: 2.h,
                    ),
                    decoration: BoxDecoration(
                      color: netBg,
                      borderRadius: BorderRadius.circular(AppRadius.r8.r),
                    ),
                    child: Text(
                      isSurplus ? 'فائض ربحي' : 'عجز مالي',
                      style: getSemiBoldStyle(
                        color: netColor,
                        fontSize: FontSize.s10,
                      ),
                    ),
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    'الصافي',
                    style: getRegularStyle(
                      color: ColorManager.textSecondary,
                      fontSize: FontSize.s11,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 4.h),
              Text(
                '${isSurplus ? '+' : '-'}$formattedNet EGP',
                style: getBoldStyle(color: netColor, fontSize: FontSize.s15),
                textDirection: TextDirection.ltr,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─── 3. Cost & Sales Structure Analysis ─────────────────────
  Widget _buildCostStructure(StatisticsPageModel? data) {
    final double totalPurchases = (data?.totalPurchases ?? 0).toDouble();
    final double totalSales = (data?.totalSales ?? 0).toDouble();
    final double totalTurnover = totalPurchases + totalSales;

    final int salesPct = totalTurnover > 0
        ? ((totalSales / totalTurnover) * 100).round()
        : 0;
    final int purchasesPct = totalTurnover > 0
        ? ((totalPurchases / totalTurnover) * 100).round()
        : 0;

    return Container(
      padding: EdgeInsets.all(AppPadding.p16.r),
      decoration: BoxDecoration(
        color: ColorManager.surface,
        borderRadius: AppBorderRadius.r20,
        boxShadow: const <BoxShadow>[AppShadows.cardShadow],
        border: Border.all(color: ColorManager.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Center(
            child: Text(
              'تحليل هيكل التكاليف',
              style: getSemiBoldStyle(
                color: ColorManager.textPrimary,
                fontSize: FontSize.s14,
              ),
            ),
          ),

          SizedBox(height: 16.h),

          if (totalTurnover > 0) ...<Widget>[
            _CostBar(
              label: 'المبيعات والإيرادات',
              pct: salesPct,
              amount: totalSales,
              color: ColorManager.primary,
            ),
            SizedBox(height: 14.h),
            _CostBar(
              label: 'المشتريات والمصروفات',
              pct: purchasesPct,
              amount: totalPurchases,
              color: ColorManager.secondary,
            ),
          ] else ...<Widget>[
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 12.h),
                child: Text(
                  'لا توجد حركات مالية مسجلة لهذه الفترة',
                  style: getRegularStyle(
                    color: ColorManager.textTertiary,
                    fontSize: FontSize.s12,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ─── 4. Most Active Partners / Transactions List ────────────
  Widget _buildActivePartners(BuildContext context, StatisticsPageModel? data) {
    final List<TransactionStatisticsModel> txns =
        data?.transactions ?? <TransactionStatisticsModel>[];

    return Container(
      decoration: BoxDecoration(
        color: ColorManager.surface,
        borderRadius: AppBorderRadius.r20,
        boxShadow: const <BoxShadow>[AppShadows.cardShadow],
        border: Border.all(color: ColorManager.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(
              AppPadding.p16.w,
              AppPadding.p16.h,
              AppPadding.p16.w,
              AppPadding.p8.h,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                if (txns.isNotEmpty)
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 3.h,
                    ),
                    decoration: BoxDecoration(
                      color: ColorManager.surfaceVariant,
                      borderRadius: BorderRadius.circular(AppRadius.r8.r),
                    ),
                    child: Text(
                      '${txns.length} معاملة',
                      style: getMediumStyle(
                        color: ColorManager.textSecondary,
                        fontSize: FontSize.s11,
                      ),
                    ),
                  ),
                Text(
                  'الشركاء الأكثر نشاطاً',
                  style: getSemiBoldStyle(
                    color: ColorManager.textPrimary,
                    fontSize: FontSize.s14,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: ColorManager.border),
          if (txns.isEmpty)
            _buildEmptyTransactions()
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: txns.length,
              separatorBuilder: (BuildContext context, int index) => Divider(
                height: 1,
                indent: 16.w,
                endIndent: 16.w,
                color: ColorManager.border.withAlpha(80),
              ),
              itemBuilder: (BuildContext ctx, int index) =>
                  _TransactionPartnerRow(
                    txn: txns[index],
                    onTap: () {
                      final String? id = txns[index].id;
                      if (id != null && id.isNotEmpty) {
                        Navigator.pushNamed(
                          context,
                          Routes.transactionDetailsRoute,
                          arguments: id,
                        );
                      }
                    },
                  ),
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyTransactions() {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: AppPadding.p28.h,
        horizontal: AppPadding.p16.w,
      ),
      child: Column(
        children: <Widget>[
          Container(
            width: 48.r,
            height: 48.r,
            decoration: const BoxDecoration(
              color: ColorManager.surfaceVariant,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.receipt_long_outlined,
              size: 24.r,
              color: ColorManager.textTertiary,
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            'لا توجد معاملات مسجلة في هذه الفترة',
            style: getMediumStyle(
              color: ColorManager.textSecondary,
              fontSize: FontSize.s13,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 4.h),
          Text(
            'اختر يوماً أو فترة أخرى لعرض العمليات والتقارير',
            style: getRegularStyle(
              color: ColorManager.textTertiary,
              fontSize: FontSize.s11,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ─── KPI Card Widget ──────────────────────────────────────────
class _KpiCard extends StatelessWidget {
  const _KpiCard({
    required this.label,
    required this.amount,
    required this.badgeLabel,
    required this.isPositive,
  });

  final String label;
  final double amount;
  final String badgeLabel;
  final bool isPositive;

  @override
  Widget build(BuildContext context) {
    final Color valueColor = isPositive
        ? ColorManager.success
        : ColorManager.error;
    final Color bgColor = isPositive
        ? ColorManager.successContainer
        : ColorManager.errorContainer;
    final IconData arrowIcon = isPositive
        ? Icons.north_east_rounded
        : Icons.south_west_rounded;
    final String formatted = NumberFormat('#,##0.##').format(amount);

    return Container(
      padding: EdgeInsets.all(AppPadding.p14.r),
      decoration: BoxDecoration(
        color: ColorManager.surface,
        borderRadius: AppBorderRadius.r20,
        boxShadow: const <BoxShadow>[AppShadows.cardShadow],
        border: Border.all(color: ColorManager.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                width: 32.r,
                height: 32.r,
                decoration: BoxDecoration(
                  color: bgColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(arrowIcon, size: 16.r, color: valueColor),
              ),
              Expanded(
                child: Text(
                  label,
                  textAlign: TextAlign.end,
                  style: getRegularStyle(
                    color: ColorManager.textSecondary,
                    fontSize: FontSize.s11,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Text(
            '$formatted EGP',
            style: getBoldStyle(color: valueColor, fontSize: FontSize.s16),
            textAlign: TextAlign.end,
            textDirection: TextDirection.ltr,
          ),
          SizedBox(height: 6.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(AppRadius.r8.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(
                      isPositive
                          ? Icons.arrow_upward_rounded
                          : Icons.arrow_downward_rounded,
                      size: 9.r,
                      color: valueColor,
                    ),
                    SizedBox(width: 3.w),
                    Text(
                      badgeLabel,
                      style: getSemiBoldStyle(
                        color: valueColor,
                        fontSize: FontSize.s9,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Cost Bar Row ─────────────────────────────────────────────
class _CostBar extends StatelessWidget {
  const _CostBar({
    required this.label,
    required this.pct,
    required this.amount,
    required this.color,
  });

  final String label;
  final int pct;
  final double amount;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final String formattedAmount = NumberFormat('#,##0.##').format(amount);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Flexible(
              child: Text(
                '$pct% ($formattedAmount EGP)',
                style: getSemiBoldStyle(color: color, fontSize: FontSize.s11),
                textDirection: TextDirection.ltr,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(width: 8.w),
            Flexible(
              child: Text(
                label,
                style: getMediumStyle(
                  color: ColorManager.textPrimary,
                  fontSize: FontSize.s12,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.end,
              ),
            ),
          ],
        ),
        SizedBox(height: 6.h),
        ClipRRect(
          borderRadius: AppBorderRadius.r100,
          child: LinearProgressIndicator(
            value: (pct / 100).clamp(0.0, 1.0),
            minHeight: 7.h,
            backgroundColor: ColorManager.surfaceVariant,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }
}

// ─── Transaction Partner Row ──────────────────────────────────
class _TransactionPartnerRow extends StatelessWidget {
  const _TransactionPartnerRow({required this.txn, required this.onTap});

  final TransactionStatisticsModel txn;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final String name = (txn.contactName?.isNotEmpty == true)
        ? txn.contactName!
        : (txn.partyName?.isNotEmpty == true ? txn.partyName! : 'غير محدد');
    final String initial = name.isNotEmpty ? name[0] : '؟';
    final String amount = NumberFormat('#,##0.##').format(txn.amount ?? 0);
    final String opType = txn.operationType?.toLowerCase() ?? '';
    final bool isSale = opType.contains('sale') || opType.contains('بيع');
    final Color amountColor = isSale
        ? ColorManager.success
        : ColorManager.error;

    final String typeArabic = isSale ? 'بيع' : 'شراء';

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppPadding.p16.w,
          vertical: AppPadding.p12.h,
        ),
        child: Row(
          children: <Widget>[
            // Amount & Type Pill
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  '${isSale ? '+' : '-'}$amount EGP',
                  style: getBoldStyle(
                    color: amountColor,
                    fontSize: FontSize.s13,
                  ),
                  textDirection: TextDirection.ltr,
                ),
                SizedBox(height: 3.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color: isSale
                        ? ColorManager.successContainer
                        : ColorManager.errorContainer,
                    borderRadius: BorderRadius.circular(AppRadius.r8.r),
                  ),
                  child: Text(
                    typeArabic,
                    style: getSemiBoldStyle(
                      color: amountColor,
                      fontSize: FontSize.s9,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(width: 8.w),
            // Name + Subtitle (Date / Payment Method)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    name,
                    style: getMediumStyle(
                      color: ColorManager.textPrimary,
                      fontSize: FontSize.s13,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 2.h),
                  Builder(
                    builder: (BuildContext context) {
                      final String paymentMethodStr =
                          translatePaymentMethod(txn.paymentMethod);
                      final String dateStr;
                      if (txn.operationDate != null &&
                          txn.operationDate!.isNotEmpty) {
                        dateStr = formatDate(
                          parseBusinessDate(txn.operationDate!),
                        );
                      } else if (txn.createdAt != null &&
                          txn.createdAt!.isNotEmpty) {
                        dateStr = formatDate(
                          parseServerTime(txn.createdAt!),
                        );
                      } else {
                        dateStr = '';
                      }

                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          if (paymentMethodStr.isNotEmpty) ...<Widget>[
                            Flexible(
                              child: Text(
                                paymentMethodStr,
                                style: getRegularStyle(
                                  color: ColorManager.textTertiary,
                                  fontSize: FontSize.s10,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (dateStr.isNotEmpty)
                              Text(
                                ' • ',
                                style: getRegularStyle(
                                  color: ColorManager.textTertiary,
                                  fontSize: FontSize.s10,
                                ),
                              ),
                          ],
                          if (dateStr.isNotEmpty)
                            Flexible(
                              child: Text(
                                dateStr,
                                style: getRegularStyle(
                                  color: ColorManager.textTertiary,
                                  fontSize: FontSize.s10,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
            SizedBox(width: 10.w),
            // Avatar Circle
            Container(
              width: 38.r,
              height: 38.r,
              decoration: BoxDecoration(
                color: ColorManager.lightPrimary,
                shape: BoxShape.circle,
                border: Border.all(
                  color: ColorManager.primary.withAlpha(40),
                  width: 1,
                ),
              ),
              child: Center(
                child: Text(
                  initial,
                  style: getBoldStyle(
                    color: ColorManager.primary,
                    fontSize: FontSize.s14,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Month & Year Picker Dialog (Without Days) ───────────────
class _MonthYearPickerDialog extends StatelessWidget {
  final int initialYear;
  final int initialMonth;

  const _MonthYearPickerDialog({
    required this.initialYear,
    required this.initialMonth,
  });

  static const List<String> _months = <String>[
    'يناير (1)',
    'فبراير (2)',
    'مارس (3)',
    'أبريل (4)',
    'مايو (5)',
    'يونيو (6)',
    'يوليو (7)',
    'أغسطس (8)',
    'سبتمبر (9)',
    'أكتوبر (10)',
    'نوفمبر (11)',
    'ديسمبر (12)',
  ];

  @override
  Widget build(BuildContext context) {
    int selectedYear = initialYear;
    int selectedMonth = initialMonth;

    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setModalState) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.r20.r),
          ),
          backgroundColor: ColorManager.surface,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                // Dialog Title
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'اختيار شهر محدد',
                      style: getBoldStyle(
                        color: ColorManager.textPrimary,
                        fontSize: FontSize.s16,
                      ),
                    ),
                    Icon(
                      Icons.calendar_month_rounded,
                      color: ColorManager.primary,
                      size: 22.r,
                    ),
                  ],
                ),

                SizedBox(height: 14.h),

                // Year Selector Bar (< 2026 >)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: ColorManager.surfaceVariant,
                    borderRadius: BorderRadius.circular(AppRadius.r12.r),
                    border: Border.all(color: ColorManager.border),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(
                          Icons.chevron_left_rounded,
                          color: ColorManager.primary,
                          size: 24.r,
                        ),
                        onPressed: () {
                          setModalState(() {
                            selectedYear--;
                          });
                        },
                        tooltip: 'السنة السابقة',
                      ),
                      Text(
                        '$selectedYear',
                        style: getBoldStyle(
                          color: ColorManager.textPrimary,
                          fontSize: FontSize.s16,
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.chevron_right_rounded,
                          color: ColorManager.primary,
                          size: 24.r,
                        ),
                        onPressed: () {
                          setModalState(() {
                            selectedYear++;
                          });
                        },
                        tooltip: 'السنة التالية',
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 14.h),

                // 3x4 Months Grid
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8.w,
                    mainAxisSpacing: 8.h,
                    childAspectRatio: 2.2,
                  ),
                  itemCount: 12,
                  itemBuilder: (BuildContext context, int index) {
                    final int monthNumber = index + 1;
                    final bool isSelected = monthNumber == selectedMonth;

                    return GestureDetector(
                      onTap: () {
                        setModalState(() {
                          selectedMonth = monthNumber;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? ColorManager.primary
                              : ColorManager.surfaceVariant,
                          borderRadius: BorderRadius.circular(AppRadius.r10.r),
                          border: Border.all(
                            color: isSelected
                                ? ColorManager.primary
                                : ColorManager.border.withAlpha(80),
                            width: isSelected ? 1.5 : 1.0,
                          ),
                          boxShadow: isSelected
                              ? <BoxShadow>[
                                  BoxShadow(
                                    color: ColorManager.primary.withAlpha(60),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ]
                              : null,
                        ),
                        child: Text(
                          _months[index],
                          textAlign: TextAlign.center,
                          style: isSelected
                              ? getBoldStyle(
                                  color: ColorManager.white,
                                  fontSize: FontSize.s11,
                                )
                              : getMediumStyle(
                                  color: ColorManager.textPrimary,
                                  fontSize: FontSize.s11,
                                ),
                        ),
                      ),
                    );
                  },
                ),

                SizedBox(height: 18.h),

                // Action Buttons (Cancel / Confirm)
                Row(
                  children: <Widget>[
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              AppRadius.r12.r,
                            ),
                          ),
                          side: const BorderSide(color: ColorManager.border),
                          padding: EdgeInsets.symmetric(vertical: 10.h),
                        ),
                        child: Text(
                          'إلغاء',
                          style: getSemiBoldStyle(
                            color: ColorManager.textSecondary,
                            fontSize: FontSize.s13,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop<Map<String, int>>(
                            <String, int>{
                              'year': selectedYear,
                              'month': selectedMonth,
                            },
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorManager.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              AppRadius.r12.r,
                            ),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 10.h),
                        ),
                        child: Text(
                          'تأكيد',
                          style: getBoldStyle(
                            color: ColorManager.white,
                            fontSize: FontSize.s13,
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
      },
    );
  }
}
