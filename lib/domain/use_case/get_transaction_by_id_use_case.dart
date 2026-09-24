import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:mizan/data/network/failure.dart';
import 'package:mizan/domain/model/transaction_by_id_mode/transaction_by_id_mode.dart';
import 'package:mizan/domain/repository/transaction_repository.dart';
import 'package:mizan/domain/use_case/base_usecase.dart';

@injectable
class GetTransactionByIdUseCase
    extends BaseUsecase<String, TransactionbyidModel> {
  final TransactionRepository _repository;

  GetTransactionByIdUseCase(this._repository);

  @override
  Future<Either<Failure, TransactionbyidModel>> execute(String input) =>
      _repository.getTransactionById(input);
}
