import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mizan/domain/model/contact_model.dart';
import 'package:mizan/presentation/common/state_randrer/state_randrer_impl.dart';

part 'contact_profile_state.freezed.dart';

@freezed
abstract class ContactProfileState with _$ContactProfileState {
  const factory ContactProfileState({
    FlowState? flowState,
    ContactProfile? data,
    @Default(false) bool isDeleted,
  }) = _ContactProfileState;
}
