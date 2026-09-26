import 'package:json_annotation/json_annotation.dart';
import 'package:mizan/data/response/base_responses/base_responses.dart';
import 'package:mizan/data/response/transaction_by_id_responses/transaction_by_id_responses.dart';

part 'pay_installment_responses.g.dart';

/// استجابة سداد القسط من السيرفر POST /api/installments/{id}/pay
/// يعيد السيرفر كائن المعاملة كاملاً ومحدَّثاً مع كافة الأقساط وقيم totalPaid و totalRemaining
@JsonSerializable()
class PayInstallmentResponse extends BaseResponse {
  @JsonKey(name: 'data')
  TransactionDataById? data;

  PayInstallmentResponse({this.data, super.success, super.message});

  factory PayInstallmentResponse.fromJson(Map<String, dynamic> json) =>
      _$PayInstallmentResponseFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$PayInstallmentResponseToJson(this);
}
