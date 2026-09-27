import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:mizan/data/data_source/statistics_remote_data_source.dart';
import 'package:mizan/data/mapper/statistics_mapper.dart';

import 'package:mizan/data/network/error_handler.dart';
import 'package:mizan/data/network/failure.dart';
import 'package:mizan/data/network/network_info.dart';
import 'package:mizan/domain/model/statistics_model/statistics_model.dart';
import 'package:mizan/domain/repository/statistics_repository.dart';

@LazySingleton(as: StatisticsRepository)
class StatisticsRepositoryImpl implements StatisticsRepository {
  final StatisticsRemoteDataSource _statisticsRemoteDataSource;
  final NetworkInfo _networkInfo;

  StatisticsRepositoryImpl(this._statisticsRemoteDataSource, this._networkInfo);

  @override
  Future<Either<Failure, StatisticsPageModel>> getStatistics() async {
    if (await _networkInfo.isConnected) {
      try {
        final response = await _statisticsRemoteDataSource.getStatistics();

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

  @override
  Future<Either<Failure, StatisticsPageModel>> getDailyStatistics(
    String date,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final response = await _statisticsRemoteDataSource.getDailyStatistics(
          date,
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

  @override
  Future<Either<Failure, StatisticsPageModel>> getMonthlyStatistics(
    String year,
    String month,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final response = await _statisticsRemoteDataSource.getMonthlyStatistics(
          year,
          month,
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
