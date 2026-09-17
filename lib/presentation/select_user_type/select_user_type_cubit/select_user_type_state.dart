import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mizan/domain/model/auth_session_model/auth_session_model.dart';
import 'package:mizan/presentation/common/state_randrer/state_randrer_impl.dart';

part 'select_user_type_state.freezed.dart';

@freezed
abstract class SelectUserTypeState with _$SelectUserTypeState {
  const factory SelectUserTypeState({
    FlowState? flowState,
    AuthSession? data,
  }) = _SelectUserTypeState;
}
