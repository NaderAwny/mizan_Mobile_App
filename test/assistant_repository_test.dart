import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mizan/data/data_source/assistant_remote_data_source.dart';
import 'package:mizan/data/network/error_handler.dart';
import 'package:mizan/data/network/failure.dart';
import 'package:mizan/data/network/network_info.dart';
import 'package:mizan/data/repository_impl/assistant_repository_impl.dart';
import 'package:mizan/data/request/assistant_request.dart';
import 'package:mizan/data/response/assistant_responses/assistant_responses.dart';
import 'package:mizan/data/response/base_responses/base_responses.dart';
import 'package:mizan/domain/model/assistant_model.dart';

class FakeNetworkInfo implements NetworkInfo {
  bool connected = true;
  @override
  Future<bool> get isConnected => Future<bool>.value(connected);
}

class FakeAssistantRemoteDataSource implements AssistantRemoteDataSource {
  bool shouldThrow = false;
  Exception? exceptionToThrow;
  bool successResponse = true;

  @override
  Future<AssistantSessionResponse> startSession() async {
    if (shouldThrow) throw exceptionToThrow ?? Exception('Network failed');
    return AssistantSessionResponse(
      success: successResponse,
      message: successResponse ? 'Success' : 'Failed to start session',
      data: successResponse
          ? AssistantSessionData(
              sessionId: 'fake-sess-1',
              expiresAt: '2026-11-22T19:00:00Z',
            )
          : null,
    );
  }

  @override
  Future<AssistantCommandResponse> sendCommand(
    AssistantCommandRequest request,
  ) async {
    if (shouldThrow) throw exceptionToThrow ?? Exception('Network failed');
    return AssistantCommandResponse(
      success: successResponse,
      message: successResponse ? 'Success' : 'Failed command',
      data: successResponse
          ? AssistantResponseData(
              sessionId: request.sessionId ?? 'new-sess-1',
              sessionReset: false,
              type: 'answer',
              message: 'رد تجريبي: ${request.text}',
            )
          : null,
    );
  }

  @override
  Future<AssistantCommandResponse> confirmAction(
    String sessionId,
    String actionId,
  ) async {
    if (shouldThrow) throw exceptionToThrow ?? Exception('Network failed');
    return AssistantCommandResponse(
      success: successResponse,
      message: successResponse ? 'Confirmed' : 'Failed confirm',
      data: successResponse
          ? AssistantResponseData(
              sessionId: sessionId,
              sessionReset: false,
              type: 'success',
              message: 'تم تأكيد العملية بنجاح',
            )
          : null,
    );
  }

  @override
  Future<AssistantCommandResponse> cancelAction(
    String sessionId,
    String actionId,
  ) async {
    if (shouldThrow) throw exceptionToThrow ?? Exception('Network failed');
    return AssistantCommandResponse(
      success: successResponse,
      message: successResponse ? 'Cancelled' : 'Failed cancel',
      data: successResponse
          ? AssistantResponseData(
              sessionId: sessionId,
              sessionReset: false,
              type: 'cancelled',
              message: 'تم إلغاء العملية',
            )
          : null,
    );
  }

  @override
  Future<BaseResponse> endSession(String sessionId) async {
    if (shouldThrow) throw exceptionToThrow ?? Exception('Network failed');
    return BaseResponse(
      success: successResponse,
      message: successResponse ? 'Session ended' : 'Failed to end session',
    );
  }
}

void main() {
  late FakeNetworkInfo fakeNetworkInfo;
  late FakeAssistantRemoteDataSource fakeRemoteDataSource;
  late AssistantRepositoryImpl repository;

  setUp(() {
    fakeNetworkInfo = FakeNetworkInfo();
    fakeRemoteDataSource = FakeAssistantRemoteDataSource();
    repository = AssistantRepositoryImpl(fakeRemoteDataSource, fakeNetworkInfo);
  });

  group('AssistantRepositoryImpl Tests', () {
    test('startSession returns Right on success', () async {
      final Either<Failure, AssistantSession> result =
          await repository.startSession();
      expect(result.isRight(), true);
      result.fold(
        (Failure f) => fail('Expected right'),
        (AssistantSession s) => expect(s.sessionId, 'fake-sess-1'),
      );
    });

    test('sendCommand returns Left when no internet', () async {
      fakeNetworkInfo.connected = false;
      final Either<Failure, AssistantReply> result =
          await repository.sendCommand('sess-1', 'نص');
      expect(result.isLeft(), true);
      result.fold(
        (Failure f) => expect(f.code, ResponseCode.NO_INTERNET_CONNECTION),
        (AssistantReply r) => fail('Expected left'),
      );
    });

    test('confirmAction maps DioException 429 correctly', () async {
      fakeRemoteDataSource.shouldThrow = true;
      fakeRemoteDataSource.exceptionToThrow = DioException(
        requestOptions: RequestOptions(path: '/api/assistant/confirm'),
        response: Response<dynamic>(
          requestOptions: RequestOptions(path: '/api/assistant/confirm'),
          statusCode: 429,
          data: <String, dynamic>{'message': 'Too Many Requests'},
        ),
        type: DioExceptionType.badResponse,
      );

      final Either<Failure, AssistantReply> result =
          await repository.confirmAction('sess-1', 'act-1');
      expect(result.isLeft(), true);
      result.fold(
        (Failure f) => expect(f.code, 429),
        (AssistantReply r) => fail('Expected left'),
      );
    });

    test('cancelAction returns Right on success', () async {
      final Either<Failure, AssistantReply> result =
          await repository.cancelAction('sess-1', 'act-1');
      expect(result.isRight(), true);
      result.fold(
        (Failure f) => fail('Expected right'),
        (AssistantReply r) => expect(r.type, AssistantReplyType.cancelled),
      );
    });

    test('endSession returns Right on success', () async {
      final Either<Failure, void> result =
          await repository.endSession('sess-1');
      expect(result.isRight(), true);
    });
  });
}
