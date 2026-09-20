import 'package:injectable/injectable.dart';
import 'package:mizan/data/network/app_api.dart';
import 'package:mizan/data/request/transaction_request.dart';
import 'package:mizan/data/response/transaction_responses/transaction_responses.dart';

abstract class TransactionRemoteDataSource {
  Future<TransactionResponse> createTransaction(
    CreateTransactionRequest request,
  );
}

@LazySingleton(as: TransactionRemoteDataSource)
class TransactionRemoteDataSourceImpl implements TransactionRemoteDataSource {
  final AppServiceClient _appServiceClient;

  TransactionRemoteDataSourceImpl(this._appServiceClient);

  @override
  Future<TransactionResponse> createTransaction(
    CreateTransactionRequest request,
  ) {
    return _appServiceClient.createTransaction(request.toBody());
  }
}
