// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'select_user_type_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SelectUserTypeState {

 FlowState? get flowState; AuthSession? get data; String? get selectedType; bool get shopNameTouched;
/// Create a copy of SelectUserTypeState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SelectUserTypeStateCopyWith<SelectUserTypeState> get copyWith => _$SelectUserTypeStateCopyWithImpl<SelectUserTypeState>(this as SelectUserTypeState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SelectUserTypeState&&(identical(other.flowState, flowState) || other.flowState == flowState)&&(identical(other.data, data) || other.data == data)&&(identical(other.selectedType, selectedType) || other.selectedType == selectedType)&&(identical(other.shopNameTouched, shopNameTouched) || other.shopNameTouched == shopNameTouched));
}


@override
int get hashCode => Object.hash(runtimeType,flowState,data,selectedType,shopNameTouched);

@override
String toString() {
  return 'SelectUserTypeState(flowState: $flowState, data: $data, selectedType: $selectedType, shopNameTouched: $shopNameTouched)';
}


}

/// @nodoc
abstract mixin class $SelectUserTypeStateCopyWith<$Res>  {
  factory $SelectUserTypeStateCopyWith(SelectUserTypeState value, $Res Function(SelectUserTypeState) _then) = _$SelectUserTypeStateCopyWithImpl;
@useResult
$Res call({
 FlowState? flowState, AuthSession? data, String? selectedType, bool shopNameTouched
});




}
/// @nodoc
class _$SelectUserTypeStateCopyWithImpl<$Res>
    implements $SelectUserTypeStateCopyWith<$Res> {
  _$SelectUserTypeStateCopyWithImpl(this._self, this._then);

  final SelectUserTypeState _self;
  final $Res Function(SelectUserTypeState) _then;

/// Create a copy of SelectUserTypeState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? flowState = freezed,Object? data = freezed,Object? selectedType = freezed,Object? shopNameTouched = null,}) {
  return _then(_self.copyWith(
flowState: freezed == flowState ? _self.flowState : flowState // ignore: cast_nullable_to_non_nullable
as FlowState?,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as AuthSession?,selectedType: freezed == selectedType ? _self.selectedType : selectedType // ignore: cast_nullable_to_non_nullable
as String?,shopNameTouched: null == shopNameTouched ? _self.shopNameTouched : shopNameTouched // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [SelectUserTypeState].
extension SelectUserTypeStatePatterns on SelectUserTypeState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SelectUserTypeState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SelectUserTypeState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SelectUserTypeState value)  $default,){
final _that = this;
switch (_that) {
case _SelectUserTypeState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SelectUserTypeState value)?  $default,){
final _that = this;
switch (_that) {
case _SelectUserTypeState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( FlowState? flowState,  AuthSession? data,  String? selectedType,  bool shopNameTouched)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SelectUserTypeState() when $default != null:
return $default(_that.flowState,_that.data,_that.selectedType,_that.shopNameTouched);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( FlowState? flowState,  AuthSession? data,  String? selectedType,  bool shopNameTouched)  $default,) {final _that = this;
switch (_that) {
case _SelectUserTypeState():
return $default(_that.flowState,_that.data,_that.selectedType,_that.shopNameTouched);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( FlowState? flowState,  AuthSession? data,  String? selectedType,  bool shopNameTouched)?  $default,) {final _that = this;
switch (_that) {
case _SelectUserTypeState() when $default != null:
return $default(_that.flowState,_that.data,_that.selectedType,_that.shopNameTouched);case _:
  return null;

}
}

}

/// @nodoc


class _SelectUserTypeState implements SelectUserTypeState {
  const _SelectUserTypeState({this.flowState, this.data, this.selectedType = null, this.shopNameTouched = false});
  

@override final  FlowState? flowState;
@override final  AuthSession? data;
@override@JsonKey() final  String? selectedType;
@override@JsonKey() final  bool shopNameTouched;

/// Create a copy of SelectUserTypeState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SelectUserTypeStateCopyWith<_SelectUserTypeState> get copyWith => __$SelectUserTypeStateCopyWithImpl<_SelectUserTypeState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SelectUserTypeState&&(identical(other.flowState, flowState) || other.flowState == flowState)&&(identical(other.data, data) || other.data == data)&&(identical(other.selectedType, selectedType) || other.selectedType == selectedType)&&(identical(other.shopNameTouched, shopNameTouched) || other.shopNameTouched == shopNameTouched));
}


@override
int get hashCode => Object.hash(runtimeType,flowState,data,selectedType,shopNameTouched);

@override
String toString() {
  return 'SelectUserTypeState(flowState: $flowState, data: $data, selectedType: $selectedType, shopNameTouched: $shopNameTouched)';
}


}

/// @nodoc
abstract mixin class _$SelectUserTypeStateCopyWith<$Res> implements $SelectUserTypeStateCopyWith<$Res> {
  factory _$SelectUserTypeStateCopyWith(_SelectUserTypeState value, $Res Function(_SelectUserTypeState) _then) = __$SelectUserTypeStateCopyWithImpl;
@override @useResult
$Res call({
 FlowState? flowState, AuthSession? data, String? selectedType, bool shopNameTouched
});




}
/// @nodoc
class __$SelectUserTypeStateCopyWithImpl<$Res>
    implements _$SelectUserTypeStateCopyWith<$Res> {
  __$SelectUserTypeStateCopyWithImpl(this._self, this._then);

  final _SelectUserTypeState _self;
  final $Res Function(_SelectUserTypeState) _then;

/// Create a copy of SelectUserTypeState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? flowState = freezed,Object? data = freezed,Object? selectedType = freezed,Object? shopNameTouched = null,}) {
  return _then(_SelectUserTypeState(
flowState: freezed == flowState ? _self.flowState : flowState // ignore: cast_nullable_to_non_nullable
as FlowState?,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as AuthSession?,selectedType: freezed == selectedType ? _self.selectedType : selectedType // ignore: cast_nullable_to_non_nullable
as String?,shopNameTouched: null == shopNameTouched ? _self.shopNameTouched : shopNameTouched // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
