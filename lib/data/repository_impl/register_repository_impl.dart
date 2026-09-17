import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:mizan/data/mapper/register_mapper.dart';
import 'package:mizan/data/network/error_handler.dart';
import 'package:mizan/data/network/failure.dart';
import 'package:mizan/data/network/network_info.dart';
import 'package:mizan/data/request/register_request.dart';
import 'package:mizan/data/data_source/register_remote_data_source.dart';
import 'package:mizan/domain/model/register_model.dart';
import 'package:mizan/domain/repository/register_repository.dart';

@LazySingleton(as: RegisterRepository)
class RegisterRepositoryImpl implements RegisterRepository {
  final RegisterRemoteDataSource registerRemoteDataSource;
  final NetworkInfo networkInfo;

  RegisterRepositoryImpl(this.registerRemoteDataSource, this.networkInfo);

  @override
  Future<Either<Failure, RegisterModel>> registerRepository(
    RegisterRequest registerRequest,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await registerRemoteDataSource.register(
          registerRequest,
        );

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
