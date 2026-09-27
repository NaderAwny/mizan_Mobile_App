import 'package:dartz/dartz.dart';
import 'package:mizan/data/network/failure.dart';
import 'package:mizan/domain/model/statistics_model/statistics_model.dart';

abstract class StatisticsRepository {
  Future<Either<Failure, StatisticsPageModel>> getStatistics();
  Future<Either<Failure, StatisticsPageModel>> getDailyStatistics(String date);
  Future<Either<Failure, StatisticsPageModel>> getMonthlyStatistics(
    String year,
    String month,
  );
}
