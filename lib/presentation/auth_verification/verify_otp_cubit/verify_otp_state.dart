import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mizan/domain/model/auth_session_model/auth_session_model.dart';
import 'package:mizan/presentation/common/state_randrer/state_randrer_impl.dart';

part 'verify_otp_state.freezed.dart';

@freezed
abstract class VerifyOtpState with _$VerifyOtpState {
  const factory VerifyOtpState({
    FlowState? flowState,
    AuthSession? data,
  }) = _VerifyOtpState;
}
