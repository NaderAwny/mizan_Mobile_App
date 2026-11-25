class AssistantCommandRequest {
  final String? sessionId;
  final String text;

  const AssistantCommandRequest({
    this.sessionId,
    required this.text,
  });

  Map<String, dynamic> toJson() => <String, dynamic>{
    if (sessionId != null && sessionId!.isNotEmpty) 'sessionId': sessionId,
    'text': text,
  };
}
