// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'send_otp_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SendOtpState {

 FlowState? get flowState; String get email; bool get isEmailValid; bool get isAllValid; bool get sendOtpSuccess;
/// Create a copy of SendOtpState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SendOtpStateCopyWith<SendOtpState> get copyWith => _$SendOtpStateCopyWithImpl<SendOtpState>(this as SendOtpState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SendOtpState&&(identical(other.flowState, flowState) || other.flowState == flowState)&&(identical(other.email, email) || other.email == email)&&(identical(other.isEmailValid, isEmailValid) || other.isEmailValid == isEmailValid)&&(identical(other.isAllValid, isAllValid) || other.isAllValid == isAllValid)&&(identical(other.sendOtpSuccess, sendOtpSuccess) || other.sendOtpSuccess == sendOtpSuccess));
}


@override
int get hashCode => Object.hash(runtimeType,flowState,email,isEmailValid,isAllValid,sendOtpSuccess);

@override
String toString() {
  return 'SendOtpState(flowState: $flowState, email: $email, isEmailValid: $isEmailValid, isAllValid: $isAllValid, sendOtpSuccess: $sendOtpSuccess)';
}


}

/// @nodoc
abstract mixin class $SendOtpStateCopyWith<$Res>  {
  factory $SendOtpStateCopyWith(SendOtpState value, $Res Function(SendOtpState) _then) = _$SendOtpStateCopyWithImpl;
@useResult
$Res call({
 FlowState? flowState, String email, bool isEmailValid, bool isAllValid, bool sendOtpSuccess
});




}
/// @nodoc
class _$SendOtpStateCopyWithImpl<$Res>
    implements $SendOtpStateCopyWith<$Res> {
  _$SendOtpStateCopyWithImpl(this._self, this._then);

  final SendOtpState _self;
  final $Res Function(SendOtpState) _then;

/// Create a copy of SendOtpState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? flowState = freezed,Object? email = null,Object? isEmailValid = null,Object? isAllValid = null,Object? sendOtpSuccess = null,}) {
  return _then(_self.copyWith(
flowState: freezed == flowState ? _self.flowState : flowState // ignore: cast_nullable_to_non_nullable
as FlowState?,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,isEmailValid: null == isEmailValid ? _self.isEmailValid : isEmailValid // ignore: cast_nullable_to_non_nullable
as bool,isAllValid: null == isAllValid ? _self.isAllValid : isAllValid // ignore: cast_nullable_to_non_nullable
as bool,sendOtpSuccess: null == sendOtpSuccess ? _self.sendOtpSuccess : sendOtpSuccess // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [SendOtpState].
extension SendOtpStatePatterns on SendOtpState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SendOtpState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SendOtpState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SendOtpState value)  $default,){
final _that = this;
switch (_that) {
case _SendOtpState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SendOtpState value)?  $default,){
final _that = this;
switch (_that) {
case _SendOtpState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( FlowState? flowState,  String email,  bool isEmailValid,  bool isAllValid,  bool sendOtpSuccess)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SendOtpState() when $default != null:
return $default(_that.flowState,_that.email,_that.isEmailValid,_that.isAllValid,_that.sendOtpSuccess);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( FlowState? flowState,  String email,  bool isEmailValid,  bool isAllValid,  bool sendOtpSuccess)  $default,) {final _that = this;
switch (_that) {
case _SendOtpState():
return $default(_that.flowState,_that.email,_that.isEmailValid,_that.isAllValid,_that.sendOtpSuccess);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( FlowState? flowState,  String email,  bool isEmailValid,  bool isAllValid,  bool sendOtpSuccess)?  $default,) {final _that = this;
switch (_that) {
case _SendOtpState() when $default != null:
return $default(_that.flowState,_that.email,_that.isEmailValid,_that.isAllValid,_that.sendOtpSuccess);case _:
  return null;

}
}

}

/// @nodoc


class _SendOtpState implements SendOtpState {
  const _SendOtpState({this.flowState, this.email = '', this.isEmailValid = false, this.isAllValid = false, this.sendOtpSuccess = false});
  

@override final  FlowState? flowState;
@override@JsonKey() final  String email;
@override@JsonKey() final  bool isEmailValid;
@override@JsonKey() final  bool isAllValid;
@override@JsonKey() final  bool sendOtpSuccess;

/// Create a copy of SendOtpState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SendOtpStateCopyWith<_SendOtpState> get copyWith => __$SendOtpStateCopyWithImpl<_SendOtpState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SendOtpState&&(identical(other.flowState, flowState) || other.flowState == flowState)&&(identical(other.email, email) || other.email == email)&&(identical(other.isEmailValid, isEmailValid) || other.isEmailValid == isEmailValid)&&(identical(other.isAllValid, isAllValid) || other.isAllValid == isAllValid)&&(identical(other.sendOtpSuccess, sendOtpSuccess) || other.sendOtpSuccess == sendOtpSuccess));
}


@override
int get hashCode => Object.hash(runtimeType,flowState,email,isEmailValid,isAllValid,sendOtpSuccess);

@override
String toString() {
  return 'SendOtpState(flowState: $flowState, email: $email, isEmailValid: $isEmailValid, isAllValid: $isAllValid, sendOtpSuccess: $sendOtpSuccess)';
}


}

/// @nodoc
abstract mixin class _$SendOtpStateCopyWith<$Res> implements $SendOtpStateCopyWith<$Res> {
  factory _$SendOtpStateCopyWith(_SendOtpState value, $Res Function(_SendOtpState) _then) = __$SendOtpStateCopyWithImpl;
@override @useResult
$Res call({
 FlowState? flowState, String email, bool isEmailValid, bool isAllValid, bool sendOtpSuccess
});




}
/// @nodoc
class __$SendOtpStateCopyWithImpl<$Res>
    implements _$SendOtpStateCopyWith<$Res> {
  __$SendOtpStateCopyWithImpl(this._self, this._then);

  final _SendOtpState _self;
  final $Res Function(_SendOtpState) _then;

/// Create a copy of SendOtpState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? flowState = freezed,Object? email = null,Object? isEmailValid = null,Object? isAllValid = null,Object? sendOtpSuccess = null,}) {
  return _then(_SendOtpState(
flowState: freezed == flowState ? _self.flowState : flowState // ignore: cast_nullable_to_non_nullable
as FlowState?,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,isEmailValid: null == isEmailValid ? _self.isEmailValid : isEmailValid // ignore: cast_nullable_to_non_nullable
as bool,isAllValid: null == isAllValid ? _self.isAllValid : isAllValid // ignore: cast_nullable_to_non_nullable
as bool,sendOtpSuccess: null == sendOtpSuccess ? _self.sendOtpSuccess : sendOtpSuccess // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
