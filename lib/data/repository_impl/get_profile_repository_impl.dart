import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:mizan/data/mapper/get_profile_mapper.dart';
import 'package:mizan/data/network/error_handler.dart';
import 'package:mizan/data/network/failure.dart';
import 'package:mizan/data/network/network_info.dart';
import 'package:mizan/data/data_source/get_profile_data_source.dart';
import 'package:mizan/domain/model/get_profile_model/get_profile_model.dart';
import 'package:mizan/domain/repository/get_profile_repository.dart';

@LazySingleton(as: GetProfileRepository)
class GetProfileRepositoryImpl implements GetProfileRepository {
  final GetProfileDataSource getProfileDataSource;
  final NetworkInfo networkInfo;

  GetProfileRepositoryImpl(this.getProfileDataSource, this.networkInfo);

  @override
  Future<Either<Failure, GetProfileModel>> getProfile() async {
    if (await networkInfo.isConnected) {
      try {
        final response = await getProfileDataSource.getProfile();

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
