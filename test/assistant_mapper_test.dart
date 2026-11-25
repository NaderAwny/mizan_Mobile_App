import 'package:flutter_test/flutter_test.dart';
import 'package:mizan/data/mapper/assistant_mapper.dart';
import 'package:mizan/data/response/assistant_responses/assistant_responses.dart';
import 'package:mizan/domain/model/assistant_model.dart';

void main() {
  group('Assistant Mapper Tests', () {
    test('AssistantSessionMapper handles null and valid data', () {
      const AssistantSessionData? nullData = null;
      final AssistantSession nullDomain = nullData.toDomain();
      expect(nullDomain.sessionId, '');
      expect(nullDomain.expiresAt, isNull);

      final AssistantSessionData validData = AssistantSessionData(
        sessionId: 'test-session-123',
        expiresAt: '2026-11-22T20:00:00Z',
      );
      final AssistantSession validDomain = validData.toDomain();
      expect(validDomain.sessionId, 'test-session-123');
      expect(validDomain.expiresAt, isNotNull);
    });

    test('parseIsoDateSafe handles dates without Z as UTC', () {
      final DateTime? date = parseIsoDateSafe('2026-11-22T18:00:00');
      expect(date, isNotNull);

      final DateTime? invalidDate = parseIsoDateSafe('invalid-date-string');
      expect(invalidDate, isNull);
    });

    test('PendingActionMapper maps correctly and handles empty actionId', () {
      final PendingActionData emptyData = PendingActionData(
        actionId: '',
        intent: 'add_transaction',
        summary: 'بيع نقدي',
      );
      expect(emptyData.toDomain(), isNull);

      final PendingActionData validData = PendingActionData(
        actionId: 'action-456',
        intent: 'create_sale',
        summary: 'تسجيل عملية بيع بمبلغ 500',
        expiresAt: '2026-11-22T19:00:00Z',
      );
      final AssistantPendingAction? domain = validData.toDomain();
      expect(domain, isNotNull);
      expect(domain!.actionId, 'action-456');
      expect(domain.intent, 'create_sale');
      expect(domain.summary, 'تسجيل عملية بيع بمبلغ 500');
    });

    test('AssistantResponseMapper handles all types and case insensitivity', () {
      final List<String> types = <String>[
        'answer',
        'ANSWER',
        'question',
        'Question',
        'clarification',
        'confirmation',
        'CONFIRMATION',
        'success',
        'cancelled',
        'error',
        'something_new_from_server',
      ];

      for (final String typeStr in types) {
        final AssistantResponseData data = AssistantResponseData(
          sessionId: 'session-1',
          type: typeStr,
          message: 'Hello',
        );
        final AssistantReply domain = data.toDomain();
        expect(domain.message, 'Hello');
        if (typeStr == 'something_new_from_server') {
          expect(domain.type, AssistantReplyType.unknown);
        } else {
          expect(domain.type.name.toLowerCase(), typeStr.toLowerCase());
        }
      }
    });

    test('AssistantResponseMapper handles null and raw payload preservation', () {
      final AssistantResponseData data = AssistantResponseData(
        sessionId: 'session-xyz',
        sessionReset: true,
        type: 'answer',
        message: 'إليك كشف الحساب',
        data: <String, dynamic>{'balance': 1500, 'transactions': <dynamic>[1, 2]},
        options: <String>['خيار 1', '', '  ', 'خيار 2'],
      );

      final AssistantReply domain = data.toDomain();
      expect(domain.sessionReset, true);
      expect(domain.payload, isA<Map<String, dynamic>>());
      expect((domain.payload as Map<String, dynamic>)['balance'], 1500);
      expect(domain.options, <String>['خيار 1', 'خيار 2']);
    });
  });
}
