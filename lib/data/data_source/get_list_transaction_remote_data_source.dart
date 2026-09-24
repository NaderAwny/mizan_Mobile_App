import 'package:injectable/injectable.dart';
import 'package:mizan/data/network/app_api.dart';
import 'package:mizan/data/response/get_list_transaction_responses/get_list_transaction_responses.dart';

abstract class GetListTransactionsRemoteDataSource {
  Future<GetListTransactionsResponse> getListTransactions({
    required int page,
    required int pageSize,
    String? contactId,
    String? type,
    String? dateFrom,
    String? dateTo,
  });
}

@LazySingleton(as: GetListTransactionsRemoteDataSource)
class GetListTransactionsRemoteDataSourceImpl
    implements GetListTransactionsRemoteDataSource {
  final AppServiceClient _appServiceClient;

  GetListTransactionsRemoteDataSourceImpl(this._appServiceClient);

  @override
  Future<GetListTransactionsResponse> getListTransactions({
    required int page,
    required int pageSize,
    String? contactId,
    String? type,
    String? dateFrom,
    String? dateTo,
  }) {
    return _appServiceClient.getTransactions(
      page,
      pageSize,
      contactId,
      type,
      dateFrom,
      dateTo,
    );
  }
}
