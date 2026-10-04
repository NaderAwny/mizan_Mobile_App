import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:mizan/app/app_logger.dart';
import 'package:mizan/data/network/failure.dart';
import 'package:mizan/domain/model/auth_session_model/auth_session_model.dart';
import 'package:mizan/domain/use_case/verify_otp_use_case.dart';
import 'package:mizan/presentation/auth_verification/verify_otp_cubit/verify_otp_state.dart';
import 'package:mizan/presentation/common/state_randrer/state_randrer.dart';
import 'package:mizan/presentation/common/state_randrer/state_randrer_impl.dart';

@injectable
class VerifyOtpCubit extends Cubit<VerifyOtpState> {
  final VerifyOtpUseCase _usecase;
  VerifyOtpCubit(this._usecase) : super(const VerifyOtpState());

  Future<void> verify({required String email, required String code}) async {
    emit(
      state.copyWith(
        flowState: LoadingState(
          stateRendererType: StateRendererType.popupLoadingState,
          title: 'جاري التحقق',
          message: 'جاري مطابقة رمز التحقق المدخل...',
        ),
      ),
    );
    (await _usecase.execute(VerifyOtpInput(email, code))).fold(
      (Failure failure) {
        AppLogger.e('verifyOtp failure', error: failure.message);
        emit(
          state.copyWith(
            flowState: ErrorState(
              StateRendererType.popupErrorStatete,
              failure.message,
              title: 'فشل التحقق',
            ),
          ),
        );
      },
      (AuthSession session) =>
          emit(state.copyWith(data: session, flowState: ContentState())),
    );
  }
}
