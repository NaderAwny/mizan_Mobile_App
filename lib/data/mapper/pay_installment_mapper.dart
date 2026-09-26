import 'package:mizan/data/mapper/transaction_by_id_mapper.dart';
import 'package:mizan/data/response/pay_installment_responses/pay_installment_responses.dart';
import 'package:mizan/domain/model/transaction_by_id_mode/transaction_by_id_mode.dart';

extension PayInstallmentResponseMapper on PayInstallmentResponse? {
  TransactionbyidModel toDomain() {
    return this?.data.toDomain() ?? const TransactionbyidModel();
  }
}
