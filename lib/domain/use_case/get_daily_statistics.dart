import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:mizan/data/network/failure.dart';
import 'package:mizan/domain/model/statistics_model/statistics_model.dart';
import 'package:mizan/domain/repository/statistics_repository.dart';
import 'package:mizan/domain/use_case/base_usecase.dart';

@injectable
class DailyStatisticsUseCase
    implements BaseUsecase<String, StatisticsPageModel> {
  final StatisticsRepository _statisticsRepository;

  DailyStatisticsUseCase(this._statisticsRepository);

  @override
  Future<Either<Failure, StatisticsPageModel>> execute(String date) async {
    return await _statisticsRepository.getDailyStatistics(date);
  }
}
