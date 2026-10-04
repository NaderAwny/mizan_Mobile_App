import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mizan/app/di.dart';
import 'package:mizan/data/request/transaction_request.dart';
import 'package:mizan/presentation/common/state_randrer/state_randrer_impl.dart';
import 'package:mizan/presentation/operations/quick_transaction_args.dart';
import 'package:mizan/presentation/operations/widgets/contact_picker_bottom_sheet.dart';
import 'package:mizan/presentation/resources/assets_manager.dart';
import 'package:mizan/presentation/resources/color_manager.dart';
import 'package:mizan/presentation/resources/constants_manager.dart';
import 'package:mizan/presentation/resources/font_manager.dart';
import 'package:mizan/presentation/resources/strings_manager.dart';
import 'package:mizan/presentation/resources/styles_manager.dart';
import 'package:mizan/presentation/resources/values_manager.dart';
import 'package:mizan/presentation/transactions/transaction_form_cubit/transaction_form_cubit.dart';
import 'package:mizan/presentation/transactions/transaction_form_cubit/transaction_form_state.dart';

class QuickPurchaseView extends StatelessWidget {
  final QuickTransactionArgs? args;

  const QuickPurchaseView({super.key, this.args});

  @override
  Widget build(BuildContext context) {
    final QuickTransactionArgs? effectiveArgs =
        args ??
        (ModalRoute.of(context)?.settings.arguments is QuickTransactionArgs
            ? ModalRoute.of(context)!.settings.arguments as QuickTransactionArgs
            : null);

    return BlocProvider<TransactionFormCubit>(
      create: (_) => getIt<TransactionFormCubit>(),
      child: _QuickPurchaseScreen(args: effectiveArgs),
    );
  }
}

class _QuickPurchaseScreen extends StatefulWidget {
  final QuickTransactionArgs? args;

  const _QuickPurchaseScreen({this.args});

  @override
  State<_QuickPurchaseScreen> createState() => _QuickPurchaseScreenState();
}

class _PurchaseInstallmentEntry {
  final TextEditingController amountController;
  DateTime dueDate;

  _PurchaseInstallmentEntry({required double amount, required this.dueDate})
    : amountController = TextEditingController(
        text: amount > 0 ? amount.toStringAsFixed(0) : '',
      );

  void dispose() {
    amountController.dispose();
  }
}

class _QuickPurchaseScreenState extends State<_QuickPurchaseScreen> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Contact selection
  String? _selectedContactId;
  String? _selectedPartyName;
  bool _isPartyVip = false;

  // Transaction Date
  DateTime _transactionDate = DateTime.now();

  // Payment Method: Cash vs Credit (آجل)
  bool _isCash = true;

  // Installment Mode
  bool _isInstallment = false;
  String _installmentPlanMode = "Automatic"; // "Automatic" | "Custom"
  int _installmentCount = 3;
  String _frequency = "Monthly"; // "Weekly" | "Monthly" | "Yearly"
  DateTime _firstInstallmentDate = DateTime.now().add(const Duration(days: 30));

  // Custom Installments list
  final List<_PurchaseInstallmentEntry> _customInstallmentEntries =
      <_PurchaseInstallmentEntry>[];

  final List<num> _quickAmountChips = <num>[100, 250, 500, 1000, 2500];

  @override
  void initState() {
    super.initState();
    if (widget.args != null) {
      _selectedContactId = widget.args!.contactId;
      _selectedPartyName = widget.args!.contactName;
      _isPartyVip = widget.args!.isVip;
    }
    _initCustomInstallments();
  }

  void _initCustomInstallments() {
    _customInstallmentEntries.clear();
    final double total = double.tryParse(_amountController.text) ?? 0.0;
    final double half = total > 0 ? total / 2 : 0.0;
    _customInstallmentEntries.add(
      _PurchaseInstallmentEntry(
        amount: half,
        dueDate: DateTime.now().add(const Duration(days: 30)),
      ),
    );
    _customInstallmentEntries.add(
      _PurchaseInstallmentEntry(
        amount: half,
        dueDate: DateTime.now().add(const Duration(days: 60)),
      ),
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    for (_PurchaseInstallmentEntry entry in _customInstallmentEntries) {
      entry.dispose();
    }
    super.dispose();
  }

  void _setAmount(num amount) {
    setState(() {
      _amountController.text = amount.toString();
    });
    if (_isInstallment && _installmentPlanMode == "Custom") {
      _recalculateCustomInstallments(amount.toDouble());
    }
  }

  void _recalculateCustomInstallments(double totalAmount) {
    if (_customInstallmentEntries.isEmpty) return;
    final int count = _customInstallmentEntries.length;
    final double split = (totalAmount / count).roundToDouble();
    for (int i = 0; i < count; i++) {
      _customInstallmentEntries[i].amountController.text = split
          .toStringAsFixed(0);
    }
  }

  double get _totalCustomSum {
    double sum = 0.0;
    for (_PurchaseInstallmentEntry e in _customInstallmentEntries) {
      sum += double.tryParse(e.amountController.text) ?? 0.0;
    }
    return sum;
  }

  Future<void> _pickTransactionDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _transactionDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: ColorManager.secondary,
              onPrimary: ColorManager.white,
              onSurface: ColorManager.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _transactionDate = picked);
    }
  }

  Future<void> _pickFirstInstallmentDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _firstInstallmentDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2035),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: ColorManager.secondary,
              onPrimary: ColorManager.white,
              onSurface: ColorManager.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _firstInstallmentDate = picked);
    }
  }

  Future<void> _pickContact() async {
    final ContactPickerResult? result = await ContactPickerBottomSheet.show(
      context,
      selectedContactId: _selectedContactId,
      selectedName: _selectedPartyName,
    );
    if (result != null) {
      setState(() {
        _selectedContactId = result.contactId;
        _selectedPartyName = result.name;
        _isPartyVip = result.isVip;
      });
    }
  }

  void _submit() {
    FocusScope.of(context).unfocus();

    final num amount = num.tryParse(_amountController.text.trim()) ?? 0;

    List<CustomInstallmentItem>? customItems;
    if (_isInstallment && _installmentPlanMode == "Custom") {
      customItems = _customInstallmentEntries.map((
        _PurchaseInstallmentEntry e,
      ) {
        final num amt = num.tryParse(e.amountController.text.trim()) ?? 0;
        return CustomInstallmentItem(
          amount: amt,
          dueDate: e.dueDate.toIso8601String(),
        );
      }).toList();
    }

    final CreateTransactionRequest request = CreateTransactionRequest(
      contactId: _selectedContactId,
      partyName: _selectedPartyName,
      type: "Purchase",
      amount: amount,
      paymentMethod: _isInstallment
          ? "Deferred"
          : (_isCash ? "Cash" : "Credit"),
      transactionDate: _transactionDate.toIso8601String(),
      noteText: _noteController.text.trim().isEmpty
          ? null
          : _noteController.text.trim(),
      isInstallment: _isInstallment,
      installmentPlanMode: _isInstallment ? _installmentPlanMode : null,
      installmentCount: _isInstallment && _installmentPlanMode == "Automatic"
          ? _installmentCount
          : null,
      frequency: _isInstallment && _installmentPlanMode == "Automatic"
          ? _frequency
          : null,
      firstInstallmentDate:
          _isInstallment && _installmentPlanMode == "Automatic"
          ? _firstInstallmentDate.toIso8601String()
          : null,
      customInstallments: customItems,
    );

    context.read<TransactionFormCubit>().submit(request);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TransactionFormCubit, TransactionFormState>(
      listenWhen: (TransactionFormState prev, TransactionFormState curr) =>
          curr.isActionSuccess && !prev.isActionSuccess,
      listener: (BuildContext context, TransactionFormState state) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.of(
            context,
            rootNavigator: true,
          ).popUntil((Route<dynamic> route) => route is! PopupRoute);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: ColorManager.success,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.r12.r),
              ),
              content: Row(
                children: <Widget>[
                  Icon(
                    Icons.check_circle_rounded,
                    color: ColorManager.white,
                    size: 20.r,
                  ),
                  SizedBox(width: 8.w),
                  const Text("تم تسجيل عملية الشراء بنجاح"),
                ],
              ),
            ),
          );

          Navigator.of(context).pop(true);
        });
      },
      builder: (BuildContext context, TransactionFormState state) {
        final Widget content = _buildContent(context, state);

        final FlowState? flowState = state.flowState;
        if (flowState is LoadingState || flowState is ErrorState) {
          final Widget? overlay = flowState!.getScreenWidget(
            context,
            content,
            _submit,
          );
          if (overlay != null) return _scaffold(overlay);
        }

        return _scaffold(content);
      },
    );
  }

  Widget _scaffold(Widget body) {
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
              border: Border.all(color: ColorManager.border),
            ),
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: Icon(
                Icons.arrow_forward_ios_rounded,
                color: ColorManager.textPrimary,
                size: 16.r,
              ),
              onPressed: () => Navigator.maybePop(context),
            ),
          ),
        ),
        title: Text(
          "تسجيل عملية شراء",
          style: getBoldStyle(
            color: ColorManager.textPrimary,
            fontSize: FontSize.s16,
          ),
        ),
        actions: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
            padding: EdgeInsets.all(6.r),
            decoration: BoxDecoration(
              color: ColorManager.lightSecondary,
              borderRadius: BorderRadius.circular(AppRadius.r8.r),
            ),
            child: SvgPicture.asset(
              IconAssets.arrowUpRight,
              width: 18.r,
              height: 18.r,
              colorFilter: const ColorFilter.mode(
                ColorManager.secondary,
                BlendMode.srcIn,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(child: body),
    );
  }

  Widget _buildContent(BuildContext context, TransactionFormState state) {
    final double parsedAmount = double.tryParse(_amountController.text) ?? 0.0;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // ── 1. Amount Input Hero ────────────────────────────────────
            _buildAmountSection(),

            SizedBox(height: 14.h),

            // ── 2. Quick Amount Chips ───────────────────────────────────
            _buildQuickAmountChips(),

            SizedBox(height: 20.h),

            // ── 3. Supplier Picker ──────────────────────────────────────
            _buildSupplierField(),

            SizedBox(height: 16.h),

            // ── 4. Date & Payment Method Row ────────────────────────────
            _buildDateAndPaymentRow(),

            SizedBox(height: 16.h),

            // ── 5. Installment Switch Row ───────────────────────────────
            _buildInstallmentSwitchCard(),

            // ── 6. Expanded Installment Configuration ───────────────────
            if (_isInstallment) ...<Widget>[
              SizedBox(height: 14.h),
              _buildInstallmentConfigSection(parsedAmount),
            ],

            SizedBox(height: 16.h),

            // ── 7. Notes Field ──────────────────────────────────────────
            _buildNotesField(),

            SizedBox(height: 28.h),

            // ── 8. Action Button ────────────────────────────────────────
            _buildSubmitButton(state),

            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }

  // ── Amount Section ─────────────────────────────────────────────────────────
  Widget _buildAmountSection() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: ColorManager.surface,
        borderRadius: BorderRadius.circular(AppRadius.r20.r),
        border: Border.all(color: ColorManager.border),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x081C1816),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: <Widget>[
          Text(
            "المبلغ المالي للمشتريات",
            style: getMediumStyle(
              color: ColorManager.textSecondary,
              fontSize: FontSize.s13,
            ),
          ),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: <Widget>[
              Text(
                AppConstants.defaultCurrency,
                style: getBoldStyle(
                  color: ColorManager.secondary,
                  fontSize: FontSize.s18,
                ),
              ),
              SizedBox(width: 8.w),
              IntrinsicWidth(
                child: TextField(
                  controller: _amountController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  textAlign: TextAlign.center,
                  style: getExtraBoldStyle(
                    color: ColorManager.textPrimary,
                    fontSize: FontSize.s36,
                  ),
                  decoration: InputDecoration(
                    hintText: "0.0",
                    hintStyle: getExtraBoldStyle(
                      color: ColorManager.textTertiary.withAlpha(120),
                      fontSize: FontSize.s36,
                    ),
                    filled: true,
                    fillColor: ColorManager.surface,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    focusedErrorBorder: InputBorder.none,
                  ),

                  onChanged: (String val) {
                    setState(() {});
                    if (_isInstallment && _installmentPlanMode == "Custom") {
                      _recalculateCustomInstallments(
                        double.tryParse(val) ?? 0.0,
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Quick Chips ────────────────────────────────────────────────────────────
  Widget _buildQuickAmountChips() {
    final double currentAmount = double.tryParse(_amountController.text) ?? -1;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _quickAmountChips.map((num chipAmount) {
          final bool isSelected = currentAmount == chipAmount.toDouble();
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: ChoiceChip(
              label: Text(
                "$chipAmount ${AppConstants.defaultCurrency}",
                style: getBoldStyle(
                  color: isSelected
                      ? ColorManager.white
                      : ColorManager.textSecondary,
                  fontSize: FontSize.s12,
                ),
              ),
              selected: isSelected,
              selectedColor: ColorManager.secondary,
              backgroundColor: ColorManager.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.r12.r),
                side: BorderSide(
                  color: isSelected
                      ? ColorManager.secondary
                      : ColorManager.border,
                ),
              ),
              showCheckmark: false,
              onSelected: (_) => _setAmount(chipAmount),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ── Supplier Field ─────────────────────────────────────────────────────────
  Widget _buildSupplierField() {
    final bool hasSelection =
        (_selectedContactId != null && _selectedContactId!.isNotEmpty) ||
        (_selectedPartyName != null && _selectedPartyName!.isNotEmpty);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "الطرف الثاني (المورد) *",
          style: getBoldStyle(
            color: ColorManager.textPrimary,
            fontSize: FontSize.s13,
          ),
        ),
        SizedBox(height: 6.h),
        InkWell(
          onTap: _pickContact,
          borderRadius: BorderRadius.circular(AppRadius.r14.r),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
            decoration: BoxDecoration(
              color: ColorManager.surface,
              borderRadius: BorderRadius.circular(AppRadius.r14.r),
              border: Border.all(
                color: hasSelection
                    ? ColorManager.secondary
                    : ColorManager.border,
                width: hasSelection ? 1.5 : 1.0,
              ),
            ),
            child: Row(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                    color: ColorManager.lightSecondary,
                    borderRadius: BorderRadius.circular(AppRadius.r10.r),
                  ),
                  child: SvgPicture.asset(
                    IconAssets.store,
                    width: 16.r,
                    height: 16.r,
                    colorFilter: const ColorFilter.mode(
                      ColorManager.secondary,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: hasSelection
                      ? Row(
                          children: <Widget>[
                            Flexible(
                              child: Text(
                                _selectedPartyName ?? "مورد محدد",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: getBoldStyle(
                                  color: ColorManager.textPrimary,
                                  fontSize: FontSize.s14,
                                ),
                              ),
                            ),
                            if (_isPartyVip) ...<Widget>[
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
                                  "مورد VIP",
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
                          "اختر المورد من الدليل أو اكتب اسمه...",
                          style: getRegularStyle(
                            color: ColorManager.textTertiary,
                            fontSize: FontSize.s13,
                          ),
                        ),
                ),
                if (hasSelection)
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedContactId = null;
                        _selectedPartyName = null;
                        _isPartyVip = false;
                      });
                    },
                    child: Padding(
                      padding: EdgeInsets.all(4.r),
                      child: Icon(
                        Icons.close_rounded,
                        color: ColorManager.textSecondary,
                        size: 16.r,
                      ),
                    ),
                  )
                else
                  SvgPicture.asset(
                    IconAssets.chevronDown,
                    width: 16.r,
                    height: 16.r,
                    colorFilter: const ColorFilter.mode(
                      ColorManager.textSecondary,
                      BlendMode.srcIn,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ── Date and Payment Row ───────────────────────────────────────────────────
  Widget _buildDateAndPaymentRow() {
    final String formattedDate = formatArabicDate(_transactionDate);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // Date Field
        Expanded(
          flex: 5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "تاريخ العملية",
                style: getBoldStyle(
                  color: ColorManager.textPrimary,
                  fontSize: FontSize.s13,
                ),
              ),
              SizedBox(height: 6.h),
              InkWell(
                onTap: _pickTransactionDate,
                borderRadius: BorderRadius.circular(AppRadius.r12.r),
                child: Container(
                  height: 48.h,
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  decoration: BoxDecoration(
                    color: ColorManager.surface,
                    borderRadius: BorderRadius.circular(AppRadius.r12.r),
                    border: Border.all(color: ColorManager.border),
                  ),
                  child: Row(
                    children: <Widget>[
                      SvgPicture.asset(
                        IconAssets.calendar,
                        width: 16.r,
                        height: 16.r,
                        colorFilter: const ColorFilter.mode(
                          ColorManager.secondary,
                          BlendMode.srcIn,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          formattedDate,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: getMediumStyle(
                            color: ColorManager.textPrimary,
                            fontSize: FontSize.s12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        SizedBox(width: 10.w),

        // Payment Method Toggle (Cash vs Credit)
        Expanded(
          flex: 5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "طريقة الدفع",
                style: getBoldStyle(
                  color: ColorManager.textPrimary,
                  fontSize: FontSize.s13,
                ),
              ),
              SizedBox(height: 6.h),
              Container(
                height: 48.h,
                padding: EdgeInsets.all(3.r),
                decoration: BoxDecoration(
                  color: ColorManager.surface,
                  borderRadius: BorderRadius.circular(AppRadius.r12.r),
                  border: Border.all(color: ColorManager.border),
                ),
                child: Row(
                  children: <Widget>[
                    // Cash
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _isCash = true),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          decoration: BoxDecoration(
                            color: _isCash
                                ? ColorManager.secondary
                                : ColorManager.transparent,
                            borderRadius: BorderRadius.circular(
                              AppRadius.r10.r,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            AppStrings.cash,
                            style: getBoldStyle(
                              color: _isCash
                                  ? ColorManager.white
                                  : ColorManager.textSecondary,
                              fontSize: FontSize.s12,
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Credit (آجل)
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _isCash = false),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          decoration: BoxDecoration(
                            color: !_isCash
                                ? ColorManager.secondary
                                : ColorManager.transparent,
                            borderRadius: BorderRadius.circular(
                              AppRadius.r10.r,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            AppStrings.credit,
                            style: getBoldStyle(
                              color: !_isCash
                                  ? ColorManager.white
                                  : ColorManager.textSecondary,
                              fontSize: FontSize.s12,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ── Installment Switch Card ────────────────────────────────────────────────
  Widget _buildInstallmentSwitchCard() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: ColorManager.surface,
        borderRadius: BorderRadius.circular(AppRadius.r14.r),
        border: Border.all(
          color: _isInstallment ? ColorManager.secondary : ColorManager.border,
          width: _isInstallment ? 1.5 : 1.0,
        ),
      ),
      child: Row(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: ColorManager.lightSecondary,
              borderRadius: BorderRadius.circular(AppRadius.r10.r),
            ),
            child: SvgPicture.asset(
              IconAssets.walletCards,
              width: 18.r,
              height: 18.r,
              colorFilter: const ColorFilter.mode(
                ColorManager.secondary,
                BlendMode.srcIn,
              ),
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "تقسيط المشتريات على دفعات",
                  style: getBoldStyle(
                    color: ColorManager.textPrimary,
                    fontSize: FontSize.s13,
                  ),
                ),
                Text(
                  "سداد قيمة البضاعة على دفعات للمورد",
                  style: getRegularStyle(
                    color: ColorManager.textSecondary,
                    fontSize: FontSize.s11,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: _isInstallment,
            activeThumbColor: ColorManager.secondary,
            onChanged: (bool val) {
              setState(() {
                _isInstallment = val;
                if (val && _isCash) {
                  _isCash = false;
                }
              });
            },
          ),
        ],
      ),
    );
  }

  // ── Installment Configuration Section ──────────────────────────────────────
  Widget _buildInstallmentConfigSection(double totalAmount) {
    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: ColorManager.surface,
        borderRadius: BorderRadius.circular(AppRadius.r16.r),
        border: Border.all(color: ColorManager.secondary.withAlpha(80)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Mode Tabs (Automatic vs Custom)
          Row(
            children: <Widget>[
              Expanded(
                child: GestureDetector(
                  onTap: () =>
                      setState(() => _installmentPlanMode = "Automatic"),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    decoration: BoxDecoration(
                      color: _installmentPlanMode == "Automatic"
                          ? ColorManager.lightSecondary
                          : ColorManager.surfaceVariant,
                      borderRadius: BorderRadius.circular(AppRadius.r10.r),
                      border: Border.all(
                        color: _installmentPlanMode == "Automatic"
                            ? ColorManager.secondary
                            : ColorManager.transparent,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "تقسيط تلقائي (متساوي)",
                      style: getBoldStyle(
                        color: _installmentPlanMode == "Automatic"
                            ? ColorManager.darkSecondary
                            : ColorManager.textSecondary,
                        fontSize: FontSize.s12,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() => _installmentPlanMode = "Custom");
                    _recalculateCustomInstallments(totalAmount);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    decoration: BoxDecoration(
                      color: _installmentPlanMode == "Custom"
                          ? ColorManager.lightSecondary
                          : ColorManager.surfaceVariant,
                      borderRadius: BorderRadius.circular(AppRadius.r10.r),
                      border: Border.all(
                        color: _installmentPlanMode == "Custom"
                            ? ColorManager.secondary
                            : ColorManager.transparent,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "تقسيط مخصص (يدوي)",
                      style: getBoldStyle(
                        color: _installmentPlanMode == "Custom"
                            ? ColorManager.darkSecondary
                            : ColorManager.textSecondary,
                        fontSize: FontSize.s12,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 14.h),

          if (_installmentPlanMode == "Automatic") ...<Widget>[
            // Count of Installments
            Text(
              "عدد الأقساط",
              style: getBoldStyle(
                color: ColorManager.textPrimary,
                fontSize: FontSize.s12,
              ),
            ),
            SizedBox(height: 6.h),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: <int>[2, 3, 4, 6, 12].map((int cnt) {
                  final bool isSel = _installmentCount == cnt;
                  return Padding(
                    padding: EdgeInsets.only(left: 6.w),
                    child: ChoiceChip(
                      label: Text(
                        "$cnt أقساط",
                        style: getBoldStyle(
                          color: isSel
                              ? ColorManager.white
                              : ColorManager.textSecondary,
                          fontSize: FontSize.s11,
                        ),
                      ),
                      selected: isSel,
                      selectedColor: ColorManager.secondary,
                      backgroundColor: ColorManager.surfaceVariant,
                      showCheckmark: false,
                      onSelected: (_) =>
                          setState(() => _installmentCount = cnt),
                    ),
                  );
                }).toList(),
              ),
            ),

            SizedBox(height: 12.h),

            // Frequency & First Date Row
            Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "التكرار",
                        style: getBoldStyle(
                          color: ColorManager.textPrimary,
                          fontSize: FontSize.s12,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      DropdownButtonFormField<String>(
                        dropdownColor: ColorManager.white,
                        initialValue: _frequency,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: ColorManager.surfaceVariant,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 8.h,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              AppRadius.r10.r,
                            ),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        items: const <DropdownMenuItem<String>>[
                          DropdownMenuItem<String>(
                            value: "Weekly",
                            child: Text(
                              "أسبوعي",
                              style: TextStyle(color: ColorManager.black),
                            ),
                          ),
                          DropdownMenuItem<String>(
                            value: "Monthly",
                            child: Text(
                              "شهري",
                              style: TextStyle(color: ColorManager.black),
                            ),
                          ),
                          DropdownMenuItem<String>(
                            value: "Yearly",
                            child: Text(
                              "سنوي",
                              style: TextStyle(color: ColorManager.black),
                            ),
                          ),
                        ],
                        onChanged: (String? val) {
                          if (val != null) setState(() => _frequency = val);
                        },
                      ),
                    ],
                  ),
                ),

                SizedBox(width: 10.w),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "تاريخ أول قسط",
                        style: getBoldStyle(
                          color: ColorManager.textPrimary,
                          fontSize: FontSize.s12,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      InkWell(
                        onTap: _pickFirstInstallmentDate,
                        child: Container(
                          height: 48.h,
                          padding: EdgeInsets.symmetric(horizontal: 8.w),
                          decoration: BoxDecoration(
                            color: ColorManager.surfaceVariant,
                            borderRadius: BorderRadius.circular(
                              AppRadius.r10.r,
                            ),
                          ),
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.calendar_today_rounded,
                                size: 14.r,
                                color: ColorManager.secondary,
                              ),
                              SizedBox(width: 6.w),
                              Expanded(
                                child: Text(
                                  formatNumericDate(_firstInstallmentDate),
                                  style: getMediumStyle(
                                    color: ColorManager.textPrimary,
                                    fontSize: FontSize.s11,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            if (totalAmount > 0) ...<Widget>[
              SizedBox(height: 12.h),
              Container(
                padding: EdgeInsets.all(10.r),
                decoration: BoxDecoration(
                  color: ColorManager.lightSecondary,
                  borderRadius: BorderRadius.circular(AppRadius.r10.r),
                ),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.info_outline_rounded,
                      color: ColorManager.darkSecondary,
                      size: 16.r,
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        "قيمة كل قسط: ${(totalAmount / _installmentCount).toStringAsFixed(1)} ${AppConstants.defaultCurrency} (إجمالي $_installmentCount أقساط)",
                        style: getBoldStyle(
                          color: ColorManager.darkSecondary,
                          fontSize: FontSize.s11,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ] else ...<Widget>[
            // Custom Installments List
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "الأقساط المخصصة",
                  style: getBoldStyle(
                    color: ColorManager.textPrimary,
                    fontSize: FontSize.s12,
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    setState(() {
                      final int count = _customInstallmentEntries.length + 1;
                      _customInstallmentEntries.add(
                        _PurchaseInstallmentEntry(
                          amount: 0,
                          dueDate: DateTime.now().add(
                            Duration(days: 30 * count),
                          ),
                        ),
                      );
                    });
                  },
                  icon: const Icon(Icons.add_rounded, size: 16),
                  label: const Text("إضافة قسط"),
                  style: TextButton.styleFrom(
                    foregroundColor: ColorManager.secondary,
                    padding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),

            ..._customInstallmentEntries.asMap().entries.map((
              MapEntry<int, _PurchaseInstallmentEntry> entry,
            ) {
              final int idx = entry.key;
              final _PurchaseInstallmentEntry item = entry.value;

              return Container(
                margin: EdgeInsets.only(bottom: 8.h),
                padding: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  color: ColorManager.surfaceVariant,
                  borderRadius: BorderRadius.circular(AppRadius.r10.r),
                ),
                child: Row(
                  children: <Widget>[
                    CircleAvatar(
                      radius: 12.r,
                      backgroundColor: ColorManager.lightSecondary,
                      child: Text(
                        "${idx + 1}",
                        style: getBoldStyle(
                          color: ColorManager.darkSecondary,
                          fontSize: FontSize.s10,
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      flex: 4,
                      child: TextField(
                        style: getRegularStyle(
                          color: ColorManager.black,
                          fontSize: FontSize.s14,
                        ),
                        controller: item.amountController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: "المبلغ",
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 8.h,
                          ),
                          filled: true,
                          fillColor: ColorManager.surface,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppRadius.r8.r),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        onChanged: (_) => setState(() {}),
                      ),
                    ),
                    SizedBox(width: 6.w),
                    Expanded(
                      flex: 4,
                      child: InkWell(
                        onTap: () async {
                          final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: item.dueDate,
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2035),
                          );
                          if (picked != null) {
                            setState(() => item.dueDate = picked);
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 6.w,
                            vertical: 8.h,
                          ),
                          decoration: BoxDecoration(
                            color: ColorManager.surface,
                            borderRadius: BorderRadius.circular(AppRadius.r8.r),
                          ),
                          child: Text(
                            formatNumericDate(item.dueDate),
                            style: getMediumStyle(
                              color: ColorManager.textPrimary,
                              fontSize: FontSize.s11,
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (_customInstallmentEntries.length > 1)
                      IconButton(
                        icon: Icon(
                          Icons.delete_outline_rounded,
                          size: 18.r,
                          color: ColorManager.error,
                        ),
                        onPressed: () {
                          setState(() {
                            _customInstallmentEntries.removeAt(idx);
                          });
                        },
                      ),
                  ],
                ),
              );
            }),

            SizedBox(height: 6.h),
            Builder(
              builder: (_) {
                final double sum = _totalCustomSum;
                final bool matches = (sum - totalAmount).abs() < 0.01;
                return Container(
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                    color: matches
                        ? ColorManager.successContainer
                        : ColorManager.errorContainer,
                    borderRadius: BorderRadius.circular(AppRadius.r8.r),
                  ),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        matches
                            ? Icons.check_circle_rounded
                            : Icons.warning_rounded,
                        color: matches
                            ? ColorManager.success
                            : ColorManager.error,
                        size: 16.r,
                      ),
                      SizedBox(width: 6.w),
                      Expanded(
                        child: Text(
                          "مجموع الأقساط: $sum / إجمالي الفاتورة: $totalAmount",
                          style: getBoldStyle(
                            color: matches
                                ? ColorManager.success
                                : ColorManager.error,
                            fontSize: FontSize.s11,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ],
      ),
    );
  }

  // ── Notes Field ────────────────────────────────────────────────────────────
  Widget _buildNotesField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "ملاحظات على العملية (اختياري)",
          style: getBoldStyle(
            color: ColorManager.textPrimary,
            fontSize: FontSize.s13,
          ),
        ),
        SizedBox(height: 6.h),
        TextField(
          controller: _noteController,
          style: getRegularStyle(
            color: ColorManager.black,
            fontSize: FontSize.s14,
          ),
          maxLines: 2,
          decoration: InputDecoration(
            hintText: "أضف أي تفاصيل أو أرقام فواتير مشتريات...",
            hintStyle: getRegularStyle(
              color: ColorManager.textTertiary,
              fontSize: FontSize.s12,
            ),
            filled: true,
            fillColor: ColorManager.surface,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 14.w,
              vertical: 12.h,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.r14.r),
              borderSide: const BorderSide(color: ColorManager.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.r14.r),
              borderSide: const BorderSide(color: ColorManager.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.r14.r),
              borderSide: const BorderSide(color: ColorManager.secondary),
            ),
          ),
        ),
      ],
    );
  }

  // ── Submit Button ──────────────────────────────────────────────────────────
  Widget _buildSubmitButton(TransactionFormState state) {
    final bool isLoading = state.flowState is LoadingState;

    return SizedBox(
      height: 75.h,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: ColorManager.secondary,
          borderRadius: BorderRadius.circular(AppRadius.r14.r),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: ColorManager.secondary.withAlpha(50),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: isLoading ? null : _submit,
          style: ElevatedButton.styleFrom(
            backgroundColor: ColorManager.transparent,
            shadowColor: ColorManager.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.r14.r),
            ),
          ),
          child: isLoading
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    color: ColorManager.white,
                    strokeWidth: 2.5,
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Center(
                      child: Text(
                        "حفظ عملية الشراء",
                        style: getBoldStyle(
                          color: ColorManager.white,
                          fontSize: FontSize.s15,
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Icon(
                      Icons.check_rounded,
                      color: ColorManager.white,
                      size: 20.r,
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
