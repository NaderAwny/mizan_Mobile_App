import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:mizan/data/network/failure.dart';
import 'package:mizan/domain/model/notification_model.dart';
import 'package:mizan/domain/repository/notification_repository.dart';
import 'package:mizan/domain/use_case/base_usecase.dart';

@injectable
class RunRemindersScanUseCase implements BaseUsecase<void, RemindersScanResult> {
  final NotificationRepository _repository;

  RunRemindersScanUseCase(this._repository);

  @override
  Future<Either<Failure, RemindersScanResult>> execute(void input) async {
    return await _repository.runRemindersScan();
  }
}
