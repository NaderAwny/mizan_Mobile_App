import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mizan/presentation/common/state_randrer/state_randrer_impl.dart';

part 'register_state.freezed.dart';

@freezed
abstract class RegisterState with _$RegisterState {
  const factory RegisterState({
    FlowState? flowState,
    @Default('') String email,
    @Default('') String lastName,
    @Default('') String firstName,
    @Default(false) bool isEmailValid,
    @Default(false) bool isLastNameValid,
    @Default(false) bool isFirstNameValid,
    @Default(false) bool isAllValid,
    @Default(false) bool registerSuccess,
  }) = _RegisterState;
}
