import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:mizan/data/mapper/register_mapper.dart';
import 'package:mizan/data/network/error_handler.dart';
import 'package:mizan/data/network/failure.dart';
import 'package:mizan/data/network/network_info.dart';
import 'package:mizan/data/data_source/send_otp_remote_data_source.dart';
import 'package:mizan/data/request/send_otp.dart';
import 'package:mizan/domain/model/register_model.dart';
import 'package:mizan/domain/repository/send_otp_repository.dart';

@LazySingleton(as: SendOtpRepository)
class SendOtpRepositoryImpl implements SendOtpRepository {
  final SendOtpRemoteDataSource sendOtpRemoteDataSource;
  final NetworkInfo networkInfo;

  SendOtpRepositoryImpl(this.sendOtpRemoteDataSource, this.networkInfo);

  @override
  Future<Either<Failure, RegisterModel>> sendOtpRepository(
    SendOtpRequest sendOtpRequest,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await sendOtpRemoteDataSource.sendOtp(sendOtpRequest);

        // ignore: unrelated_type_equality_checks
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
      } catch (e) {
        return Left(ErrorHandler.handle(e).failure);
      }
    } else {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }
}
