import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:mizan/data/network/failure.dart';
import 'package:mizan/domain/model/installments_dashboard_model.dart';
import 'package:mizan/domain/use_case/get_installments_dashboard_use_case.dart';
import 'package:mizan/presentation/common/state_randrer/state_randrer.dart';
import 'package:mizan/presentation/common/state_randrer/state_randrer_impl.dart';
import 'package:mizan/presentation/installments/installments_dashboard/installments_dashboard_state.dart';
import 'package:mizan/presentation/resources/strings_manager.dart';

@injectable
class InstallmentsDashboardCubit extends Cubit<InstallmentsDashboardState> {
  final GetInstallmentsDashboardUseCase _getInstallmentsDashboardUseCase;

  InstallmentsDashboardCubit(this._getInstallmentsDashboardUseCase)
    : super(const InstallmentsDashboardState());

  Future<void> getInstallmentsDashboard() async {
    // أول تحميل فقط بنعرض Loading كامل، والـ refresh بيفضل عارض الداتا القديمة
    if (state.data == null) {
      emit(
        state.copyWith(
          flowState: LoadingState(
            stateRendererType: StateRendererType.fullScreenLoadingState,
            title: AppStrings.loading,
            message: "جاري جلب لوحة متابعة الأقساط...",
          ),
        ),
      );
    }

    final Either<Failure, InstallmentsDashboardModel> result =
        await _getInstallmentsDashboardUseCase.execute(null);

    result.fold(
      (Failure failure) {
        if (isClosed) return;
        emit(
          state.copyWith(
            flowState: ErrorState(
              StateRendererType.fullScreenErrorState,
              failure.message,
              title: "تعذر تحميل لوحة متابعة الأقساط",
            ),
          ),
        );
      },
      (InstallmentsDashboardModel dashboard) {
        if (isClosed) return;
        emit(
          state.copyWith(
            data: dashboard,
            flowState: dashboard.plans.isEmpty
                ? EmptyState("لا توجد خطط أقساط نشطة حالياً")
                : ContentState(),
          ),
        );
      },
    );
  }
}
