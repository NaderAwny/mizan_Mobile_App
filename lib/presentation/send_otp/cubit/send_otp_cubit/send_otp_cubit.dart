// ignore_for_file: body_might_complete_normally_nullable
import 'package:emails_validator/emails_validator.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:mizan/data/request/send_otp.dart';
import 'package:mizan/domain/use_case/send_otp_use_case.dart';
import 'package:mizan/presentation/common/state_randrer/state_randrer.dart';
import 'package:mizan/presentation/common/state_randrer/state_randrer_impl.dart';
import 'package:mizan/presentation/send_otp/cubit/send_otp_state.dart';

@injectable
class SendOtpCubit extends Cubit<SendOtpState> {
  final SendOtpUseCase sendOtpUseCase;
  SendOtpCubit(this.sendOtpUseCase) : super(const SendOtpState());

  void resetSuccess() {
    emit(state.copyWith(sendOtpSuccess: false));
  }

  void sendOtp() async {
    emit(
      state.copyWith(
        sendOtpSuccess: false,
        flowState: LoadingState(
          stateRendererType: StateRendererType.popupLoadingState,
          title: "جاري المعالجة",
          message: "جاري إرسال رمز التحقق إلى بريدك الإلكتروني...",
        ),
      ),
    );

    (await sendOtpUseCase.execute(SendOtpRequest(email: state.email))).fold(
      (failure) => {
        // left -> failure
        emit(
          state.copyWith(
            flowState: ErrorState(
              StateRendererType.popupErrorStatete,
              failure.message,
              title: "تعذر إرسال الرمز",
            ),
          ),
        ),
        // ignore: avoid_print
        print(failure.message),
      },
      (data) => {
        // right -> data (success)
        emit(state.copyWith(flowState: ContentState(), sendOtpSuccess: true)),
        // navigate to sentOtp screen — handled by BlocConsumer listener
      },
    );
  }

  void setEmail(String email) {
    final valid = isEmailValid(email);
    final newState = state.copyWith(
      email: email,
      isEmailValid: valid,
      sendOtpSuccess: false,
    );
    emit(
      newState.copyWith(
        email: email,
        isEmailValid: isEmailValid(email),
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
}
