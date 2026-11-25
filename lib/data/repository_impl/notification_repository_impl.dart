import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:mizan/data/data_source/notification_remote_data_source.dart';
import 'package:mizan/data/mapper/notification_mapper.dart';
import 'package:mizan/data/network/error_handler.dart';
import 'package:mizan/data/network/failure.dart';
import 'package:mizan/data/network/network_info.dart';
import 'package:mizan/data/response/base_responses/base_responses.dart';
import 'package:mizan/data/response/notifications_responses/notifications_responses.dart';
import 'package:mizan/domain/model/notification_model.dart';
import 'package:mizan/domain/repository/notification_repository.dart';

@LazySingleton(as: NotificationRepository)
class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  NotificationRepositoryImpl(this._remoteDataSource, this._networkInfo);

  @override
  Future<Either<Failure, NotificationsPage>> getNotifications({
    required int page,
    required int pageSize,
    required bool unreadOnly,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        final NotificationsPageResponse response = await _remoteDataSource
            .getNotifications(
              page: page,
              pageSize: pageSize,
              unreadOnly: unreadOnly,
            );
        if (response.success == true) {
          return Right(response.data.toDomain());
        } else {
          return Left(
            Failure(
              ApiInternalStatus.FAILURE,
              response.message ?? ResponseMessage.DEAFULT,
            ),
          );
        }
      } catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  @override
  Future<Either<Failure, NotificationReadStatus>> markNotificationRead(
    String id,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        // 204 No Content → أي رد ناجح (من غير exception) معناه إن الإشعار اتقرأ
        await _remoteDataSource.markNotificationRead(id);
        return Right(NotificationReadStatus(id: id, isRead: true));
      } catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  @override
  Future<Either<Failure, void>> markAllNotificationsRead() async {
    if (await _networkInfo.isConnected) {
      try {
        final BaseResponse response = await _remoteDataSource
            .markAllNotificationsRead();
        if (response.success == true) {
          return const Right(null);
        } else {
          return Left(
            Failure(
              ApiInternalStatus.FAILURE,
              response.message ?? ResponseMessage.DEAFULT,
            ),
          );
        }
      } catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  @override
  Future<Either<Failure, RemindersScanResult>> runRemindersScan() async {
    if (await _networkInfo.isConnected) {
      try {
        final RunRemindersScanResponse response = await _remoteDataSource
            .runRemindersScan();
        if (response.success == true) {
          return Right(response.data.toDomain());
        } else {
          return Left(
            Failure(
              ApiInternalStatus.FAILURE,
              response.message ?? ResponseMessage.DEAFULT,
            ),
          );
        }
      } catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }
}
