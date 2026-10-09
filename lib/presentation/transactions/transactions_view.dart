// ─────────────────────────────────────────────────────────────
// TransactionsView — Mizan design system & Figma Node #3:116 compliant
// ─────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mizan/app/di.dart';
import 'package:mizan/domain/model/get_list_transactions_model.dart';
import 'package:mizan/presentation/common/state_randrer/state_randrer_impl.dart';
import 'package:mizan/presentation/home.dart';
import 'package:mizan/presentation/resources/assets_manager.dart';
import 'package:mizan/presentation/resources/color_manager.dart';
import 'package:mizan/presentation/resources/constants_manager.dart';
import 'package:mizan/presentation/resources/font_manager.dart';
import 'package:mizan/presentation/resources/routes_manager.dart';
import 'package:mizan/presentation/resources/strings_manager.dart';
import 'package:mizan/presentation/resources/styles_manager.dart';
import 'package:mizan/presentation/resources/values_manager.dart';
import 'package:mizan/presentation/transactions/get_list_transaction/get_list_transaction_cubit.dart';
import 'package:mizan/presentation/transactions/get_list_transaction/get_list_transaction_state.dart';
import 'package:mizan/presentation/transactions/get_transaction_by_id/transaction_by_id_view.dart';

class TransactionsView extends StatelessWidget {
  const TransactionsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<GetListTransactionCubit>(
      create: (_) => getIt<GetListTransactionCubit>()..getListTransactions(),
      child: const _TransactionsScreen(),
    );
  }
}

class _TransactionsScreen extends StatefulWidget {
  const _TransactionsScreen();

  @override
  State<_TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<_TransactionsScreen> {
  final ScrollController _scrollController = ScrollController();
  late final TextEditingController _searchController;

  static const List<String> _filterTabs = <String>[
    AppStrings.allTransactions,
    AppStrings.quickSale,
    AppStrings.quickPurchase,
    AppStrings.quickCollect,
    AppStrings.quickPay,
  ];

  static const List<String?> _filterTypeValues = <String?>[
    null,
    "Sale",
    "Purchase",
    "Collect",
    "Pay",
  ];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.hasClients) {
      final double maxScroll = _scrollController.position.maxScrollExtent;
      final double currentScroll = _scrollController.position.pixels;
      if (currentScroll >= (maxScroll * 0.8)) {
        context.read<GetListTransactionCubit>().loadMoreTransactions();
      }
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onFilterTabChanged(int index) {
    final String? selectedType = _filterTypeValues[index];
    context.read<GetListTransactionCubit>().selectFilter(index, selectedType);
  }

  void _handleBack() {
    if (_searchController.text.isNotEmpty) {
      _searchController.clear();
      context.read<GetListTransactionCubit>().searchTransactions('');
      return;
    }
    final int currentFilter = context
        .read<GetListTransactionCubit>()
        .state
        .selectedFilterIndex;
    if (currentFilter != 0) {
      _onFilterTabChanged(0);
      return;
    }
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
      return;
    }
    const SwitchHomeTabNotification(0).dispatch(context);
  }

  void _showTransactionTypePicker(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: ColorManager.transparent,
      builder: (BuildContext ctx) => Container(
        padding: EdgeInsets.all(20.r),
        decoration: BoxDecoration(
          color: ColorManager.background,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(AppRadius.r24.r),
            topRight: Radius.circular(AppRadius.r24.r),
          ),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: ColorManager.black.withAlpha(20),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Center(
              child: Container(
                width: 44.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: ColorManager.borderDark,
                  borderRadius: BorderRadius.circular(AppRadius.r10.r),
                ),
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              "تسجيل عملية مالية جديدة",
              style: getBoldStyle(
                color: ColorManager.textPrimary,
                fontSize: FontSize.s16,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4.h),
            Text(
              "اختر نوع العملية التي تريد توثيقها في ميزان",
              style: getRegularStyle(
                color: ColorManager.textSecondary,
                fontSize: FontSize.s12,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.h),
            _TransactionTypeOption(
              icon: IconAssets.shoppingBag,
              title: "عملية بيع جديدة",
              subtitle: "تسجيل فاتورة مبيعات لعميل (كاش أو تقسيط)",
              color: ColorManager.primary,
              bgColor: ColorManager.lightPrimary,
              onTap: () {
                Navigator.pop(ctx);
                Navigator.pushNamed(context, Routes.quickSaleRoute).then((_) {
                  if (context.mounted) {
                    context
                        .read<GetListTransactionCubit>()
                        .getListTransactions();
                  }
                });
              },
            ),
            SizedBox(height: 10.h),
            _TransactionTypeOption(
              icon: IconAssets.arrowUpRight,
              title: "عملية شراء جديدة",
              subtitle: "تسجيل فاتورة مشتريات من مورد (كاش أو تقسيط)",
              color: ColorManager.secondary,
              bgColor: ColorManager.lightSecondary,
              onTap: () {
                Navigator.pop(ctx);
                Navigator.pushNamed(context, Routes.quickPurchaseRoute).then((
                  _,
                ) {
                  if (context.mounted) {
                    context
                        .read<GetListTransactionCubit>()
                        .getListTransactions();
                  }
                });
              },
            ),
            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GetListTransactionCubit, GetListTransactionState>(
      listener: (BuildContext context, GetListTransactionState state) {},
      builder: (BuildContext context, GetListTransactionState state) {
        return Scaffold(
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
                  onPressed: _handleBack,
                ),
              ),
            ),
            title: Column(
              children: <Widget>[
                Text(
                  AppStrings.financialTransactions,
                  style: getBoldStyle(
                    color: ColorManager.textPrimary,
                    fontSize: FontSize.s16,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  AppStrings.transactionsSubtitle,
                  style: getRegularStyle(
                    color: ColorManager.textSecondary,
                    fontSize: FontSize.s11,
                  ),
                ),
              ],
            ),
            actions: <Widget>[
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
                    icon: Icon(
                      Icons.notifications_none_rounded,
                      color: ColorManager.textPrimary,
                      size: 20.r,
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, Routes.notificationsRoute);
                    },
                  ),
                ),
              ),
            ],
          ),
          body: Column(
            children: <Widget>[
              // Pinned Search Bar & Horizontal Filter Tabs (Figma Node #3:116)
              Padding(
                padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 8.h),
                child: Column(
                  children: <Widget>[
                    // Search Bar with real-time filtering without full screen loading
                    _TransactionsSearchBar(
                      controller: _searchController,
                      onChanged: (String query) {
                        context
                            .read<GetListTransactionCubit>()
                            .searchTransactions(query);
                      },
                      onClear: () {
                        context
                            .read<GetListTransactionCubit>()
                            .searchTransactions('');
                      },
                    ),
                    SizedBox(height: 10.h),
                    // Horizontal Filter Tabs Pills
                    _TransactionsFilterTabs(
                      tabs: _filterTabs,
                      selectedIndex: state.selectedFilterIndex,
                      onTabSelected: _onFilterTabChanged,
                    ),
                  ],
                ),
              ),

              // Transactions List with State Handling
              Expanded(
                child:
                    state.flowState?.getScreenWidget(
                      context,
                      _buildBody(context, state),
                      () => context
                          .read<GetListTransactionCubit>()
                          .getListTransactions(),
                    ) ??
                    _buildBody(context, state),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            heroTag: 'transactions_fab',
            backgroundColor: ColorManager.primary,
            elevation: 4,
            shape: const CircleBorder(),
            onPressed: () => _showTransactionTypePicker(context),
            child: const Icon(
              Icons.add_rounded,
              color: ColorManager.white,
              size: 28,
            ),
          ),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, GetListTransactionState state) {
    final List<GetListTransactionsModel> rawList =
        state.data ?? <GetListTransactionsModel>[];
    final String searchQuery = state.searchQuery.trim().toLowerCase();

    // Client-side query filter for instant search without reload
    final List<GetListTransactionsModel> items = searchQuery.isEmpty
        ? rawList
        : rawList.where((GetListTransactionsModel tx) {
            final bool contactMatch = tx.contactName.toLowerCase().contains(
              searchQuery,
            );
            final bool idMatch = tx.id.toLowerCase().contains(searchQuery);
            final bool typeMatch = tx.type.toLowerCase().contains(searchQuery);
            final bool amountMatch = tx.amount.toString().contains(searchQuery);
            final bool paymentMatch = tx.paymentMethod.toLowerCase().contains(
              searchQuery,
            );
            return contactMatch ||
                idMatch ||
                typeMatch ||
                amountMatch ||
                paymentMatch;
          }).toList();

    return RefreshIndicator(
      onRefresh: () =>
          context.read<GetListTransactionCubit>().getListTransactions(),
      color: ColorManager.primary,
      child: CustomScrollView(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        slivers: <Widget>[
          if (items.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(24.r),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
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
                        searchQuery.isNotEmpty
                            ? "لا توجد نتائج مطابقة لبحثك"
                            : AppStrings.noTransactionsTitle,
                        textAlign: TextAlign.center,
                        style: getBoldStyle(
                          color: ColorManager.textPrimary,
                          fontSize: FontSize.s15,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        searchQuery.isNotEmpty
                            ? "تأكد من كتابة الاسم أو رقم المعاملة بشكل صحيح"
                            : AppStrings.noTransactionsSubtitle,
                        textAlign: TextAlign.center,
                        style: getRegularStyle(
                          color: ColorManager.textSecondary,
                          fontSize: FontSize.s12,
                          height: 1.4,
                        ),
                      ),
                      if (searchQuery.isEmpty) ...<Widget>[
                        SizedBox(height: 24.h),
                        ElevatedButton.icon(
                          onPressed: () => _showTransactionTypePicker(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorManager.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                AppRadius.r12.r,
                              ),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: 20.w,
                              vertical: 10.h,
                            ),
                          ),
                          icon: Icon(
                            Icons.add_rounded,
                            color: ColorManager.white,
                            size: 18.r,
                          ),
                          label: Text(
                            AppStrings.recordFirstTransaction,
                            style: getBoldStyle(
                              color: ColorManager.white,
                              fontSize: FontSize.s13,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            )
          else
            _buildGroupedTransactionsList(context, items),

          // Loading more bottom spinner without freezing
          if (state.isLoadingMore)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0),
                child: Center(
                  child: CircularProgressIndicator(color: ColorManager.primary),
                ),
              ),
            ),

          SliverToBoxAdapter(child: SizedBox(height: 80.h)),
        ],
      ),
    );
  }

  Widget _buildGroupedTransactionsList(
    BuildContext context,
    List<GetListTransactionsModel> transactions,
  ) {
    // Group transactions by date string
    final Map<String, List<GetListTransactionsModel>> grouped =
        <String, List<GetListTransactionsModel>>{};
    for (GetListTransactionsModel tx in transactions) {
      final String headerKey = _getDateGroupKey(
        tx.transactionDate.isNotEmpty ? tx.transactionDate : tx.createdAt,
      );
      grouped
          .putIfAbsent(headerKey, () => <GetListTransactionsModel>[])
          .add(tx);
    }

    final List<String> dateKeys = grouped.keys.toList();

    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
          final String dateKey = dateKeys[index];
          final List<GetListTransactionsModel> txList = grouped[dateKey]!;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Date Section Header (e.g. اليوم - الأحد 26 يناير)
              Padding(
                padding: EdgeInsets.only(top: 14.h, bottom: 8.h),
                child: Text(
                  dateKey,
                  style: getBoldStyle(
                    color: ColorManager.textSecondary,
                    fontSize: FontSize.s12,
                  ),
                ),
              ),
              // Transaction Cards for this date
              ...txList.map(
                (GetListTransactionsModel tx) =>
                    _TransactionCardItem(transaction: tx),
              ),
            ],
          );
        }, childCount: dateKeys.length),
      ),
    );
  }

  String _getDateGroupKey(String rawDate) {
    if (rawDate.isEmpty) return "معاملات سابقة";
    try {
      final DateTime dt = DateTime.parse(rawDate).toLocal();
      final DateTime now = DateTime.now();
      final DateTime today = DateTime(now.year, now.month, now.day);
      final DateTime txDay = DateTime(dt.year, dt.month, dt.day);

      const List<String> daysArabic = <String>[
        "الإثنين",
        "الثلاثاء",
        "الأربعاء",
        "الخميس",
        "الجمعة",
        "السبت",
        "الأحد",
      ];
      const List<String> monthsArabic = <String>[
        "يناير",
        "فبراير",
        "مارس",
        "أبريل",
        "مايو",
        "يونيو",
        "يوليو",
        "أغسطس",
        "سبتمبر",
        "أكتوبر",
        "نوفمبر",
        "ديسمبر",
      ];

      final String dayName = daysArabic[dt.weekday - 1];
      final String monthName = monthsArabic[dt.month - 1];

      if (txDay == today) {
        return "اليوم - $dayName ${dt.day} $monthName";
      } else if (txDay == today.subtract(const Duration(days: 1))) {
        return "أمس - $dayName ${dt.day} $monthName";
      } else {
        return "$dayName ${dt.day} $monthName ${dt.year}";
      }
    } catch (_) {
      return rawDate;
    }
  }
}

// ─────────────────────────────────────────────────────────────
// Transaction Card Item (Figma Node #3:116 Component)
// ─────────────────────────────────────────────────────────────
class _TransactionCardItem extends StatelessWidget {
  final GetListTransactionsModel transaction;

  const _TransactionCardItem({required this.transaction});

  bool get _isIncome {
    final String t = transaction.type.toLowerCase();
    return t == 'sale' ||
        t == 'بيع' ||
        t == 'collect' ||
        t == 'تحصيل' ||
        t == 'income';
  }

  String _formatTime(String rawDate) {
    if (rawDate.isEmpty) return "";
    try {
      final DateTime dt = DateTime.parse(rawDate).toLocal();
      final int hour = dt.hour > 12
          ? dt.hour - 12
          : dt.hour == 0
          ? 12
          : dt.hour;
      final String minute = dt.minute.toString().padLeft(2, '0');
      final String period = dt.hour >= 12 ? "م" : "ص";
      return "$hour:$minute $period";
    } catch (_) {
      return "";
    }
  }

  String _getTitle() {
    final String t = transaction.type.toLowerCase();
    final bool isCash =
        transaction.paymentMethod.toLowerCase() == 'cash' ||
        transaction.paymentMethod == 'كاش';

    if (t == 'sale' || t == 'بيع') {
      return isCash ? "فاتورة مبيعات نقدية" : "فاتورة مبيعات آجل";
    } else if (t == 'purchase' || t == 'شراء') {
      return isCash ? "شراء بضاعة (نقدي)" : "شراء بضاعة (آجل)";
    } else if (t == 'collect' || t == 'تحصيل') {
      return "تحصيل دفعة مالية";
    } else if (t == 'pay' || t == 'دفع') {
      return "سداد دفعة للمورد";
    }
    return transaction.type;
  }

  @override
  Widget build(BuildContext context) {
    final bool isIncome = _isIncome;
    final String amountPrefix = isIncome ? "+" : "-";
    final Color amountColor = isIncome
        ? ColorManager.success
        : ColorManager.error;
    final String timeStr = _formatTime(
      transaction.transactionDate.isNotEmpty
          ? transaction.transactionDate
          : transaction.createdAt,
    );

    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      decoration: BoxDecoration(
        color: ColorManager.surface,
        borderRadius: BorderRadius.circular(AppRadius.r14.r),
        border: Border.all(color: ColorManager.border, width: 1.0),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: ColorManager.shadowWarm,
            offset: Offset(0, 2),
            blurRadius: 6,
          ),
        ],
      ),
      child: Material(
        color: ColorManager.transparent,
        child: InkWell(
          onTap: () async {
            final Object? result = await Navigator.push(
              context,
              MaterialPageRoute<Object>(
                builder: (BuildContext context) => TransactionDetailsView(
                  transactionId: transaction.id,
                  id: transaction.id,
                ),
              ),
            );
            if (result == true && context.mounted) {
              context.read<GetListTransactionCubit>().getListTransactions();
            }
          },
          borderRadius: BorderRadius.circular(AppRadius.r14.r),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
            child: Row(
              children: <Widget>[
                // Type Icon Badge (Figma Node #3:116)
                Container(
                  width: 40.r,
                  height: 40.r,
                  decoration: BoxDecoration(
                    color: isIncome
                        ? ColorManager.successContainer
                        : ColorManager.errorContainer,
                    borderRadius: BorderRadius.circular(AppRadius.r10.r),
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      isIncome
                          ? IconAssets.arrowDownLeft
                          : IconAssets.arrowUpRight,
                      width: 18.r,
                      height: 18.r,
                      colorFilter: ColorFilter.mode(
                        isIncome ? ColorManager.success : ColorManager.error,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),

                // Title + Second Party Name
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        _getTitle(),
                        style: getBoldStyle(
                          color: ColorManager.textPrimary,
                          fontSize: FontSize.s13,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 3.h),
                      Row(
                        children: <Widget>[
                          Flexible(
                            child: Text(
                              transaction.contactName.isNotEmpty
                                  ? transaction.contactName
                                  : "عميل نقدي",
                              style: getRegularStyle(
                                color: ColorManager.textSecondary,
                                fontSize: FontSize.s11,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (transaction.isInstallment) ...<Widget>[
                            SizedBox(width: 6.w),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 6.w,
                                vertical: 1.h,
                              ),
                              decoration: BoxDecoration(
                                color: ColorManager.lightSecondary,
                                borderRadius: BorderRadius.circular(
                                  AppRadius.r4.r,
                                ),
                              ),
                              child: Text(
                                "قسط",
                                style: getMediumStyle(
                                  color: ColorManager.secondary,
                                  fontSize: FontSize.s9,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),

                // Amount + Timestamp
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      "$amountPrefix${transaction.amount} ${AppConstants.defaultCurrency}",
                      textDirection: TextDirection.ltr,
                      style: getBoldStyle(
                        color: amountColor,
                        fontSize: FontSize.s13,
                      ),
                    ),
                    if (timeStr.isNotEmpty) ...<Widget>[
                      SizedBox(height: 3.h),
                      Text(
                        timeStr,
                        style: getRegularStyle(
                          color: ColorManager.textTertiary,
                          fontSize: FontSize.s10,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Search Bar with Real-time Filtering (Figma Node #3:116)
// ─────────────────────────────────────────────────────────────
class _TransactionsSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  const _TransactionsSearchBar({
    required this.controller,
    required this.onChanged,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48.h,
      decoration: BoxDecoration(
        color: ColorManager.surface,
        borderRadius: BorderRadius.circular(AppRadius.r14.r),
        border: Border.all(color: ColorManager.border, width: 1.2),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: ColorManager.shadowWarm,
            offset: Offset(0, 2),
            blurRadius: 6,
          ),
        ],
      ),
      child: ValueListenableBuilder<TextEditingValue>(
        valueListenable: controller,
        builder: (BuildContext context, TextEditingValue value, _) {
          return TextField(
            controller: controller,
            onChanged: onChanged,
            style: getMediumStyle(
              color: ColorManager.textPrimary,
              fontSize: FontSize.s13,
            ),
            textAlignVertical: TextAlignVertical.center,
            decoration: InputDecoration(
              isDense: true,
              filled: true,
              fillColor: ColorManager.surface,
              hintText: AppStrings.searchTransactionsHint,
              hintStyle: getRegularStyle(
                color: ColorManager.textTertiary,
                fontSize: FontSize.s12,
              ),
              prefixIcon: Icon(
                Icons.search_rounded,
                color: ColorManager.textTertiary,
                size: 20.r,
              ),
              suffixIcon: value.text.isNotEmpty
                  ? IconButton(
                      icon: Icon(
                        Icons.close_rounded,
                        color: ColorManager.textSecondary,
                        size: 18.r,
                      ),
                      onPressed: () {
                        controller.clear();
                        onClear();
                      },
                    )
                  : null,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 14.w,
                vertical: 12.h,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.r14.r),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.r14.r),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.r14.r),
                borderSide: const BorderSide(
                  color: ColorManager.primary,
                  width: 1.2,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Horizontal Filter Pills Bar (Figma Node #3:116)
// ─────────────────────────────────────────────────────────────
class _TransactionsFilterTabs extends StatelessWidget {
  final List<String> tabs;
  final int selectedIndex;
  final ValueChanged<int> onTabSelected;

  const _TransactionsFilterTabs({
    required this.tabs,
    required this.selectedIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: tabs.length,
        separatorBuilder: (_, _) => SizedBox(width: 8.w),
        itemBuilder: (BuildContext context, int index) {
          final bool isSelected = selectedIndex == index;
          return Material(
            color: ColorManager.transparent,
            child: InkWell(
              onTap: () => onTabSelected(index),
              borderRadius: BorderRadius.circular(AppRadius.r20.r),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 7.h),
                decoration: BoxDecoration(
                  color: isSelected
                      ? ColorManager.primary
                      : ColorManager.surface,
                  borderRadius: BorderRadius.circular(AppRadius.r20.r),
                  border: Border.all(
                    color: isSelected
                        ? ColorManager.primary
                        : ColorManager.border,
                    width: 1.0,
                  ),
                  boxShadow: isSelected
                      ? <BoxShadow>[
                          BoxShadow(
                            color: ColorManager.primary.withAlpha(40),
                            offset: const Offset(0, 2),
                            blurRadius: 5,
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: Text(
                    tabs[index],
                    style: getMediumStyle(
                      color: isSelected
                          ? ColorManager.white
                          : ColorManager.textSecondary,
                      fontSize: FontSize.s12,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// New Transaction Type Option for Bottom Sheet
// ─────────────────────────────────────────────────────────────
class _TransactionTypeOption extends StatelessWidget {
  final String icon;
  final String title;
  final String subtitle;
  final Color color;
  final Color bgColor;
  final VoidCallback onTap;

  const _TransactionTypeOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.bgColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ColorManager.surface,
        borderRadius: BorderRadius.circular(AppRadius.r14.r),
        border: Border.all(color: ColorManager.border),
      ),
      child: Material(
        color: ColorManager.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.r14.r),
          child: Padding(
            padding: EdgeInsets.all(14.r),
            child: Row(
              children: <Widget>[
                Container(
                  width: 44.r,
                  height: 44.r,
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(AppRadius.r12.r),
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      icon,
                      width: 22.r,
                      height: 22.r,
                      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
                    ),
                  ),
                ),
                SizedBox(width: 14.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        title,
                        style: getBoldStyle(
                          color: ColorManager.textPrimary,
                          fontSize: FontSize.s13,
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
                ),
                Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 14.r,
                  color: ColorManager.textTertiary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
