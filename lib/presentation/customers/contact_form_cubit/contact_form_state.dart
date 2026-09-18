import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mizan/domain/model/contact_model.dart';
import 'package:mizan/presentation/common/state_randrer/state_randrer_impl.dart';

part 'contact_form_state.freezed.dart';

@freezed
abstract class ContactFormState with _$ContactFormState {
  const factory ContactFormState({
    FlowState? flowState,
    Contact? savedContact,
    @Default(false) bool isActionSuccess,
    @Default(false) bool isEditMode,
  }) = _ContactFormState;
}
