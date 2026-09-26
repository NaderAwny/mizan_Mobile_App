import 'package:injectable/injectable.dart';
import 'package:mizan/data/network/app_api.dart';
import 'package:mizan/data/response/pay_installment_responses/pay_installment_responses.dart';

abstract class InstallmentRemoteDataSource {
  /// POST /api/installments/{id}/pay
  Future<PayInstallmentResponse> payInstallment(String installmentId);
}

@LazySingleton(as: InstallmentRemoteDataSource)
class InstallmentRemoteDataSourceImpl implements InstallmentRemoteDataSource {
  final AppServiceClient _appServiceClient;

  InstallmentRemoteDataSourceImpl(this._appServiceClient);

  @override
  Future<PayInstallmentResponse> payInstallment(String installmentId) {
    return _appServiceClient.payInstallment(installmentId);
  }
}
