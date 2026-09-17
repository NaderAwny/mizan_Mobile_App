// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'register_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RegisterState {

 FlowState? get flowState; String get email; String get lastName; String get firstName; bool get isEmailValid; bool get isLastNameValid; bool get isFirstNameValid; bool get isAllValid; bool get registerSuccess;
/// Create a copy of RegisterState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RegisterStateCopyWith<RegisterState> get copyWith => _$RegisterStateCopyWithImpl<RegisterState>(this as RegisterState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RegisterState&&(identical(other.flowState, flowState) || other.flowState == flowState)&&(identical(other.email, email) || other.email == email)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.isEmailValid, isEmailValid) || other.isEmailValid == isEmailValid)&&(identical(other.isLastNameValid, isLastNameValid) || other.isLastNameValid == isLastNameValid)&&(identical(other.isFirstNameValid, isFirstNameValid) || other.isFirstNameValid == isFirstNameValid)&&(identical(other.isAllValid, isAllValid) || other.isAllValid == isAllValid)&&(identical(other.registerSuccess, registerSuccess) || other.registerSuccess == registerSuccess));
}


@override
int get hashCode => Object.hash(runtimeType,flowState,email,lastName,firstName,isEmailValid,isLastNameValid,isFirstNameValid,isAllValid,registerSuccess);

@override
String toString() {
  return 'RegisterState(flowState: $flowState, email: $email, lastName: $lastName, firstName: $firstName, isEmailValid: $isEmailValid, isLastNameValid: $isLastNameValid, isFirstNameValid: $isFirstNameValid, isAllValid: $isAllValid, registerSuccess: $registerSuccess)';
}


}

/// @nodoc
abstract mixin class $RegisterStateCopyWith<$Res>  {
  factory $RegisterStateCopyWith(RegisterState value, $Res Function(RegisterState) _then) = _$RegisterStateCopyWithImpl;
@useResult
$Res call({
 FlowState? flowState, String email, String lastName, String firstName, bool isEmailValid, bool isLastNameValid, bool isFirstNameValid, bool isAllValid, bool registerSuccess
});




}
/// @nodoc
class _$RegisterStateCopyWithImpl<$Res>
    implements $RegisterStateCopyWith<$Res> {
  _$RegisterStateCopyWithImpl(this._self, this._then);

  final RegisterState _self;
  final $Res Function(RegisterState) _then;

/// Create a copy of RegisterState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? flowState = freezed,Object? email = null,Object? lastName = null,Object? firstName = null,Object? isEmailValid = null,Object? isLastNameValid = null,Object? isFirstNameValid = null,Object? isAllValid = null,Object? registerSuccess = null,}) {
  return _then(_self.copyWith(
flowState: freezed == flowState ? _self.flowState : flowState // ignore: cast_nullable_to_non_nullable
as FlowState?,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,lastName: null == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String,firstName: null == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String,isEmailValid: null == isEmailValid ? _self.isEmailValid : isEmailValid // ignore: cast_nullable_to_non_nullable
as bool,isLastNameValid: null == isLastNameValid ? _self.isLastNameValid : isLastNameValid // ignore: cast_nullable_to_non_nullable
as bool,isFirstNameValid: null == isFirstNameValid ? _self.isFirstNameValid : isFirstNameValid // ignore: cast_nullable_to_non_nullable
as bool,isAllValid: null == isAllValid ? _self.isAllValid : isAllValid // ignore: cast_nullable_to_non_nullable
as bool,registerSuccess: null == registerSuccess ? _self.registerSuccess : registerSuccess // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [RegisterState].
extension RegisterStatePatterns on RegisterState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RegisterState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RegisterState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RegisterState value)  $default,){
final _that = this;
switch (_that) {
case _RegisterState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RegisterState value)?  $default,){
final _that = this;
switch (_that) {
case _RegisterState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( FlowState? flowState,  String email,  String lastName,  String firstName,  bool isEmailValid,  bool isLastNameValid,  bool isFirstNameValid,  bool isAllValid,  bool registerSuccess)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RegisterState() when $default != null:
return $default(_that.flowState,_that.email,_that.lastName,_that.firstName,_that.isEmailValid,_that.isLastNameValid,_that.isFirstNameValid,_that.isAllValid,_that.registerSuccess);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( FlowState? flowState,  String email,  String lastName,  String firstName,  bool isEmailValid,  bool isLastNameValid,  bool isFirstNameValid,  bool isAllValid,  bool registerSuccess)  $default,) {final _that = this;
switch (_that) {
case _RegisterState():
return $default(_that.flowState,_that.email,_that.lastName,_that.firstName,_that.isEmailValid,_that.isLastNameValid,_that.isFirstNameValid,_that.isAllValid,_that.registerSuccess);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( FlowState? flowState,  String email,  String lastName,  String firstName,  bool isEmailValid,  bool isLastNameValid,  bool isFirstNameValid,  bool isAllValid,  bool registerSuccess)?  $default,) {final _that = this;
switch (_that) {
case _RegisterState() when $default != null:
return $default(_that.flowState,_that.email,_that.lastName,_that.firstName,_that.isEmailValid,_that.isLastNameValid,_that.isFirstNameValid,_that.isAllValid,_that.registerSuccess);case _:
  return null;

}
}

}

/// @nodoc


class _RegisterState implements RegisterState {
  const _RegisterState({this.flowState, this.email = '', this.lastName = '', this.firstName = '', this.isEmailValid = false, this.isLastNameValid = false, this.isFirstNameValid = false, this.isAllValid = false, this.registerSuccess = false});
  

@override final  FlowState? flowState;
@override@JsonKey() final  String email;
@override@JsonKey() final  String lastName;
@override@JsonKey() final  String firstName;
@override@JsonKey() final  bool isEmailValid;
@override@JsonKey() final  bool isLastNameValid;
@override@JsonKey() final  bool isFirstNameValid;
@override@JsonKey() final  bool isAllValid;
@override@JsonKey() final  bool registerSuccess;

/// Create a copy of RegisterState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RegisterStateCopyWith<_RegisterState> get copyWith => __$RegisterStateCopyWithImpl<_RegisterState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RegisterState&&(identical(other.flowState, flowState) || other.flowState == flowState)&&(identical(other.email, email) || other.email == email)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.isEmailValid, isEmailValid) || other.isEmailValid == isEmailValid)&&(identical(other.isLastNameValid, isLastNameValid) || other.isLastNameValid == isLastNameValid)&&(identical(other.isFirstNameValid, isFirstNameValid) || other.isFirstNameValid == isFirstNameValid)&&(identical(other.isAllValid, isAllValid) || other.isAllValid == isAllValid)&&(identical(other.registerSuccess, registerSuccess) || other.registerSuccess == registerSuccess));
}


@override
int get hashCode => Object.hash(runtimeType,flowState,email,lastName,firstName,isEmailValid,isLastNameValid,isFirstNameValid,isAllValid,registerSuccess);

@override
String toString() {
  return 'RegisterState(flowState: $flowState, email: $email, lastName: $lastName, firstName: $firstName, isEmailValid: $isEmailValid, isLastNameValid: $isLastNameValid, isFirstNameValid: $isFirstNameValid, isAllValid: $isAllValid, registerSuccess: $registerSuccess)';
}


}

/// @nodoc
abstract mixin class _$RegisterStateCopyWith<$Res> implements $RegisterStateCopyWith<$Res> {
  factory _$RegisterStateCopyWith(_RegisterState value, $Res Function(_RegisterState) _then) = __$RegisterStateCopyWithImpl;
@override @useResult
$Res call({
 FlowState? flowState, String email, String lastName, String firstName, bool isEmailValid, bool isLastNameValid, bool isFirstNameValid, bool isAllValid, bool registerSuccess
});




}
/// @nodoc
class __$RegisterStateCopyWithImpl<$Res>
    implements _$RegisterStateCopyWith<$Res> {
  __$RegisterStateCopyWithImpl(this._self, this._then);

  final _RegisterState _self;
  final $Res Function(_RegisterState) _then;

/// Create a copy of RegisterState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? flowState = freezed,Object? email = null,Object? lastName = null,Object? firstName = null,Object? isEmailValid = null,Object? isLastNameValid = null,Object? isFirstNameValid = null,Object? isAllValid = null,Object? registerSuccess = null,}) {
  return _then(_RegisterState(
flowState: freezed == flowState ? _self.flowState : flowState // ignore: cast_nullable_to_non_nullable
as FlowState?,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,lastName: null == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String,firstName: null == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String,isEmailValid: null == isEmailValid ? _self.isEmailValid : isEmailValid // ignore: cast_nullable_to_non_nullable
as bool,isLastNameValid: null == isLastNameValid ? _self.isLastNameValid : isLastNameValid // ignore: cast_nullable_to_non_nullable
as bool,isFirstNameValid: null == isFirstNameValid ? _self.isFirstNameValid : isFirstNameValid // ignore: cast_nullable_to_non_nullable
as bool,isAllValid: null == isAllValid ? _self.isAllValid : isAllValid // ignore: cast_nullable_to_non_nullable
as bool,registerSuccess: null == registerSuccess ? _self.registerSuccess : registerSuccess // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
