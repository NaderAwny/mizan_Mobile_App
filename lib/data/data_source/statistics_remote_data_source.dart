import 'package:injectable/injectable.dart';
import 'package:mizan/data/network/app_api.dart';
import 'package:mizan/data/response/statistics_response/statistic_response.dart';

abstract class StatisticsRemoteDataSource {
  Future<StatisticsResponse> getStatistics();
  Future<StatisticsResponse> getDailyStatistics(String date);
  Future<StatisticsResponse> getMonthlyStatistics(String year, String month);
}

@LazySingleton(as: StatisticsRemoteDataSource)
class StatisticsRemoteDataSourceImpl implements StatisticsRemoteDataSource {
  final AppServiceClient _appServiceClient;

  StatisticsRemoteDataSourceImpl(this._appServiceClient);

  @override
  Future<StatisticsResponse> getStatistics() async {
    return await _appServiceClient.getStatistics();
  }

  @override
  Future<StatisticsResponse> getDailyStatistics(String date) async {
    return await _appServiceClient.getDailyStatistics(date);
  }

  @override
  Future<StatisticsResponse> getMonthlyStatistics(
    String year,
    String month,
  ) async {
    return await _appServiceClient.getMonthlyStatistics(year, month);
  }
}
