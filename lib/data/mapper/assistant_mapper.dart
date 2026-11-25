import 'package:mizan/app/extensions.dart';
import 'package:mizan/data/response/assistant_responses/assistant_responses.dart';
import 'package:mizan/domain/model/assistant_model.dart';

DateTime? parseIsoDateSafe(String? dateStr) {
  if (dateStr == null || dateStr.trim().isEmpty) return null;
  try {
    final String trimmed = dateStr.trim();
    if (!trimmed.endsWith('Z') && !trimmed.contains('+') && !RegExp(r'-\d\d:\d\d').hasMatch(trimmed)) {
      return DateTime.parse('${trimmed}Z').toLocal();
    }
    return DateTime.parse(trimmed).toLocal();
  } catch (_) {
    return null;
  }
}

extension AssistantSessionMapper on AssistantSessionData? {
  AssistantSession toDomain() {
    return AssistantSession(
      sessionId: this?.sessionId.orEmpty() ?? '',
      expiresAt: parseIsoDateSafe(this?.expiresAt),
    );
  }
}

extension PendingActionMapper on PendingActionData? {
  AssistantPendingAction? toDomain() {
    if (this == null) return null;
    final String actionId = this?.actionId.orEmpty() ?? '';
    if (actionId.isEmpty) return null;

    return AssistantPendingAction(
      actionId: actionId,
      intent: this?.intent.orEmpty() ?? '',
      summary: this?.summary.orEmpty() ?? '',
      expiresAt: parseIsoDateSafe(this?.expiresAt),
    );
  }
}

extension AssistantResponseMapper on AssistantResponseData? {
  AssistantReply toDomain() {
    final AssistantReplyType parsedType = AssistantReplyType.fromString(this?.type);
    return AssistantReply(
      sessionId: this?.sessionId.orEmpty() ?? '',
      sessionReset: this?.sessionReset.orFalse() ?? false,
      type: parsedType,
      message: this?.message.orEmpty() ?? '',
      payload: this?.data,
      options: (this?.options ?? const <String>[]).where((String o) => o.trim().isNotEmpty).toList(),
      pendingAction: this?.pendingAction.toDomain(),
    );
  }
}
