import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:mizan/data/data_source/voice_note_remote_data_source.dart';
import 'package:mizan/data/mapper/voice_note_mapper.dart';
import 'package:mizan/data/network/error_handler.dart';
import 'package:mizan/data/network/failure.dart';
import 'package:mizan/data/network/network_info.dart';
import 'package:mizan/data/request/voice_note_request.dart';
import 'package:mizan/domain/model/voice_note_model/voice_note_model.dart';
import 'package:mizan/domain/repository/voice_note_repository.dart';

@LazySingleton(as: VoiceNoteRepository)
class VoiceNoteRepositoryImpl implements VoiceNoteRepository {
  final VoiceNoteRemoteDataSource _remote;
  final NetworkInfo _networkInfo;

  VoiceNoteRepositoryImpl(this._remote, this._networkInfo);

  @override
  Future<Either<Failure, VoiceNoteModel>> createVoiceNote(
    CreateVoiceNoteRequest request,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final response = await _remote.createVoiceNote(request);
        if (response.success == true || response.data != null) {
          return Right(response.data.toDomain());
        } else {
          return Left(
            Failure(
              ApiInternalStatus.FAILURE,
              response.message ?? ResponseMessage.DEAFULT,
            ),
          );
        }
      } catch (e) {
        return Left(ErrorHandler.handle(e).failure);
      }
    } else {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  @override
  Future<Either<Failure, VoiceNotesPage>> getVoiceNotes({
    required int page,
    required int pageSize,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        final response = await _remote.getVoiceNotes(
          page: page,
          pageSize: pageSize,
        );
        if (response.success == true || response.data != null) {
          return Right(response.data.toDomain());
        } else {
          return Left(
            Failure(
              ApiInternalStatus.FAILURE,
              response.message ?? ResponseMessage.DEAFULT,
            ),
          );
        }
      } catch (e) {
        return Left(ErrorHandler.handle(e).failure);
      }
    } else {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  @override
  Future<Either<Failure, VoiceNoteModel>> getVoiceNoteById(String id) async {
    if (await _networkInfo.isConnected) {
      try {
        final response = await _remote.getVoiceNoteById(id);
        if (response.success == true || response.data != null) {
          return Right(response.data.toDomain());
        } else {
          return Left(
            Failure(
              ApiInternalStatus.FAILURE,
              response.message ?? ResponseMessage.DEAFULT,
            ),
          );
        }
      } catch (e) {
        return Left(ErrorHandler.handle(e).failure);
      }
    } else {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }
}
