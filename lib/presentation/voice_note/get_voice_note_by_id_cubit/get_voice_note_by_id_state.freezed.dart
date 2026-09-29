// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'get_voice_note_by_id_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$GetVoiceNoteByIdState {

 FlowState? get flowState; VoiceNoteModel? get data;
/// Create a copy of GetVoiceNoteByIdState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GetVoiceNoteByIdStateCopyWith<GetVoiceNoteByIdState> get copyWith => _$GetVoiceNoteByIdStateCopyWithImpl<GetVoiceNoteByIdState>(this as GetVoiceNoteByIdState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GetVoiceNoteByIdState&&(identical(other.flowState, flowState) || other.flowState == flowState)&&(identical(other.data, data) || other.data == data));
}


@override
int get hashCode => Object.hash(runtimeType,flowState,data);

@override
String toString() {
  return 'GetVoiceNoteByIdState(flowState: $flowState, data: $data)';
}


}

/// @nodoc
abstract mixin class $GetVoiceNoteByIdStateCopyWith<$Res>  {
  factory $GetVoiceNoteByIdStateCopyWith(GetVoiceNoteByIdState value, $Res Function(GetVoiceNoteByIdState) _then) = _$GetVoiceNoteByIdStateCopyWithImpl;
@useResult
$Res call({
 FlowState? flowState, VoiceNoteModel? data
});




}
/// @nodoc
class _$GetVoiceNoteByIdStateCopyWithImpl<$Res>
    implements $GetVoiceNoteByIdStateCopyWith<$Res> {
  _$GetVoiceNoteByIdStateCopyWithImpl(this._self, this._then);

  final GetVoiceNoteByIdState _self;
  final $Res Function(GetVoiceNoteByIdState) _then;

/// Create a copy of GetVoiceNoteByIdState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? flowState = freezed,Object? data = freezed,}) {
  return _then(_self.copyWith(
flowState: freezed == flowState ? _self.flowState : flowState // ignore: cast_nullable_to_non_nullable
as FlowState?,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as VoiceNoteModel?,
  ));
}

}


/// Adds pattern-matching-related methods to [GetVoiceNoteByIdState].
extension GetVoiceNoteByIdStatePatterns on GetVoiceNoteByIdState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GetVoiceNoteByIdState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GetVoiceNoteByIdState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GetVoiceNoteByIdState value)  $default,){
final _that = this;
switch (_that) {
case _GetVoiceNoteByIdState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GetVoiceNoteByIdState value)?  $default,){
final _that = this;
switch (_that) {
case _GetVoiceNoteByIdState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( FlowState? flowState,  VoiceNoteModel? data)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GetVoiceNoteByIdState() when $default != null:
return $default(_that.flowState,_that.data);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( FlowState? flowState,  VoiceNoteModel? data)  $default,) {final _that = this;
switch (_that) {
case _GetVoiceNoteByIdState():
return $default(_that.flowState,_that.data);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( FlowState? flowState,  VoiceNoteModel? data)?  $default,) {final _that = this;
switch (_that) {
case _GetVoiceNoteByIdState() when $default != null:
return $default(_that.flowState,_that.data);case _:
  return null;

}
}

}

/// @nodoc


class _GetVoiceNoteByIdState implements GetVoiceNoteByIdState {
  const _GetVoiceNoteByIdState({this.flowState, this.data});
  

@override final  FlowState? flowState;
@override final  VoiceNoteModel? data;

/// Create a copy of GetVoiceNoteByIdState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GetVoiceNoteByIdStateCopyWith<_GetVoiceNoteByIdState> get copyWith => __$GetVoiceNoteByIdStateCopyWithImpl<_GetVoiceNoteByIdState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GetVoiceNoteByIdState&&(identical(other.flowState, flowState) || other.flowState == flowState)&&(identical(other.data, data) || other.data == data));
}


@override
int get hashCode => Object.hash(runtimeType,flowState,data);

@override
String toString() {
  return 'GetVoiceNoteByIdState(flowState: $flowState, data: $data)';
}


}

/// @nodoc
abstract mixin class _$GetVoiceNoteByIdStateCopyWith<$Res> implements $GetVoiceNoteByIdStateCopyWith<$Res> {
  factory _$GetVoiceNoteByIdStateCopyWith(_GetVoiceNoteByIdState value, $Res Function(_GetVoiceNoteByIdState) _then) = __$GetVoiceNoteByIdStateCopyWithImpl;
@override @useResult
$Res call({
 FlowState? flowState, VoiceNoteModel? data
});




}
/// @nodoc
class __$GetVoiceNoteByIdStateCopyWithImpl<$Res>
    implements _$GetVoiceNoteByIdStateCopyWith<$Res> {
  __$GetVoiceNoteByIdStateCopyWithImpl(this._self, this._then);

  final _GetVoiceNoteByIdState _self;
  final $Res Function(_GetVoiceNoteByIdState) _then;

/// Create a copy of GetVoiceNoteByIdState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? flowState = freezed,Object? data = freezed,}) {
  return _then(_GetVoiceNoteByIdState(
flowState: freezed == flowState ? _self.flowState : flowState // ignore: cast_nullable_to_non_nullable
as FlowState?,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as VoiceNoteModel?,
  ));
}


}

// dart format on
