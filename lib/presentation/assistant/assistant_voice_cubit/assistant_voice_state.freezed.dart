// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'assistant_voice_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AssistantVoiceState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AssistantVoiceState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AssistantVoiceState()';
}


}

/// @nodoc
class $AssistantVoiceStateCopyWith<$Res>  {
$AssistantVoiceStateCopyWith(AssistantVoiceState _, $Res Function(AssistantVoiceState) __);
}


/// Adds pattern-matching-related methods to [AssistantVoiceState].
extension AssistantVoiceStatePatterns on AssistantVoiceState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Idle value)?  idle,TResult Function( _RequestingPermission value)?  requestingPermission,TResult Function( _PermissionDenied value)?  permissionDenied,TResult Function( _Greeting value)?  greeting,TResult Function( _Listening value)?  listening,TResult Function( _Reviewing value)?  reviewing,TResult Function( _ReadyToSend value)?  readyToSend,TResult Function( _VoiceError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Idle() when idle != null:
return idle(_that);case _RequestingPermission() when requestingPermission != null:
return requestingPermission(_that);case _PermissionDenied() when permissionDenied != null:
return permissionDenied(_that);case _Greeting() when greeting != null:
return greeting(_that);case _Listening() when listening != null:
return listening(_that);case _Reviewing() when reviewing != null:
return reviewing(_that);case _ReadyToSend() when readyToSend != null:
return readyToSend(_that);case _VoiceError() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Idle value)  idle,required TResult Function( _RequestingPermission value)  requestingPermission,required TResult Function( _PermissionDenied value)  permissionDenied,required TResult Function( _Greeting value)  greeting,required TResult Function( _Listening value)  listening,required TResult Function( _Reviewing value)  reviewing,required TResult Function( _ReadyToSend value)  readyToSend,required TResult Function( _VoiceError value)  error,}){
final _that = this;
switch (_that) {
case _Idle():
return idle(_that);case _RequestingPermission():
return requestingPermission(_that);case _PermissionDenied():
return permissionDenied(_that);case _Greeting():
return greeting(_that);case _Listening():
return listening(_that);case _Reviewing():
return reviewing(_that);case _ReadyToSend():
return readyToSend(_that);case _VoiceError():
return error(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Idle value)?  idle,TResult? Function( _RequestingPermission value)?  requestingPermission,TResult? Function( _PermissionDenied value)?  permissionDenied,TResult? Function( _Greeting value)?  greeting,TResult? Function( _Listening value)?  listening,TResult? Function( _Reviewing value)?  reviewing,TResult? Function( _ReadyToSend value)?  readyToSend,TResult? Function( _VoiceError value)?  error,}){
final _that = this;
switch (_that) {
case _Idle() when idle != null:
return idle(_that);case _RequestingPermission() when requestingPermission != null:
return requestingPermission(_that);case _PermissionDenied() when permissionDenied != null:
return permissionDenied(_that);case _Greeting() when greeting != null:
return greeting(_that);case _Listening() when listening != null:
return listening(_that);case _Reviewing() when reviewing != null:
return reviewing(_that);case _ReadyToSend() when readyToSend != null:
return readyToSend(_that);case _VoiceError() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  idle,TResult Function()?  requestingPermission,TResult Function( bool isPermanent)?  permissionDenied,TResult Function()?  greeting,TResult Function( String partialText,  double soundLevel)?  listening,TResult Function( String recognizedText,  double autoSendCountdown)?  reviewing,TResult Function( String text)?  readyToSend,TResult Function( AssistantVoiceErrorKind kind,  String? customMessage)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Idle() when idle != null:
return idle();case _RequestingPermission() when requestingPermission != null:
return requestingPermission();case _PermissionDenied() when permissionDenied != null:
return permissionDenied(_that.isPermanent);case _Greeting() when greeting != null:
return greeting();case _Listening() when listening != null:
return listening(_that.partialText,_that.soundLevel);case _Reviewing() when reviewing != null:
return reviewing(_that.recognizedText,_that.autoSendCountdown);case _ReadyToSend() when readyToSend != null:
return readyToSend(_that.text);case _VoiceError() when error != null:
return error(_that.kind,_that.customMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  idle,required TResult Function()  requestingPermission,required TResult Function( bool isPermanent)  permissionDenied,required TResult Function()  greeting,required TResult Function( String partialText,  double soundLevel)  listening,required TResult Function( String recognizedText,  double autoSendCountdown)  reviewing,required TResult Function( String text)  readyToSend,required TResult Function( AssistantVoiceErrorKind kind,  String? customMessage)  error,}) {final _that = this;
switch (_that) {
case _Idle():
return idle();case _RequestingPermission():
return requestingPermission();case _PermissionDenied():
return permissionDenied(_that.isPermanent);case _Greeting():
return greeting();case _Listening():
return listening(_that.partialText,_that.soundLevel);case _Reviewing():
return reviewing(_that.recognizedText,_that.autoSendCountdown);case _ReadyToSend():
return readyToSend(_that.text);case _VoiceError():
return error(_that.kind,_that.customMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  idle,TResult? Function()?  requestingPermission,TResult? Function( bool isPermanent)?  permissionDenied,TResult? Function()?  greeting,TResult? Function( String partialText,  double soundLevel)?  listening,TResult? Function( String recognizedText,  double autoSendCountdown)?  reviewing,TResult? Function( String text)?  readyToSend,TResult? Function( AssistantVoiceErrorKind kind,  String? customMessage)?  error,}) {final _that = this;
switch (_that) {
case _Idle() when idle != null:
return idle();case _RequestingPermission() when requestingPermission != null:
return requestingPermission();case _PermissionDenied() when permissionDenied != null:
return permissionDenied(_that.isPermanent);case _Greeting() when greeting != null:
return greeting();case _Listening() when listening != null:
return listening(_that.partialText,_that.soundLevel);case _Reviewing() when reviewing != null:
return reviewing(_that.recognizedText,_that.autoSendCountdown);case _ReadyToSend() when readyToSend != null:
return readyToSend(_that.text);case _VoiceError() when error != null:
return error(_that.kind,_that.customMessage);case _:
  return null;

}
}

}

/// @nodoc


class _Idle implements AssistantVoiceState {
  const _Idle();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Idle);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AssistantVoiceState.idle()';
}


}




/// @nodoc


class _RequestingPermission implements AssistantVoiceState {
  const _RequestingPermission();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RequestingPermission);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AssistantVoiceState.requestingPermission()';
}


}




/// @nodoc


class _PermissionDenied implements AssistantVoiceState {
  const _PermissionDenied({this.isPermanent = false});
  

@JsonKey() final  bool isPermanent;

/// Create a copy of AssistantVoiceState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PermissionDeniedCopyWith<_PermissionDenied> get copyWith => __$PermissionDeniedCopyWithImpl<_PermissionDenied>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PermissionDenied&&(identical(other.isPermanent, isPermanent) || other.isPermanent == isPermanent));
}


@override
int get hashCode => Object.hash(runtimeType,isPermanent);

@override
String toString() {
  return 'AssistantVoiceState.permissionDenied(isPermanent: $isPermanent)';
}


}

/// @nodoc
abstract mixin class _$PermissionDeniedCopyWith<$Res> implements $AssistantVoiceStateCopyWith<$Res> {
  factory _$PermissionDeniedCopyWith(_PermissionDenied value, $Res Function(_PermissionDenied) _then) = __$PermissionDeniedCopyWithImpl;
@useResult
$Res call({
 bool isPermanent
});




}
/// @nodoc
class __$PermissionDeniedCopyWithImpl<$Res>
    implements _$PermissionDeniedCopyWith<$Res> {
  __$PermissionDeniedCopyWithImpl(this._self, this._then);

  final _PermissionDenied _self;
  final $Res Function(_PermissionDenied) _then;

/// Create a copy of AssistantVoiceState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? isPermanent = null,}) {
  return _then(_PermissionDenied(
isPermanent: null == isPermanent ? _self.isPermanent : isPermanent // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class _Greeting implements AssistantVoiceState {
  const _Greeting();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Greeting);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AssistantVoiceState.greeting()';
}


}




/// @nodoc


class _Listening implements AssistantVoiceState {
  const _Listening({this.partialText = '', this.soundLevel = 0.0});
  

@JsonKey() final  String partialText;
@JsonKey() final  double soundLevel;

/// Create a copy of AssistantVoiceState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ListeningCopyWith<_Listening> get copyWith => __$ListeningCopyWithImpl<_Listening>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Listening&&(identical(other.partialText, partialText) || other.partialText == partialText)&&(identical(other.soundLevel, soundLevel) || other.soundLevel == soundLevel));
}


@override
int get hashCode => Object.hash(runtimeType,partialText,soundLevel);

@override
String toString() {
  return 'AssistantVoiceState.listening(partialText: $partialText, soundLevel: $soundLevel)';
}


}

/// @nodoc
abstract mixin class _$ListeningCopyWith<$Res> implements $AssistantVoiceStateCopyWith<$Res> {
  factory _$ListeningCopyWith(_Listening value, $Res Function(_Listening) _then) = __$ListeningCopyWithImpl;
@useResult
$Res call({
 String partialText, double soundLevel
});




}
/// @nodoc
class __$ListeningCopyWithImpl<$Res>
    implements _$ListeningCopyWith<$Res> {
  __$ListeningCopyWithImpl(this._self, this._then);

  final _Listening _self;
  final $Res Function(_Listening) _then;

/// Create a copy of AssistantVoiceState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? partialText = null,Object? soundLevel = null,}) {
  return _then(_Listening(
partialText: null == partialText ? _self.partialText : partialText // ignore: cast_nullable_to_non_nullable
as String,soundLevel: null == soundLevel ? _self.soundLevel : soundLevel // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

/// @nodoc


class _Reviewing implements AssistantVoiceState {
  const _Reviewing({required this.recognizedText, this.autoSendCountdown = 1.5});
  

 final  String recognizedText;
@JsonKey() final  double autoSendCountdown;

/// Create a copy of AssistantVoiceState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReviewingCopyWith<_Reviewing> get copyWith => __$ReviewingCopyWithImpl<_Reviewing>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Reviewing&&(identical(other.recognizedText, recognizedText) || other.recognizedText == recognizedText)&&(identical(other.autoSendCountdown, autoSendCountdown) || other.autoSendCountdown == autoSendCountdown));
}


@override
int get hashCode => Object.hash(runtimeType,recognizedText,autoSendCountdown);

@override
String toString() {
  return 'AssistantVoiceState.reviewing(recognizedText: $recognizedText, autoSendCountdown: $autoSendCountdown)';
}


}

/// @nodoc
abstract mixin class _$ReviewingCopyWith<$Res> implements $AssistantVoiceStateCopyWith<$Res> {
  factory _$ReviewingCopyWith(_Reviewing value, $Res Function(_Reviewing) _then) = __$ReviewingCopyWithImpl;
@useResult
$Res call({
 String recognizedText, double autoSendCountdown
});




}
/// @nodoc
class __$ReviewingCopyWithImpl<$Res>
    implements _$ReviewingCopyWith<$Res> {
  __$ReviewingCopyWithImpl(this._self, this._then);

  final _Reviewing _self;
  final $Res Function(_Reviewing) _then;

/// Create a copy of AssistantVoiceState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? recognizedText = null,Object? autoSendCountdown = null,}) {
  return _then(_Reviewing(
recognizedText: null == recognizedText ? _self.recognizedText : recognizedText // ignore: cast_nullable_to_non_nullable
as String,autoSendCountdown: null == autoSendCountdown ? _self.autoSendCountdown : autoSendCountdown // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

/// @nodoc


class _ReadyToSend implements AssistantVoiceState {
  const _ReadyToSend(this.text);
  

 final  String text;

/// Create a copy of AssistantVoiceState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReadyToSendCopyWith<_ReadyToSend> get copyWith => __$ReadyToSendCopyWithImpl<_ReadyToSend>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReadyToSend&&(identical(other.text, text) || other.text == text));
}


@override
int get hashCode => Object.hash(runtimeType,text);

@override
String toString() {
  return 'AssistantVoiceState.readyToSend(text: $text)';
}


}

/// @nodoc
abstract mixin class _$ReadyToSendCopyWith<$Res> implements $AssistantVoiceStateCopyWith<$Res> {
  factory _$ReadyToSendCopyWith(_ReadyToSend value, $Res Function(_ReadyToSend) _then) = __$ReadyToSendCopyWithImpl;
@useResult
$Res call({
 String text
});




}
/// @nodoc
class __$ReadyToSendCopyWithImpl<$Res>
    implements _$ReadyToSendCopyWith<$Res> {
  __$ReadyToSendCopyWithImpl(this._self, this._then);

  final _ReadyToSend _self;
  final $Res Function(_ReadyToSend) _then;

/// Create a copy of AssistantVoiceState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? text = null,}) {
  return _then(_ReadyToSend(
null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _VoiceError implements AssistantVoiceState {
  const _VoiceError({required this.kind, this.customMessage});
  

 final  AssistantVoiceErrorKind kind;
 final  String? customMessage;

/// Create a copy of AssistantVoiceState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VoiceErrorCopyWith<_VoiceError> get copyWith => __$VoiceErrorCopyWithImpl<_VoiceError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VoiceError&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.customMessage, customMessage) || other.customMessage == customMessage));
}


@override
int get hashCode => Object.hash(runtimeType,kind,customMessage);

@override
String toString() {
  return 'AssistantVoiceState.error(kind: $kind, customMessage: $customMessage)';
}


}

/// @nodoc
abstract mixin class _$VoiceErrorCopyWith<$Res> implements $AssistantVoiceStateCopyWith<$Res> {
  factory _$VoiceErrorCopyWith(_VoiceError value, $Res Function(_VoiceError) _then) = __$VoiceErrorCopyWithImpl;
@useResult
$Res call({
 AssistantVoiceErrorKind kind, String? customMessage
});




}
/// @nodoc
class __$VoiceErrorCopyWithImpl<$Res>
    implements _$VoiceErrorCopyWith<$Res> {
  __$VoiceErrorCopyWithImpl(this._self, this._then);

  final _VoiceError _self;
  final $Res Function(_VoiceError) _then;

/// Create a copy of AssistantVoiceState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? kind = null,Object? customMessage = freezed,}) {
  return _then(_VoiceError(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as AssistantVoiceErrorKind,customMessage: freezed == customMessage ? _self.customMessage : customMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
