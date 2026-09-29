// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_voice_note_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$VoiceNoteFormState {

 FlowState? get flowState; VoiceNoteModel? get savedVoiceNote; bool get isActionSuccess;
/// Create a copy of VoiceNoteFormState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VoiceNoteFormStateCopyWith<VoiceNoteFormState> get copyWith => _$VoiceNoteFormStateCopyWithImpl<VoiceNoteFormState>(this as VoiceNoteFormState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VoiceNoteFormState&&(identical(other.flowState, flowState) || other.flowState == flowState)&&(identical(other.savedVoiceNote, savedVoiceNote) || other.savedVoiceNote == savedVoiceNote)&&(identical(other.isActionSuccess, isActionSuccess) || other.isActionSuccess == isActionSuccess));
}


@override
int get hashCode => Object.hash(runtimeType,flowState,savedVoiceNote,isActionSuccess);

@override
String toString() {
  return 'VoiceNoteFormState(flowState: $flowState, savedVoiceNote: $savedVoiceNote, isActionSuccess: $isActionSuccess)';
}


}

/// @nodoc
abstract mixin class $VoiceNoteFormStateCopyWith<$Res>  {
  factory $VoiceNoteFormStateCopyWith(VoiceNoteFormState value, $Res Function(VoiceNoteFormState) _then) = _$VoiceNoteFormStateCopyWithImpl;
@useResult
$Res call({
 FlowState? flowState, VoiceNoteModel? savedVoiceNote, bool isActionSuccess
});




}
/// @nodoc
class _$VoiceNoteFormStateCopyWithImpl<$Res>
    implements $VoiceNoteFormStateCopyWith<$Res> {
  _$VoiceNoteFormStateCopyWithImpl(this._self, this._then);

  final VoiceNoteFormState _self;
  final $Res Function(VoiceNoteFormState) _then;

/// Create a copy of VoiceNoteFormState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? flowState = freezed,Object? savedVoiceNote = freezed,Object? isActionSuccess = null,}) {
  return _then(_self.copyWith(
flowState: freezed == flowState ? _self.flowState : flowState // ignore: cast_nullable_to_non_nullable
as FlowState?,savedVoiceNote: freezed == savedVoiceNote ? _self.savedVoiceNote : savedVoiceNote // ignore: cast_nullable_to_non_nullable
as VoiceNoteModel?,isActionSuccess: null == isActionSuccess ? _self.isActionSuccess : isActionSuccess // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [VoiceNoteFormState].
extension VoiceNoteFormStatePatterns on VoiceNoteFormState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VoiceNoteFormState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VoiceNoteFormState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VoiceNoteFormState value)  $default,){
final _that = this;
switch (_that) {
case _VoiceNoteFormState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VoiceNoteFormState value)?  $default,){
final _that = this;
switch (_that) {
case _VoiceNoteFormState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( FlowState? flowState,  VoiceNoteModel? savedVoiceNote,  bool isActionSuccess)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VoiceNoteFormState() when $default != null:
return $default(_that.flowState,_that.savedVoiceNote,_that.isActionSuccess);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( FlowState? flowState,  VoiceNoteModel? savedVoiceNote,  bool isActionSuccess)  $default,) {final _that = this;
switch (_that) {
case _VoiceNoteFormState():
return $default(_that.flowState,_that.savedVoiceNote,_that.isActionSuccess);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( FlowState? flowState,  VoiceNoteModel? savedVoiceNote,  bool isActionSuccess)?  $default,) {final _that = this;
switch (_that) {
case _VoiceNoteFormState() when $default != null:
return $default(_that.flowState,_that.savedVoiceNote,_that.isActionSuccess);case _:
  return null;

}
}

}

/// @nodoc


class _VoiceNoteFormState implements VoiceNoteFormState {
  const _VoiceNoteFormState({this.flowState, this.savedVoiceNote, this.isActionSuccess = false});
  

@override final  FlowState? flowState;
@override final  VoiceNoteModel? savedVoiceNote;
@override@JsonKey() final  bool isActionSuccess;

/// Create a copy of VoiceNoteFormState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VoiceNoteFormStateCopyWith<_VoiceNoteFormState> get copyWith => __$VoiceNoteFormStateCopyWithImpl<_VoiceNoteFormState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VoiceNoteFormState&&(identical(other.flowState, flowState) || other.flowState == flowState)&&(identical(other.savedVoiceNote, savedVoiceNote) || other.savedVoiceNote == savedVoiceNote)&&(identical(other.isActionSuccess, isActionSuccess) || other.isActionSuccess == isActionSuccess));
}


@override
int get hashCode => Object.hash(runtimeType,flowState,savedVoiceNote,isActionSuccess);

@override
String toString() {
  return 'VoiceNoteFormState(flowState: $flowState, savedVoiceNote: $savedVoiceNote, isActionSuccess: $isActionSuccess)';
}


}

/// @nodoc
abstract mixin class _$VoiceNoteFormStateCopyWith<$Res> implements $VoiceNoteFormStateCopyWith<$Res> {
  factory _$VoiceNoteFormStateCopyWith(_VoiceNoteFormState value, $Res Function(_VoiceNoteFormState) _then) = __$VoiceNoteFormStateCopyWithImpl;
@override @useResult
$Res call({
 FlowState? flowState, VoiceNoteModel? savedVoiceNote, bool isActionSuccess
});




}
/// @nodoc
class __$VoiceNoteFormStateCopyWithImpl<$Res>
    implements _$VoiceNoteFormStateCopyWith<$Res> {
  __$VoiceNoteFormStateCopyWithImpl(this._self, this._then);

  final _VoiceNoteFormState _self;
  final $Res Function(_VoiceNoteFormState) _then;

/// Create a copy of VoiceNoteFormState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? flowState = freezed,Object? savedVoiceNote = freezed,Object? isActionSuccess = null,}) {
  return _then(_VoiceNoteFormState(
flowState: freezed == flowState ? _self.flowState : flowState // ignore: cast_nullable_to_non_nullable
as FlowState?,savedVoiceNote: freezed == savedVoiceNote ? _self.savedVoiceNote : savedVoiceNote // ignore: cast_nullable_to_non_nullable
as VoiceNoteModel?,isActionSuccess: null == isActionSuccess ? _self.isActionSuccess : isActionSuccess // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
