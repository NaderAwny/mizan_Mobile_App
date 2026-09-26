import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:mizan/data/network/failure.dart';
import 'package:mizan/domain/model/transaction_by_id_mode/transaction_by_id_mode.dart';
import 'package:mizan/domain/repository/installment_repository.dart';
import 'package:mizan/domain/use_case/base_usecase.dart';

@injectable
class PayInstallmentUseCase
    implements BaseUsecase<String, TransactionbyidModel> {
  final InstallmentRepository _repository;

  PayInstallmentUseCase(this._repository);

  @override
  Future<Either<Failure, TransactionbyidModel>> execute(String input) {
    return _repository.payInstallment(input);
  }
}
