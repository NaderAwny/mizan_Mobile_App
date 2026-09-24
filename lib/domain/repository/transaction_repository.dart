import 'package:dartz/dartz.dart';
import 'package:mizan/data/network/failure.dart';
import 'package:mizan/data/request/transaction_request.dart';
import 'package:mizan/domain/model/transaction_by_id_mode/transaction_by_id_mode.dart';
import 'package:mizan/domain/model/transaction_model.dart';

abstract class TransactionRepository {
  Future<Either<Failure, Transaction>> createTransaction(
    CreateTransactionRequest request,
  );
  Future<Either<Failure, TransactionbyidModel>> getTransactionById(String id);
}
