import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mizan/app/di.dart';
import 'package:mizan/presentation/analytics/analytics_view.dart';
import 'package:mizan/presentation/common/state_randrer/state_randrer_impl.dart';
import 'package:mizan/presentation/customers/customers_view.dart';
import 'package:mizan/presentation/get_profile/cubit/get_profile_cubit.dart';
import 'package:mizan/presentation/get_profile/cubit/get_profile_state.dart';
import 'package:mizan/presentation/home/widgets/custom_bottom_nav_bar.dart';
import 'package:mizan/presentation/home/widgets/hero_balance_card.dart';
import 'package:mizan/presentation/home/widgets/home_header.dart';
import 'package:mizan/presentation/home/widgets/monthly_summary_card.dart';
import 'package:mizan/presentation/home/widgets/quick_actions_bar.dart';
import 'package:mizan/presentation/home/widgets/recent_transactions_section.dart';
import 'package:mizan/presentation/installments/installments_view.dart';
import 'package:mizan/presentation/resources/assets_manager.dart';
import 'package:mizan/presentation/resources/color_manager.dart';
import 'package:mizan/presentation/resources/font_manager.dart';
import 'package:mizan/presentation/resources/strings_manager.dart';
import 'package:mizan/presentation/resources/styles_manager.dart';
import 'package:mizan/presentation/resources/values_manager.dart';
import 'package:mizan/presentation/statistics/cubit/statistics_cubit.dart';
import 'package:mizan/presentation/statistics/cubit/statistics_state.dart';
import 'package:mizan/presentation/transactions/get_list_transaction/get_list_transaction_cubit.dart';
import 'package:mizan/presentation/transactions/get_list_transaction/get_list_transaction_state.dart';
import 'package:mizan/presentation/transactions/transactions_view.dart';
import 'package:mizan/presentation/home/widgets/mizan_drawer.dart';

// ─────────────────────────────────────────────────────────────────────────────
// HomeView — Mizan Financial Dashboard (Figma Node 3:10)
// High-performance modular architecture with smooth tab micro-interactions
// ─────────────────────────────────────────────────────────────────────────────
class SwitchHomeTabNotification extends Notification {
  final int targetIndex;
  const SwitchHomeTabNotification(this.targetIndex);
}

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    return MultiBlocProvider(
      providers: [
        BlocProvider<GetProfileCubit>(
          create: (_) => getIt<GetProfileCubit>()..getProfile(),
        ),
        BlocProvider<StatisticsCubit>(
          create: (_) => getIt<StatisticsCubit>()
            ..getMonthlyStatistics(
              now.year.toString(),
              now.month.toString(),
            ),
        ),
        BlocProvider<GetListTransactionCubit>(
          create: (_) => getIt<GetListTransactionCubit>()..getListTransactions(),
        ),
      ],
      child: const _HomeScreen(),
    );
  }
}

class _HomeScreen extends StatefulWidget {
  const _HomeScreen();

  @override
  State<_HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<_HomeScreen> {
  int _currentTabIndex = 0;

  void _onTabSelected(int index) {
    setState(() {
      _currentTabIndex = index;
    });
  }

  void _openVoiceRecordDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => const _VoiceRecordSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (_currentTabIndex != 0) {
          setState(() {
            _currentTabIndex = 0;
          });
        }
      },
      child: NotificationListener<SwitchHomeTabNotification>(
        onNotification: (notification) {
          setState(() {
            _currentTabIndex = notification.targetIndex;
          });
          return true;
        },
        child: Scaffold(
          backgroundColor: ColorManager.background,
          drawer: const MizanDrawer(),
          body: IndexedStack(
            index: _currentTabIndex,
            children: [
              _buildHomeDashboardTab(),
              const TransactionsView(),
              const CustomersView(),
              const InstallmentsView(),
              const AnalyticsView(),
            ],
          ),
          floatingActionButton: _currentTabIndex == 0
              ? _buildSmartVoiceFAB()
              : null,
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          bottomNavigationBar: CustomBottomNavBar(
            currentIndex: _currentTabIndex,
            onTap: _onTabSelected,
          ),
        ),
      ),
    );
  }

  Widget _buildHomeDashboardTab() {
    return SafeArea(
      child: RefreshIndicator(
        color: ColorManager.primary,
        backgroundColor: ColorManager.surface,
        onRefresh: () async {
          final now = DateTime.now();
          await Future.wait([
            context.read<GetProfileCubit>().getProfile(),
            context.read<StatisticsCubit>().getMonthlyStatistics(
              now.year.toString(),
              now.month.toString(),
            ),
            context.read<GetListTransactionCubit>().getListTransactions(),
          ]);
        },

        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Top Header Bar (Real Profile & Shop data)
              BlocBuilder<GetProfileCubit, GetProfileState>(
                builder: (context, profileState) {
                  final profile = profileState.data;
                  final userName = (profile != null && profile.firstName.isNotEmpty)
                      ? "${profile.firstName} ${profile.lastName}".trim()
                      : "مرحباً بك";
                  final shopName = profile?.shop?.shopName?.isNotEmpty == true
                      ? profile!.shop!.shopName!
                      : "محل ميزان التجاري";
                  return HomeHeader(
                    userName: userName,
                    shopName: shopName,
                  );
                },
              ),

              SizedBox(height: 14.h),

              // 2 & 3 & 4. Hero Card + Quick Actions + Monthly Summary Card (Real Statistics Data)
              BlocBuilder<StatisticsCubit, StatisticsState>(
                builder: (context, statsState) {
                  final stats = statsState.data;
                  final totalSales = (stats?.totalSales ?? 0).toDouble();
                  final totalPurchases = (stats?.totalPurchases ?? 0).toDouble();
                  final totalBalance = totalSales - totalPurchases;
                  final totalTurnover = totalSales + totalPurchases;
                  final targetAmount = totalTurnover > 0 ? totalTurnover : 50000.0;
                  final percentage = targetAmount > 0
                      ? (totalSales / targetAmount)
                      : 0.0;

                  return Column(
                    children: [
                      // Hero Financial Balance Card (Compact & Fitted)
                      HeroBalanceCard(
                        totalBalance: totalBalance,
                        totalDebts: totalSales,
                        totalPayables: totalPurchases,
                        currency: "ج.م",
                      ),

                      SizedBox(height: 14.h),

                      // Quick Financial Actions (بيع، شراء، تحصيل، دفع)
                      const QuickActionsBar(),

                      SizedBox(height: 14.h),

                      // Monthly Performance & Ring Summary Card
                      MonthlySummaryCard(
                        collectedAmount: totalSales,
                        targetAmount: targetAmount,
                        percentage: percentage,
                      ),
                    ],
                  );
                },
              ),

              SizedBox(height: 14.h),

              // 5. Recent Activity & Transactions Section (Real Data from API)
              BlocBuilder<GetListTransactionCubit, GetListTransactionState>(
                builder: (context, txState) {
                  return RecentTransactionsSection(
                    transactions: txState.data,
                    isLoading: txState.flowState is LoadingState,
                  );
                },
              ),

              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildSmartVoiceFAB() {
    return Container(
      height: 44.h,
      decoration: BoxDecoration(
        gradient: ColorManager.primaryGradient,
        borderRadius: BorderRadius.circular(AppRadius.r28.r),
        boxShadow: const [
          BoxShadow(
            color: Color(0x38C57B57),
            blurRadius: 14.0,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _openVoiceRecordDialog,
          borderRadius: BorderRadius.circular(AppRadius.r28.r),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
            child: Row(
              mainAxisSize: MainAxisSize.min,
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
                SizedBox(width: 6.w),
                Text(
                  AppStrings.voiceRecording,
                  style: getBoldStyle(
                    color: ColorManager.white,
                    fontSize: FontSize.s12,
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

// ─────────────────────────────────────────────────────────────────────────────
// Voice Record Sheet (Responsive & Zero Overflow)
// ─────────────────────────────────────────────────────────────────────────────
class _VoiceRecordSheet extends StatelessWidget {
  const _VoiceRecordSheet();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      decoration: BoxDecoration(
        color: ColorManager.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppRadius.r24.r),
          topRight: Radius.circular(AppRadius.r24.r),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1F000000),
            blurRadius: 20,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: ColorManager.borderDark,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            SizedBox(height: 20.h),
            Container(
              width: 68.r,
              height: 68.r,
              decoration: BoxDecoration(
                color: ColorManager.lightPrimary,
                shape: BoxShape.circle,
                border: Border.all(
                  color: ColorManager.primary.withAlpha(45),
                  width: 2,
                ),
              ),
              child: Center(
                child: SvgPicture.asset(
                  IconAssets.mic,
                  width: 32.r,
                  height: 32.r,
                  colorFilter: const ColorFilter.mode(
                    ColorManager.primary,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              AppStrings.voiceRecording,
              style: getBoldStyle(
                color: ColorManager.textPrimary,
                fontSize: FontSize.s17,
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              "تحدث وسيقوم ميزان الذكي بتحليل وتسجيل المعاملة تلقائياً",
              textAlign: TextAlign.center,
              style: getRegularStyle(
                color: ColorManager.textSecondary,
                fontSize: FontSize.s12,
                height: 1.4,
              ),
            ),
            SizedBox(height: 20.h),
            // Prompt Box with Expanded Text to avoid overflow
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: ColorManager.surfaceVariant,
                borderRadius: BorderRadius.circular(AppRadius.r12.r),
                border: Border.all(color: ColorManager.border),
              ),
              child: Row(
                children: [
                  SvgPicture.asset(
                    IconAssets.waveform,
                    width: 20.r,
                    height: 20.r,
                    colorFilter: const ColorFilter.mode(
                      ColorManager.primary,
                      BlendMode.srcIn,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      "اضغط وتحدث: \"بيع بضاعة لأحمد بمبلغ 500 جنيه\"",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: getMediumStyle(
                        color: ColorManager.textSecondary,
                        fontSize: FontSize.s11,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 14.h),
          ],
        ),
      ),
    );
  }
}
