import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:mizan/data/network/failure.dart';
import 'package:mizan/domain/model/notification_model.dart';
import 'package:mizan/domain/repository/notification_repository.dart';
import 'package:mizan/domain/use_case/base_usecase.dart';

@injectable
class MarkNotificationReadUseCase
    extends BaseUsecase<String, NotificationReadStatus> {
  final NotificationRepository _repository;

  MarkNotificationReadUseCase(this._repository);

  @override
  Future<Either<Failure, NotificationReadStatus>> execute(String input) =>
      _repository.markNotificationRead(input);
}
