import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:mizan/data/network/failure.dart';
import 'package:mizan/domain/model/installments_dashboard_model.dart';
import 'package:mizan/domain/repository/installment_repository.dart';
import 'package:mizan/domain/use_case/base_usecase.dart';

@injectable
class GetInstallmentsDashboardUseCase
    implements BaseUsecase<void, InstallmentsDashboardModel> {
  final InstallmentRepository _repository;

  GetInstallmentsDashboardUseCase(this._repository);

  @override
  Future<Either<Failure, InstallmentsDashboardModel>> execute(
    void input,
  ) async {
    return await _repository.getInstallmentsDashboard();
  }
}
