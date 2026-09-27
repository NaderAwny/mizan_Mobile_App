// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'statistics_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$StatisticsState {

 FlowState? get flowState; StatisticsPageModel? get data; String? get selectedDate;// null = summary mode, non-null = daily mode
 bool get isMonthlyMode; String? get selectedMonthYear;
/// Create a copy of StatisticsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StatisticsStateCopyWith<StatisticsState> get copyWith => _$StatisticsStateCopyWithImpl<StatisticsState>(this as StatisticsState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StatisticsState&&(identical(other.flowState, flowState) || other.flowState == flowState)&&(identical(other.data, data) || other.data == data)&&(identical(other.selectedDate, selectedDate) || other.selectedDate == selectedDate)&&(identical(other.isMonthlyMode, isMonthlyMode) || other.isMonthlyMode == isMonthlyMode)&&(identical(other.selectedMonthYear, selectedMonthYear) || other.selectedMonthYear == selectedMonthYear));
}


@override
int get hashCode => Object.hash(runtimeType,flowState,data,selectedDate,isMonthlyMode,selectedMonthYear);

@override
String toString() {
  return 'StatisticsState(flowState: $flowState, data: $data, selectedDate: $selectedDate, isMonthlyMode: $isMonthlyMode, selectedMonthYear: $selectedMonthYear)';
}


}

/// @nodoc
abstract mixin class $StatisticsStateCopyWith<$Res>  {
  factory $StatisticsStateCopyWith(StatisticsState value, $Res Function(StatisticsState) _then) = _$StatisticsStateCopyWithImpl;
@useResult
$Res call({
 FlowState? flowState, StatisticsPageModel? data, String? selectedDate, bool isMonthlyMode, String? selectedMonthYear
});




}
/// @nodoc
class _$StatisticsStateCopyWithImpl<$Res>
    implements $StatisticsStateCopyWith<$Res> {
  _$StatisticsStateCopyWithImpl(this._self, this._then);

  final StatisticsState _self;
  final $Res Function(StatisticsState) _then;

/// Create a copy of StatisticsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? flowState = freezed,Object? data = freezed,Object? selectedDate = freezed,Object? isMonthlyMode = null,Object? selectedMonthYear = freezed,}) {
  return _then(_self.copyWith(
flowState: freezed == flowState ? _self.flowState : flowState // ignore: cast_nullable_to_non_nullable
as FlowState?,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as StatisticsPageModel?,selectedDate: freezed == selectedDate ? _self.selectedDate : selectedDate // ignore: cast_nullable_to_non_nullable
as String?,isMonthlyMode: null == isMonthlyMode ? _self.isMonthlyMode : isMonthlyMode // ignore: cast_nullable_to_non_nullable
as bool,selectedMonthYear: freezed == selectedMonthYear ? _self.selectedMonthYear : selectedMonthYear // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [StatisticsState].
extension StatisticsStatePatterns on StatisticsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StatisticsState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StatisticsState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StatisticsState value)  $default,){
final _that = this;
switch (_that) {
case _StatisticsState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StatisticsState value)?  $default,){
final _that = this;
switch (_that) {
case _StatisticsState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( FlowState? flowState,  StatisticsPageModel? data,  String? selectedDate,  bool isMonthlyMode,  String? selectedMonthYear)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StatisticsState() when $default != null:
return $default(_that.flowState,_that.data,_that.selectedDate,_that.isMonthlyMode,_that.selectedMonthYear);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( FlowState? flowState,  StatisticsPageModel? data,  String? selectedDate,  bool isMonthlyMode,  String? selectedMonthYear)  $default,) {final _that = this;
switch (_that) {
case _StatisticsState():
return $default(_that.flowState,_that.data,_that.selectedDate,_that.isMonthlyMode,_that.selectedMonthYear);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( FlowState? flowState,  StatisticsPageModel? data,  String? selectedDate,  bool isMonthlyMode,  String? selectedMonthYear)?  $default,) {final _that = this;
switch (_that) {
case _StatisticsState() when $default != null:
return $default(_that.flowState,_that.data,_that.selectedDate,_that.isMonthlyMode,_that.selectedMonthYear);case _:
  return null;

}
}

}

/// @nodoc


class _StatisticsState implements StatisticsState {
  const _StatisticsState({this.flowState, this.data, this.selectedDate, this.isMonthlyMode = false, this.selectedMonthYear});
  

@override final  FlowState? flowState;
@override final  StatisticsPageModel? data;
@override final  String? selectedDate;
// null = summary mode, non-null = daily mode
@override@JsonKey() final  bool isMonthlyMode;
@override final  String? selectedMonthYear;

/// Create a copy of StatisticsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StatisticsStateCopyWith<_StatisticsState> get copyWith => __$StatisticsStateCopyWithImpl<_StatisticsState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StatisticsState&&(identical(other.flowState, flowState) || other.flowState == flowState)&&(identical(other.data, data) || other.data == data)&&(identical(other.selectedDate, selectedDate) || other.selectedDate == selectedDate)&&(identical(other.isMonthlyMode, isMonthlyMode) || other.isMonthlyMode == isMonthlyMode)&&(identical(other.selectedMonthYear, selectedMonthYear) || other.selectedMonthYear == selectedMonthYear));
}


@override
int get hashCode => Object.hash(runtimeType,flowState,data,selectedDate,isMonthlyMode,selectedMonthYear);

@override
String toString() {
  return 'StatisticsState(flowState: $flowState, data: $data, selectedDate: $selectedDate, isMonthlyMode: $isMonthlyMode, selectedMonthYear: $selectedMonthYear)';
}


}

/// @nodoc
abstract mixin class _$StatisticsStateCopyWith<$Res> implements $StatisticsStateCopyWith<$Res> {
  factory _$StatisticsStateCopyWith(_StatisticsState value, $Res Function(_StatisticsState) _then) = __$StatisticsStateCopyWithImpl;
@override @useResult
$Res call({
 FlowState? flowState, StatisticsPageModel? data, String? selectedDate, bool isMonthlyMode, String? selectedMonthYear
});




}
/// @nodoc
class __$StatisticsStateCopyWithImpl<$Res>
    implements _$StatisticsStateCopyWith<$Res> {
  __$StatisticsStateCopyWithImpl(this._self, this._then);

  final _StatisticsState _self;
  final $Res Function(_StatisticsState) _then;

/// Create a copy of StatisticsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? flowState = freezed,Object? data = freezed,Object? selectedDate = freezed,Object? isMonthlyMode = null,Object? selectedMonthYear = freezed,}) {
  return _then(_StatisticsState(
flowState: freezed == flowState ? _self.flowState : flowState // ignore: cast_nullable_to_non_nullable
as FlowState?,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as StatisticsPageModel?,selectedDate: freezed == selectedDate ? _self.selectedDate : selectedDate // ignore: cast_nullable_to_non_nullable
as String?,isMonthlyMode: null == isMonthlyMode ? _self.isMonthlyMode : isMonthlyMode // ignore: cast_nullable_to_non_nullable
as bool,selectedMonthYear: freezed == selectedMonthYear ? _self.selectedMonthYear : selectedMonthYear // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
