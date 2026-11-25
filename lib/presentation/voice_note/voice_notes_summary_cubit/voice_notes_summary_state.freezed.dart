// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'voice_notes_summary_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$VoiceNotesSummaryState {

 FlowState? get flowState; VoiceNoteSummaryModel? get summary; String get selectedPeriod; String? get customFrom; String? get customTo; bool get isBalanceVisible;
/// Create a copy of VoiceNotesSummaryState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VoiceNotesSummaryStateCopyWith<VoiceNotesSummaryState> get copyWith => _$VoiceNotesSummaryStateCopyWithImpl<VoiceNotesSummaryState>(this as VoiceNotesSummaryState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VoiceNotesSummaryState&&(identical(other.flowState, flowState) || other.flowState == flowState)&&(identical(other.summary, summary) || other.summary == summary)&&(identical(other.selectedPeriod, selectedPeriod) || other.selectedPeriod == selectedPeriod)&&(identical(other.customFrom, customFrom) || other.customFrom == customFrom)&&(identical(other.customTo, customTo) || other.customTo == customTo)&&(identical(other.isBalanceVisible, isBalanceVisible) || other.isBalanceVisible == isBalanceVisible));
}


@override
int get hashCode => Object.hash(runtimeType,flowState,summary,selectedPeriod,customFrom,customTo,isBalanceVisible);

@override
String toString() {
  return 'VoiceNotesSummaryState(flowState: $flowState, summary: $summary, selectedPeriod: $selectedPeriod, customFrom: $customFrom, customTo: $customTo, isBalanceVisible: $isBalanceVisible)';
}


}

/// @nodoc
abstract mixin class $VoiceNotesSummaryStateCopyWith<$Res>  {
  factory $VoiceNotesSummaryStateCopyWith(VoiceNotesSummaryState value, $Res Function(VoiceNotesSummaryState) _then) = _$VoiceNotesSummaryStateCopyWithImpl;
@useResult
$Res call({
 FlowState? flowState, VoiceNoteSummaryModel? summary, String selectedPeriod, String? customFrom, String? customTo, bool isBalanceVisible
});




}
/// @nodoc
class _$VoiceNotesSummaryStateCopyWithImpl<$Res>
    implements $VoiceNotesSummaryStateCopyWith<$Res> {
  _$VoiceNotesSummaryStateCopyWithImpl(this._self, this._then);

  final VoiceNotesSummaryState _self;
  final $Res Function(VoiceNotesSummaryState) _then;

/// Create a copy of VoiceNotesSummaryState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? flowState = freezed,Object? summary = freezed,Object? selectedPeriod = null,Object? customFrom = freezed,Object? customTo = freezed,Object? isBalanceVisible = null,}) {
  return _then(_self.copyWith(
flowState: freezed == flowState ? _self.flowState : flowState // ignore: cast_nullable_to_non_nullable
as FlowState?,summary: freezed == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as VoiceNoteSummaryModel?,selectedPeriod: null == selectedPeriod ? _self.selectedPeriod : selectedPeriod // ignore: cast_nullable_to_non_nullable
as String,customFrom: freezed == customFrom ? _self.customFrom : customFrom // ignore: cast_nullable_to_non_nullable
as String?,customTo: freezed == customTo ? _self.customTo : customTo // ignore: cast_nullable_to_non_nullable
as String?,isBalanceVisible: null == isBalanceVisible ? _self.isBalanceVisible : isBalanceVisible // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [VoiceNotesSummaryState].
extension VoiceNotesSummaryStatePatterns on VoiceNotesSummaryState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VoiceNotesSummaryState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VoiceNotesSummaryState() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VoiceNotesSummaryState value)  $default,){
final _that = this;
switch (_that) {
case _VoiceNotesSummaryState():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VoiceNotesSummaryState value)?  $default,){
final _that = this;
switch (_that) {
case _VoiceNotesSummaryState() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( FlowState? flowState,  VoiceNoteSummaryModel? summary,  String selectedPeriod,  String? customFrom,  String? customTo,  bool isBalanceVisible)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VoiceNotesSummaryState() when $default != null:
return $default(_that.flowState,_that.summary,_that.selectedPeriod,_that.customFrom,_that.customTo,_that.isBalanceVisible);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( FlowState? flowState,  VoiceNoteSummaryModel? summary,  String selectedPeriod,  String? customFrom,  String? customTo,  bool isBalanceVisible)  $default,) {final _that = this;
switch (_that) {
case _VoiceNotesSummaryState():
return $default(_that.flowState,_that.summary,_that.selectedPeriod,_that.customFrom,_that.customTo,_that.isBalanceVisible);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( FlowState? flowState,  VoiceNoteSummaryModel? summary,  String selectedPeriod,  String? customFrom,  String? customTo,  bool isBalanceVisible)?  $default,) {final _that = this;
switch (_that) {
case _VoiceNotesSummaryState() when $default != null:
return $default(_that.flowState,_that.summary,_that.selectedPeriod,_that.customFrom,_that.customTo,_that.isBalanceVisible);case _:
  return null;

}
}

}

/// @nodoc


class _VoiceNotesSummaryState implements VoiceNotesSummaryState {
  const _VoiceNotesSummaryState({this.flowState, this.summary, this.selectedPeriod = 'today', this.customFrom, this.customTo, this.isBalanceVisible = true});
  

@override final  FlowState? flowState;
@override final  VoiceNoteSummaryModel? summary;
@override@JsonKey() final  String selectedPeriod;
@override final  String? customFrom;
@override final  String? customTo;
@override@JsonKey() final  bool isBalanceVisible;

/// Create a copy of VoiceNotesSummaryState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VoiceNotesSummaryStateCopyWith<_VoiceNotesSummaryState> get copyWith => __$VoiceNotesSummaryStateCopyWithImpl<_VoiceNotesSummaryState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VoiceNotesSummaryState&&(identical(other.flowState, flowState) || other.flowState == flowState)&&(identical(other.summary, summary) || other.summary == summary)&&(identical(other.selectedPeriod, selectedPeriod) || other.selectedPeriod == selectedPeriod)&&(identical(other.customFrom, customFrom) || other.customFrom == customFrom)&&(identical(other.customTo, customTo) || other.customTo == customTo)&&(identical(other.isBalanceVisible, isBalanceVisible) || other.isBalanceVisible == isBalanceVisible));
}


@override
int get hashCode => Object.hash(runtimeType,flowState,summary,selectedPeriod,customFrom,customTo,isBalanceVisible);

@override
String toString() {
  return 'VoiceNotesSummaryState(flowState: $flowState, summary: $summary, selectedPeriod: $selectedPeriod, customFrom: $customFrom, customTo: $customTo, isBalanceVisible: $isBalanceVisible)';
}


}

/// @nodoc
abstract mixin class _$VoiceNotesSummaryStateCopyWith<$Res> implements $VoiceNotesSummaryStateCopyWith<$Res> {
  factory _$VoiceNotesSummaryStateCopyWith(_VoiceNotesSummaryState value, $Res Function(_VoiceNotesSummaryState) _then) = __$VoiceNotesSummaryStateCopyWithImpl;
@override @useResult
$Res call({
 FlowState? flowState, VoiceNoteSummaryModel? summary, String selectedPeriod, String? customFrom, String? customTo, bool isBalanceVisible
});




}
/// @nodoc
class __$VoiceNotesSummaryStateCopyWithImpl<$Res>
    implements _$VoiceNotesSummaryStateCopyWith<$Res> {
  __$VoiceNotesSummaryStateCopyWithImpl(this._self, this._then);

  final _VoiceNotesSummaryState _self;
  final $Res Function(_VoiceNotesSummaryState) _then;

/// Create a copy of VoiceNotesSummaryState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? flowState = freezed,Object? summary = freezed,Object? selectedPeriod = null,Object? customFrom = freezed,Object? customTo = freezed,Object? isBalanceVisible = null,}) {
  return _then(_VoiceNotesSummaryState(
flowState: freezed == flowState ? _self.flowState : flowState // ignore: cast_nullable_to_non_nullable
as FlowState?,summary: freezed == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as VoiceNoteSummaryModel?,selectedPeriod: null == selectedPeriod ? _self.selectedPeriod : selectedPeriod // ignore: cast_nullable_to_non_nullable
as String,customFrom: freezed == customFrom ? _self.customFrom : customFrom // ignore: cast_nullable_to_non_nullable
as String?,customTo: freezed == customTo ? _self.customTo : customTo // ignore: cast_nullable_to_non_nullable
as String?,isBalanceVisible: null == isBalanceVisible ? _self.isBalanceVisible : isBalanceVisible // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
