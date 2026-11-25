// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'assistant_chat_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AssistantChatState {

 FlowState? get flowState; List<ChatMessage> get messages; String? get currentSessionId; DateTime? get sessionExpiresAt; AssistantPendingAction? get pendingAction; bool get isActionExpired; String? get expiredActionId; bool get isExecutingAction; bool get sessionResetNotice; bool get isRateLimited; String? get rateLimitMessage; String? get lastFailedText;
/// Create a copy of AssistantChatState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AssistantChatStateCopyWith<AssistantChatState> get copyWith => _$AssistantChatStateCopyWithImpl<AssistantChatState>(this as AssistantChatState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AssistantChatState&&(identical(other.flowState, flowState) || other.flowState == flowState)&&const DeepCollectionEquality().equals(other.messages, messages)&&(identical(other.currentSessionId, currentSessionId) || other.currentSessionId == currentSessionId)&&(identical(other.sessionExpiresAt, sessionExpiresAt) || other.sessionExpiresAt == sessionExpiresAt)&&(identical(other.pendingAction, pendingAction) || other.pendingAction == pendingAction)&&(identical(other.isActionExpired, isActionExpired) || other.isActionExpired == isActionExpired)&&(identical(other.expiredActionId, expiredActionId) || other.expiredActionId == expiredActionId)&&(identical(other.isExecutingAction, isExecutingAction) || other.isExecutingAction == isExecutingAction)&&(identical(other.sessionResetNotice, sessionResetNotice) || other.sessionResetNotice == sessionResetNotice)&&(identical(other.isRateLimited, isRateLimited) || other.isRateLimited == isRateLimited)&&(identical(other.rateLimitMessage, rateLimitMessage) || other.rateLimitMessage == rateLimitMessage)&&(identical(other.lastFailedText, lastFailedText) || other.lastFailedText == lastFailedText));
}


@override
int get hashCode => Object.hash(runtimeType,flowState,const DeepCollectionEquality().hash(messages),currentSessionId,sessionExpiresAt,pendingAction,isActionExpired,expiredActionId,isExecutingAction,sessionResetNotice,isRateLimited,rateLimitMessage,lastFailedText);

@override
String toString() {
  return 'AssistantChatState(flowState: $flowState, messages: $messages, currentSessionId: $currentSessionId, sessionExpiresAt: $sessionExpiresAt, pendingAction: $pendingAction, isActionExpired: $isActionExpired, expiredActionId: $expiredActionId, isExecutingAction: $isExecutingAction, sessionResetNotice: $sessionResetNotice, isRateLimited: $isRateLimited, rateLimitMessage: $rateLimitMessage, lastFailedText: $lastFailedText)';
}


}

/// @nodoc
abstract mixin class $AssistantChatStateCopyWith<$Res>  {
  factory $AssistantChatStateCopyWith(AssistantChatState value, $Res Function(AssistantChatState) _then) = _$AssistantChatStateCopyWithImpl;
@useResult
$Res call({
 FlowState? flowState, List<ChatMessage> messages, String? currentSessionId, DateTime? sessionExpiresAt, AssistantPendingAction? pendingAction, bool isActionExpired, String? expiredActionId, bool isExecutingAction, bool sessionResetNotice, bool isRateLimited, String? rateLimitMessage, String? lastFailedText
});




}
/// @nodoc
class _$AssistantChatStateCopyWithImpl<$Res>
    implements $AssistantChatStateCopyWith<$Res> {
  _$AssistantChatStateCopyWithImpl(this._self, this._then);

  final AssistantChatState _self;
  final $Res Function(AssistantChatState) _then;

/// Create a copy of AssistantChatState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? flowState = freezed,Object? messages = null,Object? currentSessionId = freezed,Object? sessionExpiresAt = freezed,Object? pendingAction = freezed,Object? isActionExpired = null,Object? expiredActionId = freezed,Object? isExecutingAction = null,Object? sessionResetNotice = null,Object? isRateLimited = null,Object? rateLimitMessage = freezed,Object? lastFailedText = freezed,}) {
  return _then(_self.copyWith(
flowState: freezed == flowState ? _self.flowState : flowState // ignore: cast_nullable_to_non_nullable
as FlowState?,messages: null == messages ? _self.messages : messages // ignore: cast_nullable_to_non_nullable
as List<ChatMessage>,currentSessionId: freezed == currentSessionId ? _self.currentSessionId : currentSessionId // ignore: cast_nullable_to_non_nullable
as String?,sessionExpiresAt: freezed == sessionExpiresAt ? _self.sessionExpiresAt : sessionExpiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,pendingAction: freezed == pendingAction ? _self.pendingAction : pendingAction // ignore: cast_nullable_to_non_nullable
as AssistantPendingAction?,isActionExpired: null == isActionExpired ? _self.isActionExpired : isActionExpired // ignore: cast_nullable_to_non_nullable
as bool,expiredActionId: freezed == expiredActionId ? _self.expiredActionId : expiredActionId // ignore: cast_nullable_to_non_nullable
as String?,isExecutingAction: null == isExecutingAction ? _self.isExecutingAction : isExecutingAction // ignore: cast_nullable_to_non_nullable
as bool,sessionResetNotice: null == sessionResetNotice ? _self.sessionResetNotice : sessionResetNotice // ignore: cast_nullable_to_non_nullable
as bool,isRateLimited: null == isRateLimited ? _self.isRateLimited : isRateLimited // ignore: cast_nullable_to_non_nullable
as bool,rateLimitMessage: freezed == rateLimitMessage ? _self.rateLimitMessage : rateLimitMessage // ignore: cast_nullable_to_non_nullable
as String?,lastFailedText: freezed == lastFailedText ? _self.lastFailedText : lastFailedText // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AssistantChatState].
extension AssistantChatStatePatterns on AssistantChatState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AssistantChatState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AssistantChatState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AssistantChatState value)  $default,){
final _that = this;
switch (_that) {
case _AssistantChatState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AssistantChatState value)?  $default,){
final _that = this;
switch (_that) {
case _AssistantChatState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( FlowState? flowState,  List<ChatMessage> messages,  String? currentSessionId,  DateTime? sessionExpiresAt,  AssistantPendingAction? pendingAction,  bool isActionExpired,  String? expiredActionId,  bool isExecutingAction,  bool sessionResetNotice,  bool isRateLimited,  String? rateLimitMessage,  String? lastFailedText)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AssistantChatState() when $default != null:
return $default(_that.flowState,_that.messages,_that.currentSessionId,_that.sessionExpiresAt,_that.pendingAction,_that.isActionExpired,_that.expiredActionId,_that.isExecutingAction,_that.sessionResetNotice,_that.isRateLimited,_that.rateLimitMessage,_that.lastFailedText);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( FlowState? flowState,  List<ChatMessage> messages,  String? currentSessionId,  DateTime? sessionExpiresAt,  AssistantPendingAction? pendingAction,  bool isActionExpired,  String? expiredActionId,  bool isExecutingAction,  bool sessionResetNotice,  bool isRateLimited,  String? rateLimitMessage,  String? lastFailedText)  $default,) {final _that = this;
switch (_that) {
case _AssistantChatState():
return $default(_that.flowState,_that.messages,_that.currentSessionId,_that.sessionExpiresAt,_that.pendingAction,_that.isActionExpired,_that.expiredActionId,_that.isExecutingAction,_that.sessionResetNotice,_that.isRateLimited,_that.rateLimitMessage,_that.lastFailedText);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( FlowState? flowState,  List<ChatMessage> messages,  String? currentSessionId,  DateTime? sessionExpiresAt,  AssistantPendingAction? pendingAction,  bool isActionExpired,  String? expiredActionId,  bool isExecutingAction,  bool sessionResetNotice,  bool isRateLimited,  String? rateLimitMessage,  String? lastFailedText)?  $default,) {final _that = this;
switch (_that) {
case _AssistantChatState() when $default != null:
return $default(_that.flowState,_that.messages,_that.currentSessionId,_that.sessionExpiresAt,_that.pendingAction,_that.isActionExpired,_that.expiredActionId,_that.isExecutingAction,_that.sessionResetNotice,_that.isRateLimited,_that.rateLimitMessage,_that.lastFailedText);case _:
  return null;

}
}

}

/// @nodoc


class _AssistantChatState implements AssistantChatState {
  const _AssistantChatState({this.flowState, final  List<ChatMessage> messages = const <ChatMessage>[], this.currentSessionId, this.sessionExpiresAt, this.pendingAction, this.isActionExpired = false, this.expiredActionId, this.isExecutingAction = false, this.sessionResetNotice = false, this.isRateLimited = false, this.rateLimitMessage, this.lastFailedText}): _messages = messages;
  

@override final  FlowState? flowState;
 final  List<ChatMessage> _messages;
@override@JsonKey() List<ChatMessage> get messages {
  if (_messages is EqualUnmodifiableListView) return _messages;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_messages);
}

@override final  String? currentSessionId;
@override final  DateTime? sessionExpiresAt;
@override final  AssistantPendingAction? pendingAction;
@override@JsonKey() final  bool isActionExpired;
@override final  String? expiredActionId;
@override@JsonKey() final  bool isExecutingAction;
@override@JsonKey() final  bool sessionResetNotice;
@override@JsonKey() final  bool isRateLimited;
@override final  String? rateLimitMessage;
@override final  String? lastFailedText;

/// Create a copy of AssistantChatState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AssistantChatStateCopyWith<_AssistantChatState> get copyWith => __$AssistantChatStateCopyWithImpl<_AssistantChatState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AssistantChatState&&(identical(other.flowState, flowState) || other.flowState == flowState)&&const DeepCollectionEquality().equals(other._messages, _messages)&&(identical(other.currentSessionId, currentSessionId) || other.currentSessionId == currentSessionId)&&(identical(other.sessionExpiresAt, sessionExpiresAt) || other.sessionExpiresAt == sessionExpiresAt)&&(identical(other.pendingAction, pendingAction) || other.pendingAction == pendingAction)&&(identical(other.isActionExpired, isActionExpired) || other.isActionExpired == isActionExpired)&&(identical(other.expiredActionId, expiredActionId) || other.expiredActionId == expiredActionId)&&(identical(other.isExecutingAction, isExecutingAction) || other.isExecutingAction == isExecutingAction)&&(identical(other.sessionResetNotice, sessionResetNotice) || other.sessionResetNotice == sessionResetNotice)&&(identical(other.isRateLimited, isRateLimited) || other.isRateLimited == isRateLimited)&&(identical(other.rateLimitMessage, rateLimitMessage) || other.rateLimitMessage == rateLimitMessage)&&(identical(other.lastFailedText, lastFailedText) || other.lastFailedText == lastFailedText));
}


@override
int get hashCode => Object.hash(runtimeType,flowState,const DeepCollectionEquality().hash(_messages),currentSessionId,sessionExpiresAt,pendingAction,isActionExpired,expiredActionId,isExecutingAction,sessionResetNotice,isRateLimited,rateLimitMessage,lastFailedText);

@override
String toString() {
  return 'AssistantChatState(flowState: $flowState, messages: $messages, currentSessionId: $currentSessionId, sessionExpiresAt: $sessionExpiresAt, pendingAction: $pendingAction, isActionExpired: $isActionExpired, expiredActionId: $expiredActionId, isExecutingAction: $isExecutingAction, sessionResetNotice: $sessionResetNotice, isRateLimited: $isRateLimited, rateLimitMessage: $rateLimitMessage, lastFailedText: $lastFailedText)';
}


}

/// @nodoc
abstract mixin class _$AssistantChatStateCopyWith<$Res> implements $AssistantChatStateCopyWith<$Res> {
  factory _$AssistantChatStateCopyWith(_AssistantChatState value, $Res Function(_AssistantChatState) _then) = __$AssistantChatStateCopyWithImpl;
@override @useResult
$Res call({
 FlowState? flowState, List<ChatMessage> messages, String? currentSessionId, DateTime? sessionExpiresAt, AssistantPendingAction? pendingAction, bool isActionExpired, String? expiredActionId, bool isExecutingAction, bool sessionResetNotice, bool isRateLimited, String? rateLimitMessage, String? lastFailedText
});




}
/// @nodoc
class __$AssistantChatStateCopyWithImpl<$Res>
    implements _$AssistantChatStateCopyWith<$Res> {
  __$AssistantChatStateCopyWithImpl(this._self, this._then);

  final _AssistantChatState _self;
  final $Res Function(_AssistantChatState) _then;

/// Create a copy of AssistantChatState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? flowState = freezed,Object? messages = null,Object? currentSessionId = freezed,Object? sessionExpiresAt = freezed,Object? pendingAction = freezed,Object? isActionExpired = null,Object? expiredActionId = freezed,Object? isExecutingAction = null,Object? sessionResetNotice = null,Object? isRateLimited = null,Object? rateLimitMessage = freezed,Object? lastFailedText = freezed,}) {
  return _then(_AssistantChatState(
flowState: freezed == flowState ? _self.flowState : flowState // ignore: cast_nullable_to_non_nullable
as FlowState?,messages: null == messages ? _self._messages : messages // ignore: cast_nullable_to_non_nullable
as List<ChatMessage>,currentSessionId: freezed == currentSessionId ? _self.currentSessionId : currentSessionId // ignore: cast_nullable_to_non_nullable
as String?,sessionExpiresAt: freezed == sessionExpiresAt ? _self.sessionExpiresAt : sessionExpiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,pendingAction: freezed == pendingAction ? _self.pendingAction : pendingAction // ignore: cast_nullable_to_non_nullable
as AssistantPendingAction?,isActionExpired: null == isActionExpired ? _self.isActionExpired : isActionExpired // ignore: cast_nullable_to_non_nullable
as bool,expiredActionId: freezed == expiredActionId ? _self.expiredActionId : expiredActionId // ignore: cast_nullable_to_non_nullable
as String?,isExecutingAction: null == isExecutingAction ? _self.isExecutingAction : isExecutingAction // ignore: cast_nullable_to_non_nullable
as bool,sessionResetNotice: null == sessionResetNotice ? _self.sessionResetNotice : sessionResetNotice // ignore: cast_nullable_to_non_nullable
as bool,isRateLimited: null == isRateLimited ? _self.isRateLimited : isRateLimited // ignore: cast_nullable_to_non_nullable
as bool,rateLimitMessage: freezed == rateLimitMessage ? _self.rateLimitMessage : rateLimitMessage // ignore: cast_nullable_to_non_nullable
as String?,lastFailedText: freezed == lastFailedText ? _self.lastFailedText : lastFailedText // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
