// ignore_for_file: body_might_complete_normally_nullable
import 'dart:async';

import 'package:emails_validator/emails_validator.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:mizan/app/app_logger.dart';
import 'package:mizan/data/network/failure.dart';
import 'package:mizan/data/request/send_otp.dart';
import 'package:mizan/domain/model/register_model.dart';
import 'package:mizan/domain/use_case/send_otp_use_case.dart';
import 'package:mizan/presentation/common/state_randrer/state_randrer.dart';
import 'package:mizan/presentation/common/state_randrer/state_randrer_impl.dart';
import 'package:mizan/presentation/send_otp/cubit/send_otp_state.dart';

@injectable
class SendOtpCubit extends Cubit<SendOtpState> {
  final SendOtpUseCase sendOtpUseCase;
  SendOtpCubit(this.sendOtpUseCase) : super(const SendOtpState());

  Timer? _timer;

  void resetSuccess() {
    emit(state.copyWith(sendOtpSuccess: false));
  }

  void touchEmail() {
    if (state.emailTouched) return;
    emit(state.copyWith(emailTouched: true));
  }

  void startTimer([int seconds = 120]) {
    _timer?.cancel();
    emit(state.copyWith(secondsLeft: seconds));
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (isClosed || state.secondsLeft <= 1) {
        timer.cancel();
        if (!isClosed) emit(state.copyWith(secondsLeft: 0));
        return;
      }
      emit(state.copyWith(secondsLeft: state.secondsLeft - 1));
    });
  }

  Future<void> sendOtp() async {
    emit(
      state.copyWith(
        sendOtpSuccess: false,
        flowState: LoadingState(
          stateRendererType: StateRendererType.popupLoadingState,
          title: 'جاري المعالجة',
          message: 'جاري إرسال رمز التحقق إلى بريدك الإلكتروني...',
        ),
      ),
    );

    (await sendOtpUseCase.execute(SendOtpRequest(email: state.email))).fold(
      (Failure failure) => <void>{
        // left -> failure
        emit(
          state.copyWith(
            flowState: ErrorState(
              StateRendererType.popupErrorStatete,
              failure.message,
              title: 'تعذر إرسال الرمز',
            ),
          ),
        ),
        AppLogger.e('sendOtp failure', error: failure.message),
      },
      (RegisterModel data) => <void>{
        // right -> data (success)
        emit(state.copyWith(flowState: ContentState(), sendOtpSuccess: true)),
        // navigate to sentOtp screen — handled by BlocConsumer listener
      },
    );
  }

  void setEmail(String email) {
    final bool valid = isEmailValid(email);
    emit(
      state.copyWith(
        email: email,
        isEmailValid: valid,
        sendOtpSuccess: false,
        isAllValid: validateAllInputs(email),
      ),
    );
  }

  bool isEmailValid(String email) {
    return EmailsValidator.validate(email);
  }

  bool validateAllInputs(String email) {
    return isEmailValid(email);
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
