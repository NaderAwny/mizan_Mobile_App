# فيتشر العمليات اليدوية (Manual Transactions) — من 4.1 إلى 4.6
### توثيق كامل بالمعمارية الحقيقية لمشروع `mizan_Mobile_App`

> اتعمل هذا الملف بعد تنزيل الريبو فعليًا (`NaderAwny/mizan_Mobile_App`) وقراءة كل ملفات
> `lib/` المتعلقة، ومقارنتها بملف الـ Postman collection اللي رفعته. مفيش أي تخمين — كل نمط
> مكتوب هنا مسحوب من فيتشر **Contacts** الشغالة فعليًا عندك (لأنها أقرب فيتشر مكتملة
> بنفس الطراز)، ومن `glowy_conventions.md`.

---

## 1. الوضع الحالي في الريبو (فحص حقيقي، مش افتراض)

| الطبقة | الموجود فعليًا |
|---|---|
| **UI** | `presentation/transactions/transactions_view.dart` (شاشة Empty State فاضية) + `presentation/operations/quick_sale_view.dart` / `quick_purchase_view.dart` / `quick_collect_view.dart` / `quick_pay_view.dart` — كل الأربعة **Placeholder ثابت** وفيه نص حرفي في الكود: *"جاهزة للربط مع الـ Cubit والـ API"*. |
| **Cubit/State** | **مفيش خالص** لأي حاجة اسمها transaction. |
| **domain (model/repository/use_case)** | **مفيش خالص** — مفيش `transaction_model.dart` ولا `transaction_repository.dart` ولا أي usecase. |
| **data (request/response/data_source/mapper/repository_impl)** | **مفيش خالص**. |
| **`app_api.dart`** | فيه بس `auth` + `contacts` + `profile`. **مفيش أي endpoint اسمه `/api/transactions`**. |

**يعني الفيتشر لسه صفر من طبقة الداتا لغاية الـ Cubit.** الشغل المطلوب هنا مش "تعديل" حاجة
موجودة، ده **بناء من الصفر** بالظبط بنفس نمط فيتشر Contacts (الفيتشر الوحيدة المكتملة
بالكامل في المشروع دلوقتي: `data_source` → `mapper` → `repository_impl` → `domain` →
`use_case` → `Cubit/State`).

---

## 2. الـ Endpoint الواحد اللي بيغطي كل الحالات من 4.1 لـ 4.6

كل الستة عمليات (4.1 → 4.6) هي **نفس الـ Endpoint بالظبط**:

```
POST {{base_url}}/api/transactions
```

الفرق بينهم هو **شكل الـ Request Body** بس (حسب `type` / `isInstallment` /
`installmentPlanMode`)، والـ Response بيرجع نفس الشكل دايمًا لكن مصفوفة `installments`
بتتغيّر حسب الحالة. ده معناه: **يبقى Model واحد للـ Request، وModel واحد للـ Response**،
مش 6 كلاسات منفصلة — تمامًا زي ما هو موضّح في تعليق الـ Postman نفسه.

### جدول الفروق الكامل بين الـ 6 حالات

| # | الاسم | `type` | `isInstallment` | `installmentPlanMode` | حقول إضافية مطلوبة |
|---|---|---|---|---|---|
| 4.1 | مبيعات كاش مرتبطة بطرف | `Sale` | `false` | — | — |
| 4.2 | مشتريات كاش من مورد | `Purchase` | `false` | — | — |
| 4.3 | مبيعات بتقسيط تلقائي | `Sale` | `true` | `Automatic` | `installmentCount`, `frequency`, `firstInstallmentDate` |
| 4.4 | مشتريات بتقسيط تلقائي | `Purchase` | `true` | `Automatic` | `installmentCount`, `frequency`, `firstInstallmentDate` |
| 4.5 | مشتريات بتقسيط يدوي | `Purchase` | `true` | `Custom` | `customInstallments[]` (كل عنصر: `amount` + `dueDate`) |
| 4.6 | مبيعات بتقسيط يدوي | `Sale` | `true` | `Custom` | `customInstallments[]` (كل عنصر: `amount` + `dueDate`) |

**قاعدة مهمة من الـ Postman:** في حالة `Custom`، لازم `sum(customInstallments.amount) == amount`
الإجمالي — التحقق ده المفروض يحصل **Client-side قبل الإرسال** كمان (مش بس Server-side)
لتقليل حالات الفشل الراجعة من السيرفر.

### شكل الـ Request الكامل (Union واحد لكل الحالات)

```json
{
  "contactId": "uuid?",          // اختياري لو فيه partyName
  "partyName": "string?",        // مطلوب لو contactId فاضي
  "type": "Sale | Purchase",
  "amount": 500.0,
  "paymentMethod": "Cash | Installments",
  "transactionDate": "ISO-8601",
  "noteText": "string?",

  "isInstallment": false,
  "installmentPlanMode": "Automatic | Custom | null",

  "installmentCount": 3,                       // Automatic بس
  "frequency": "Weekly | Monthly | Yearly",     // Automatic بس
  "firstInstallmentDate": "ISO-8601",           // Automatic بس

  "customInstallments": [                        // Custom بس
    { "amount": 1000.0, "dueDate": "ISO-8601" }
  ]
}
```

### شكل الـ Response الكامل (`201 Created`)

```json
{
  "success": true,
  "message": "تم إنشاء العملية بنجاح",
  "data": {
    "id": "uuid",
    "contactId": "uuid",
    "contactName": "string",
    "type": "Sale | Purchase",
    "amount": 500.0,
    "paymentMethod": "Cash | Installments",
    "transactionDate": "ISO-8601",
    "isInstallment": false,
    "installments": [
      {
        "id": "uuid",
        "installmentNumber": 1,
        "amount": 1000.0,
        "dueDate": "ISO-8601",
        "isPaid": false,
        "status": "Pending"
      }
    ],
    "createdAt": "ISO-8601"
  }
}
```

`installments` بتكون `[]` في 4.1/4.2، وبتتعبّى في 4.3/4.4/4.5/4.6.

---

## 3. المعمارية اللي هتُبنى بيها (نفس نمط Contacts حرفيًا)

```
lib/
├── data/
│   ├── request/
│   │   └── transaction_request.dart          # CreateTransactionRequest + CustomInstallmentItem
│   ├── response/transaction_responses/
│   │   ├── transaction_responses.dart          # TransactionData + InstallmentData + TransactionResponse
│   │   └── transaction_responses.g.dart        # مولّد (build_runner)
│   ├── data_source/
│   │   └── transaction_remote_data_source.dart # abstract + Impl (@LazySingleton)
│   ├── mapper/
│   │   └── transaction_mapper.dart             # extension على Data? { toDomain() }
│   ├── network/
│   │   └── app_api.dart                        # + createTransaction endpoint (تعديل، مش ملف جديد)
│   └── repository_impl/
│       └── transaction_repository_impl.dart    # @LazySingleton(as: TransactionRepository)
├── domain/
│   ├── model/
│   │   └── transaction_model.dart              # Transaction + Installment (plain Dart, بدون freezed)
│   ├── repository/
│   │   └── transaction_repository.dart         # abstract
│   └── use_case/
│       └── create_transaction_use_case.dart    # @injectable — واحد بس يغطي 4.1→4.6
└── presentation/
    └── transactions/
        └── transaction_form_cubit/
            ├── transaction_form_cubit.dart      # @injectable extends Cubit<TransactionFormState>
            └── transaction_form_state.dart      # @freezed
```

> ملحوظة معمارية: مش هينفع نعمل usecase لكل حالة من الـ 6 (زي `CreateSaleCashUseCase`،
> `CreateSaleAutoInstallmentUseCase`...) لأن الـ Endpoint والـ Repository method **واحدة**.
> الفروق كلها بتتحل جوه شكل الـ Request نفسه. usecase واحد `CreateTransactionUseCase`
> كافي — تمامًا نفس فكرة `CreateContactUseCase` مع `CreateContactRequest`.

---

## 4. الكود بالتفصيل — طبقة الـ Data

### 4.1 — `data/request/transaction_request.dart`

```dart
class CustomInstallmentItem {
  final num amount;
  final String dueDate; // ISO-8601

  CustomInstallmentItem({required this.amount, required this.dueDate});

  Map<String, dynamic> toJson() => {
    'amount': amount,
    'dueDate': dueDate,
  };
}

class CreateTransactionRequest {
  final String? contactId;
  final String? partyName;
  final String type;              // "Sale" | "Purchase"
  final num amount;
  final String paymentMethod;     // "Cash" | "Installments"
  final String transactionDate;   // ISO-8601
  final String? noteText;

  final bool isInstallment;
  final String? installmentPlanMode; // "Automatic" | "Custom" | null

  // Automatic فقط
  final int? installmentCount;
  final String? frequency;            // "Weekly" | "Monthly" | "Yearly"
  final String? firstInstallmentDate;

  // Custom فقط
  final List<CustomInstallmentItem>? customInstallments;

  CreateTransactionRequest({
    this.contactId,
    this.partyName,
    required this.type,
    required this.amount,
    required this.paymentMethod,
    required this.transactionDate,
    this.noteText,
    this.isInstallment = false,
    this.installmentPlanMode,
    this.installmentCount,
    this.frequency,
    this.firstInstallmentDate,
    this.customInstallments,
  });

  Map<String, dynamic> toBody() => {
    if (contactId != null) 'contactId': contactId,
    if (partyName != null) 'partyName': partyName,
    'type': type,
    'amount': amount,
    'paymentMethod': paymentMethod,
    'transactionDate': transactionDate,
    if (noteText != null) 'noteText': noteText,
    'isInstallment': isInstallment,
    if (installmentPlanMode != null) 'installmentPlanMode': installmentPlanMode,
    if (installmentCount != null) 'installmentCount': installmentCount,
    if (frequency != null) 'frequency': frequency,
    if (firstInstallmentDate != null) 'firstInstallmentDate': firstInstallmentDate,
    if (customInstallments != null)
      'customInstallments': customInstallments!.map((e) => e.toJson()).toList(),
  };
}
```

> ليه `toBody()` هنا بدل `@Field` منفصلة زي contacts؟ لأن `contacts` عندها 3-6 حقول ثابتة
> بس، لكن الـ transaction عندها حقول شرطية بتختفي/تظهر حسب الحالة — إرسالها كـ
> `@Body() Map<String, dynamic>` (زي نمط `verifyOtp`/`selectUserType` الموجود فعلًا في
> `app_api.dart`) أنضف من `@Field` لعدد كبير من الحقول الاختيارية. ده مش كسر للنمط، ده
> استخدام النمط التاني الموجود فعلًا في نفس الملف.

### 4.2 — `data/response/transaction_responses/transaction_responses.dart`

```dart
import 'package:json_annotation/json_annotation.dart';
import 'package:mizan/data/response/base_responses/base_responses.dart';

part 'transaction_responses.g.dart';

@JsonSerializable()
class InstallmentData {
  @JsonKey(name: "id")
  String? id;
  @JsonKey(name: "installmentNumber")
  int? installmentNumber;
  @JsonKey(name: "amount")
  num? amount;
  @JsonKey(name: "dueDate")
  String? dueDate;
  @JsonKey(name: "isPaid")
  bool? isPaid;
  @JsonKey(name: "status")
  String? status;

  InstallmentData({
    this.id,
    this.installmentNumber,
    this.amount,
    this.dueDate,
    this.isPaid,
    this.status,
  });

  factory InstallmentData.fromJson(Map<String, dynamic> json) =>
      _$InstallmentDataFromJson(json);

  Map<String, dynamic> toJson() => _$InstallmentDataToJson(this);
}

@JsonSerializable()
class TransactionData {
  @JsonKey(name: "id")
  String? id;
  @JsonKey(name: "contactId")
  String? contactId;
  @JsonKey(name: "contactName")
  String? contactName;
  @JsonKey(name: "type")
  String? type;
  @JsonKey(name: "amount")
  num? amount;
  @JsonKey(name: "paymentMethod")
  String? paymentMethod;
  @JsonKey(name: "transactionDate")
  String? transactionDate;
  @JsonKey(name: "isInstallment")
  bool? isInstallment;
  @JsonKey(name: "installments")
  List<InstallmentData>? installments;
  @JsonKey(name: "createdAt")
  String? createdAt;

  TransactionData({
    this.id,
    this.contactId,
    this.contactName,
    this.type,
    this.amount,
    this.paymentMethod,
    this.transactionDate,
    this.isInstallment,
    this.installments,
    this.createdAt,
  });

  factory TransactionData.fromJson(Map<String, dynamic> json) =>
      _$TransactionDataFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionDataToJson(this);
}

@JsonSerializable()
class TransactionResponse extends BaseResponse {
  @JsonKey(name: "data")
  TransactionData? data;

  TransactionResponse({this.data, super.success, super.message});

  factory TransactionResponse.fromJson(Map<String, dynamic> json) =>
      _$TransactionResponseFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$TransactionResponseToJson(this);
}
```

> `.g.dart` مش هتتكتب يدوي — بتخرج أوتوماتيك بأمر:
> `dart run build_runner build --delete-conflicting-outputs`

### 4.3 — `data/data_source/transaction_remote_data_source.dart`

```dart
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
```

### 4.4 — إضافة في `data/network/app_api.dart` (تعديل على الملف الموجود، مش ملف جديد)

```dart
// ======================== Transactions Endpoints ========================
@POST("/api/transactions")
Future<TransactionResponse> createTransaction(@Body() Map<String, dynamic> body);
```

(وإضافة الـ import: `import 'package:mizan/data/response/transaction_responses/transaction_responses.dart';`)

### 4.5 — `data/mapper/transaction_mapper.dart`

```dart
import 'package:mizan/app/extensions.dart';
import 'package:mizan/data/response/transaction_responses/transaction_responses.dart';
import 'package:mizan/domain/model/transaction_model.dart';

extension InstallmentResponseMapper on InstallmentData? {
  Installment toDomain() {
    return Installment(
      id: this?.id.orEmpty() ?? '',
      installmentNumber: this?.installmentNumber.orZero() ?? 0,
      amount: this?.amount.orZeroNum() ?? 0,
      dueDate: this?.dueDate.orEmpty() ?? '',
      isPaid: this?.isPaid.orFalse() ?? false,
      status: this?.status.orEmpty() ?? '',
    );
  }
}

extension TransactionResponseMapper on TransactionData? {
  Transaction toDomain() {
    return Transaction(
      id: this?.id.orEmpty() ?? '',
      contactId: this?.contactId.orEmpty() ?? '',
      contactName: this?.contactName.orEmpty() ?? '',
      type: this?.type.orEmpty() ?? '',
      amount: this?.amount.orZeroNum() ?? 0,
      paymentMethod: this?.paymentMethod.orEmpty() ?? '',
      transactionDate: this?.transactionDate.orEmpty() ?? '',
      isInstallment: this?.isInstallment.orFalse() ?? false,
      installments:
          (this?.installments?.map((i) => i.toDomain()) ?? const []).toList(),
      createdAt: this?.createdAt.orEmpty() ?? '',
    );
  }
}
```

### 4.6 — `data/repository_impl/transaction_repository_impl.dart`

```dart
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:mizan/data/data_source/transaction_remote_data_source.dart';
import 'package:mizan/data/mapper/transaction_mapper.dart';
import 'package:mizan/data/network/error_handler.dart';
import 'package:mizan/data/network/failure.dart';
import 'package:mizan/data/network/network_info.dart';
import 'package:mizan/data/request/transaction_request.dart';
import 'package:mizan/domain/model/transaction_model.dart';
import 'package:mizan/domain/repository/transaction_repository.dart';

@LazySingleton(as: TransactionRepository)
class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionRemoteDataSource _remote;
  final NetworkInfo _networkInfo;

  TransactionRepositoryImpl(this._remote, this._networkInfo);

  @override
  Future<Either<Failure, Transaction>> createTransaction(
    CreateTransactionRequest request,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final response = await _remote.createTransaction(request);
        if (response.success == true) {
          return Right(response.data.toDomain());
        } else {
          return Left(
            Failure(
              ApiInternalStatus.FAILURE,
              response.message ?? ResponseMessage.DEAFULT,
            ),
          );
        }
      } catch (e) {
        return Left(ErrorHandler.handle(e).failure);
      }
    } else {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }
}
```

هنا بالظبط نفس الـ pattern الموجود حرفيًا في `contact_repository_impl.dart`
(NetworkInfo check → try/catch → success flag check → Failure ثابتة).

---

## 5. طبقة الـ Domain

### 5.1 — `domain/model/transaction_model.dart`

```dart
class Installment {
  final String id;
  final int installmentNumber;
  final num amount;
  final String dueDate;
  final bool isPaid;
  final String status;

  const Installment({
    required this.id,
    required this.installmentNumber,
    required this.amount,
    required this.dueDate,
    required this.isPaid,
    required this.status,
  });
}

class Transaction {
  final String id;
  final String contactId;
  final String contactName;
  final String type;
  final num amount;
  final String paymentMethod;
  final String transactionDate;
  final bool isInstallment;
  final List<Installment> installments;
  final String createdAt;

  const Transaction({
    required this.id,
    required this.contactId,
    required this.contactName,
    required this.type,
    required this.amount,
    required this.paymentMethod,
    required this.transactionDate,
    required this.isInstallment,
    required this.installments,
    required this.createdAt,
  });
}
```

### 5.2 — `domain/repository/transaction_repository.dart`

```dart
import 'package:dartz/dartz.dart';
import 'package:mizan/data/network/failure.dart';
import 'package:mizan/data/request/transaction_request.dart';
import 'package:mizan/domain/model/transaction_model.dart';

abstract class TransactionRepository {
  Future<Either<Failure, Transaction>> createTransaction(
    CreateTransactionRequest request,
  );
}
```

### 5.3 — `domain/use_case/create_transaction_use_case.dart`

```dart
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:mizan/data/network/failure.dart';
import 'package:mizan/data/request/transaction_request.dart';
import 'package:mizan/domain/model/transaction_model.dart';
import 'package:mizan/domain/repository/transaction_repository.dart';
import 'package:mizan/domain/use_case/base_usecase.dart';

typedef CreateTransactionInput = CreateTransactionRequest;

@injectable
class CreateTransactionUseCase
    extends BaseUsecase<CreateTransactionRequest, Transaction> {
  final TransactionRepository _repository;

  CreateTransactionUseCase(this._repository);

  @override
  Future<Either<Failure, Transaction>> execute(
    CreateTransactionRequest input,
  ) => _repository.createTransaction(input);
}
```

هذا الـ usecase الواحد هو اللي بيغطي الحالات كلها من 4.1 لـ 4.6 — الفرق بينهم بيتحدد
بس من شكل الـ `CreateTransactionRequest` اللي هتبنيه الشاشة/الـ Cubit قبل النداء عليه.

---

## 6. طبقة الـ Presentation — Cubit واحد يبني الـ Request المناسب لكل حالة

الفرق الوحيد الحقيقي بين 4.1↔4.6 هو **إزاي الشاشة تبني الـ Request**، فالـ Cubit بيحتاج
دوال منفصلة بالاسم (submitCashSale, submitCashPurchase, submitAutomaticInstallment,
submitCustomInstallment) لكن كلهم بينتهوا بنداء واحد على `_createTransactionUseCase.execute(...)`.

### 6.1 — `presentation/transactions/transaction_form_cubit/transaction_form_state.dart`

```dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mizan/domain/model/transaction_model.dart';
import 'package:mizan/presentation/common/state_randrer/state_randrer_impl.dart';

part 'transaction_form_state.freezed.dart';

@freezed
abstract class TransactionFormState with _$TransactionFormState {
  const factory TransactionFormState({
    FlowState? flowState,
    Transaction? savedTransaction,
    @Default(false) bool isActionSuccess,
  }) = _TransactionFormState;
}
```

### 6.2 — `presentation/transactions/transaction_form_cubit/transaction_form_cubit.dart`

```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:mizan/data/request/transaction_request.dart';
import 'package:mizan/domain/use_case/create_transaction_use_case.dart';
import 'package:mizan/presentation/common/state_randrer/state_randrer.dart';
import 'package:mizan/presentation/common/state_randrer/state_randrer_impl.dart';
import 'package:mizan/presentation/transactions/transaction_form_cubit/transaction_form_state.dart';

@injectable
class TransactionFormCubit extends Cubit<TransactionFormState> {
  final CreateTransactionUseCase _createTransactionUseCase;

  TransactionFormCubit(this._createTransactionUseCase)
    : super(const TransactionFormState());

  /// نقطة تحقق واحدة موحّدة بدل تكرار عدة ErrorState متتالية.
  /// بترجع أول رسالة خطأ لو فيه، أو null لو البيانات سليمة.
  String? _validate({
    required String? contactId,
    required String? partyName,
    required num amount,
    required bool isInstallment,
    required String? installmentPlanMode,
    required int? installmentCount,
    required List<CustomInstallmentItem>? customInstallments,
  }) {
    if ((contactId == null || contactId.isEmpty) &&
        (partyName == null || partyName.trim().isEmpty)) {
      return "يجب تحديد عميل/مورد أو كتابة اسم الطرف";
    }
    if (amount <= 0) {
      return "المبلغ يجب أن يكون أكبر من صفر";
    }
    if (isInstallment && installmentPlanMode == "Automatic") {
      if (installmentCount == null || installmentCount <= 0) {
        return "عدد الأقساط يجب أن يكون أكبر من صفر";
      }
    }
    if (isInstallment && installmentPlanMode == "Custom") {
      if (customInstallments == null || customInstallments.isEmpty) {
        return "يجب إضافة أقساط مخصصة على الأقل قسط واحد";
      }
      final sum = customInstallments.fold<num>(0, (p, e) => p + e.amount);
      if (sum != amount) {
        return "مجموع الأقساط المخصصة ($sum) لا يساوي المبلغ الإجمالي ($amount)";
      }
    }
    return null;
  }

  Future<void> submit(CreateTransactionRequest request) async {
    final validationError = _validate(
      contactId: request.contactId,
      partyName: request.partyName,
      amount: request.amount,
      isInstallment: request.isInstallment,
      installmentPlanMode: request.installmentPlanMode,
      installmentCount: request.installmentCount,
      customInstallments: request.customInstallments,
    );

    if (validationError != null) {
      emit(
        state.copyWith(
          flowState: ErrorState(
            StateRendererType.popupErrorStatete,
            validationError,
            title: "تعذر إنشاء العملية",
          ),
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        flowState: LoadingState(
          stateRendererType: StateRendererType.popupLoadingState,
          message: "جاري تسجيل العملية...",
        ),
      ),
    );

    final result = await _createTransactionUseCase.execute(request);

    result.fold(
      (failure) {
        if (isClosed) return;
        emit(
          state.copyWith(
            flowState: ErrorState(
              StateRendererType.popupErrorStatete,
              failure.message,
              title: "تعذر إنشاء العملية",
            ),
          ),
        );
      },
      (transaction) {
        if (isClosed) return;
        emit(
          state.copyWith(
            savedTransaction: transaction,
            isActionSuccess: true,
            flowState: ContentState(),
          ),
        );
      },
    );
  }
}
```

---

## 7. بخصوص "الفشل" اللي هتشيلها وتغيّرها ⚠️

من كلامك، فهمت إنك شايف تكرار كبير في حالات `ErrorState`/الفشل زي اللي موجودة فعليًا في
`ContactFormCubit` الحالي (فيه `emit(ErrorState(...))` منفصلة لكل حقل: اسم فاضي، اسم فيه
أرقام، تليفون فاضي... كل واحدة `return` لوحدها). **ده افتراضي بناءً على اللي شفته في الكود
الحقيقي، ومش متأكد 100% إنه ده قصدك بالظبط — يفضل تأكيدها.**

الحل اللي طبّقته في `TransactionFormCubit` فوق:
- دالة تحقق واحدة `_validate()` بترجع **رسالة واحدة أو `null`**، بدل سلسلة
  `if...emit...return` متكررة زي `ContactFormCubit`.
- فشل الشبكة/السيرفر (`failure.message` الجايه من `ErrorHandler`) وفشل التحقق المحلي
  (`validationError`) بيتعرضوا **بنفس شكل `ErrorState` وبنفس `StateRendererType`**
  (`popupErrorStatete`) — يعني الشاشة مش محتاجة تفرّق بين نوعين مختلفين من العرض، غيّر بس
  الرسالة.
- لو قصدك حاجة تانية (زي: تقليل عدد أنواع `StateRendererType` نفسها، أو تغيير مكان عرض
  الخطأ من Popup لـ Inline تحت كل حقل)، قولّي بالتحديد وهعدّل الكود على أساسه.

---

## 8. خطوات التنفيذ بالترتيب

1. `transaction_model.dart` (domain/model) — قسم 5.1
2. `transaction_responses.dart` (data/response) — قسم 4.2، وبعدها:
   `dart run build_runner build --delete-conflicting-outputs` لتوليد `.g.dart`
3. `transaction_request.dart` (data/request) — قسم 4.1
4. `transaction_repository.dart` (domain/repository) — قسم 5.2
5. `transaction_remote_data_source.dart` (data/data_source) — قسم 4.3
6. تعديل `app_api.dart`: إضافة `createTransaction` — قسم 4.4
7. `transaction_mapper.dart` (data/mapper) — قسم 4.5
8. `transaction_repository_impl.dart` (data/repository_impl) — قسم 4.6
9. `create_transaction_use_case.dart` (domain/use_case) — قسم 5.3
10. `transaction_form_state.dart` + `transaction_form_cubit.dart` (presentation) — قسم 6،
    وبعدها build_runner تاني لتوليد `transaction_form_state.freezed.dart`
11. تسجيل الكل في DI: كل حاجة `@injectable`/`@LazySingleton` بتتسجل أوتوماتيك بعد
    build_runner — مفيش تعديل يدوي مطلوب في `di.dart` إلا لو حصل تعارض.
12. **وقف هنا** — ربط `TransactionFormCubit` بشاشات `quick_sale_view.dart` /
    `quick_purchase_view.dart` / الفورم الكامل بتاعة التقسيط، دي خطوة UI منفصلة زي ما هو
    متعارف عليه في المشروع (نفس مبدأ antigravity skill: للـ Cubit بس، مفيش UI).

---

## 9. حاجات مهمة اتأكدت منها وأنا بفحص الريبو (علشان تاخدها في الحسبان)

- الـ Response models في المشروع **`json_serializable` عادي، مش `freezed`** — والـ
  `freezed` مستخدم **بس** في `*_state.dart`. طبّقت ده حرفيًا فوق.
- فيه نمطين لإرسال الـ Body في `app_api.dart`: `@Field` منفصلة (زي `register`/`contacts`)
  و`@Body() Map<String, dynamic>` (زي `verifyOtp`/`selectUserType`). اخترت التاني
  للـ transactions لأن عدد الحقول الاختيارية كبير ومتغيّر.
- `contactId` اختياري في الـ request لكن **إلزامي إن يكون فيه واحد بديل** (`partyName`) —
  التحقق ده لازم يبقى Client-side قبل الإرسال (موجود في `_validate()` فوق).
- الأقساط الـ `Custom` لازم مجموعها = المبلغ الإجمالي — تحقق Client-side موجود فوق كمان،
  زي ما هو موضّح في وصف 4.6 بالـ Postman.
