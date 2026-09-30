import 'package:json_annotation/json_annotation.dart';
import 'package:mizan/data/response/base_responses/base_responses.dart';

part 'installments_dashboard_responses.g.dart';

@JsonSerializable()
class DashboardInstallmentData {
  @JsonKey(name: "installmentId")
  String? installmentId;
  @JsonKey(name: "amount")
  num? amount;
  @JsonKey(name: "dueDate")
  String? dueDate;
  @JsonKey(name: "isPaid")
  bool? isPaid;
  @JsonKey(name: "paidAt")
  String? paidAt;
  @JsonKey(name: "status")
  String? status;
  @JsonKey(name: "daysOverdue")
  int? daysOverdue;

  DashboardInstallmentData({
    this.installmentId,
    this.amount,
    this.dueDate,
    this.isPaid,
    this.paidAt,
    this.status,
    this.daysOverdue,
  });

  factory DashboardInstallmentData.fromJson(Map<String, dynamic> json) =>
      _$DashboardInstallmentDataFromJson(json);

  Map<String, dynamic> toJson() => _$DashboardInstallmentDataToJson(this);
}

@JsonSerializable()
class InstallmentPlanData {
  @JsonKey(name: "transactionId")
  String? transactionId;
  @JsonKey(name: "contactId")
  String? contactId;
  @JsonKey(name: "contactName")
  String? contactName;
  @JsonKey(name: "phoneNumber")
  String? phoneNumber;
  @JsonKey(name: "totalAmount")
  num? totalAmount;
  @JsonKey(name: "remainingAmount")
  num? remainingAmount;
  @JsonKey(name: "totalInstallmentsCount")
  int? totalInstallmentsCount;
  @JsonKey(name: "paidInstallmentsCount")
  int? paidInstallmentsCount;
  @JsonKey(name: "nextDueDate")
  String? nextDueDate;
  @JsonKey(name: "status")
  String? status;
  @JsonKey(name: "isOverdue")
  bool? isOverdue;
  @JsonKey(name: "isDueToday")
  bool? isDueToday;
  @JsonKey(name: "daysOverdue")
  int? daysOverdue;
  @JsonKey(name: "installments")
  List<DashboardInstallmentData>? installments;

  InstallmentPlanData({
    this.transactionId,
    this.contactId,
    this.contactName,
    this.phoneNumber,
    this.totalAmount,
    this.remainingAmount,
    this.totalInstallmentsCount,
    this.paidInstallmentsCount,
    this.nextDueDate,
    this.status,
    this.isOverdue,
    this.isDueToday,
    this.daysOverdue,
    this.installments,
  });

  factory InstallmentPlanData.fromJson(Map<String, dynamic> json) =>
      _$InstallmentPlanDataFromJson(json);

  Map<String, dynamic> toJson() => _$InstallmentPlanDataToJson(this);
}

@JsonSerializable()
class InstallmentsDashboardData {
  @JsonKey(name: "totalOverdueAmount")
  num? totalOverdueAmount;
  @JsonKey(name: "totalDueTodayAmount")
  num? totalDueTodayAmount;
  @JsonKey(name: "totalUpcomingAmount")
  num? totalUpcomingAmount;
  @JsonKey(name: "totalPaidAmount")
  num? totalPaidAmount;
  @JsonKey(name: "totalDebtsCount")
  int? totalDebtsCount;
  @JsonKey(name: "plans")
  List<InstallmentPlanData>? plans;

  InstallmentsDashboardData({
    this.totalOverdueAmount,
    this.totalDueTodayAmount,
    this.totalUpcomingAmount,
    this.totalPaidAmount,
    this.totalDebtsCount,
    this.plans,
  });

  factory InstallmentsDashboardData.fromJson(Map<String, dynamic> json) =>
      _$InstallmentsDashboardDataFromJson(json);

  Map<String, dynamic> toJson() => _$InstallmentsDashboardDataToJson(this);
}

@JsonSerializable()
class InstallmentsDashboardResponse extends BaseResponse {
  @JsonKey(name: "data")
  InstallmentsDashboardData? data;

  InstallmentsDashboardResponse({this.data, super.success, super.message});

  factory InstallmentsDashboardResponse.fromJson(Map<String, dynamic> json) =>
      _$InstallmentsDashboardResponseFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$InstallmentsDashboardResponseToJson(this);
}
