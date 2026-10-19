import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:mizan/data/network/failure.dart';
import 'package:mizan/domain/model/notification_model.dart';
import 'package:mizan/domain/repository/notification_repository.dart';
import 'package:mizan/domain/use_case/base_usecase.dart';

@lazySingleton
class GetNotificationsUseCase
    implements BaseUsecase<GetNotificationsParams, NotificationsPage> {
  final NotificationRepository _repository;

  GetNotificationsUseCase(this._repository);

  @override
  Future<Either<Failure, NotificationsPage>> execute(
    GetNotificationsParams params,
  ) async {
    return await _repository.getNotifications(
      page: params.page,
      pageSize: params.pageSize,
      unreadOnly: params.unreadOnly,
    );
  }
}

class GetNotificationsParams {
  final int page;
  final int pageSize;
  final bool unreadOnly;

  GetNotificationsParams({
    required this.page,
    required this.pageSize,
    this.unreadOnly = false,
  });
}
