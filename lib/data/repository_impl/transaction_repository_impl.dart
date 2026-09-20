import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:mizan/data/data_source/transaction_remote_data_source.dart';
import 'package:mizan/data/mapper/transaction_mapper.dart';
import 'package:mizan/data/network/error_handler.dart';
import 'package:mizan/data/network/failure.dart';
import 'package:mizan/data/network/network_info.dart';
import 'package:mizan/data/request/transaction_request.dart';
import 'package:mizan/domain/model/transaction_model.dart';
import 'package:mizan/domain/repository/transaction_repository.dart';

@LazySingleton(as: TransactionRepository)
class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionRemoteDataSource _remote;
  final NetworkInfo _networkInfo;

  TransactionRepositoryImpl(this._remote, this._networkInfo);

  @override
  Future<Either<Failure, Transaction>> createTransaction(
    CreateTransactionRequest request,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final response = await _remote.createTransaction(request);
        if (response.success == true) {
          return Right(response.data.toDomain());
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
