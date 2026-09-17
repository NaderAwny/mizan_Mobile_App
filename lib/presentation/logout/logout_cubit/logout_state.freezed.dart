// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'logout_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LogoutState {

 FlowState? get flowState; bool? get isLoggedOut;
/// Create a copy of LogoutState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LogoutStateCopyWith<LogoutState> get copyWith => _$LogoutStateCopyWithImpl<LogoutState>(this as LogoutState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LogoutState&&(identical(other.flowState, flowState) || other.flowState == flowState)&&(identical(other.isLoggedOut, isLoggedOut) || other.isLoggedOut == isLoggedOut));
}


@override
int get hashCode => Object.hash(runtimeType,flowState,isLoggedOut);

@override
String toString() {
  return 'LogoutState(flowState: $flowState, isLoggedOut: $isLoggedOut)';
}


}

/// @nodoc
abstract mixin class $LogoutStateCopyWith<$Res>  {
  factory $LogoutStateCopyWith(LogoutState value, $Res Function(LogoutState) _then) = _$LogoutStateCopyWithImpl;
@useResult
$Res call({
 FlowState? flowState, bool? isLoggedOut
});




}
/// @nodoc
class _$LogoutStateCopyWithImpl<$Res>
    implements $LogoutStateCopyWith<$Res> {
  _$LogoutStateCopyWithImpl(this._self, this._then);

  final LogoutState _self;
  final $Res Function(LogoutState) _then;

/// Create a copy of LogoutState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? flowState = freezed,Object? isLoggedOut = freezed,}) {
  return _then(_self.copyWith(
flowState: freezed == flowState ? _self.flowState : flowState // ignore: cast_nullable_to_non_nullable
as FlowState?,isLoggedOut: freezed == isLoggedOut ? _self.isLoggedOut : isLoggedOut // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [LogoutState].
extension LogoutStatePatterns on LogoutState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LogoutState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LogoutState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LogoutState value)  $default,){
final _that = this;
switch (_that) {
case _LogoutState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LogoutState value)?  $default,){
final _that = this;
switch (_that) {
case _LogoutState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( FlowState? flowState,  bool? isLoggedOut)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LogoutState() when $default != null:
return $default(_that.flowState,_that.isLoggedOut);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( FlowState? flowState,  bool? isLoggedOut)  $default,) {final _that = this;
switch (_that) {
case _LogoutState():
return $default(_that.flowState,_that.isLoggedOut);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( FlowState? flowState,  bool? isLoggedOut)?  $default,) {final _that = this;
switch (_that) {
case _LogoutState() when $default != null:
return $default(_that.flowState,_that.isLoggedOut);case _:
  return null;

}
}

}

/// @nodoc


class _LogoutState implements LogoutState {
  const _LogoutState({this.flowState, this.isLoggedOut});
  

@override final  FlowState? flowState;
@override final  bool? isLoggedOut;

/// Create a copy of LogoutState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LogoutStateCopyWith<_LogoutState> get copyWith => __$LogoutStateCopyWithImpl<_LogoutState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LogoutState&&(identical(other.flowState, flowState) || other.flowState == flowState)&&(identical(other.isLoggedOut, isLoggedOut) || other.isLoggedOut == isLoggedOut));
}


@override
int get hashCode => Object.hash(runtimeType,flowState,isLoggedOut);

@override
String toString() {
  return 'LogoutState(flowState: $flowState, isLoggedOut: $isLoggedOut)';
}


}

/// @nodoc
abstract mixin class _$LogoutStateCopyWith<$Res> implements $LogoutStateCopyWith<$Res> {
  factory _$LogoutStateCopyWith(_LogoutState value, $Res Function(_LogoutState) _then) = __$LogoutStateCopyWithImpl;
@override @useResult
$Res call({
 FlowState? flowState, bool? isLoggedOut
});




}
/// @nodoc
class __$LogoutStateCopyWithImpl<$Res>
    implements _$LogoutStateCopyWith<$Res> {
  __$LogoutStateCopyWithImpl(this._self, this._then);

  final _LogoutState _self;
  final $Res Function(_LogoutState) _then;

/// Create a copy of LogoutState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? flowState = freezed,Object? isLoggedOut = freezed,}) {
  return _then(_LogoutState(
flowState: freezed == flowState ? _self.flowState : flowState // ignore: cast_nullable_to_non_nullable
as FlowState?,isLoggedOut: freezed == isLoggedOut ? _self.isLoggedOut : isLoggedOut // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}

// dart format on
