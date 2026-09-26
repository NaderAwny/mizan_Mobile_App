import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:mizan/data/data_source/installment_remote_data_source.dart';
import 'package:mizan/data/mapper/pay_installment_mapper.dart';
import 'package:mizan/data/network/error_handler.dart';
import 'package:mizan/data/network/failure.dart';
import 'package:mizan/data/network/network_info.dart';
import 'package:mizan/domain/model/transaction_by_id_mode/transaction_by_id_mode.dart';
import 'package:mizan/domain/repository/installment_repository.dart';

@LazySingleton(as: InstallmentRepository)
class InstallmentRepositoryImpl implements InstallmentRepository {
  final InstallmentRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  InstallmentRepositoryImpl(this._remoteDataSource, this._networkInfo);

  @override
  Future<Either<Failure, TransactionbyidModel>> payInstallment(
    String installmentId,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final response = await _remoteDataSource.payInstallment(installmentId);
        if (response.success == true) {
          return Right(response.toDomain());
        } else {
          return Left(
            Failure(
              ApiInternalStatus.FAILURE,
              response.message ?? ResponseMessage.DEAFULT,
            ),
          );
        }
      } catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }
}
