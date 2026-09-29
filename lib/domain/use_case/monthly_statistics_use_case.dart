import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:mizan/data/network/failure.dart';
import 'package:mizan/domain/model/statistics_model/statistics_model.dart';
import 'package:mizan/domain/repository/statistics_repository.dart';
import 'package:mizan/domain/use_case/base_usecase.dart';

@injectable
class MonthlyStatisticsUseCase
    implements BaseUsecase<MonthlyStatisticsInput, StatisticsPageModel> {
  final StatisticsRepository _statisticsRepository;

  MonthlyStatisticsUseCase(this._statisticsRepository);

  @override
  Future<Either<Failure, StatisticsPageModel>> execute(
    MonthlyStatisticsInput input,
  ) async {
    return await _statisticsRepository.getMonthlyStatistics(
      input.year,
      input.month,
    );
  }
}

class MonthlyStatisticsInput {
  final String year;
  final String month;

  MonthlyStatisticsInput({required this.year, required this.month});
}
