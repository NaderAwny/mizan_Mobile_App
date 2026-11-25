// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transaction_form_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TransactionFormState {

 FlowState? get flowState; Transaction? get savedTransaction; bool get isActionSuccess; String? get selectedContactId; String? get selectedPartyName; bool get isPartyVip; DateTime? get transactionDate; bool get isCash; bool get isInstallment; String get installmentPlanMode; int get installmentCount; String get frequency; DateTime? get firstInstallmentDate;
/// Create a copy of TransactionFormState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TransactionFormStateCopyWith<TransactionFormState> get copyWith => _$TransactionFormStateCopyWithImpl<TransactionFormState>(this as TransactionFormState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TransactionFormState&&(identical(other.flowState, flowState) || other.flowState == flowState)&&(identical(other.savedTransaction, savedTransaction) || other.savedTransaction == savedTransaction)&&(identical(other.isActionSuccess, isActionSuccess) || other.isActionSuccess == isActionSuccess)&&(identical(other.selectedContactId, selectedContactId) || other.selectedContactId == selectedContactId)&&(identical(other.selectedPartyName, selectedPartyName) || other.selectedPartyName == selectedPartyName)&&(identical(other.isPartyVip, isPartyVip) || other.isPartyVip == isPartyVip)&&(identical(other.transactionDate, transactionDate) || other.transactionDate == transactionDate)&&(identical(other.isCash, isCash) || other.isCash == isCash)&&(identical(other.isInstallment, isInstallment) || other.isInstallment == isInstallment)&&(identical(other.installmentPlanMode, installmentPlanMode) || other.installmentPlanMode == installmentPlanMode)&&(identical(other.installmentCount, installmentCount) || other.installmentCount == installmentCount)&&(identical(other.frequency, frequency) || other.frequency == frequency)&&(identical(other.firstInstallmentDate, firstInstallmentDate) || other.firstInstallmentDate == firstInstallmentDate));
}


@override
int get hashCode => Object.hash(runtimeType,flowState,savedTransaction,isActionSuccess,selectedContactId,selectedPartyName,isPartyVip,transactionDate,isCash,isInstallment,installmentPlanMode,installmentCount,frequency,firstInstallmentDate);

@override
String toString() {
  return 'TransactionFormState(flowState: $flowState, savedTransaction: $savedTransaction, isActionSuccess: $isActionSuccess, selectedContactId: $selectedContactId, selectedPartyName: $selectedPartyName, isPartyVip: $isPartyVip, transactionDate: $transactionDate, isCash: $isCash, isInstallment: $isInstallment, installmentPlanMode: $installmentPlanMode, installmentCount: $installmentCount, frequency: $frequency, firstInstallmentDate: $firstInstallmentDate)';
}


}

/// @nodoc
abstract mixin class $TransactionFormStateCopyWith<$Res>  {
  factory $TransactionFormStateCopyWith(TransactionFormState value, $Res Function(TransactionFormState) _then) = _$TransactionFormStateCopyWithImpl;
@useResult
$Res call({
 FlowState? flowState, Transaction? savedTransaction, bool isActionSuccess, String? selectedContactId, String? selectedPartyName, bool isPartyVip, DateTime? transactionDate, bool isCash, bool isInstallment, String installmentPlanMode, int installmentCount, String frequency, DateTime? firstInstallmentDate
});




}
/// @nodoc
class _$TransactionFormStateCopyWithImpl<$Res>
    implements $TransactionFormStateCopyWith<$Res> {
  _$TransactionFormStateCopyWithImpl(this._self, this._then);

  final TransactionFormState _self;
  final $Res Function(TransactionFormState) _then;

/// Create a copy of TransactionFormState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? flowState = freezed,Object? savedTransaction = freezed,Object? isActionSuccess = null,Object? selectedContactId = freezed,Object? selectedPartyName = freezed,Object? isPartyVip = null,Object? transactionDate = freezed,Object? isCash = null,Object? isInstallment = null,Object? installmentPlanMode = null,Object? installmentCount = null,Object? frequency = null,Object? firstInstallmentDate = freezed,}) {
  return _then(_self.copyWith(
flowState: freezed == flowState ? _self.flowState : flowState // ignore: cast_nullable_to_non_nullable
as FlowState?,savedTransaction: freezed == savedTransaction ? _self.savedTransaction : savedTransaction // ignore: cast_nullable_to_non_nullable
as Transaction?,isActionSuccess: null == isActionSuccess ? _self.isActionSuccess : isActionSuccess // ignore: cast_nullable_to_non_nullable
as bool,selectedContactId: freezed == selectedContactId ? _self.selectedContactId : selectedContactId // ignore: cast_nullable_to_non_nullable
as String?,selectedPartyName: freezed == selectedPartyName ? _self.selectedPartyName : selectedPartyName // ignore: cast_nullable_to_non_nullable
as String?,isPartyVip: null == isPartyVip ? _self.isPartyVip : isPartyVip // ignore: cast_nullable_to_non_nullable
as bool,transactionDate: freezed == transactionDate ? _self.transactionDate : transactionDate // ignore: cast_nullable_to_non_nullable
as DateTime?,isCash: null == isCash ? _self.isCash : isCash // ignore: cast_nullable_to_non_nullable
as bool,isInstallment: null == isInstallment ? _self.isInstallment : isInstallment // ignore: cast_nullable_to_non_nullable
as bool,installmentPlanMode: null == installmentPlanMode ? _self.installmentPlanMode : installmentPlanMode // ignore: cast_nullable_to_non_nullable
as String,installmentCount: null == installmentCount ? _self.installmentCount : installmentCount // ignore: cast_nullable_to_non_nullable
as int,frequency: null == frequency ? _self.frequency : frequency // ignore: cast_nullable_to_non_nullable
as String,firstInstallmentDate: freezed == firstInstallmentDate ? _self.firstInstallmentDate : firstInstallmentDate // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [TransactionFormState].
extension TransactionFormStatePatterns on TransactionFormState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TransactionFormState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TransactionFormState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TransactionFormState value)  $default,){
final _that = this;
switch (_that) {
case _TransactionFormState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TransactionFormState value)?  $default,){
final _that = this;
switch (_that) {
case _TransactionFormState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( FlowState? flowState,  Transaction? savedTransaction,  bool isActionSuccess,  String? selectedContactId,  String? selectedPartyName,  bool isPartyVip,  DateTime? transactionDate,  bool isCash,  bool isInstallment,  String installmentPlanMode,  int installmentCount,  String frequency,  DateTime? firstInstallmentDate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TransactionFormState() when $default != null:
return $default(_that.flowState,_that.savedTransaction,_that.isActionSuccess,_that.selectedContactId,_that.selectedPartyName,_that.isPartyVip,_that.transactionDate,_that.isCash,_that.isInstallment,_that.installmentPlanMode,_that.installmentCount,_that.frequency,_that.firstInstallmentDate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( FlowState? flowState,  Transaction? savedTransaction,  bool isActionSuccess,  String? selectedContactId,  String? selectedPartyName,  bool isPartyVip,  DateTime? transactionDate,  bool isCash,  bool isInstallment,  String installmentPlanMode,  int installmentCount,  String frequency,  DateTime? firstInstallmentDate)  $default,) {final _that = this;
switch (_that) {
case _TransactionFormState():
return $default(_that.flowState,_that.savedTransaction,_that.isActionSuccess,_that.selectedContactId,_that.selectedPartyName,_that.isPartyVip,_that.transactionDate,_that.isCash,_that.isInstallment,_that.installmentPlanMode,_that.installmentCount,_that.frequency,_that.firstInstallmentDate);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( FlowState? flowState,  Transaction? savedTransaction,  bool isActionSuccess,  String? selectedContactId,  String? selectedPartyName,  bool isPartyVip,  DateTime? transactionDate,  bool isCash,  bool isInstallment,  String installmentPlanMode,  int installmentCount,  String frequency,  DateTime? firstInstallmentDate)?  $default,) {final _that = this;
switch (_that) {
case _TransactionFormState() when $default != null:
return $default(_that.flowState,_that.savedTransaction,_that.isActionSuccess,_that.selectedContactId,_that.selectedPartyName,_that.isPartyVip,_that.transactionDate,_that.isCash,_that.isInstallment,_that.installmentPlanMode,_that.installmentCount,_that.frequency,_that.firstInstallmentDate);case _:
  return null;

}
}

}

/// @nodoc


class _TransactionFormState implements TransactionFormState {
  const _TransactionFormState({this.flowState, this.savedTransaction, this.isActionSuccess = false, this.selectedContactId, this.selectedPartyName, this.isPartyVip = false, this.transactionDate, this.isCash = true, this.isInstallment = false, this.installmentPlanMode = "Automatic", this.installmentCount = 3, this.frequency = "Monthly", this.firstInstallmentDate});
  

@override final  FlowState? flowState;
@override final  Transaction? savedTransaction;
@override@JsonKey() final  bool isActionSuccess;
@override final  String? selectedContactId;
@override final  String? selectedPartyName;
@override@JsonKey() final  bool isPartyVip;
@override final  DateTime? transactionDate;
@override@JsonKey() final  bool isCash;
@override@JsonKey() final  bool isInstallment;
@override@JsonKey() final  String installmentPlanMode;
@override@JsonKey() final  int installmentCount;
@override@JsonKey() final  String frequency;
@override final  DateTime? firstInstallmentDate;

/// Create a copy of TransactionFormState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TransactionFormStateCopyWith<_TransactionFormState> get copyWith => __$TransactionFormStateCopyWithImpl<_TransactionFormState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TransactionFormState&&(identical(other.flowState, flowState) || other.flowState == flowState)&&(identical(other.savedTransaction, savedTransaction) || other.savedTransaction == savedTransaction)&&(identical(other.isActionSuccess, isActionSuccess) || other.isActionSuccess == isActionSuccess)&&(identical(other.selectedContactId, selectedContactId) || other.selectedContactId == selectedContactId)&&(identical(other.selectedPartyName, selectedPartyName) || other.selectedPartyName == selectedPartyName)&&(identical(other.isPartyVip, isPartyVip) || other.isPartyVip == isPartyVip)&&(identical(other.transactionDate, transactionDate) || other.transactionDate == transactionDate)&&(identical(other.isCash, isCash) || other.isCash == isCash)&&(identical(other.isInstallment, isInstallment) || other.isInstallment == isInstallment)&&(identical(other.installmentPlanMode, installmentPlanMode) || other.installmentPlanMode == installmentPlanMode)&&(identical(other.installmentCount, installmentCount) || other.installmentCount == installmentCount)&&(identical(other.frequency, frequency) || other.frequency == frequency)&&(identical(other.firstInstallmentDate, firstInstallmentDate) || other.firstInstallmentDate == firstInstallmentDate));
}


@override
int get hashCode => Object.hash(runtimeType,flowState,savedTransaction,isActionSuccess,selectedContactId,selectedPartyName,isPartyVip,transactionDate,isCash,isInstallment,installmentPlanMode,installmentCount,frequency,firstInstallmentDate);

@override
String toString() {
  return 'TransactionFormState(flowState: $flowState, savedTransaction: $savedTransaction, isActionSuccess: $isActionSuccess, selectedContactId: $selectedContactId, selectedPartyName: $selectedPartyName, isPartyVip: $isPartyVip, transactionDate: $transactionDate, isCash: $isCash, isInstallment: $isInstallment, installmentPlanMode: $installmentPlanMode, installmentCount: $installmentCount, frequency: $frequency, firstInstallmentDate: $firstInstallmentDate)';
}


}

/// @nodoc
abstract mixin class _$TransactionFormStateCopyWith<$Res> implements $TransactionFormStateCopyWith<$Res> {
  factory _$TransactionFormStateCopyWith(_TransactionFormState value, $Res Function(_TransactionFormState) _then) = __$TransactionFormStateCopyWithImpl;
@override @useResult
$Res call({
 FlowState? flowState, Transaction? savedTransaction, bool isActionSuccess, String? selectedContactId, String? selectedPartyName, bool isPartyVip, DateTime? transactionDate, bool isCash, bool isInstallment, String installmentPlanMode, int installmentCount, String frequency, DateTime? firstInstallmentDate
});




}
/// @nodoc
class __$TransactionFormStateCopyWithImpl<$Res>
    implements _$TransactionFormStateCopyWith<$Res> {
  __$TransactionFormStateCopyWithImpl(this._self, this._then);

  final _TransactionFormState _self;
  final $Res Function(_TransactionFormState) _then;

/// Create a copy of TransactionFormState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? flowState = freezed,Object? savedTransaction = freezed,Object? isActionSuccess = null,Object? selectedContactId = freezed,Object? selectedPartyName = freezed,Object? isPartyVip = null,Object? transactionDate = freezed,Object? isCash = null,Object? isInstallment = null,Object? installmentPlanMode = null,Object? installmentCount = null,Object? frequency = null,Object? firstInstallmentDate = freezed,}) {
  return _then(_TransactionFormState(
flowState: freezed == flowState ? _self.flowState : flowState // ignore: cast_nullable_to_non_nullable
as FlowState?,savedTransaction: freezed == savedTransaction ? _self.savedTransaction : savedTransaction // ignore: cast_nullable_to_non_nullable
as Transaction?,isActionSuccess: null == isActionSuccess ? _self.isActionSuccess : isActionSuccess // ignore: cast_nullable_to_non_nullable
as bool,selectedContactId: freezed == selectedContactId ? _self.selectedContactId : selectedContactId // ignore: cast_nullable_to_non_nullable
as String?,selectedPartyName: freezed == selectedPartyName ? _self.selectedPartyName : selectedPartyName // ignore: cast_nullable_to_non_nullable
as String?,isPartyVip: null == isPartyVip ? _self.isPartyVip : isPartyVip // ignore: cast_nullable_to_non_nullable
as bool,transactionDate: freezed == transactionDate ? _self.transactionDate : transactionDate // ignore: cast_nullable_to_non_nullable
as DateTime?,isCash: null == isCash ? _self.isCash : isCash // ignore: cast_nullable_to_non_nullable
as bool,isInstallment: null == isInstallment ? _self.isInstallment : isInstallment // ignore: cast_nullable_to_non_nullable
as bool,installmentPlanMode: null == installmentPlanMode ? _self.installmentPlanMode : installmentPlanMode // ignore: cast_nullable_to_non_nullable
as String,installmentCount: null == installmentCount ? _self.installmentCount : installmentCount // ignore: cast_nullable_to_non_nullable
as int,frequency: null == frequency ? _self.frequency : frequency // ignore: cast_nullable_to_non_nullable
as String,firstInstallmentDate: freezed == firstInstallmentDate ? _self.firstInstallmentDate : firstInstallmentDate // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
