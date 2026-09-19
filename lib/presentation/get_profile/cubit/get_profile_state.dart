import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mizan/domain/model/get_profile_model/get_profile_model.dart';
import 'package:mizan/presentation/common/state_randrer/state_randrer_impl.dart';

part 'get_profile_state.freezed.dart';

@freezed
abstract class GetProfileState with _$GetProfileState {
  const factory GetProfileState({FlowState? flowState, GetProfileModel? data}) =
      _GetProfileState;
}
