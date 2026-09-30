import 'package:dartz/dartz.dart';
import 'package:mizan/data/network/failure.dart';
import 'package:mizan/domain/model/installments_dashboard_model.dart';
import 'package:mizan/domain/model/installments_history_model.dart';
import 'package:mizan/domain/model/transaction_by_id_mode/transaction_by_id_mode.dart';

abstract class InstallmentRepository {
  /// تسجيل سداد قسط — POST /api/installments/{installment_id}/pay
  Future<Either<Failure, TransactionbyidModel>> payInstallment(
    String installmentId,
  );

  /// لوحة متابعة الأقساط والديون — GET /api/installments/dashboard
  Future<Either<Failure, InstallmentsDashboardModel>>
  getInstallmentsDashboard();

  /// سجل الأقساط — GET /api/installments/history
  Future<Either<Failure, InstallmentsHistoryPage>> getInstallmentsHistory({
    required String status,
    required int page,
    required int pageSize,
  });
}
