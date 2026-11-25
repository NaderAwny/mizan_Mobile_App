enum AssistantReplyType {
  answer,
  question,
  clarification,
  confirmation,
  success,
  cancelled,
  error,
  unknown;

  static AssistantReplyType fromString(String? rawType) {
    if (rawType == null) return AssistantReplyType.unknown;
    final String clean = rawType.trim().toLowerCase();
    for (final AssistantReplyType value in AssistantReplyType.values) {
      if (value.name.toLowerCase() == clean) {
        return value;
      }
    }
    return AssistantReplyType.unknown;
  }
}

class AssistantSession {
  final String sessionId;
  final DateTime? expiresAt;

  const AssistantSession({
    required this.sessionId,
    this.expiresAt,
  });
}

class AssistantPendingAction {
  final String actionId;
  final String intent;
  final String summary;
  final DateTime? expiresAt;

  const AssistantPendingAction({
    required this.actionId,
    required this.intent,
    required this.summary,
    this.expiresAt,
  });

  bool get isExpired {
    if (expiresAt == null) return false;
    return DateTime.now().isAfter(expiresAt!);
  }
}

class AssistantReply {
  final String sessionId;
  final bool sessionReset;
  final AssistantReplyType type;
  final String message;
  final dynamic payload;
  final List<String> options;
  final AssistantPendingAction? pendingAction;

  const AssistantReply({
    required this.sessionId,
    required this.sessionReset,
    required this.type,
    required this.message,
    this.payload,
    this.options = const <String>[],
    this.pendingAction,
  });
}

enum ChatSender {
  user,
  assistant,
}

class ChatMessage {
  final String id;
  final ChatSender sender;
  final String text;
  final AssistantReplyType type;
  final dynamic payload;
  final List<String> options;
  final AssistantPendingAction? pendingAction;
  final DateTime timestamp;
  final bool isFailed;

  const ChatMessage({
    required this.id,
    required this.sender,
    required this.text,
    this.type = AssistantReplyType.answer,
    this.payload,
    this.options = const <String>[],
    this.pendingAction,
    required this.timestamp,
    this.isFailed = false,
  });

  ChatMessage copyWith({
    String? id,
    ChatSender? sender,
    String? text,
    AssistantReplyType? type,
    dynamic payload,
    List<String>? options,
    AssistantPendingAction? pendingAction,
    DateTime? timestamp,
    bool? isFailed,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      sender: sender ?? this.sender,
      text: text ?? this.text,
      type: type ?? this.type,
      payload: payload ?? this.payload,
      options: options ?? this.options,
      pendingAction: pendingAction ?? this.pendingAction,
      timestamp: timestamp ?? this.timestamp,
      isFailed: isFailed ?? this.isFailed,
    );
  }
}
