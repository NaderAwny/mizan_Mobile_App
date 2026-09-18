// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'contact_form_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ContactFormState {

 FlowState? get flowState; Contact? get savedContact; bool get isActionSuccess; bool get isEditMode;
/// Create a copy of ContactFormState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ContactFormStateCopyWith<ContactFormState> get copyWith => _$ContactFormStateCopyWithImpl<ContactFormState>(this as ContactFormState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ContactFormState&&(identical(other.flowState, flowState) || other.flowState == flowState)&&(identical(other.savedContact, savedContact) || other.savedContact == savedContact)&&(identical(other.isActionSuccess, isActionSuccess) || other.isActionSuccess == isActionSuccess)&&(identical(other.isEditMode, isEditMode) || other.isEditMode == isEditMode));
}


@override
int get hashCode => Object.hash(runtimeType,flowState,savedContact,isActionSuccess,isEditMode);

@override
String toString() {
  return 'ContactFormState(flowState: $flowState, savedContact: $savedContact, isActionSuccess: $isActionSuccess, isEditMode: $isEditMode)';
}


}

/// @nodoc
abstract mixin class $ContactFormStateCopyWith<$Res>  {
  factory $ContactFormStateCopyWith(ContactFormState value, $Res Function(ContactFormState) _then) = _$ContactFormStateCopyWithImpl;
@useResult
$Res call({
 FlowState? flowState, Contact? savedContact, bool isActionSuccess, bool isEditMode
});




}
/// @nodoc
class _$ContactFormStateCopyWithImpl<$Res>
    implements $ContactFormStateCopyWith<$Res> {
  _$ContactFormStateCopyWithImpl(this._self, this._then);

  final ContactFormState _self;
  final $Res Function(ContactFormState) _then;

/// Create a copy of ContactFormState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? flowState = freezed,Object? savedContact = freezed,Object? isActionSuccess = null,Object? isEditMode = null,}) {
  return _then(_self.copyWith(
flowState: freezed == flowState ? _self.flowState : flowState // ignore: cast_nullable_to_non_nullable
as FlowState?,savedContact: freezed == savedContact ? _self.savedContact : savedContact // ignore: cast_nullable_to_non_nullable
as Contact?,isActionSuccess: null == isActionSuccess ? _self.isActionSuccess : isActionSuccess // ignore: cast_nullable_to_non_nullable
as bool,isEditMode: null == isEditMode ? _self.isEditMode : isEditMode // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ContactFormState].
extension ContactFormStatePatterns on ContactFormState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ContactFormState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ContactFormState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ContactFormState value)  $default,){
final _that = this;
switch (_that) {
case _ContactFormState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ContactFormState value)?  $default,){
final _that = this;
switch (_that) {
case _ContactFormState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( FlowState? flowState,  Contact? savedContact,  bool isActionSuccess,  bool isEditMode)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ContactFormState() when $default != null:
return $default(_that.flowState,_that.savedContact,_that.isActionSuccess,_that.isEditMode);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( FlowState? flowState,  Contact? savedContact,  bool isActionSuccess,  bool isEditMode)  $default,) {final _that = this;
switch (_that) {
case _ContactFormState():
return $default(_that.flowState,_that.savedContact,_that.isActionSuccess,_that.isEditMode);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( FlowState? flowState,  Contact? savedContact,  bool isActionSuccess,  bool isEditMode)?  $default,) {final _that = this;
switch (_that) {
case _ContactFormState() when $default != null:
return $default(_that.flowState,_that.savedContact,_that.isActionSuccess,_that.isEditMode);case _:
  return null;

}
}

}

/// @nodoc


class _ContactFormState implements ContactFormState {
  const _ContactFormState({this.flowState, this.savedContact, this.isActionSuccess = false, this.isEditMode = false});
  

@override final  FlowState? flowState;
@override final  Contact? savedContact;
@override@JsonKey() final  bool isActionSuccess;
@override@JsonKey() final  bool isEditMode;

/// Create a copy of ContactFormState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ContactFormStateCopyWith<_ContactFormState> get copyWith => __$ContactFormStateCopyWithImpl<_ContactFormState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ContactFormState&&(identical(other.flowState, flowState) || other.flowState == flowState)&&(identical(other.savedContact, savedContact) || other.savedContact == savedContact)&&(identical(other.isActionSuccess, isActionSuccess) || other.isActionSuccess == isActionSuccess)&&(identical(other.isEditMode, isEditMode) || other.isEditMode == isEditMode));
}


@override
int get hashCode => Object.hash(runtimeType,flowState,savedContact,isActionSuccess,isEditMode);

@override
String toString() {
  return 'ContactFormState(flowState: $flowState, savedContact: $savedContact, isActionSuccess: $isActionSuccess, isEditMode: $isEditMode)';
}


}

/// @nodoc
abstract mixin class _$ContactFormStateCopyWith<$Res> implements $ContactFormStateCopyWith<$Res> {
  factory _$ContactFormStateCopyWith(_ContactFormState value, $Res Function(_ContactFormState) _then) = __$ContactFormStateCopyWithImpl;
@override @useResult
$Res call({
 FlowState? flowState, Contact? savedContact, bool isActionSuccess, bool isEditMode
});




}
/// @nodoc
class __$ContactFormStateCopyWithImpl<$Res>
    implements _$ContactFormStateCopyWith<$Res> {
  __$ContactFormStateCopyWithImpl(this._self, this._then);

  final _ContactFormState _self;
  final $Res Function(_ContactFormState) _then;

/// Create a copy of ContactFormState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? flowState = freezed,Object? savedContact = freezed,Object? isActionSuccess = null,Object? isEditMode = null,}) {
  return _then(_ContactFormState(
flowState: freezed == flowState ? _self.flowState : flowState // ignore: cast_nullable_to_non_nullable
as FlowState?,savedContact: freezed == savedContact ? _self.savedContact : savedContact // ignore: cast_nullable_to_non_nullable
as Contact?,isActionSuccess: null == isActionSuccess ? _self.isActionSuccess : isActionSuccess // ignore: cast_nullable_to_non_nullable
as bool,isEditMode: null == isEditMode ? _self.isEditMode : isEditMode // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
