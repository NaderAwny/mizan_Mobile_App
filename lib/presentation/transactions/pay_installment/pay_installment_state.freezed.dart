// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pay_installment_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PayInstallmentState {

 FlowState? get flowState; bool get isSuccess; TransactionbyidModel? get updatedTransaction;
/// Create a copy of PayInstallmentState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PayInstallmentStateCopyWith<PayInstallmentState> get copyWith => _$PayInstallmentStateCopyWithImpl<PayInstallmentState>(this as PayInstallmentState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PayInstallmentState&&(identical(other.flowState, flowState) || other.flowState == flowState)&&(identical(other.isSuccess, isSuccess) || other.isSuccess == isSuccess)&&(identical(other.updatedTransaction, updatedTransaction) || other.updatedTransaction == updatedTransaction));
}


@override
int get hashCode => Object.hash(runtimeType,flowState,isSuccess,updatedTransaction);

@override
String toString() {
  return 'PayInstallmentState(flowState: $flowState, isSuccess: $isSuccess, updatedTransaction: $updatedTransaction)';
}


}

/// @nodoc
abstract mixin class $PayInstallmentStateCopyWith<$Res>  {
  factory $PayInstallmentStateCopyWith(PayInstallmentState value, $Res Function(PayInstallmentState) _then) = _$PayInstallmentStateCopyWithImpl;
@useResult
$Res call({
 FlowState? flowState, bool isSuccess, TransactionbyidModel? updatedTransaction
});




}
/// @nodoc
class _$PayInstallmentStateCopyWithImpl<$Res>
    implements $PayInstallmentStateCopyWith<$Res> {
  _$PayInstallmentStateCopyWithImpl(this._self, this._then);

  final PayInstallmentState _self;
  final $Res Function(PayInstallmentState) _then;

/// Create a copy of PayInstallmentState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? flowState = freezed,Object? isSuccess = null,Object? updatedTransaction = freezed,}) {
  return _then(_self.copyWith(
flowState: freezed == flowState ? _self.flowState : flowState // ignore: cast_nullable_to_non_nullable
as FlowState?,isSuccess: null == isSuccess ? _self.isSuccess : isSuccess // ignore: cast_nullable_to_non_nullable
as bool,updatedTransaction: freezed == updatedTransaction ? _self.updatedTransaction : updatedTransaction // ignore: cast_nullable_to_non_nullable
as TransactionbyidModel?,
  ));
}

}


/// Adds pattern-matching-related methods to [PayInstallmentState].
extension PayInstallmentStatePatterns on PayInstallmentState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PayInstallmentState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PayInstallmentState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PayInstallmentState value)  $default,){
final _that = this;
switch (_that) {
case _PayInstallmentState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PayInstallmentState value)?  $default,){
final _that = this;
switch (_that) {
case _PayInstallmentState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( FlowState? flowState,  bool isSuccess,  TransactionbyidModel? updatedTransaction)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PayInstallmentState() when $default != null:
return $default(_that.flowState,_that.isSuccess,_that.updatedTransaction);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( FlowState? flowState,  bool isSuccess,  TransactionbyidModel? updatedTransaction)  $default,) {final _that = this;
switch (_that) {
case _PayInstallmentState():
return $default(_that.flowState,_that.isSuccess,_that.updatedTransaction);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( FlowState? flowState,  bool isSuccess,  TransactionbyidModel? updatedTransaction)?  $default,) {final _that = this;
switch (_that) {
case _PayInstallmentState() when $default != null:
return $default(_that.flowState,_that.isSuccess,_that.updatedTransaction);case _:
  return null;

}
}

}

/// @nodoc


class _PayInstallmentState implements PayInstallmentState {
  const _PayInstallmentState({this.flowState, this.isSuccess = false, this.updatedTransaction});
  

@override final  FlowState? flowState;
@override@JsonKey() final  bool isSuccess;
@override final  TransactionbyidModel? updatedTransaction;

/// Create a copy of PayInstallmentState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PayInstallmentStateCopyWith<_PayInstallmentState> get copyWith => __$PayInstallmentStateCopyWithImpl<_PayInstallmentState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PayInstallmentState&&(identical(other.flowState, flowState) || other.flowState == flowState)&&(identical(other.isSuccess, isSuccess) || other.isSuccess == isSuccess)&&(identical(other.updatedTransaction, updatedTransaction) || other.updatedTransaction == updatedTransaction));
}


@override
int get hashCode => Object.hash(runtimeType,flowState,isSuccess,updatedTransaction);

@override
String toString() {
  return 'PayInstallmentState(flowState: $flowState, isSuccess: $isSuccess, updatedTransaction: $updatedTransaction)';
}


}

/// @nodoc
abstract mixin class _$PayInstallmentStateCopyWith<$Res> implements $PayInstallmentStateCopyWith<$Res> {
  factory _$PayInstallmentStateCopyWith(_PayInstallmentState value, $Res Function(_PayInstallmentState) _then) = __$PayInstallmentStateCopyWithImpl;
@override @useResult
$Res call({
 FlowState? flowState, bool isSuccess, TransactionbyidModel? updatedTransaction
});




}
/// @nodoc
class __$PayInstallmentStateCopyWithImpl<$Res>
    implements _$PayInstallmentStateCopyWith<$Res> {
  __$PayInstallmentStateCopyWithImpl(this._self, this._then);

  final _PayInstallmentState _self;
  final $Res Function(_PayInstallmentState) _then;

/// Create a copy of PayInstallmentState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? flowState = freezed,Object? isSuccess = null,Object? updatedTransaction = freezed,}) {
  return _then(_PayInstallmentState(
flowState: freezed == flowState ? _self.flowState : flowState // ignore: cast_nullable_to_non_nullable
as FlowState?,isSuccess: null == isSuccess ? _self.isSuccess : isSuccess // ignore: cast_nullable_to_non_nullable
as bool,updatedTransaction: freezed == updatedTransaction ? _self.updatedTransaction : updatedTransaction // ignore: cast_nullable_to_non_nullable
as TransactionbyidModel?,
  ));
}


}

// dart format on
