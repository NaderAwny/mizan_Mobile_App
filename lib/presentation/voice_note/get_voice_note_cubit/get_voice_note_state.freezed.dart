// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'get_voice_note_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$GetListVoiceNotesState {

 FlowState? get flowState; List<VoiceNoteModel>? get data; bool get isLoadingMore; bool get hasMore;
/// Create a copy of GetListVoiceNotesState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GetListVoiceNotesStateCopyWith<GetListVoiceNotesState> get copyWith => _$GetListVoiceNotesStateCopyWithImpl<GetListVoiceNotesState>(this as GetListVoiceNotesState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GetListVoiceNotesState&&(identical(other.flowState, flowState) || other.flowState == flowState)&&const DeepCollectionEquality().equals(other.data, data)&&(identical(other.isLoadingMore, isLoadingMore) || other.isLoadingMore == isLoadingMore)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore));
}


@override
int get hashCode => Object.hash(runtimeType,flowState,const DeepCollectionEquality().hash(data),isLoadingMore,hasMore);

@override
String toString() {
  return 'GetListVoiceNotesState(flowState: $flowState, data: $data, isLoadingMore: $isLoadingMore, hasMore: $hasMore)';
}


}

/// @nodoc
abstract mixin class $GetListVoiceNotesStateCopyWith<$Res>  {
  factory $GetListVoiceNotesStateCopyWith(GetListVoiceNotesState value, $Res Function(GetListVoiceNotesState) _then) = _$GetListVoiceNotesStateCopyWithImpl;
@useResult
$Res call({
 FlowState? flowState, List<VoiceNoteModel>? data, bool isLoadingMore, bool hasMore
});




}
/// @nodoc
class _$GetListVoiceNotesStateCopyWithImpl<$Res>
    implements $GetListVoiceNotesStateCopyWith<$Res> {
  _$GetListVoiceNotesStateCopyWithImpl(this._self, this._then);

  final GetListVoiceNotesState _self;
  final $Res Function(GetListVoiceNotesState) _then;

/// Create a copy of GetListVoiceNotesState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? flowState = freezed,Object? data = freezed,Object? isLoadingMore = null,Object? hasMore = null,}) {
  return _then(_self.copyWith(
flowState: freezed == flowState ? _self.flowState : flowState // ignore: cast_nullable_to_non_nullable
as FlowState?,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as List<VoiceNoteModel>?,isLoadingMore: null == isLoadingMore ? _self.isLoadingMore : isLoadingMore // ignore: cast_nullable_to_non_nullable
as bool,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [GetListVoiceNotesState].
extension GetListVoiceNotesStatePatterns on GetListVoiceNotesState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GetListVoiceNotesState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GetListVoiceNotesState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GetListVoiceNotesState value)  $default,){
final _that = this;
switch (_that) {
case _GetListVoiceNotesState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GetListVoiceNotesState value)?  $default,){
final _that = this;
switch (_that) {
case _GetListVoiceNotesState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( FlowState? flowState,  List<VoiceNoteModel>? data,  bool isLoadingMore,  bool hasMore)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GetListVoiceNotesState() when $default != null:
return $default(_that.flowState,_that.data,_that.isLoadingMore,_that.hasMore);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( FlowState? flowState,  List<VoiceNoteModel>? data,  bool isLoadingMore,  bool hasMore)  $default,) {final _that = this;
switch (_that) {
case _GetListVoiceNotesState():
return $default(_that.flowState,_that.data,_that.isLoadingMore,_that.hasMore);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( FlowState? flowState,  List<VoiceNoteModel>? data,  bool isLoadingMore,  bool hasMore)?  $default,) {final _that = this;
switch (_that) {
case _GetListVoiceNotesState() when $default != null:
return $default(_that.flowState,_that.data,_that.isLoadingMore,_that.hasMore);case _:
  return null;

}
}

}

/// @nodoc


class _GetListVoiceNotesState implements GetListVoiceNotesState {
  const _GetListVoiceNotesState({this.flowState, final  List<VoiceNoteModel>? data, this.isLoadingMore = false, this.hasMore = true}): _data = data;
  

@override final  FlowState? flowState;
 final  List<VoiceNoteModel>? _data;
@override List<VoiceNoteModel>? get data {
  final value = _data;
  if (value == null) return null;
  if (_data is EqualUnmodifiableListView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override@JsonKey() final  bool isLoadingMore;
@override@JsonKey() final  bool hasMore;

/// Create a copy of GetListVoiceNotesState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GetListVoiceNotesStateCopyWith<_GetListVoiceNotesState> get copyWith => __$GetListVoiceNotesStateCopyWithImpl<_GetListVoiceNotesState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GetListVoiceNotesState&&(identical(other.flowState, flowState) || other.flowState == flowState)&&const DeepCollectionEquality().equals(other._data, _data)&&(identical(other.isLoadingMore, isLoadingMore) || other.isLoadingMore == isLoadingMore)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore));
}


@override
int get hashCode => Object.hash(runtimeType,flowState,const DeepCollectionEquality().hash(_data),isLoadingMore,hasMore);

@override
String toString() {
  return 'GetListVoiceNotesState(flowState: $flowState, data: $data, isLoadingMore: $isLoadingMore, hasMore: $hasMore)';
}


}

/// @nodoc
abstract mixin class _$GetListVoiceNotesStateCopyWith<$Res> implements $GetListVoiceNotesStateCopyWith<$Res> {
  factory _$GetListVoiceNotesStateCopyWith(_GetListVoiceNotesState value, $Res Function(_GetListVoiceNotesState) _then) = __$GetListVoiceNotesStateCopyWithImpl;
@override @useResult
$Res call({
 FlowState? flowState, List<VoiceNoteModel>? data, bool isLoadingMore, bool hasMore
});




}
/// @nodoc
class __$GetListVoiceNotesStateCopyWithImpl<$Res>
    implements _$GetListVoiceNotesStateCopyWith<$Res> {
  __$GetListVoiceNotesStateCopyWithImpl(this._self, this._then);

  final _GetListVoiceNotesState _self;
  final $Res Function(_GetListVoiceNotesState) _then;

/// Create a copy of GetListVoiceNotesState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? flowState = freezed,Object? data = freezed,Object? isLoadingMore = null,Object? hasMore = null,}) {
  return _then(_GetListVoiceNotesState(
flowState: freezed == flowState ? _self.flowState : flowState // ignore: cast_nullable_to_non_nullable
as FlowState?,data: freezed == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as List<VoiceNoteModel>?,isLoadingMore: null == isLoadingMore ? _self.isLoadingMore : isLoadingMore // ignore: cast_nullable_to_non_nullable
as bool,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
