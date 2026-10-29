import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mizan/app/di.dart';
import 'package:mizan/domain/model/get_profile_model/get_profile_model.dart';
import 'package:mizan/domain/model/statistics_model/statistics_model.dart';
import 'package:mizan/presentation/analytics/analytics_view.dart';
import 'package:mizan/presentation/common/state_randrer/state_randrer_impl.dart';
import 'package:mizan/presentation/customers/customers_view.dart';
import 'package:mizan/presentation/get_profile/cubit/get_profile_cubit.dart';
import 'package:mizan/presentation/get_profile/cubit/get_profile_state.dart';
import 'package:mizan/presentation/home/home_tab_cubit.dart';
import 'package:mizan/presentation/home/widgets/custom_bottom_nav_bar.dart';
import 'package:mizan/presentation/home/widgets/hero_balance_card.dart';
import 'package:mizan/presentation/home/widgets/home_header.dart';

import 'package:mizan/presentation/home/widgets/quick_actions_bar.dart';
import 'package:mizan/presentation/home/widgets/recent_transactions_section.dart';
import 'package:mizan/presentation/installments/installments_view.dart';
import 'package:mizan/presentation/notifications/notifications_cubit/notifications_cubit.dart';
import 'package:mizan/presentation/resources/assets_manager.dart';
import 'package:mizan/presentation/resources/color_manager.dart';
import 'package:mizan/presentation/resources/font_manager.dart';
import 'package:mizan/presentation/resources/routes_manager.dart';
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

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with WidgetsBindingObserver {
  late final NotificationsCubit _notificationsCubit;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _notificationsCubit = getIt<NotificationsCubit>();
    // جلب العدد فور بناء الصفحة
    _notificationsCubit.fetchUnreadCount();
    // لو الـ splash ما جابش البروفايل (فشل/timeout) نجيبه هنا تلقائياً.
    final GetProfileCubit profile = getIt<GetProfileCubit>();
    if (profile.state.data == null) profile.getProfile();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // عند العودة للتطبيق من الخلفية → أعد مزامنة العدد فوراً
    if (state == AppLifecycleState.resumed) {
      _notificationsCubit.fetchUnreadCount();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _notificationsCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final DateTime now = DateTime.now();
    return MultiBlocProvider(
      providers: <BlocProvider<StateStreamableSource<Object?>>>[
        // GetProfileCubit lazySingleton: .value عشان الـ widget ما يقفلوش.
        BlocProvider<GetProfileCubit>.value(value: getIt<GetProfileCubit>()),
        BlocProvider<StatisticsCubit>(
          create: (_) => getIt<StatisticsCubit>()
            ..getMonthlyStatistics(now.year.toString(), now.month.toString()),
        ),
        BlocProvider<GetListTransactionCubit>(
          create: (_) =>
              getIt<GetListTransactionCubit>()..getListTransactions(),
        ),
        BlocProvider<HomeTabCubit>(create: (_) => HomeTabCubit()),
        BlocProvider<NotificationsCubit>.value(
          value: _notificationsCubit,
        ),
      ],
      child: const _HomeScreen(),
    );
  }
}


class _HomeScreen extends StatelessWidget {
  const _HomeScreen();

  void _openVoiceRecordDialog(BuildContext context) {
    Navigator.of(context).pushNamed(Routes.createVoiceNoteRoute);
  }

  @override
  Widget build(BuildContext context) {
    final HomeTabCubit tabs = context.read<HomeTabCubit>();
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        if (didPop) return;
        if (tabs.state.index != 0) tabs.selectTab(0);
      },
      child: NotificationListener<SwitchHomeTabNotification>(
        onNotification: (SwitchHomeTabNotification notification) {
          tabs.selectTab(notification.targetIndex);
          return true;
        },
        child: BlocBuilder<HomeTabCubit, HomeTabState>(
          builder: (BuildContext context, HomeTabState tab) {
            return Scaffold(
              backgroundColor: ColorManager.background,
              drawer: const MizanDrawer(),
              body: IndexedStack(
                index: tab.index,
                children: <Widget>[
                  _buildHomeDashboardTab(context),
                  tab.isBuilt(1)
                      ? const TransactionsView()
                      : const SizedBox.shrink(),
                  tab.isBuilt(2)
                      ? const CustomersView()
                      : const SizedBox.shrink(),
                  tab.isBuilt(3)
                      ? const InstallmentsView()
                      : const SizedBox.shrink(),
                  tab.isBuilt(4)
                      ? const AnalyticsView()
                      : const SizedBox.shrink(),
                ],
              ),
              floatingActionButton: tab.index == 0
                  ? _buildSmartVoiceFAB(context)
                  : null,
              floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
              bottomNavigationBar: CustomBottomNavBar(
                currentIndex: tab.index,
                onTap: tabs.selectTab,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHomeDashboardTab(BuildContext context) {
    return SafeArea(
      child: RefreshIndicator(
        color: ColorManager.primary,
        backgroundColor: ColorManager.surface,
        onRefresh: () async {
          final DateTime now = DateTime.now();
          await Future.wait(<Future<void>>[
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
            children: <Widget>[
              // 1. Top Header Bar (Real Profile & Shop data)
              BlocBuilder<GetProfileCubit, GetProfileState>(
                builder: (BuildContext context, GetProfileState profileState) {
                  final GetProfileModel? profile = profileState.data;
                  final String userName =
                      (profile != null && profile.firstName.isNotEmpty)
                      ? "${profile.firstName} ${profile.lastName}".trim()
                      : "مرحباً بك";
                  final String shopName =
                      profile?.shop?.shopName?.isNotEmpty == true
                      ? profile!.shop!.shopName!
                      : "محل ميزان التجاري";
                  return HomeHeader(userName: userName, shopName: shopName);
                },
              ),

              SizedBox(height: 14.h),

              // 2 & 3 & 4. Hero Card + Quick Actions + Monthly Summary Card (Real Statistics Data)
              BlocBuilder<StatisticsCubit, StatisticsState>(
                builder: (BuildContext context, StatisticsState statsState) {
                  final StatisticsPageModel? stats = statsState.data;
                  final double totalSales = (stats?.totalSales ?? 0).toDouble();
                  final double totalPurchases = (stats?.totalPurchases ?? 0)
                      .toDouble();
                  final double totalBalance = totalSales - totalPurchases;

                  return Column(
                    children: <Widget>[
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

                      // SizedBox(height: 14.h),

                      // Monthly Performance & Ring Summary Card
                      // MonthlySummaryCard(
                      //   collectedAmount: totalSales,
                      //   targetAmount: targetAmount,
                      //   percentage: percentage,
                      // ),
                    ],
                  );
                },
              ),

              SizedBox(height: 14.h),

              // 5. Recent Activity & Transactions Section (Real Data from API)
              BlocBuilder<GetListTransactionCubit, GetListTransactionState>(
                builder:
                    (BuildContext context, GetListTransactionState txState) {
                      return RecentTransactionsSection(
                        transactions: txState.data,
                        isLoading: txState.flowState is LoadingState,
                      );
                    },
              ),

              SizedBox(height: 64.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSmartVoiceFAB(BuildContext context) {
    return Container(
      height: 44.h,
      decoration: BoxDecoration(
        gradient: ColorManager.primaryGradient,
        borderRadius: BorderRadius.circular(AppRadius.r28.r),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x38C57B57),
            blurRadius: 14.0,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: ColorManager.transparent,
        child: InkWell(
          onTap: () => _openVoiceRecordDialog(context),
          borderRadius: BorderRadius.circular(AppRadius.r28.r),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
            child: Row(
              mainAxisSize: MainAxisSize.min,
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
