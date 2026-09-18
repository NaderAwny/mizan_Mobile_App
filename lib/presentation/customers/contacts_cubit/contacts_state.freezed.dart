// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'contacts_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ContactsState {

 FlowState? get flowState; List<Contact>? get data; bool get isLoadingMore; bool get hasMore; bool get isVipOnly; String get searchQuery;
/// Create a copy of ContactsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ContactsStateCopyWith<ContactsState> get copyWith => _$ContactsStateCopyWithImpl<ContactsState>(this as ContactsState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ContactsState&&(identical(other.flowState, flowState) || other.flowState == flowState)&&const DeepCollectionEquality().equals(other.data, data)&&(identical(other.isLoadingMore, isLoadingMore) || other.isLoadingMore == isLoadingMore)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore)&&(identical(other.isVipOnly, isVipOnly) || other.isVipOnly == isVipOnly)&&(identical(other.searchQuery, searchQuery) || other.searchQuery == searchQuery));
}


@override
int get hashCode => Object.hash(runtimeType,flowState,const DeepCollectionEquality().hash(data),isLoadingMore,hasMore,isVipOnly,searchQuery);

@override
String toString() {
  return 'ContactsState(flowState: $flowState, data: $data, isLoadingMore: $isLoadingMore, hasMore: $hasMore, isVipOnly: $isVipOnly, searchQuery: $searchQuery)';
}


}

/// @nodoc
abstract mixin class $ContactsStateCopyWith<$Res>  {
  factory $ContactsStateCopyWith(ContactsState value, $Res Function(ContactsState) _then) = _$ContactsStateCopyWithImpl;
@useResult
$Res call({
 FlowState? flowState, List<Contact>? data, bool isLoadingMore, bool hasMore, bool isVipOnly, String searchQuery
});




}
/// @nodoc
class _$ContactsStateCopyWithImpl<$Res>
    implements $ContactsStateCopyWith<$Res> {
  _$ContactsStateCopyWithImpl(this._self, this._then);

  final ContactsState _self;
  final $Res Function(ContactsState) _then;

/// Create a copy of ContactsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? flowState = freezed,Object? data = freezed,Object? isLoadingMore = null,Object? hasMore = null,Object? isVipOnly = null,Object? searchQuery = null,}) {
  return _then(_self.copyWith(
flowState: freezed == flowState ? _self.flowState : flowState // ignore: cast_nullable_to_non_nullable
as FlowState?,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as List<Contact>?,isLoadingMore: null == isLoadingMore ? _self.isLoadingMore : isLoadingMore // ignore: cast_nullable_to_non_nullable
as bool,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,isVipOnly: null == isVipOnly ? _self.isVipOnly : isVipOnly // ignore: cast_nullable_to_non_nullable
as bool,searchQuery: null == searchQuery ? _self.searchQuery : searchQuery // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ContactsState].
extension ContactsStatePatterns on ContactsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ContactsState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ContactsState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ContactsState value)  $default,){
final _that = this;
switch (_that) {
case _ContactsState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ContactsState value)?  $default,){
final _that = this;
switch (_that) {
case _ContactsState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( FlowState? flowState,  List<Contact>? data,  bool isLoadingMore,  bool hasMore,  bool isVipOnly,  String searchQuery)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ContactsState() when $default != null:
return $default(_that.flowState,_that.data,_that.isLoadingMore,_that.hasMore,_that.isVipOnly,_that.searchQuery);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( FlowState? flowState,  List<Contact>? data,  bool isLoadingMore,  bool hasMore,  bool isVipOnly,  String searchQuery)  $default,) {final _that = this;
switch (_that) {
case _ContactsState():
return $default(_that.flowState,_that.data,_that.isLoadingMore,_that.hasMore,_that.isVipOnly,_that.searchQuery);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( FlowState? flowState,  List<Contact>? data,  bool isLoadingMore,  bool hasMore,  bool isVipOnly,  String searchQuery)?  $default,) {final _that = this;
switch (_that) {
case _ContactsState() when $default != null:
return $default(_that.flowState,_that.data,_that.isLoadingMore,_that.hasMore,_that.isVipOnly,_that.searchQuery);case _:
  return null;

}
}

}

/// @nodoc


class _ContactsState implements ContactsState {
  const _ContactsState({this.flowState, final  List<Contact>? data, this.isLoadingMore = false, this.hasMore = true, this.isVipOnly = false, this.searchQuery = ''}): _data = data;
  

@override final  FlowState? flowState;
 final  List<Contact>? _data;
@override List<Contact>? get data {
  final value = _data;
  if (value == null) return null;
  if (_data is EqualUnmodifiableListView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override@JsonKey() final  bool isLoadingMore;
@override@JsonKey() final  bool hasMore;
@override@JsonKey() final  bool isVipOnly;
@override@JsonKey() final  String searchQuery;

/// Create a copy of ContactsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ContactsStateCopyWith<_ContactsState> get copyWith => __$ContactsStateCopyWithImpl<_ContactsState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ContactsState&&(identical(other.flowState, flowState) || other.flowState == flowState)&&const DeepCollectionEquality().equals(other._data, _data)&&(identical(other.isLoadingMore, isLoadingMore) || other.isLoadingMore == isLoadingMore)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore)&&(identical(other.isVipOnly, isVipOnly) || other.isVipOnly == isVipOnly)&&(identical(other.searchQuery, searchQuery) || other.searchQuery == searchQuery));
}


@override
int get hashCode => Object.hash(runtimeType,flowState,const DeepCollectionEquality().hash(_data),isLoadingMore,hasMore,isVipOnly,searchQuery);

@override
String toString() {
  return 'ContactsState(flowState: $flowState, data: $data, isLoadingMore: $isLoadingMore, hasMore: $hasMore, isVipOnly: $isVipOnly, searchQuery: $searchQuery)';
}


}

/// @nodoc
abstract mixin class _$ContactsStateCopyWith<$Res> implements $ContactsStateCopyWith<$Res> {
  factory _$ContactsStateCopyWith(_ContactsState value, $Res Function(_ContactsState) _then) = __$ContactsStateCopyWithImpl;
@override @useResult
$Res call({
 FlowState? flowState, List<Contact>? data, bool isLoadingMore, bool hasMore, bool isVipOnly, String searchQuery
});




}
/// @nodoc
class __$ContactsStateCopyWithImpl<$Res>
    implements _$ContactsStateCopyWith<$Res> {
  __$ContactsStateCopyWithImpl(this._self, this._then);

  final _ContactsState _self;
  final $Res Function(_ContactsState) _then;

/// Create a copy of ContactsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? flowState = freezed,Object? data = freezed,Object? isLoadingMore = null,Object? hasMore = null,Object? isVipOnly = null,Object? searchQuery = null,}) {
  return _then(_ContactsState(
flowState: freezed == flowState ? _self.flowState : flowState // ignore: cast_nullable_to_non_nullable
as FlowState?,data: freezed == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as List<Contact>?,isLoadingMore: null == isLoadingMore ? _self.isLoadingMore : isLoadingMore // ignore: cast_nullable_to_non_nullable
as bool,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,isVipOnly: null == isVipOnly ? _self.isVipOnly : isVipOnly // ignore: cast_nullable_to_non_nullable
as bool,searchQuery: null == searchQuery ? _self.searchQuery : searchQuery // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
