import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:mizan/data/data_source/assistant_remote_data_source.dart';
import 'package:mizan/data/mapper/assistant_mapper.dart';
import 'package:mizan/data/network/error_handler.dart';
import 'package:mizan/data/network/failure.dart';
import 'package:mizan/data/network/network_info.dart';
import 'package:mizan/data/request/assistant_request.dart';
import 'package:mizan/data/response/assistant_responses/assistant_responses.dart';
import 'package:mizan/data/response/base_responses/base_responses.dart';
import 'package:mizan/domain/model/assistant_model.dart';
import 'package:mizan/domain/repository/assistant_repository.dart';

@LazySingleton(as: AssistantRepository)
class AssistantRepositoryImpl implements AssistantRepository {
  final AssistantRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  AssistantRepositoryImpl(this._remoteDataSource, this._networkInfo);

  @override
  Future<Either<Failure, AssistantSession>> startSession() async {
    if (await _networkInfo.isConnected) {
      try {
        final AssistantSessionResponse response =
            await _remoteDataSource.startSession();
        if (response.success == true && response.data != null) {
          return Right<Failure, AssistantSession>(response.data.toDomain());
        } else {
          return Left<Failure, AssistantSession>(
            Failure(
              ApiInternalStatus.FAILURE,
              response.message ?? ResponseMessage.DEAFULT,
            ),
          );
        }
      } catch (error) {
        return Left<Failure, AssistantSession>(ErrorHandler.handle(error).failure);
      }
    } else {
      return Left<Failure, AssistantSession>(
        DataSource.NO_INTERNET_CONNECTION.getFailure(),
      );
    }
  }

  @override
  Future<Either<Failure, AssistantReply>> sendCommand(
    String? sessionId,
    String text,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final AssistantCommandResponse response = await _remoteDataSource
            .sendCommand(AssistantCommandRequest(sessionId: sessionId, text: text));
        if (response.success == true && response.data != null) {
          return Right<Failure, AssistantReply>(response.data.toDomain());
        } else {
          return Left<Failure, AssistantReply>(
            Failure(
              ApiInternalStatus.FAILURE,
              response.message ?? ResponseMessage.DEAFULT,
            ),
          );
        }
      } catch (error) {
        return Left<Failure, AssistantReply>(ErrorHandler.handle(error).failure);
      }
    } else {
      return Left<Failure, AssistantReply>(
        DataSource.NO_INTERNET_CONNECTION.getFailure(),
      );
    }
  }

  @override
  Future<Either<Failure, AssistantReply>> confirmAction(
    String sessionId,
    String actionId,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final AssistantCommandResponse response =
            await _remoteDataSource.confirmAction(sessionId, actionId);
        if (response.success == true && response.data != null) {
          return Right<Failure, AssistantReply>(response.data.toDomain());
        } else {
          return Left<Failure, AssistantReply>(
            Failure(
              ApiInternalStatus.FAILURE,
              response.message ?? ResponseMessage.DEAFULT,
            ),
          );
        }
      } catch (error) {
        return Left<Failure, AssistantReply>(ErrorHandler.handle(error).failure);
      }
    } else {
      return Left<Failure, AssistantReply>(
        DataSource.NO_INTERNET_CONNECTION.getFailure(),
      );
    }
  }

  @override
  Future<Either<Failure, AssistantReply>> cancelAction(
    String sessionId,
    String actionId,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final AssistantCommandResponse response =
            await _remoteDataSource.cancelAction(sessionId, actionId);
        if (response.success == true && response.data != null) {
          return Right<Failure, AssistantReply>(response.data.toDomain());
        } else {
          return Left<Failure, AssistantReply>(
            Failure(
              ApiInternalStatus.FAILURE,
              response.message ?? ResponseMessage.DEAFULT,
            ),
          );
        }
      } catch (error) {
        return Left<Failure, AssistantReply>(ErrorHandler.handle(error).failure);
      }
    } else {
      return Left<Failure, AssistantReply>(
        DataSource.NO_INTERNET_CONNECTION.getFailure(),
      );
    }
  }

  @override
  Future<Either<Failure, void>> endSession(String sessionId) async {
    if (await _networkInfo.isConnected) {
      try {
        final BaseResponse response =
            await _remoteDataSource.endSession(sessionId);
        if (response.success == true) {
          return const Right<Failure, void>(null);
        } else {
          return Left<Failure, void>(
            Failure(
              ApiInternalStatus.FAILURE,
              response.message ?? ResponseMessage.DEAFULT,
            ),
          );
        }
      } catch (error) {
        return Left<Failure, void>(ErrorHandler.handle(error).failure);
      }
    } else {
      return Left<Failure, void>(
        DataSource.NO_INTERNET_CONNECTION.getFailure(),
      );
    }
  }
}
