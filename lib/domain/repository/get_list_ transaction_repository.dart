// ignore: file_names
import 'package:dartz/dartz.dart';
import 'package:mizan/data/network/failure.dart';
import 'package:mizan/domain/model/get_list_transactions_model.dart';

abstract class GetListTransactionsRepository {
  Future<Either<Failure, GetListTransactionsPage>> getListTransactions({
    required int page,
    required int pageSize,
    String? contactId,
    String? type,
    String? dateFrom,
    String? dateTo,
  });
}
