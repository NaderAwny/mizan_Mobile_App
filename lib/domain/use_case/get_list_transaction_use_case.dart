import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:mizan/data/network/failure.dart';
import 'package:mizan/domain/model/get_list_transactions_model.dart';
import 'package:mizan/domain/repository/get_list_ transaction_repository.dart';
import 'package:mizan/domain/use_case/base_usecase.dart';

@lazySingleton
class GetListTransactionsUseCase
    implements BaseUsecase<GetListTransactionsParams, GetListTransactionsPage> {
  final GetListTransactionsRepository _repository;

  GetListTransactionsUseCase(this._repository);

  @override
  Future<Either<Failure, GetListTransactionsPage>> execute(
    GetListTransactionsParams params,
  ) async {
    return await _repository.getListTransactions(
      page: params.page,
      pageSize: params.pageSize,
      contactId: params.contactId,
      type: params.type,
      dateFrom: params.dateFrom,
      dateTo: params.dateTo,
    );
  }
}

class GetListTransactionsParams {
  final int page;
  final int pageSize;
  final String? contactId;
  final String? type;
  final String? dateFrom;
  final String? dateTo;

  GetListTransactionsParams({
    required this.page,
    required this.pageSize,
    this.contactId,
    this.type,
    this.dateFrom,
    this.dateTo,
  });
}
