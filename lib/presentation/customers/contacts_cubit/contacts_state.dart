import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mizan/domain/model/contact_model.dart';
import 'package:mizan/presentation/common/state_randrer/state_randrer_impl.dart';

part 'contacts_state.freezed.dart';

@freezed
abstract class ContactsState with _$ContactsState {
  const factory ContactsState({
    FlowState? flowState,
    List<Contact>? data,
    @Default(false) bool isLoadingMore,
    @Default(true) bool hasMore,
    @Default(false) bool isVipOnly,
    @Default('') String searchQuery,
  }) = _ContactsState;
}
