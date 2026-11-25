import 'package:injectable/injectable.dart';
import 'package:mizan/data/network/app_api.dart';
import 'package:mizan/data/request/assistant_request.dart';
import 'package:mizan/data/response/assistant_responses/assistant_responses.dart';
import 'package:mizan/data/response/base_responses/base_responses.dart';

abstract class AssistantRemoteDataSource {
  Future<AssistantSessionResponse> startSession();
  Future<AssistantCommandResponse> sendCommand(AssistantCommandRequest request);
  Future<AssistantCommandResponse> confirmAction(String sessionId, String actionId);
  Future<AssistantCommandResponse> cancelAction(String sessionId, String actionId);
  Future<BaseResponse> endSession(String sessionId);
}

@LazySingleton(as: AssistantRemoteDataSource)
class AssistantRemoteDataSourceImpl implements AssistantRemoteDataSource {
  final AppServiceClient _appServiceClient;

  AssistantRemoteDataSourceImpl(this._appServiceClient);

  @override
  Future<AssistantSessionResponse> startSession() {
    return _appServiceClient.startAssistantSession();
  }

  @override
  Future<AssistantCommandResponse> sendCommand(AssistantCommandRequest request) {
    return _appServiceClient.sendAssistantCommand(request.toJson());
  }

  @override
  Future<AssistantCommandResponse> confirmAction(String sessionId, String actionId) {
    return _appServiceClient.confirmAssistantAction(sessionId, actionId);
  }

  @override
  Future<AssistantCommandResponse> cancelAction(String sessionId, String actionId) {
    return _appServiceClient.cancelAssistantAction(sessionId, actionId);
  }

  @override
  Future<BaseResponse> endSession(String sessionId) {
    return _appServiceClient.endAssistantSession(sessionId);
  }
}
