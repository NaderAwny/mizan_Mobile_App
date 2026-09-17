import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mizan/presentation/common/state_randrer/state_randrer_impl.dart';

part 'logout_state.freezed.dart';

@freezed
abstract class LogoutState with _$LogoutState {
  const factory LogoutState({
    FlowState? flowState,
    bool? isLoggedOut,
  }) = _LogoutState;
}
