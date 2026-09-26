import 'package:dartz/dartz.dart';
import 'package:mizan/data/network/failure.dart';
import 'package:mizan/domain/model/transaction_by_id_mode/transaction_by_id_mode.dart';

abstract class InstallmentRepository {
  /// تسجيل سداد قسط — POST /api/installments/{installment_id}/pay
  Future<Either<Failure, TransactionbyidModel>> payInstallment(
    String installmentId,
  );
}
