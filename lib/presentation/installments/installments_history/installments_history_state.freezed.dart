// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'installments_history_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$InstallmentsHistoryState {

 FlowState? get flowState; List<InstallmentHistoryItemModel>? get data; String get status; bool get isLoadingMore; bool get hasMore; int get totalCount; int get currentPage; int get totalPages;
/// Create a copy of InstallmentsHistoryState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InstallmentsHistoryStateCopyWith<InstallmentsHistoryState> get copyWith => _$InstallmentsHistoryStateCopyWithImpl<InstallmentsHistoryState>(this as InstallmentsHistoryState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InstallmentsHistoryState&&(identical(other.flowState, flowState) || other.flowState == flowState)&&const DeepCollectionEquality().equals(other.data, data)&&(identical(other.status, status) || other.status == status)&&(identical(other.isLoadingMore, isLoadingMore) || other.isLoadingMore == isLoadingMore)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore)&&(identical(other.totalCount, totalCount) || other.totalCount == totalCount)&&(identical(other.currentPage, currentPage) || other.currentPage == currentPage)&&(identical(other.totalPages, totalPages) || other.totalPages == totalPages));
}


@override
int get hashCode => Object.hash(runtimeType,flowState,const DeepCollectionEquality().hash(data),status,isLoadingMore,hasMore,totalCount,currentPage,totalPages);

@override
String toString() {
  return 'InstallmentsHistoryState(flowState: $flowState, data: $data, status: $status, isLoadingMore: $isLoadingMore, hasMore: $hasMore, totalCount: $totalCount, currentPage: $currentPage, totalPages: $totalPages)';
}


}

/// @nodoc
abstract mixin class $InstallmentsHistoryStateCopyWith<$Res>  {
  factory $InstallmentsHistoryStateCopyWith(InstallmentsHistoryState value, $Res Function(InstallmentsHistoryState) _then) = _$InstallmentsHistoryStateCopyWithImpl;
@useResult
$Res call({
 FlowState? flowState, List<InstallmentHistoryItemModel>? data, String status, bool isLoadingMore, bool hasMore, int totalCount, int currentPage, int totalPages
});




}
/// @nodoc
class _$InstallmentsHistoryStateCopyWithImpl<$Res>
    implements $InstallmentsHistoryStateCopyWith<$Res> {
  _$InstallmentsHistoryStateCopyWithImpl(this._self, this._then);

  final InstallmentsHistoryState _self;
  final $Res Function(InstallmentsHistoryState) _then;

/// Create a copy of InstallmentsHistoryState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? flowState = freezed,Object? data = freezed,Object? status = null,Object? isLoadingMore = null,Object? hasMore = null,Object? totalCount = null,Object? currentPage = null,Object? totalPages = null,}) {
  return _then(_self.copyWith(
flowState: freezed == flowState ? _self.flowState : flowState // ignore: cast_nullable_to_non_nullable
as FlowState?,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as List<InstallmentHistoryItemModel>?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,isLoadingMore: null == isLoadingMore ? _self.isLoadingMore : isLoadingMore // ignore: cast_nullable_to_non_nullable
as bool,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,totalCount: null == totalCount ? _self.totalCount : totalCount // ignore: cast_nullable_to_non_nullable
as int,currentPage: null == currentPage ? _self.currentPage : currentPage // ignore: cast_nullable_to_non_nullable
as int,totalPages: null == totalPages ? _self.totalPages : totalPages // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [InstallmentsHistoryState].
extension InstallmentsHistoryStatePatterns on InstallmentsHistoryState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InstallmentsHistoryState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InstallmentsHistoryState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InstallmentsHistoryState value)  $default,){
final _that = this;
switch (_that) {
case _InstallmentsHistoryState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InstallmentsHistoryState value)?  $default,){
final _that = this;
switch (_that) {
case _InstallmentsHistoryState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( FlowState? flowState,  List<InstallmentHistoryItemModel>? data,  String status,  bool isLoadingMore,  bool hasMore,  int totalCount,  int currentPage,  int totalPages)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InstallmentsHistoryState() when $default != null:
return $default(_that.flowState,_that.data,_that.status,_that.isLoadingMore,_that.hasMore,_that.totalCount,_that.currentPage,_that.totalPages);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( FlowState? flowState,  List<InstallmentHistoryItemModel>? data,  String status,  bool isLoadingMore,  bool hasMore,  int totalCount,  int currentPage,  int totalPages)  $default,) {final _that = this;
switch (_that) {
case _InstallmentsHistoryState():
return $default(_that.flowState,_that.data,_that.status,_that.isLoadingMore,_that.hasMore,_that.totalCount,_that.currentPage,_that.totalPages);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( FlowState? flowState,  List<InstallmentHistoryItemModel>? data,  String status,  bool isLoadingMore,  bool hasMore,  int totalCount,  int currentPage,  int totalPages)?  $default,) {final _that = this;
switch (_that) {
case _InstallmentsHistoryState() when $default != null:
return $default(_that.flowState,_that.data,_that.status,_that.isLoadingMore,_that.hasMore,_that.totalCount,_that.currentPage,_that.totalPages);case _:
  return null;

}
}

}

/// @nodoc


class _InstallmentsHistoryState implements InstallmentsHistoryState {
  const _InstallmentsHistoryState({this.flowState, final  List<InstallmentHistoryItemModel>? data, this.status = InstallmentHistoryStatus.all, this.isLoadingMore = false, this.hasMore = true, this.totalCount = 0, this.currentPage = 1, this.totalPages = 1}): _data = data;
  

@override final  FlowState? flowState;
 final  List<InstallmentHistoryItemModel>? _data;
@override List<InstallmentHistoryItemModel>? get data {
  final value = _data;
  if (value == null) return null;
  if (_data is EqualUnmodifiableListView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override@JsonKey() final  String status;
@override@JsonKey() final  bool isLoadingMore;
@override@JsonKey() final  bool hasMore;
@override@JsonKey() final  int totalCount;
@override@JsonKey() final  int currentPage;
@override@JsonKey() final  int totalPages;

/// Create a copy of InstallmentsHistoryState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InstallmentsHistoryStateCopyWith<_InstallmentsHistoryState> get copyWith => __$InstallmentsHistoryStateCopyWithImpl<_InstallmentsHistoryState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InstallmentsHistoryState&&(identical(other.flowState, flowState) || other.flowState == flowState)&&const DeepCollectionEquality().equals(other._data, _data)&&(identical(other.status, status) || other.status == status)&&(identical(other.isLoadingMore, isLoadingMore) || other.isLoadingMore == isLoadingMore)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore)&&(identical(other.totalCount, totalCount) || other.totalCount == totalCount)&&(identical(other.currentPage, currentPage) || other.currentPage == currentPage)&&(identical(other.totalPages, totalPages) || other.totalPages == totalPages));
}


@override
int get hashCode => Object.hash(runtimeType,flowState,const DeepCollectionEquality().hash(_data),status,isLoadingMore,hasMore,totalCount,currentPage,totalPages);

@override
String toString() {
  return 'InstallmentsHistoryState(flowState: $flowState, data: $data, status: $status, isLoadingMore: $isLoadingMore, hasMore: $hasMore, totalCount: $totalCount, currentPage: $currentPage, totalPages: $totalPages)';
}


}

/// @nodoc
abstract mixin class _$InstallmentsHistoryStateCopyWith<$Res> implements $InstallmentsHistoryStateCopyWith<$Res> {
  factory _$InstallmentsHistoryStateCopyWith(_InstallmentsHistoryState value, $Res Function(_InstallmentsHistoryState) _then) = __$InstallmentsHistoryStateCopyWithImpl;
@override @useResult
$Res call({
 FlowState? flowState, List<InstallmentHistoryItemModel>? data, String status, bool isLoadingMore, bool hasMore, int totalCount, int currentPage, int totalPages
});




}
/// @nodoc
class __$InstallmentsHistoryStateCopyWithImpl<$Res>
    implements _$InstallmentsHistoryStateCopyWith<$Res> {
  __$InstallmentsHistoryStateCopyWithImpl(this._self, this._then);

  final _InstallmentsHistoryState _self;
  final $Res Function(_InstallmentsHistoryState) _then;

/// Create a copy of InstallmentsHistoryState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? flowState = freezed,Object? data = freezed,Object? status = null,Object? isLoadingMore = null,Object? hasMore = null,Object? totalCount = null,Object? currentPage = null,Object? totalPages = null,}) {
  return _then(_InstallmentsHistoryState(
flowState: freezed == flowState ? _self.flowState : flowState // ignore: cast_nullable_to_non_nullable
as FlowState?,data: freezed == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as List<InstallmentHistoryItemModel>?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,isLoadingMore: null == isLoadingMore ? _self.isLoadingMore : isLoadingMore // ignore: cast_nullable_to_non_nullable
as bool,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,totalCount: null == totalCount ? _self.totalCount : totalCount // ignore: cast_nullable_to_non_nullable
as int,currentPage: null == currentPage ? _self.currentPage : currentPage // ignore: cast_nullable_to_non_nullable
as int,totalPages: null == totalPages ? _self.totalPages : totalPages // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
