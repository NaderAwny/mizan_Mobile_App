import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:mizan/data/data_source/get_list_transaction_remote_data_source.dart';
import 'package:mizan/data/mapper/get_list_trasaction_mapper.dart';

import 'package:mizan/data/network/error_handler.dart';
import 'package:mizan/data/network/failure.dart';
import 'package:mizan/data/network/network_info.dart';
import 'package:mizan/domain/model/get_list_transactions_model.dart';
import 'package:mizan/domain/repository/get_list_%20transaction_repository.dart';

@LazySingleton(as: GetListTransactionsRepository)
class GetListTransactionsRepositoryImpl
    implements GetListTransactionsRepository {
  final GetListTransactionsRemoteDataSource _remote;
  final NetworkInfo _networkInfo;

  GetListTransactionsRepositoryImpl(this._remote, this._networkInfo);

  @override
  Future<Either<Failure, GetListTransactionsPage>> getListTransactions({
    required int page,
    required int pageSize,
    String? contactId,
    String? type,
    String? dateFrom,
    String? dateTo,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        final response = await _remote.getListTransactions(
          page: page,
          pageSize: pageSize,
          contactId: contactId,
          type: type,
          dateFrom: dateFrom,
          dateTo: dateTo,
        );
        if (response.success == true) {
          return Right(response.data!.toDomain());
        } else {
          return Left(
            Failure(
              ApiInternalStatus.FAILURE,
              response.message ?? ResponseMessage.DEAFULT,
            ),
          );
        }
      } catch (e) {
        return Left(ErrorHandler.handle(e).failure);
      }
    } else {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }
}
