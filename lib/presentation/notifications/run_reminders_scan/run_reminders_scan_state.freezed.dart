// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'run_reminders_scan_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RunRemindersScanState {

 FlowState? get flowState; bool get isSuccess; RemindersScanResult? get result;
/// Create a copy of RunRemindersScanState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RunRemindersScanStateCopyWith<RunRemindersScanState> get copyWith => _$RunRemindersScanStateCopyWithImpl<RunRemindersScanState>(this as RunRemindersScanState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RunRemindersScanState&&(identical(other.flowState, flowState) || other.flowState == flowState)&&(identical(other.isSuccess, isSuccess) || other.isSuccess == isSuccess)&&(identical(other.result, result) || other.result == result));
}


@override
int get hashCode => Object.hash(runtimeType,flowState,isSuccess,result);

@override
String toString() {
  return 'RunRemindersScanState(flowState: $flowState, isSuccess: $isSuccess, result: $result)';
}


}

/// @nodoc
abstract mixin class $RunRemindersScanStateCopyWith<$Res>  {
  factory $RunRemindersScanStateCopyWith(RunRemindersScanState value, $Res Function(RunRemindersScanState) _then) = _$RunRemindersScanStateCopyWithImpl;
@useResult
$Res call({
 FlowState? flowState, bool isSuccess, RemindersScanResult? result
});




}
/// @nodoc
class _$RunRemindersScanStateCopyWithImpl<$Res>
    implements $RunRemindersScanStateCopyWith<$Res> {
  _$RunRemindersScanStateCopyWithImpl(this._self, this._then);

  final RunRemindersScanState _self;
  final $Res Function(RunRemindersScanState) _then;

/// Create a copy of RunRemindersScanState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? flowState = freezed,Object? isSuccess = null,Object? result = freezed,}) {
  return _then(_self.copyWith(
flowState: freezed == flowState ? _self.flowState : flowState // ignore: cast_nullable_to_non_nullable
as FlowState?,isSuccess: null == isSuccess ? _self.isSuccess : isSuccess // ignore: cast_nullable_to_non_nullable
as bool,result: freezed == result ? _self.result : result // ignore: cast_nullable_to_non_nullable
as RemindersScanResult?,
  ));
}

}


/// Adds pattern-matching-related methods to [RunRemindersScanState].
extension RunRemindersScanStatePatterns on RunRemindersScanState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RunRemindersScanState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RunRemindersScanState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RunRemindersScanState value)  $default,){
final _that = this;
switch (_that) {
case _RunRemindersScanState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RunRemindersScanState value)?  $default,){
final _that = this;
switch (_that) {
case _RunRemindersScanState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( FlowState? flowState,  bool isSuccess,  RemindersScanResult? result)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RunRemindersScanState() when $default != null:
return $default(_that.flowState,_that.isSuccess,_that.result);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( FlowState? flowState,  bool isSuccess,  RemindersScanResult? result)  $default,) {final _that = this;
switch (_that) {
case _RunRemindersScanState():
return $default(_that.flowState,_that.isSuccess,_that.result);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( FlowState? flowState,  bool isSuccess,  RemindersScanResult? result)?  $default,) {final _that = this;
switch (_that) {
case _RunRemindersScanState() when $default != null:
return $default(_that.flowState,_that.isSuccess,_that.result);case _:
  return null;

}
}

}

/// @nodoc


class _RunRemindersScanState implements RunRemindersScanState {
  const _RunRemindersScanState({this.flowState, this.isSuccess = false, this.result});
  

@override final  FlowState? flowState;
@override@JsonKey() final  bool isSuccess;
@override final  RemindersScanResult? result;

/// Create a copy of RunRemindersScanState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RunRemindersScanStateCopyWith<_RunRemindersScanState> get copyWith => __$RunRemindersScanStateCopyWithImpl<_RunRemindersScanState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RunRemindersScanState&&(identical(other.flowState, flowState) || other.flowState == flowState)&&(identical(other.isSuccess, isSuccess) || other.isSuccess == isSuccess)&&(identical(other.result, result) || other.result == result));
}


@override
int get hashCode => Object.hash(runtimeType,flowState,isSuccess,result);

@override
String toString() {
  return 'RunRemindersScanState(flowState: $flowState, isSuccess: $isSuccess, result: $result)';
}


}

/// @nodoc
abstract mixin class _$RunRemindersScanStateCopyWith<$Res> implements $RunRemindersScanStateCopyWith<$Res> {
  factory _$RunRemindersScanStateCopyWith(_RunRemindersScanState value, $Res Function(_RunRemindersScanState) _then) = __$RunRemindersScanStateCopyWithImpl;
@override @useResult
$Res call({
 FlowState? flowState, bool isSuccess, RemindersScanResult? result
});




}
/// @nodoc
class __$RunRemindersScanStateCopyWithImpl<$Res>
    implements _$RunRemindersScanStateCopyWith<$Res> {
  __$RunRemindersScanStateCopyWithImpl(this._self, this._then);

  final _RunRemindersScanState _self;
  final $Res Function(_RunRemindersScanState) _then;

/// Create a copy of RunRemindersScanState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? flowState = freezed,Object? isSuccess = null,Object? result = freezed,}) {
  return _then(_RunRemindersScanState(
flowState: freezed == flowState ? _self.flowState : flowState // ignore: cast_nullable_to_non_nullable
as FlowState?,isSuccess: null == isSuccess ? _self.isSuccess : isSuccess // ignore: cast_nullable_to_non_nullable
as bool,result: freezed == result ? _self.result : result // ignore: cast_nullable_to_non_nullable
as RemindersScanResult?,
  ));
}


}

// dart format on
