import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:mizan/data/network/failure.dart';
import 'package:mizan/data/request/transaction_request.dart';
import 'package:mizan/domain/model/transaction_model.dart';
import 'package:mizan/domain/repository/transaction_repository.dart';
import 'package:mizan/domain/use_case/base_usecase.dart';

typedef CreateTransactionInput = CreateTransactionRequest;

@injectable
class CreateTransactionUseCase
    extends BaseUsecase<CreateTransactionRequest, Transaction> {
  final TransactionRepository _repository;

  CreateTransactionUseCase(this._repository);

  @override
  Future<Either<Failure, Transaction>> execute(
    CreateTransactionRequest input,
  ) => _repository.createTransaction(input);
}
