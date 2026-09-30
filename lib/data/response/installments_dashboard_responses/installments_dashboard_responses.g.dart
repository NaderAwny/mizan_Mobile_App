// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'installments_dashboard_responses.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DashboardInstallmentData _$DashboardInstallmentDataFromJson(
  Map<String, dynamic> json,
) => DashboardInstallmentData(
  installmentId: json['installmentId'] as String?,
  amount: json['amount'] as num?,
  dueDate: json['dueDate'] as String?,
  isPaid: json['isPaid'] as bool?,
  paidAt: json['paidAt'] as String?,
  status: json['status'] as String?,
  daysOverdue: (json['daysOverdue'] as num?)?.toInt(),
);

Map<String, dynamic> _$DashboardInstallmentDataToJson(
  DashboardInstallmentData instance,
) => <String, dynamic>{
  'installmentId': instance.installmentId,
  'amount': instance.amount,
  'dueDate': instance.dueDate,
  'isPaid': instance.isPaid,
  'paidAt': instance.paidAt,
  'status': instance.status,
  'daysOverdue': instance.daysOverdue,
};

InstallmentPlanData _$InstallmentPlanDataFromJson(Map<String, dynamic> json) =>
    InstallmentPlanData(
      transactionId: json['transactionId'] as String?,
      contactId: json['contactId'] as String?,
      contactName: json['contactName'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      totalAmount: json['totalAmount'] as num?,
      remainingAmount: json['remainingAmount'] as num?,
      totalInstallmentsCount: (json['totalInstallmentsCount'] as num?)?.toInt(),
      paidInstallmentsCount: (json['paidInstallmentsCount'] as num?)?.toInt(),
      nextDueDate: json['nextDueDate'] as String?,
      status: json['status'] as String?,
      isOverdue: json['isOverdue'] as bool?,
      isDueToday: json['isDueToday'] as bool?,
      daysOverdue: (json['daysOverdue'] as num?)?.toInt(),
      installments: (json['installments'] as List<dynamic>?)
          ?.map(
            (e) => DashboardInstallmentData.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
    );

Map<String, dynamic> _$InstallmentPlanDataToJson(
  InstallmentPlanData instance,
) => <String, dynamic>{
  'transactionId': instance.transactionId,
  'contactId': instance.contactId,
  'contactName': instance.contactName,
  'phoneNumber': instance.phoneNumber,
  'totalAmount': instance.totalAmount,
  'remainingAmount': instance.remainingAmount,
  'totalInstallmentsCount': instance.totalInstallmentsCount,
  'paidInstallmentsCount': instance.paidInstallmentsCount,
  'nextDueDate': instance.nextDueDate,
  'status': instance.status,
  'isOverdue': instance.isOverdue,
  'isDueToday': instance.isDueToday,
  'daysOverdue': instance.daysOverdue,
  'installments': instance.installments,
};

InstallmentsDashboardData _$InstallmentsDashboardDataFromJson(
  Map<String, dynamic> json,
) => InstallmentsDashboardData(
  totalOverdueAmount: json['totalOverdueAmount'] as num?,
  totalDueTodayAmount: json['totalDueTodayAmount'] as num?,
  totalUpcomingAmount: json['totalUpcomingAmount'] as num?,
  totalPaidAmount: json['totalPaidAmount'] as num?,
  totalDebtsCount: (json['totalDebtsCount'] as num?)?.toInt(),
  plans: (json['plans'] as List<dynamic>?)
      ?.map((e) => InstallmentPlanData.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$InstallmentsDashboardDataToJson(
  InstallmentsDashboardData instance,
) => <String, dynamic>{
  'totalOverdueAmount': instance.totalOverdueAmount,
  'totalDueTodayAmount': instance.totalDueTodayAmount,
  'totalUpcomingAmount': instance.totalUpcomingAmount,
  'totalPaidAmount': instance.totalPaidAmount,
  'totalDebtsCount': instance.totalDebtsCount,
  'plans': instance.plans,
};

InstallmentsDashboardResponse _$InstallmentsDashboardResponseFromJson(
  Map<String, dynamic> json,
) => InstallmentsDashboardResponse(
  data: json['data'] == null
      ? null
      : InstallmentsDashboardData.fromJson(
          json['data'] as Map<String, dynamic>,
        ),
  success: json['success'] as bool?,
  message: json['message'] as String?,
);

Map<String, dynamic> _$InstallmentsDashboardResponseToJson(
  InstallmentsDashboardResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'data': instance.data,
};
