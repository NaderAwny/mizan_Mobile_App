// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'onboarding_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$OnBoardingState {

 int get currentIndex; List<SliderObject> get sliders; bool get isLast;
/// Create a copy of OnBoardingState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OnBoardingStateCopyWith<OnBoardingState> get copyWith => _$OnBoardingStateCopyWithImpl<OnBoardingState>(this as OnBoardingState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OnBoardingState&&(identical(other.currentIndex, currentIndex) || other.currentIndex == currentIndex)&&const DeepCollectionEquality().equals(other.sliders, sliders)&&(identical(other.isLast, isLast) || other.isLast == isLast));
}


@override
int get hashCode => Object.hash(runtimeType,currentIndex,const DeepCollectionEquality().hash(sliders),isLast);

@override
String toString() {
  return 'OnBoardingState(currentIndex: $currentIndex, sliders: $sliders, isLast: $isLast)';
}


}

/// @nodoc
abstract mixin class $OnBoardingStateCopyWith<$Res>  {
  factory $OnBoardingStateCopyWith(OnBoardingState value, $Res Function(OnBoardingState) _then) = _$OnBoardingStateCopyWithImpl;
@useResult
$Res call({
 int currentIndex, List<SliderObject> sliders, bool isLast
});




}
/// @nodoc
class _$OnBoardingStateCopyWithImpl<$Res>
    implements $OnBoardingStateCopyWith<$Res> {
  _$OnBoardingStateCopyWithImpl(this._self, this._then);

  final OnBoardingState _self;
  final $Res Function(OnBoardingState) _then;

/// Create a copy of OnBoardingState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? currentIndex = null,Object? sliders = null,Object? isLast = null,}) {
  return _then(_self.copyWith(
currentIndex: null == currentIndex ? _self.currentIndex : currentIndex // ignore: cast_nullable_to_non_nullable
as int,sliders: null == sliders ? _self.sliders : sliders // ignore: cast_nullable_to_non_nullable
as List<SliderObject>,isLast: null == isLast ? _self.isLast : isLast // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [OnBoardingState].
extension OnBoardingStatePatterns on OnBoardingState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OnBoardingState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OnBoardingState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OnBoardingState value)  $default,){
final _that = this;
switch (_that) {
case _OnBoardingState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OnBoardingState value)?  $default,){
final _that = this;
switch (_that) {
case _OnBoardingState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int currentIndex,  List<SliderObject> sliders,  bool isLast)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OnBoardingState() when $default != null:
return $default(_that.currentIndex,_that.sliders,_that.isLast);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int currentIndex,  List<SliderObject> sliders,  bool isLast)  $default,) {final _that = this;
switch (_that) {
case _OnBoardingState():
return $default(_that.currentIndex,_that.sliders,_that.isLast);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int currentIndex,  List<SliderObject> sliders,  bool isLast)?  $default,) {final _that = this;
switch (_that) {
case _OnBoardingState() when $default != null:
return $default(_that.currentIndex,_that.sliders,_that.isLast);case _:
  return null;

}
}

}

/// @nodoc


class _OnBoardingState implements OnBoardingState {
  const _OnBoardingState({this.currentIndex = 0, final  List<SliderObject> sliders = const [], this.isLast = false}): _sliders = sliders;
  

@override@JsonKey() final  int currentIndex;
 final  List<SliderObject> _sliders;
@override@JsonKey() List<SliderObject> get sliders {
  if (_sliders is EqualUnmodifiableListView) return _sliders;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sliders);
}

@override@JsonKey() final  bool isLast;

/// Create a copy of OnBoardingState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OnBoardingStateCopyWith<_OnBoardingState> get copyWith => __$OnBoardingStateCopyWithImpl<_OnBoardingState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OnBoardingState&&(identical(other.currentIndex, currentIndex) || other.currentIndex == currentIndex)&&const DeepCollectionEquality().equals(other._sliders, _sliders)&&(identical(other.isLast, isLast) || other.isLast == isLast));
}


@override
int get hashCode => Object.hash(runtimeType,currentIndex,const DeepCollectionEquality().hash(_sliders),isLast);

@override
String toString() {
  return 'OnBoardingState(currentIndex: $currentIndex, sliders: $sliders, isLast: $isLast)';
}


}

/// @nodoc
abstract mixin class _$OnBoardingStateCopyWith<$Res> implements $OnBoardingStateCopyWith<$Res> {
  factory _$OnBoardingStateCopyWith(_OnBoardingState value, $Res Function(_OnBoardingState) _then) = __$OnBoardingStateCopyWithImpl;
@override @useResult
$Res call({
 int currentIndex, List<SliderObject> sliders, bool isLast
});




}
/// @nodoc
class __$OnBoardingStateCopyWithImpl<$Res>
    implements _$OnBoardingStateCopyWith<$Res> {
  __$OnBoardingStateCopyWithImpl(this._self, this._then);

  final _OnBoardingState _self;
  final $Res Function(_OnBoardingState) _then;

/// Create a copy of OnBoardingState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? currentIndex = null,Object? sliders = null,Object? isLast = null,}) {
  return _then(_OnBoardingState(
currentIndex: null == currentIndex ? _self.currentIndex : currentIndex // ignore: cast_nullable_to_non_nullable
as int,sliders: null == sliders ? _self._sliders : sliders // ignore: cast_nullable_to_non_nullable
as List<SliderObject>,isLast: null == isLast ? _self.isLast : isLast // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
