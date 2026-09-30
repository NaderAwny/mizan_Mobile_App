// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'installments_dashboard_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$InstallmentsDashboardState {

 FlowState? get flowState; InstallmentsDashboardModel? get data;
/// Create a copy of InstallmentsDashboardState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InstallmentsDashboardStateCopyWith<InstallmentsDashboardState> get copyWith => _$InstallmentsDashboardStateCopyWithImpl<InstallmentsDashboardState>(this as InstallmentsDashboardState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InstallmentsDashboardState&&(identical(other.flowState, flowState) || other.flowState == flowState)&&(identical(other.data, data) || other.data == data));
}


@override
int get hashCode => Object.hash(runtimeType,flowState,data);

@override
String toString() {
  return 'InstallmentsDashboardState(flowState: $flowState, data: $data)';
}


}

/// @nodoc
abstract mixin class $InstallmentsDashboardStateCopyWith<$Res>  {
  factory $InstallmentsDashboardStateCopyWith(InstallmentsDashboardState value, $Res Function(InstallmentsDashboardState) _then) = _$InstallmentsDashboardStateCopyWithImpl;
@useResult
$Res call({
 FlowState? flowState, InstallmentsDashboardModel? data
});




}
/// @nodoc
class _$InstallmentsDashboardStateCopyWithImpl<$Res>
    implements $InstallmentsDashboardStateCopyWith<$Res> {
  _$InstallmentsDashboardStateCopyWithImpl(this._self, this._then);

  final InstallmentsDashboardState _self;
  final $Res Function(InstallmentsDashboardState) _then;

/// Create a copy of InstallmentsDashboardState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? flowState = freezed,Object? data = freezed,}) {
  return _then(_self.copyWith(
flowState: freezed == flowState ? _self.flowState : flowState // ignore: cast_nullable_to_non_nullable
as FlowState?,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as InstallmentsDashboardModel?,
  ));
}

}


/// Adds pattern-matching-related methods to [InstallmentsDashboardState].
extension InstallmentsDashboardStatePatterns on InstallmentsDashboardState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InstallmentsDashboardState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InstallmentsDashboardState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InstallmentsDashboardState value)  $default,){
final _that = this;
switch (_that) {
case _InstallmentsDashboardState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InstallmentsDashboardState value)?  $default,){
final _that = this;
switch (_that) {
case _InstallmentsDashboardState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( FlowState? flowState,  InstallmentsDashboardModel? data)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InstallmentsDashboardState() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( FlowState? flowState,  InstallmentsDashboardModel? data)  $default,) {final _that = this;
switch (_that) {
case _InstallmentsDashboardState():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( FlowState? flowState,  InstallmentsDashboardModel? data)?  $default,) {final _that = this;
switch (_that) {
case _InstallmentsDashboardState() when $default != null:
return $default(_that.flowState,_that.data);case _:
  return null;

}
}

}

/// @nodoc


class _InstallmentsDashboardState implements InstallmentsDashboardState {
  const _InstallmentsDashboardState({this.flowState, this.data});
  

@override final  FlowState? flowState;
@override final  InstallmentsDashboardModel? data;

/// Create a copy of InstallmentsDashboardState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InstallmentsDashboardStateCopyWith<_InstallmentsDashboardState> get copyWith => __$InstallmentsDashboardStateCopyWithImpl<_InstallmentsDashboardState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InstallmentsDashboardState&&(identical(other.flowState, flowState) || other.flowState == flowState)&&(identical(other.data, data) || other.data == data));
}


@override
int get hashCode => Object.hash(runtimeType,flowState,data);

@override
String toString() {
  return 'InstallmentsDashboardState(flowState: $flowState, data: $data)';
}


}

/// @nodoc
abstract mixin class _$InstallmentsDashboardStateCopyWith<$Res> implements $InstallmentsDashboardStateCopyWith<$Res> {
  factory _$InstallmentsDashboardStateCopyWith(_InstallmentsDashboardState value, $Res Function(_InstallmentsDashboardState) _then) = __$InstallmentsDashboardStateCopyWithImpl;
@override @useResult
$Res call({
 FlowState? flowState, InstallmentsDashboardModel? data
});




}
/// @nodoc
class __$InstallmentsDashboardStateCopyWithImpl<$Res>
    implements _$InstallmentsDashboardStateCopyWith<$Res> {
  __$InstallmentsDashboardStateCopyWithImpl(this._self, this._then);

  final _InstallmentsDashboardState _self;
  final $Res Function(_InstallmentsDashboardState) _then;

/// Create a copy of InstallmentsDashboardState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? flowState = freezed,Object? data = freezed,}) {
  return _then(_InstallmentsDashboardState(
flowState: freezed == flowState ? _self.flowState : flowState // ignore: cast_nullable_to_non_nullable
as FlowState?,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as InstallmentsDashboardModel?,
  ));
}


}

// dart format on
