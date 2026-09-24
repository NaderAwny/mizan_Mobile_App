// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'get_list_transaction_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$GetListTransactionState {

 FlowState? get flowState; List<GetListTransactionsModel>? get data; bool get isLoadingMore; bool get hasMore; String get searchQuery; String? get contactId; String? get type; String? get dateFrom; String? get dateTo;
/// Create a copy of GetListTransactionState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GetListTransactionStateCopyWith<GetListTransactionState> get copyWith => _$GetListTransactionStateCopyWithImpl<GetListTransactionState>(this as GetListTransactionState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GetListTransactionState&&(identical(other.flowState, flowState) || other.flowState == flowState)&&const DeepCollectionEquality().equals(other.data, data)&&(identical(other.isLoadingMore, isLoadingMore) || other.isLoadingMore == isLoadingMore)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore)&&(identical(other.searchQuery, searchQuery) || other.searchQuery == searchQuery)&&(identical(other.contactId, contactId) || other.contactId == contactId)&&(identical(other.type, type) || other.type == type)&&(identical(other.dateFrom, dateFrom) || other.dateFrom == dateFrom)&&(identical(other.dateTo, dateTo) || other.dateTo == dateTo));
}


@override
int get hashCode => Object.hash(runtimeType,flowState,const DeepCollectionEquality().hash(data),isLoadingMore,hasMore,searchQuery,contactId,type,dateFrom,dateTo);

@override
String toString() {
  return 'GetListTransactionState(flowState: $flowState, data: $data, isLoadingMore: $isLoadingMore, hasMore: $hasMore, searchQuery: $searchQuery, contactId: $contactId, type: $type, dateFrom: $dateFrom, dateTo: $dateTo)';
}


}

/// @nodoc
abstract mixin class $GetListTransactionStateCopyWith<$Res>  {
  factory $GetListTransactionStateCopyWith(GetListTransactionState value, $Res Function(GetListTransactionState) _then) = _$GetListTransactionStateCopyWithImpl;
@useResult
$Res call({
 FlowState? flowState, List<GetListTransactionsModel>? data, bool isLoadingMore, bool hasMore, String searchQuery, String? contactId, String? type, String? dateFrom, String? dateTo
});




}
/// @nodoc
class _$GetListTransactionStateCopyWithImpl<$Res>
    implements $GetListTransactionStateCopyWith<$Res> {
  _$GetListTransactionStateCopyWithImpl(this._self, this._then);

  final GetListTransactionState _self;
  final $Res Function(GetListTransactionState) _then;

/// Create a copy of GetListTransactionState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? flowState = freezed,Object? data = freezed,Object? isLoadingMore = null,Object? hasMore = null,Object? searchQuery = null,Object? contactId = freezed,Object? type = freezed,Object? dateFrom = freezed,Object? dateTo = freezed,}) {
  return _then(_self.copyWith(
flowState: freezed == flowState ? _self.flowState : flowState // ignore: cast_nullable_to_non_nullable
as FlowState?,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as List<GetListTransactionsModel>?,isLoadingMore: null == isLoadingMore ? _self.isLoadingMore : isLoadingMore // ignore: cast_nullable_to_non_nullable
as bool,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,searchQuery: null == searchQuery ? _self.searchQuery : searchQuery // ignore: cast_nullable_to_non_nullable
as String,contactId: freezed == contactId ? _self.contactId : contactId // ignore: cast_nullable_to_non_nullable
as String?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,dateFrom: freezed == dateFrom ? _self.dateFrom : dateFrom // ignore: cast_nullable_to_non_nullable
as String?,dateTo: freezed == dateTo ? _self.dateTo : dateTo // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [GetListTransactionState].
extension GetListTransactionStatePatterns on GetListTransactionState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GetListTransactionState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GetListTransactionState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GetListTransactionState value)  $default,){
final _that = this;
switch (_that) {
case _GetListTransactionState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GetListTransactionState value)?  $default,){
final _that = this;
switch (_that) {
case _GetListTransactionState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( FlowState? flowState,  List<GetListTransactionsModel>? data,  bool isLoadingMore,  bool hasMore,  String searchQuery,  String? contactId,  String? type,  String? dateFrom,  String? dateTo)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GetListTransactionState() when $default != null:
return $default(_that.flowState,_that.data,_that.isLoadingMore,_that.hasMore,_that.searchQuery,_that.contactId,_that.type,_that.dateFrom,_that.dateTo);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( FlowState? flowState,  List<GetListTransactionsModel>? data,  bool isLoadingMore,  bool hasMore,  String searchQuery,  String? contactId,  String? type,  String? dateFrom,  String? dateTo)  $default,) {final _that = this;
switch (_that) {
case _GetListTransactionState():
return $default(_that.flowState,_that.data,_that.isLoadingMore,_that.hasMore,_that.searchQuery,_that.contactId,_that.type,_that.dateFrom,_that.dateTo);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( FlowState? flowState,  List<GetListTransactionsModel>? data,  bool isLoadingMore,  bool hasMore,  String searchQuery,  String? contactId,  String? type,  String? dateFrom,  String? dateTo)?  $default,) {final _that = this;
switch (_that) {
case _GetListTransactionState() when $default != null:
return $default(_that.flowState,_that.data,_that.isLoadingMore,_that.hasMore,_that.searchQuery,_that.contactId,_that.type,_that.dateFrom,_that.dateTo);case _:
  return null;

}
}

}

/// @nodoc


class _GetListTransactionState implements GetListTransactionState {
  const _GetListTransactionState({this.flowState, final  List<GetListTransactionsModel>? data, this.isLoadingMore = false, this.hasMore = true, this.searchQuery = '', this.contactId, this.type, this.dateFrom, this.dateTo}): _data = data;
  

@override final  FlowState? flowState;
 final  List<GetListTransactionsModel>? _data;
@override List<GetListTransactionsModel>? get data {
  final value = _data;
  if (value == null) return null;
  if (_data is EqualUnmodifiableListView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override@JsonKey() final  bool isLoadingMore;
@override@JsonKey() final  bool hasMore;
@override@JsonKey() final  String searchQuery;
@override final  String? contactId;
@override final  String? type;
@override final  String? dateFrom;
@override final  String? dateTo;

/// Create a copy of GetListTransactionState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GetListTransactionStateCopyWith<_GetListTransactionState> get copyWith => __$GetListTransactionStateCopyWithImpl<_GetListTransactionState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GetListTransactionState&&(identical(other.flowState, flowState) || other.flowState == flowState)&&const DeepCollectionEquality().equals(other._data, _data)&&(identical(other.isLoadingMore, isLoadingMore) || other.isLoadingMore == isLoadingMore)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore)&&(identical(other.searchQuery, searchQuery) || other.searchQuery == searchQuery)&&(identical(other.contactId, contactId) || other.contactId == contactId)&&(identical(other.type, type) || other.type == type)&&(identical(other.dateFrom, dateFrom) || other.dateFrom == dateFrom)&&(identical(other.dateTo, dateTo) || other.dateTo == dateTo));
}


@override
int get hashCode => Object.hash(runtimeType,flowState,const DeepCollectionEquality().hash(_data),isLoadingMore,hasMore,searchQuery,contactId,type,dateFrom,dateTo);

@override
String toString() {
  return 'GetListTransactionState(flowState: $flowState, data: $data, isLoadingMore: $isLoadingMore, hasMore: $hasMore, searchQuery: $searchQuery, contactId: $contactId, type: $type, dateFrom: $dateFrom, dateTo: $dateTo)';
}


}

/// @nodoc
abstract mixin class _$GetListTransactionStateCopyWith<$Res> implements $GetListTransactionStateCopyWith<$Res> {
  factory _$GetListTransactionStateCopyWith(_GetListTransactionState value, $Res Function(_GetListTransactionState) _then) = __$GetListTransactionStateCopyWithImpl;
@override @useResult
$Res call({
 FlowState? flowState, List<GetListTransactionsModel>? data, bool isLoadingMore, bool hasMore, String searchQuery, String? contactId, String? type, String? dateFrom, String? dateTo
});




}
/// @nodoc
class __$GetListTransactionStateCopyWithImpl<$Res>
    implements _$GetListTransactionStateCopyWith<$Res> {
  __$GetListTransactionStateCopyWithImpl(this._self, this._then);

  final _GetListTransactionState _self;
  final $Res Function(_GetListTransactionState) _then;

/// Create a copy of GetListTransactionState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? flowState = freezed,Object? data = freezed,Object? isLoadingMore = null,Object? hasMore = null,Object? searchQuery = null,Object? contactId = freezed,Object? type = freezed,Object? dateFrom = freezed,Object? dateTo = freezed,}) {
  return _then(_GetListTransactionState(
flowState: freezed == flowState ? _self.flowState : flowState // ignore: cast_nullable_to_non_nullable
as FlowState?,data: freezed == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as List<GetListTransactionsModel>?,isLoadingMore: null == isLoadingMore ? _self.isLoadingMore : isLoadingMore // ignore: cast_nullable_to_non_nullable
as bool,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,searchQuery: null == searchQuery ? _self.searchQuery : searchQuery // ignore: cast_nullable_to_non_nullable
as String,contactId: freezed == contactId ? _self.contactId : contactId // ignore: cast_nullable_to_non_nullable
as String?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,dateFrom: freezed == dateFrom ? _self.dateFrom : dateFrom // ignore: cast_nullable_to_non_nullable
as String?,dateTo: freezed == dateTo ? _self.dateTo : dateTo // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
