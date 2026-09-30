import 'package:injectable/injectable.dart';
import 'package:mizan/data/network/app_api.dart';
import 'package:mizan/data/response/installments_dashboard_responses/installments_dashboard_responses.dart';
import 'package:mizan/data/response/installments_history_responses/installments_history_responses.dart';
import 'package:mizan/data/response/pay_installment_responses/pay_installment_responses.dart';

abstract class InstallmentRemoteDataSource {
  /// POST /api/installments/{id}/pay
  Future<PayInstallmentResponse> payInstallment(String installmentId);

  /// GET /api/installments/dashboard
  Future<InstallmentsDashboardResponse> getInstallmentsDashboard();

  /// GET /api/installments/history
  Future<InstallmentsHistoryResponse> getInstallmentsHistory({
    required String status,
    required int page,
    required int pageSize,
  });
}

@LazySingleton(as: InstallmentRemoteDataSource)
class InstallmentRemoteDataSourceImpl implements InstallmentRemoteDataSource {
  final AppServiceClient _appServiceClient;

  InstallmentRemoteDataSourceImpl(this._appServiceClient);

  @override
  Future<PayInstallmentResponse> payInstallment(String installmentId) {
    return _appServiceClient.payInstallment(installmentId);
  }

  @override
  Future<InstallmentsDashboardResponse> getInstallmentsDashboard() {
    return _appServiceClient.getInstallmentsDashboard();
  }

  @override
  Future<InstallmentsHistoryResponse> getInstallmentsHistory({
    required String status,
    required int page,
    required int pageSize,
  }) {
    return _appServiceClient.getInstallmentsHistory(status, page, pageSize);
  }
}
