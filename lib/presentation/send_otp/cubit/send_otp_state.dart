import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mizan/presentation/common/state_randrer/state_randrer_impl.dart';

part 'send_otp_state.freezed.dart';

@freezed
abstract class SendOtpState with _$SendOtpState {
  const factory SendOtpState({
    FlowState? flowState,
    @Default('') String email,
    @Default(false) bool isEmailValid,
    @Default(false) bool isAllValid,
    @Default(false) bool sendOtpSuccess,
    @Default(0) int secondsLeft,       // كان ValueNotifier<int> في الـ view
    @Default(false) bool emailTouched, // كان _emailTouched setState في الـ view
  }) = _SendOtpState;
}
