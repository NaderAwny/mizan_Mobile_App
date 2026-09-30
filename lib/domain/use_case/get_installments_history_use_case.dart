import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:mizan/data/network/failure.dart';
import 'package:mizan/domain/model/installments_history_model.dart';
import 'package:mizan/domain/repository/installment_repository.dart';
import 'package:mizan/domain/use_case/base_usecase.dart';

/// القيم المسموحة لفلتر الحالة في GET /api/installments/history
class InstallmentHistoryStatus {
  static const String all = 'all';
  static const String overdue = 'overdue';
  static const String dueToday = 'duetoday';
  static const String upcoming = 'upcoming';
  static const String paid = 'paid';
}

@lazySingleton
class GetInstallmentsHistoryUseCase
    implements
        BaseUsecase<GetInstallmentsHistoryParams, InstallmentsHistoryPage> {
  final InstallmentRepository _repository;

  GetInstallmentsHistoryUseCase(this._repository);

  @override
  Future<Either<Failure, InstallmentsHistoryPage>> execute(
    GetInstallmentsHistoryParams params,
  ) async {
    return await _repository.getInstallmentsHistory(
      status: params.status,
      page: params.page,
      pageSize: params.pageSize,
    );
  }
}

class GetInstallmentsHistoryParams {
  final String status;
  final int page;
  final int pageSize;

  GetInstallmentsHistoryParams({
    this.status = InstallmentHistoryStatus.all,
    required this.page,
    required this.pageSize,
  });
}
