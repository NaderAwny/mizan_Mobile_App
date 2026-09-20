import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:mizan/data/request/transaction_request.dart';
import 'package:mizan/domain/use_case/create_transaction_use_case.dart';
import 'package:mizan/presentation/common/state_randrer/state_randrer.dart';
import 'package:mizan/presentation/common/state_randrer/state_randrer_impl.dart';
import 'package:mizan/presentation/transactions/transaction_form_cubit/transaction_form_state.dart';

@injectable
class TransactionFormCubit extends Cubit<TransactionFormState> {
  final CreateTransactionUseCase _createTransactionUseCase;

  TransactionFormCubit(this._createTransactionUseCase)
    : super(const TransactionFormState());

  /// نقطة تحقق واحدة موحّدة بدل تكرار عدة ErrorState متتالية.
  /// بترجع أول رسالة خطأ لو فيه، أو null لو البيانات سليمة.
  String? _validate({
    required String? contactId,
    required String? partyName,
    required num amount,
    required bool isInstallment,
    required String? installmentPlanMode,
    required int? installmentCount,
    required List<CustomInstallmentItem>? customInstallments,
  }) {
    if ((contactId == null || contactId.isEmpty) &&
        (partyName == null || partyName.trim().isEmpty)) {
      return "يجب تحديد عميل/مورد أو كتابة اسم الطرف";
    }
    if (amount <= 0) {
      return "المبلغ يجب أن يكون أكبر من صفر";
    }
    if (isInstallment && installmentPlanMode == "Automatic") {
      if (installmentCount == null || installmentCount <= 0) {
        return "عدد الأقساط يجب أن يكون أكبر من صفر";
      }
    }
    if (isInstallment && installmentPlanMode == "Custom") {
      if (customInstallments == null || customInstallments.isEmpty) {
        return "يجب إضافة أقساط مخصصة على الأقل قسط واحد";
      }
      final sum = customInstallments.fold<num>(0, (p, e) => p + e.amount);
      if (sum != amount) {
        return "مجموع الأقساط المخصصة ($sum) لا يساوي المبلغ الإجمالي ($amount)";
      }
    }
    return null;
  }

  Future<void> submit(CreateTransactionRequest request) async {
    final validationError = _validate(
      contactId: request.contactId,
      partyName: request.partyName,
      amount: request.amount,
      isInstallment: request.isInstallment,
      installmentPlanMode: request.installmentPlanMode,
      installmentCount: request.installmentCount,
      customInstallments: request.customInstallments,
    );

    if (validationError != null) {
      emit(
        state.copyWith(
          flowState: ErrorState(
            StateRendererType.popupErrorStatete,
            validationError,
            title: "تعذر إنشاء العملية",
          ),
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        flowState: LoadingState(
          stateRendererType: StateRendererType.popupLoadingState,
          message: "جاري تسجيل العملية...",
        ),
      ),
    );

    final result = await _createTransactionUseCase.execute(request);

    result.fold(
      (failure) {
        if (isClosed) return;
        emit(
          state.copyWith(
            flowState: ErrorState(
              StateRendererType.popupErrorStatete,
              failure.message,
              title: "تعذر إنشاء العملية",
            ),
          ),
        );
      },
      (transaction) {
        if (isClosed) return;
        emit(
          state.copyWith(
            savedTransaction: transaction,
            isActionSuccess: true,
            flowState: ContentState(),
          ),
        );
      },
    );
  }
}
