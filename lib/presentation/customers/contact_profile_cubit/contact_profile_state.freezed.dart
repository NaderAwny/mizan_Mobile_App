// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'contact_profile_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ContactProfileState {

 FlowState? get flowState; ContactProfile? get data; bool get isDeleted;
/// Create a copy of ContactProfileState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ContactProfileStateCopyWith<ContactProfileState> get copyWith => _$ContactProfileStateCopyWithImpl<ContactProfileState>(this as ContactProfileState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ContactProfileState&&(identical(other.flowState, flowState) || other.flowState == flowState)&&(identical(other.data, data) || other.data == data)&&(identical(other.isDeleted, isDeleted) || other.isDeleted == isDeleted));
}


@override
int get hashCode => Object.hash(runtimeType,flowState,data,isDeleted);

@override
String toString() {
  return 'ContactProfileState(flowState: $flowState, data: $data, isDeleted: $isDeleted)';
}


}

/// @nodoc
abstract mixin class $ContactProfileStateCopyWith<$Res>  {
  factory $ContactProfileStateCopyWith(ContactProfileState value, $Res Function(ContactProfileState) _then) = _$ContactProfileStateCopyWithImpl;
@useResult
$Res call({
 FlowState? flowState, ContactProfile? data, bool isDeleted
});




}
/// @nodoc
class _$ContactProfileStateCopyWithImpl<$Res>
    implements $ContactProfileStateCopyWith<$Res> {
  _$ContactProfileStateCopyWithImpl(this._self, this._then);

  final ContactProfileState _self;
  final $Res Function(ContactProfileState) _then;

/// Create a copy of ContactProfileState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? flowState = freezed,Object? data = freezed,Object? isDeleted = null,}) {
  return _then(_self.copyWith(
flowState: freezed == flowState ? _self.flowState : flowState // ignore: cast_nullable_to_non_nullable
as FlowState?,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as ContactProfile?,isDeleted: null == isDeleted ? _self.isDeleted : isDeleted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ContactProfileState].
extension ContactProfileStatePatterns on ContactProfileState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ContactProfileState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ContactProfileState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ContactProfileState value)  $default,){
final _that = this;
switch (_that) {
case _ContactProfileState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ContactProfileState value)?  $default,){
final _that = this;
switch (_that) {
case _ContactProfileState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( FlowState? flowState,  ContactProfile? data,  bool isDeleted)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ContactProfileState() when $default != null:
return $default(_that.flowState,_that.data,_that.isDeleted);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( FlowState? flowState,  ContactProfile? data,  bool isDeleted)  $default,) {final _that = this;
switch (_that) {
case _ContactProfileState():
return $default(_that.flowState,_that.data,_that.isDeleted);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( FlowState? flowState,  ContactProfile? data,  bool isDeleted)?  $default,) {final _that = this;
switch (_that) {
case _ContactProfileState() when $default != null:
return $default(_that.flowState,_that.data,_that.isDeleted);case _:
  return null;

}
}

}

/// @nodoc


class _ContactProfileState implements ContactProfileState {
  const _ContactProfileState({this.flowState, this.data, this.isDeleted = false});
  

@override final  FlowState? flowState;
@override final  ContactProfile? data;
@override@JsonKey() final  bool isDeleted;

/// Create a copy of ContactProfileState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ContactProfileStateCopyWith<_ContactProfileState> get copyWith => __$ContactProfileStateCopyWithImpl<_ContactProfileState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ContactProfileState&&(identical(other.flowState, flowState) || other.flowState == flowState)&&(identical(other.data, data) || other.data == data)&&(identical(other.isDeleted, isDeleted) || other.isDeleted == isDeleted));
}


@override
int get hashCode => Object.hash(runtimeType,flowState,data,isDeleted);

@override
String toString() {
  return 'ContactProfileState(flowState: $flowState, data: $data, isDeleted: $isDeleted)';
}


}

/// @nodoc
abstract mixin class _$ContactProfileStateCopyWith<$Res> implements $ContactProfileStateCopyWith<$Res> {
  factory _$ContactProfileStateCopyWith(_ContactProfileState value, $Res Function(_ContactProfileState) _then) = __$ContactProfileStateCopyWithImpl;
@override @useResult
$Res call({
 FlowState? flowState, ContactProfile? data, bool isDeleted
});




}
/// @nodoc
class __$ContactProfileStateCopyWithImpl<$Res>
    implements _$ContactProfileStateCopyWith<$Res> {
  __$ContactProfileStateCopyWithImpl(this._self, this._then);

  final _ContactProfileState _self;
  final $Res Function(_ContactProfileState) _then;

/// Create a copy of ContactProfileState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? flowState = freezed,Object? data = freezed,Object? isDeleted = null,}) {
  return _then(_ContactProfileState(
flowState: freezed == flowState ? _self.flowState : flowState // ignore: cast_nullable_to_non_nullable
as FlowState?,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as ContactProfile?,isDeleted: null == isDeleted ? _self.isDeleted : isDeleted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
