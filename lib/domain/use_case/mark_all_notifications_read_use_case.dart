import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:mizan/data/network/failure.dart';
import 'package:mizan/domain/repository/notification_repository.dart';
import 'package:mizan/domain/use_case/base_usecase.dart';

@injectable
class MarkAllNotificationsReadUseCase implements BaseUsecase<void, void> {
  final NotificationRepository _repository;

  MarkAllNotificationsReadUseCase(this._repository);

  @override
  Future<Either<Failure, void>> execute(void input) async {
    return await _repository.markAllNotificationsRead();
  }
}
