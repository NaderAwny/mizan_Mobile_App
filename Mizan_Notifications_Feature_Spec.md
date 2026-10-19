# Mizan — Notifications Feature (Feature 3) — Implementation Spec

> Repo: `NaderAwny/mizan_Mobile_App` (branch `feature/update`) · package name `mizan` · layer-first architecture.
> Everything below was extracted from the **real code** of the repo and the **real Postman collection** (`Mizan_API.postman_collection.json`, folder 7 + 3.8).
> **Scope of this file: Data → Domain → Cubit/State → View wiring.** The visual design of the View comes from Figma via the MCP server (separate step) — but it must follow section 6.

---

## 0. Rules for the AI executing this file (read first, obey literally)

1. **Do not invent anything**: no endpoint, field, package, class, color, size, string, asset, folder. If something is not in this file or in the repo → **stop and ask**.
2. **Copy the sibling.** The closest existing sibling for every file is named in section 3. Open it, copy its shape, change only names/types.
3. **The repo wins** over any `*-SKILL.md` in the repo root when they disagree. Keep existing typos (`state_randrer`, `popupErrorStatete`, `DEAFULT`, `get_list_ transaction_repository.dart`) — they are public API.
4. Mandatory project rules (from `MIZAN_PRODUCTION_RULES.md`) that apply to ALL new code:
   - No `setState`. No `BlocSelector` (only `BlocBuilder` / `BlocConsumer`). Freezed states only (no Equatable).
   - No `dynamic`. Explicit types everywhere (`always_specify_types`). The only allowed `Map<String, dynamic>` is `fromJson`/`toJson`.
   - Cubits come from `getIt<...>()` in the View, never `new`. `if (isClosed) return;` before **every** `emit` inside `.fold`.
   - No logic in widgets. Widgets are small `const` `StatelessWidget` **classes** (not `_buildX()` helper methods). Lists use `ListView.builder/separated` or `SliverList.builder`.
   - No hardcoded colors / sizes / strings / asset paths → `ColorManager`, `AppPadding/AppSize/AppRadius`, `AppStrings`, `IconAssets`.
   - Navigation only through `Routes` + `RouteGenerator`. No `Image.network`. No `print` (use `AppLogger`).
5. 401 / refresh is global (`AuthInterceptor`). Never handle it inside this feature.
6. Do **not** modify: `notification_service.dart`, `device_*` files, auth files, `di.config.dart` by hand (generated).
7. Firebase/FCM already works (register device, foreground/background, tap → `Routes.notificationsRoute`). **Do not touch it.**

---

## 1. What already exists (do NOT recreate)

| Item | Where | Status |
|---|---|---|
| Route `Routes.notificationsRoute = "/notifications"` + `case` in `RouteGenerator` | `presentation/resources/routes_manager.dart` | exists → returns `const NotificationsView()` |
| `NotificationsView` | `presentation/notifications/notifications_view.dart` | **placeholder only** (static "جاهزة للربط مع الـ Cubit والـ API") → **replace its content, same file, same class name** |
| Bell entry points → `pushNamed(Routes.notificationsRoute)` | `home_header.dart` (bell has `hasBadge: true` hardcoded), `mizan_drawer.dart`, `transactions_view.dart`, `statistics_view.dart` | exist, untouched |
| FCM tap → opens notifications screen | `app/notification_service.dart` | exists, untouched |
| `BaseResponse {success, message}` | `data/response/base_responses/base_responses.dart` | reuse |
| `AppStrings.notifications = "التنبيهات"`, `IconAssets.bell`, `AppStrings.sendReminder` | resources | reuse |
| Update contact (3.8) incl. `contactEmail` | `UpdateContactUseCase`, `UpdateContactRequest`, `ContactFormCubit`, `ContactFormView`, `AppServiceClient.updateContact` | **already implemented** — reuse only, no new code |
| Get contact by id (3.4), Get transaction by id (4.8) | `GetContactByIdUseCase`, `GetTransactionByIdUseCase` | exist — reuse if needed |

**What is NEW:** endpoints 7.1, 7.2, 7.3, 7.4 → full chain below.

---

## 2. API contract (verbatim from Postman — field names are case-sensitive)

All responses use the wrapper `{ "success": bool, "message": string|null, "data": ... }`. Auth: Bearer (auto-attached by interceptor).

### 7.1 `GET /api/notifications?page=1&pageSize=20&unreadOnly=false`
`unreadOnly=true` → unread only. Response `200`:
```json
{ "success": true, "message": null,
  "data": {
    "items": [
      { "id": "99999999-8888-7777-6666-555555555555",
        "type": "InstallmentReminder",
        "title": "تذكير بقسط مستحق",
        "message": "يستحق قسط بمبلغ 1000.00 ج.م على الطرف محمود حسن إبراهيم اليوم.",
        "transactionId": "f4689c23-5d6e-7f8a-9b0c-1d2e3f4a5b6c",
        "installmentId": "11111111-2222-3333-4444-555555555555",
        "isRead": false,
        "createdAt": "2026-08-19T06:00:00Z" } ],
    "totalCount": 1, "page": 1, "pageSize": 20, "totalPages": 1 } }
```
⚠️ There is **no** `hasNextPage` / `hasPreviousPage` in this response (unlike installments history). Derive `hasNextPage = page < totalPages` in the **mapper** (see 4.5).
`type`: the only value in the collection is `"InstallmentReminder"` → keep it a `String`, never an enum, never invent other values.

### 7.2 `PATCH /api/notifications/{notification_id}/read` (no body)
```json
{ "success": true, "message": "تم تحديث حالة الإشعار",
  "data": { "id": "99999999-8888-7777-6666-555555555555", "isRead": true } }
```

### 7.3 `PATCH /api/notifications/read-all` (no body)
```json
{ "success": true, "message": "تم تعليم جميع الإشعارات كمقروءة", "data": null }
```

### 7.4 `POST /api/notifications/run-reminders-scan` (no body)
Manual trigger of the reminders scanner. It (1) scans installments due in **3 days / 1 day / same day**, (2) creates an in-app notification for the shop owner, (3) sends a reminder **email to the client only if the client has `contactEmail`**.
```json
{ "success": true,
  "message": "تم تشغيل فحص تذكيرات الأقساط وإرسال الإشعارات وإيميلات التذكير بنجاح",
  "data": { "remindersProcessed": 3, "timestamp": "2026-08-19T10:00:00Z" } }
```
It scans **all** installments at once. There is no endpoint to remind one installment/one client.

### 3.8 `PUT /api/contacts/{id}` — already implemented. `contactEmail` is the email that receives automatic installment reminders (Feature 3).

---

## 3. Files — create / edit, in this exact order

| # | Action | Path | Sibling to copy |
|---|---|---|---|
| 1 | **create** | `lib/data/response/notifications_responses/notifications_responses.dart` (+ `.g.dart` generated) | `installments_history_responses.dart` |
| 2 | **edit** | `lib/data/network/app_api.dart` (imports + new section + `.g.dart` regenerated) | same file |
| 3 | **create** | `lib/data/data_source/notification_remote_data_source.dart` | `installment_remote_data_source.dart` |
| 4 | **create** | `lib/domain/model/notification_model.dart` | `installments_history_model.dart` |
| 5 | **create** | `lib/data/mapper/notification_mapper.dart` | `installments_history_mapper.dart` |
| 6 | **create** | `lib/domain/repository/notification_repository.dart` | `installment_repository.dart` |
| 7 | **create** | `lib/data/repository_impl/notification_repository_impl.dart` | `installment_repository_impl.dart` |
| 8 | **create** | `lib/domain/use_case/get_notifications_use_case.dart` | `get_installments_history_use_case.dart` |
| 9 | **create** | `lib/domain/use_case/mark_notification_read_use_case.dart` | `toggle_vip_contact_use_case.dart` |
| 10 | **create** | `lib/domain/use_case/mark_all_notifications_read_use_case.dart` | `get_profile_use_case.dart` (void input) |
| 11 | **create** | `lib/domain/use_case/run_reminders_scan_use_case.dart` | `get_profile_use_case.dart` (void input) |
| 12 | **create** | `lib/presentation/notifications/notifications_cubit/notifications_state.dart` (+ `.freezed.dart`) | `installments_history_state.dart` |
| 13 | **create** | `lib/presentation/notifications/notifications_cubit/notifications_cubit.dart` | `installments_history_cubit.dart` + `contacts_cubit.toggleVip` |
| 14 | **create** | `lib/presentation/notifications/run_reminders_scan/run_reminders_scan_state.dart` (+ `.freezed.dart`) | `pay_installment_state.dart` |
| 15 | **create** | `lib/presentation/notifications/run_reminders_scan/run_reminders_scan_cubit.dart` | `pay_installment_cubit.dart` |
| 16 | **edit** | `lib/presentation/resources/strings_manager.dart` (new block, section 5.4) | same file |
| 17 | **edit (replace content)** | `lib/presentation/notifications/notifications_view.dart` | `installments_history_view.dart` |
| 18 | **create** | `lib/presentation/notifications/widgets/*` (section 6) | `installments_history/widgets/*` |
| 19 | **create** | `lib/presentation/notifications/run_reminders_scan/run_reminders_sheet.dart` | `pay_installment_sheet.dart` (shape only) |

`routes_manager.dart` needs **no change** (route + case already exist).

---

## 4. Data & Domain layer — code

### 4.1 `data/response/notifications_responses/notifications_responses.dart`
```dart
import 'package:json_annotation/json_annotation.dart';
import 'package:mizan/data/response/base_responses/base_responses.dart';

part 'notifications_responses.g.dart';

@JsonSerializable()
class NotificationData {
  @JsonKey(name: "id")
  String? id;
  @JsonKey(name: "type")
  String? type;
  @JsonKey(name: "title")
  String? title;
  @JsonKey(name: "message")
  String? message;
  @JsonKey(name: "transactionId")
  String? transactionId;
  @JsonKey(name: "installmentId")
  String? installmentId;
  @JsonKey(name: "isRead")
  bool? isRead;
  @JsonKey(name: "createdAt")
  String? createdAt;

  NotificationData({
    this.id,
    this.type,
    this.title,
    this.message,
    this.transactionId,
    this.installmentId,
    this.isRead,
    this.createdAt,
  });

  factory NotificationData.fromJson(Map<String, dynamic> json) =>
      _$NotificationDataFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationDataToJson(this);
}

@JsonSerializable()
class NotificationsPageData {
  @JsonKey(name: "items")
  List<NotificationData>? items;
  @JsonKey(name: "totalCount")
  int? totalCount;
  @JsonKey(name: "page")
  int? page;
  @JsonKey(name: "pageSize")
  int? pageSize;
  @JsonKey(name: "totalPages")
  int? totalPages;

  NotificationsPageData({
    this.items,
    this.totalCount,
    this.page,
    this.pageSize,
    this.totalPages,
  });

  factory NotificationsPageData.fromJson(Map<String, dynamic> json) =>
      _$NotificationsPageDataFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationsPageDataToJson(this);
}

// 7.1
@JsonSerializable()
class NotificationsPageResponse extends BaseResponse {
  @JsonKey(name: "data")
  NotificationsPageData? data;

  NotificationsPageResponse({this.data, super.success, super.message});

  factory NotificationsPageResponse.fromJson(Map<String, dynamic> json) =>
      _$NotificationsPageResponseFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$NotificationsPageResponseToJson(this);
}

@JsonSerializable()
class MarkNotificationReadData {
  @JsonKey(name: "id")
  String? id;
  @JsonKey(name: "isRead")
  bool? isRead;

  MarkNotificationReadData({this.id, this.isRead});

  factory MarkNotificationReadData.fromJson(Map<String, dynamic> json) =>
      _$MarkNotificationReadDataFromJson(json);

  Map<String, dynamic> toJson() => _$MarkNotificationReadDataToJson(this);
}

// 7.2
@JsonSerializable()
class MarkNotificationReadResponse extends BaseResponse {
  @JsonKey(name: "data")
  MarkNotificationReadData? data;

  MarkNotificationReadResponse({this.data, super.success, super.message});

  factory MarkNotificationReadResponse.fromJson(Map<String, dynamic> json) =>
      _$MarkNotificationReadResponseFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$MarkNotificationReadResponseToJson(this);
}

@JsonSerializable()
class RunRemindersScanData {
  @JsonKey(name: "remindersProcessed")
  int? remindersProcessed;
  @JsonKey(name: "timestamp")
  String? timestamp;

  RunRemindersScanData({this.remindersProcessed, this.timestamp});

  factory RunRemindersScanData.fromJson(Map<String, dynamic> json) =>
      _$RunRemindersScanDataFromJson(json);

  Map<String, dynamic> toJson() => _$RunRemindersScanDataToJson(this);
}

// 7.4
@JsonSerializable()
class RunRemindersScanResponse extends BaseResponse {
  @JsonKey(name: "data")
  RunRemindersScanData? data;

  RunRemindersScanResponse({this.data, super.success, super.message});

  factory RunRemindersScanResponse.fromJson(Map<String, dynamic> json) =>
      _$RunRemindersScanResponseFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$RunRemindersScanResponseToJson(this);
}
```
7.3 (`read-all`, `data: null`) uses the existing **`BaseResponse`** (same as `logout`). No new class.

### 4.2 `data/network/app_api.dart` — edit
Add imports (alphabetical with the others):
```dart
import 'package:mizan/data/response/notifications_responses/notifications_responses.dart';
```
Add a new section (after the Installments block). `read-all` is declared before `{id}/read` (project convention: static paths first):
```dart
  // ======================== Notifications Endpoints ========================
  /// GET /api/notifications — قائمة الإشعارات
  @GET("/api/notifications")
  Future<NotificationsPageResponse> getNotifications(
    @Query("page") int page,
    @Query("pageSize") int pageSize,
    @Query("unreadOnly") bool unreadOnly,
  );

  /// PATCH /api/notifications/read-all — تعليم الكل كمقروء
  @PATCH("/api/notifications/read-all")
  Future<BaseResponse> markAllNotificationsRead();

  /// PATCH /api/notifications/{id}/read — تعليم إشعار كمقروء
  @PATCH("/api/notifications/{id}/read")
  Future<MarkNotificationReadResponse> markNotificationRead(
    @Path("id") String id,
  );

  /// POST /api/notifications/run-reminders-scan — تشغيل فحص التذكيرات
  @POST("/api/notifications/run-reminders-scan")
  Future<RunRemindersScanResponse> runRemindersScan();
```

### 4.3 `data/data_source/notification_remote_data_source.dart`
```dart
import 'package:injectable/injectable.dart';
import 'package:mizan/data/network/app_api.dart';
import 'package:mizan/data/response/base_responses/base_responses.dart';
import 'package:mizan/data/response/notifications_responses/notifications_responses.dart';

abstract class NotificationRemoteDataSource {
  /// GET /api/notifications
  Future<NotificationsPageResponse> getNotifications({
    required int page,
    required int pageSize,
    required bool unreadOnly,
  });

  /// PATCH /api/notifications/{id}/read
  Future<MarkNotificationReadResponse> markNotificationRead(String id);

  /// PATCH /api/notifications/read-all
  Future<BaseResponse> markAllNotificationsRead();

  /// POST /api/notifications/run-reminders-scan
  Future<RunRemindersScanResponse> runRemindersScan();
}

@LazySingleton(as: NotificationRemoteDataSource)
class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final AppServiceClient _appServiceClient;

  NotificationRemoteDataSourceImpl(this._appServiceClient);

  @override
  Future<NotificationsPageResponse> getNotifications({
    required int page,
    required int pageSize,
    required bool unreadOnly,
  }) {
    return _appServiceClient.getNotifications(page, pageSize, unreadOnly);
  }

  @override
  Future<MarkNotificationReadResponse> markNotificationRead(String id) {
    return _appServiceClient.markNotificationRead(id);
  }

  @override
  Future<BaseResponse> markAllNotificationsRead() {
    return _appServiceClient.markAllNotificationsRead();
  }

  @override
  Future<RunRemindersScanResponse> runRemindersScan() {
    return _appServiceClient.runRemindersScan();
  }
}
```

### 4.4 `domain/model/notification_model.dart` (plain Dart, non-nullable, no json)
```dart
class NotificationModel {
  final String id;
  final String type; // "InstallmentReminder" (only value in the API contract)
  final String title;
  final String message;
  final String transactionId; // "" when null
  final String installmentId; // "" when null
  final bool isRead;
  final String createdAt; // ISO-8601 UTC

  const NotificationModel({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    required this.transactionId,
    required this.installmentId,
    required this.isRead,
    required this.createdAt,
  });
}

class NotificationsPage {
  final List<NotificationModel> items;
  final int page;
  final int pageSize;
  final int totalCount;
  final int totalPages;
  final bool hasNextPage; // derived in mapper: page < totalPages

  const NotificationsPage({
    required this.items,
    required this.page,
    required this.pageSize,
    required this.totalCount,
    required this.totalPages,
    required this.hasNextPage,
  });
}

/// نتيجة PATCH /api/notifications/{id}/read
class NotificationReadStatus {
  final String id;
  final bool isRead;

  const NotificationReadStatus({required this.id, required this.isRead});
}

/// نتيجة POST /api/notifications/run-reminders-scan
class RemindersScanResult {
  final int remindersProcessed;
  final String timestamp;

  const RemindersScanResult({
    required this.remindersProcessed,
    required this.timestamp,
  });
}
```

### 4.5 `data/mapper/notification_mapper.dart`
```dart
import 'package:mizan/app/extensions.dart';
import 'package:mizan/data/response/notifications_responses/notifications_responses.dart';
import 'package:mizan/domain/model/notification_model.dart';

extension NotificationMapper on NotificationData? {
  NotificationModel toDomain() {
    return NotificationModel(
      id: this?.id.orEmpty() ?? '',
      type: this?.type.orEmpty() ?? '',
      title: this?.title.orEmpty() ?? '',
      message: this?.message.orEmpty() ?? '',
      transactionId: this?.transactionId.orEmpty() ?? '',
      installmentId: this?.installmentId.orEmpty() ?? '',
      isRead: this?.isRead.orFalse() ?? false,
      createdAt: this?.createdAt.orEmpty() ?? '',
    );
  }
}

extension NotificationsPageMapper on NotificationsPageData? {
  NotificationsPage toDomain() {
    final int currentPage = this?.page.orZero() ?? 1;
    final int totalPages = this?.totalPages.orZero() ?? 1;
    return NotificationsPage(
      items:
          (this?.items?.map((NotificationData i) => i.toDomain()) ??
                  const <NotificationModel>[])
              .toList(),
      page: currentPage,
      pageSize: this?.pageSize.orZero() ?? 20,
      totalCount: this?.totalCount.orZero() ?? 0,
      totalPages: totalPages,
      hasNextPage: currentPage < totalPages,
    );
  }
}

extension NotificationReadStatusMapper on MarkNotificationReadData? {
  NotificationReadStatus toDomain() {
    return NotificationReadStatus(
      id: this?.id.orEmpty() ?? '',
      isRead: this?.isRead.orFalse() ?? false,
    );
  }
}

extension RemindersScanResultMapper on RunRemindersScanData? {
  RemindersScanResult toDomain() {
    return RemindersScanResult(
      remindersProcessed: this?.remindersProcessed.orZero() ?? 0,
      timestamp: this?.timestamp.orEmpty() ?? '',
    );
  }
}
```

### 4.6 Repository
`domain/repository/notification_repository.dart`
```dart
import 'package:dartz/dartz.dart';
import 'package:mizan/data/network/failure.dart';
import 'package:mizan/domain/model/notification_model.dart';

abstract class NotificationRepository {
  /// GET /api/notifications
  Future<Either<Failure, NotificationsPage>> getNotifications({
    required int page,
    required int pageSize,
    required bool unreadOnly,
  });

  /// PATCH /api/notifications/{id}/read
  Future<Either<Failure, NotificationReadStatus>> markNotificationRead(
    String id,
  );

  /// PATCH /api/notifications/read-all
  Future<Either<Failure, void>> markAllNotificationsRead();

  /// POST /api/notifications/run-reminders-scan
  Future<Either<Failure, RemindersScanResult>> runRemindersScan();
}
```
`data/repository_impl/notification_repository_impl.dart` — **inline pattern exactly like `InstallmentRepositoryImpl`** (no `_guard`; that helper only exists in the device repo):
```dart
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:mizan/data/data_source/notification_remote_data_source.dart';
import 'package:mizan/data/mapper/notification_mapper.dart';
import 'package:mizan/data/network/error_handler.dart';
import 'package:mizan/data/network/failure.dart';
import 'package:mizan/data/network/network_info.dart';
import 'package:mizan/data/response/base_responses/base_responses.dart';
import 'package:mizan/data/response/notifications_responses/notifications_responses.dart';
import 'package:mizan/domain/model/notification_model.dart';
import 'package:mizan/domain/repository/notification_repository.dart';

@LazySingleton(as: NotificationRepository)
class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  NotificationRepositoryImpl(this._remoteDataSource, this._networkInfo);

  @override
  Future<Either<Failure, NotificationsPage>> getNotifications({
    required int page,
    required int pageSize,
    required bool unreadOnly,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        final NotificationsPageResponse response = await _remoteDataSource
            .getNotifications(
              page: page,
              pageSize: pageSize,
              unreadOnly: unreadOnly,
            );
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
      } catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  @override
  Future<Either<Failure, NotificationReadStatus>> markNotificationRead(
    String id,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final MarkNotificationReadResponse response = await _remoteDataSource
            .markNotificationRead(id);
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
      } catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  @override
  Future<Either<Failure, void>> markAllNotificationsRead() async {
    if (await _networkInfo.isConnected) {
      try {
        final BaseResponse response = await _remoteDataSource
            .markAllNotificationsRead();
        if (response.success == true) {
          return const Right(null);
        } else {
          return Left(
            Failure(
              ApiInternalStatus.FAILURE,
              response.message ?? ResponseMessage.DEAFULT,
            ),
          );
        }
      } catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  @override
  Future<Either<Failure, RemindersScanResult>> runRemindersScan() async {
    if (await _networkInfo.isConnected) {
      try {
        final RunRemindersScanResponse response = await _remoteDataSource
            .runRemindersScan();
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
      } catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }
}
```

### 4.7 Use cases
`get_notifications_use_case.dart` (list → `@lazySingleton`, params class in same file — copy `GetInstallmentsHistoryUseCase`):
```dart
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:mizan/data/network/failure.dart';
import 'package:mizan/domain/model/notification_model.dart';
import 'package:mizan/domain/repository/notification_repository.dart';
import 'package:mizan/domain/use_case/base_usecase.dart';

@lazySingleton
class GetNotificationsUseCase
    implements BaseUsecase<GetNotificationsParams, NotificationsPage> {
  final NotificationRepository _repository;

  GetNotificationsUseCase(this._repository);

  @override
  Future<Either<Failure, NotificationsPage>> execute(
    GetNotificationsParams params,
  ) async {
    return await _repository.getNotifications(
      page: params.page,
      pageSize: params.pageSize,
      unreadOnly: params.unreadOnly,
    );
  }
}

class GetNotificationsParams {
  final int page;
  final int pageSize;
  final bool unreadOnly;

  GetNotificationsParams({
    required this.page,
    required this.pageSize,
    this.unreadOnly = false,
  });
}
```
`mark_notification_read_use_case.dart` (single id → `@injectable extends BaseUsecase<String, …>`):
```dart
@injectable
class MarkNotificationReadUseCase
    extends BaseUsecase<String, NotificationReadStatus> {
  final NotificationRepository _repository;

  MarkNotificationReadUseCase(this._repository);

  @override
  Future<Either<Failure, NotificationReadStatus>> execute(String input) =>
      _repository.markNotificationRead(input);
}
```
`mark_all_notifications_read_use_case.dart` (void input, like `GetProfileUsecase`):
```dart
@injectable
class MarkAllNotificationsReadUseCase implements BaseUsecase<void, void> {
  final NotificationRepository _repository;

  MarkAllNotificationsReadUseCase(this._repository);

  @override
  Future<Either<Failure, void>> execute(void input) async {
    return await _repository.markAllNotificationsRead();
  }
}
```
`run_reminders_scan_use_case.dart`:
```dart
@injectable
class RunRemindersScanUseCase implements BaseUsecase<void, RemindersScanResult> {
  final NotificationRepository _repository;

  RunRemindersScanUseCase(this._repository);

  @override
  Future<Either<Failure, RemindersScanResult>> execute(void input) async {
    return await _repository.runRemindersScan();
  }
}
```
(Each file needs the same imports as above: `dartz`, `injectable`, `failure.dart`, the model, the repository, `base_usecase.dart`.)

---

## 5. Presentation — State, Cubit, Strings

### 5.1 `notifications_cubit/notifications_state.dart`
```dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mizan/domain/model/notification_model.dart';
import 'package:mizan/presentation/common/state_randrer/state_randrer_impl.dart';

part 'notifications_state.freezed.dart';

@freezed
abstract class NotificationsState with _$NotificationsState {
  const factory NotificationsState({
    FlowState? flowState,
    List<NotificationModel>? data,
    @Default(false) bool unreadOnly, // الفلتر: false = الكل / true = غير مقروءة
    @Default(false) bool isLoadingMore,
    @Default(true) bool hasMore,
    @Default(0) int totalCount,
    @Default(1) int currentPage,
    @Default(1) int totalPages,
  }) = _NotificationsState;
}
```

### 5.2 `notifications_cubit/notifications_cubit.dart`
Pattern = `InstallmentsHistoryCubit` (list + filter + load-more) + `ContactsCubit.toggleVip` (optimistic update + revert). `@injectable` (factory) because the screen owns it.
```dart
@injectable
class NotificationsCubit extends Cubit<NotificationsState> {
  final GetNotificationsUseCase _getNotificationsUseCase;
  final MarkNotificationReadUseCase _markNotificationReadUseCase;
  final MarkAllNotificationsReadUseCase _markAllNotificationsReadUseCase;

  NotificationsCubit(
    this._getNotificationsUseCase,
    this._markNotificationReadUseCase,
    this._markAllNotificationsReadUseCase,
  ) : super(const NotificationsState());

  int currentPage = 1;
  final int pageSize = 20;

  // ── 7.1 first load / refresh / change filter ─────────────────────────────
  Future<void> getNotifications({bool? unreadOnly}) async {
    currentPage = 1;
    final bool isInitialLoad = state.data == null;
    final bool targetUnreadOnly = unreadOnly ?? state.unreadOnly;

    if (isInitialLoad) {
      emit(
        state.copyWith(
          flowState: LoadingState(
            stateRendererType: StateRendererType.fullScreenLoadingState,
            title: AppStrings.loading,
            message: AppStrings.notificationsLoading,
          ),
          unreadOnly: targetUnreadOnly,
          hasMore: true,
        ),
      );
    } else {
      emit(state.copyWith(unreadOnly: targetUnreadOnly, hasMore: true));
    }

    final Either<Failure, NotificationsPage> result =
        await _getNotificationsUseCase.execute(
          GetNotificationsParams(
            page: 1,
            pageSize: pageSize,
            unreadOnly: targetUnreadOnly,
          ),
        );

    result.fold(
      (Failure failure) {
        if (isClosed) return;
        emit(
          state.copyWith(
            flowState: ErrorState(
              StateRendererType.fullScreenErrorState,
              failure.message,
              title: AppStrings.notificationsLoadError,
            ),
          ),
        );
      },
      (NotificationsPage page) {
        if (isClosed) return;
        currentPage = page.page;
        emit(
          state.copyWith(
            flowState: page.items.isEmpty
                ? EmptyState(
                    targetUnreadOnly
                        ? AppStrings.notificationsUnreadEmpty
                        : AppStrings.notificationsEmpty,
                  )
                : ContentState(),
            data: page.items,
            hasMore: page.hasNextPage,
            totalCount: page.totalCount,
            currentPage: page.page,
            totalPages: page.totalPages,
          ),
        );
      },
    );
  }

  /// فلتر: الكل / غير مقروءة
  void changeUnreadFilter(bool unreadOnly) {
    if (unreadOnly == state.unreadOnly && state.data != null) return;
    getNotifications(unreadOnly: unreadOnly);
  }

  // ── load more (same shape as loadMoreInstallments) ───────────────────────
  Future<void> loadMoreNotifications() async {
    if (state.isLoadingMore || !state.hasMore) return;

    emit(state.copyWith(isLoadingMore: true));
    final int nextPage = currentPage + 1;

    final Either<Failure, NotificationsPage> result =
        await _getNotificationsUseCase.execute(
          GetNotificationsParams(
            page: nextPage,
            pageSize: pageSize,
            unreadOnly: state.unreadOnly,
          ),
        );

    result.fold(
      (Failure failure) {
        if (isClosed) return;
        emit(state.copyWith(isLoadingMore: false));
      },
      (NotificationsPage page) {
        if (isClosed) return;
        currentPage = nextPage;
        final List<NotificationModel> currentItems =
            state.data ?? <NotificationModel>[];
        emit(
          state.copyWith(
            data: <NotificationModel>[...currentItems, ...page.items],
            isLoadingMore: false,
            hasMore: page.hasNextPage,
            totalCount: page.totalCount,
            currentPage: page.page,
            totalPages: page.totalPages,
          ),
        );
      },
    );
  }

  // ── 7.2 mark one as read — optimistic + revert (mirror ContactsCubit.toggleVip) ──
  Future<void> markAsRead(String notificationId) async {
    final List<NotificationModel>? currentList = state.data;
    if (currentList == null || currentList.isEmpty) return;

    final int index = currentList.indexWhere(
      (NotificationModel n) => n.id == notificationId,
    );
    if (index == -1) return;

    final NotificationModel original = currentList[index];
    if (original.isRead) return; // already read → no API call

    final List<NotificationModel> optimisticList =
        List<NotificationModel>.from(currentList);
    optimisticList[index] = _withReadFlag(original, true);
    emit(state.copyWith(data: optimisticList));

    final Either<Failure, NotificationReadStatus> result =
        await _markNotificationReadUseCase.execute(notificationId);

    result.fold(
      (Failure failure) {
        if (isClosed) return;
        final List<NotificationModel> revertedList =
            List<NotificationModel>.from(state.data ?? optimisticList);
        final int revIndex = revertedList.indexWhere(
          (NotificationModel n) => n.id == notificationId,
        );
        if (revIndex != -1) revertedList[revIndex] = original;
        emit(
          state.copyWith(
            data: revertedList,
            flowState: ErrorState(
              StateRendererType.popupErrorStatete,
              failure.message,
              title: AppStrings.markReadFailed,
            ),
          ),
        );
      },
      (NotificationReadStatus status) {
        if (isClosed) return;
        final List<NotificationModel> confirmedList =
            List<NotificationModel>.from(state.data ?? optimisticList);
        final int confirmedIndex = confirmedList.indexWhere(
          (NotificationModel n) => n.id == notificationId,
        );
        if (confirmedIndex != -1) {
          confirmedList[confirmedIndex] = _withReadFlag(
            original,
            status.isRead,
          );
        }
        emit(state.copyWith(data: confirmedList));
      },
    );
  }

  // ── 7.3 mark all as read — popup states (action), then refresh from server ──
  Future<void> markAllAsRead() async {
    emit(
      state.copyWith(
        flowState: LoadingState(
          stateRendererType: StateRendererType.popupLoadingState,
          message: AppStrings.markAllLoading,
        ),
      ),
    );

    final Either<Failure, void> result =
        await _markAllNotificationsReadUseCase.execute(null);

    await result.fold(
      (Failure failure) async {
        if (isClosed) return;
        emit(
          state.copyWith(
            flowState: ErrorState(
              StateRendererType.popupErrorStatete,
              failure.message,
              title: AppStrings.markAllFailed,
            ),
          ),
        );
      },
      (void _) async {
        if (isClosed) return;
        await getNotifications(); // silent refresh (data != null) → sets Content/Empty → closes popup
      },
    );
  }

  NotificationModel _withReadFlag(NotificationModel n, bool isRead) {
    return NotificationModel(
      id: n.id,
      type: n.type,
      title: n.title,
      message: n.message,
      transactionId: n.transactionId,
      installmentId: n.installmentId,
      isRead: isRead,
      createdAt: n.createdAt,
    );
  }
}
```
Imports needed: `dartz`, `flutter_bloc`, `injectable`, `failure.dart`, `notification_model.dart`, the 3 use cases, `state_randrer.dart`, `state_randrer_impl.dart`, `notifications_state.dart`, `strings_manager.dart`.

### 5.3 `run_reminders_scan/` (7.4 — action → popup states, mirror `PayInstallment*`)
`run_reminders_scan_state.dart`
```dart
@freezed
abstract class RunRemindersScanState with _$RunRemindersScanState {
  const factory RunRemindersScanState({
    FlowState? flowState,
    @Default(false) bool isSuccess,
    RemindersScanResult? result,
  }) = _RunRemindersScanState;
}
```
`run_reminders_scan_cubit.dart`
```dart
@injectable
class RunRemindersScanCubit extends Cubit<RunRemindersScanState> {
  final RunRemindersScanUseCase _runRemindersScanUseCase;

  RunRemindersScanCubit(this._runRemindersScanUseCase)
    : super(RunRemindersScanState(flowState: ContentState()));

  Future<void> run() async {
    emit(
      state.copyWith(
        flowState: LoadingState(
          stateRendererType: StateRendererType.popupLoadingState,
          message: AppStrings.runRemindersLoading,
        ),
        isSuccess: false,
      ),
    );

    final Either<Failure, RemindersScanResult> result =
        await _runRemindersScanUseCase.execute(null);

    result.fold(
      (Failure failure) {
        if (isClosed) return;
        emit(
          state.copyWith(
            flowState: ErrorState(
              StateRendererType.popupErrorStatete,
              failure.message,
              title: AppStrings.runRemindersFailed,
            ),
            isSuccess: false,
          ),
        );
      },
      (RemindersScanResult scan) {
        if (isClosed) return;
        emit(
          state.copyWith(
            flowState: ContentState(),
            isSuccess: true,
            result: scan,
          ),
        );
      },
    );
  }
}
```

### 5.4 Strings — `strings_manager.dart` (new block; `grep` for name collisions first)
Every Arabic string goes here; cubits/views reference `AppStrings.*` only.
```dart
  // --- Notifications Feature ---
  static const String notificationsSubtitle = "تذكيرات الأقساط وتنبيهات العملاء";
  static const String notificationsFilterAll = "الكل";
  static const String notificationsFilterUnread = "غير مقروءة";
  static const String markAllAsRead = "تعليم الكل كمقروء";
  static const String notificationsLoading = "جاري جلب الإشعارات...";
  static const String notificationsLoadError = "تعذر تحميل الإشعارات";
  static const String notificationsEmpty = "لا توجد إشعارات حتى الآن";
  static const String notificationsUnreadEmpty = "لا توجد إشعارات غير مقروءة";
  static const String markReadFailed = "فشل تحديث حالة الإشعار";
  static const String markAllLoading = "جاري تعليم الإشعارات كمقروءة...";
  static const String markAllFailed = "تعذر تعليم الإشعارات كمقروءة";
  static const String notificationsToday = "اليوم";
  static const String notificationsYesterday = "أمس";
  static const String notificationsOlder = "أقدم";
  // reminders sheet (7.4)
  static const String runRemindersTitle = "إرسال التذكيرات الآن";
  static const String runRemindersDescription = "سيفحص النظام الأقساط المستحقة بعد 3 أيام، وبعد يوم، وفي نفس اليوم.";
  static const String runRemindersInApp = "إشعار داخل التطبيق لك";
  static const String runRemindersEmail = "إيميل تذكير للعميل (لو مسجّل له بريد إلكتروني)";
  static const String runRemindersNoEmailNote = "العميل المسجّل بالاسم فقط ولا يملك بريداً إلكترونياً لن يصله إيميل. أضف بريده من بيانات الطرف.";
  static const String runRemindersConfirm = "إرسال الآن";
  static const String runRemindersLoading = "جاري فحص الأقساط وإرسال التذكيرات...";
  static const String runRemindersFailed = "تعذر تشغيل التذكيرات";
  static const String runRemindersDone = "تم تشغيل التذكيرات";
  static const String runRemindersProcessedSuffix = "تذكير تمت معالجته";
```

---

## 6. View — `notifications_view.dart` (design comes from Figma MCP; structure/wiring below is fixed)

**Wiring (exactly like `installments_history_view.dart`):**
```dart
class NotificationsView extends StatelessWidget {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<NotificationsCubit>(
      create: (_) => getIt<NotificationsCubit>()..getNotifications(),
      child: const _NotificationsScreen(),
    );
  }
}
```
- Private `_NotificationsScreen` → `Directionality(rtl)` → `Scaffold(backgroundColor: ColorManager.background)`.
- AppBar: same pattern as the siblings (`surface`, `elevation 0`, `scrolledUnderElevation 0`, `centerTitle`, circular back with `Icons.arrow_forward_ios_rounded`, title `AppStrings.notifications` bold 16 + subtitle `AppStrings.notificationsSubtitle` regular 11). Actions: "mark all read" + "run reminders" entry.
- Body: `BlocBuilder<NotificationsCubit, NotificationsState>` with `buildWhen`; list area uses
  `state.flowState?.getScreenWidget(context, content, () => cubit.getNotifications()) ?? content`
  (this gives loading / error+retry / empty for **each filter** automatically through `FlowState`).
- List = `RefreshIndicator` → `CustomScrollView` → `SliverList.builder` (load-more via the cubit's `loadMoreNotifications()`, same trigger style as `installments_history_view.dart`).
- Header rows ("اليوم / أمس / أقدم") are computed by a **pure formatter** in `widgets/notification_formatters.dart` (precedent: `InstallmentFormatters`), not by widget logic.
- Side effects (popups for mark-all / mark-one errors) are handled by `FlowState.getScreenWidget` exactly like `pay_installment`/`contacts` — do not add `showDialog` by hand.

**Widgets folder `presentation/notifications/widgets/`** (each a `const` `StatelessWidget` class, short `build`):
| File | Purpose | Data source |
|---|---|---|
| `notifications_filter_tabs.dart` | tabs: الكل / غير مقروءة → `cubit.changeUnreadFilter(bool)` | `state.unreadOnly` |
| `notification_card.dart` | one notification: unread dot + distinct background if `!isRead`; title, message, relative time; `onTap` | `NotificationModel` |
| `notification_date_header.dart` | group header اليوم/أمس/أقدم | formatter on `createdAt` |
| `notification_formatters.dart` | pure functions (group label, relative time) | — |
| `notifications_load_more.dart` | load-more indicator/button | `state.isLoadingMore`, `state.hasMore` |

**Card behaviour (all through the Cubit):**
- Tap on an **unread** card → `context.read<NotificationsCubit>().markAsRead(item.id)`, then if `item.transactionId.isNotEmpty` → `Navigator.pushNamed(context, Routes.transactionDetailsRoute, arguments: item.transactionId).then((_) { if (context.mounted) context.read<NotificationsCubit>().getNotifications(); })` (same as `installment_timeline_card.dart`).
- Tap on a **read** card → only navigation.
- "Mark all read" button → `cubit.markAllAsRead()` (hidden by the screen when `data` is empty).
- Unknown `type` → render with the default style. **Never** add icons/colors for types the API does not define.

**Design rules (important — user requirement):** keep the exact same visual language as the rest of the app. Colors only from `ColorManager` (primary `#C57B57`, secondary `#D1A153`, background `#FCFAF7`, surface, surfaceVariant, border, `lightPrimary`/`lightSecondary`, `success*`, `error*`, `warning*`); same gradient family (`ColorManager.primaryGradient`); radii `AppRadius.r12/r14/r16`; cards like sibling cards (`surface` + `border` + the same soft shadow `AppShadows`). If a token genuinely does not exist, add a named constant to the right manager with a `/// #HEX` comment — never paste a hex in a widget. Sizes via screenutil on the 402×874 canvas (`.w/.h/.r`; `.sp` is already inside the style helpers).

**Reminders bottom sheet — `run_reminders_sheet.dart`:**
- Public entry like `showPayInstallmentSheet`: `Future<void> showRunRemindersSheet({required BuildContext context, required VoidCallback onSuccess})` → `showModalBottomSheet(isScrollControlled: true, backgroundColor: ColorManager.transparent, barrierColor: ColorManager.black.withAlpha(90), builder: BlocProvider<RunRemindersScanCubit>(create: (_) => getIt<RunRemindersScanCubit>(), ...))`.
- Content = `AppStrings.runRemindersTitle/Description`, the two bullets (in-app notification + email to client if he has an email), and the **email note** `runRemindersNoEmailNote` (a static informational banner — it does not need per-client data).
- Confirm button → `cubit.run()`. Use `BlocConsumer<RunRemindersScanCubit, RunRemindersScanState>`: `listenWhen` on `isSuccess` → show the result `"${result.remindersProcessed} ${AppStrings.runRemindersProcessedSuffix}"` and call `onSuccess` (refresh list) then close.
- **Write the new sheet as a `StatelessWidget` + small widget classes** (rule 5). Do **not** copy `pay_installment_sheet.dart`'s `StatefulWidget` + helper methods style — only its entry-point shape.
- Entry point to open it: an action in the Notifications AppBar (icon: existing `mail_plus.svg` entry in `assets_manager.dart` — check the constant name at line ~62).

---

## 7. Optional Phase 2 (build ONLY if the owner confirms — each needs a decision)

1. **Unread badge on the bell** (`home_header.dart` currently has `hasBadge: true` hardcoded). Real source: `GET /api/notifications?unreadOnly=true&pageSize=1` → read `totalCount`. Implementation = reuse `GetNotificationsUseCase` (no new endpoint) in a `@lazySingleton` cubit like `GetProfileCubit` (singleton because the header lives across screens). Refresh it on open of the screen / after mark-read / after FCM foreground message.
2. **"Client has no email" line + "Add email" button on each card.** The notification object has **no** `contactId` and **no** email flag. Without backend changes, the only real path is: tap → `GetTransactionByIdUseCase(transactionId)` → `contactId` → `GetContactByIdUseCase` → `contactEmail.isEmpty` → open `Routes.contactFormRoute` with the `Contact` (it already edits `contactEmail` via `PUT /api/contacts/{id}`). That is 2 extra calls on demand. **Do not show a per-card "no email" line until the backend adds the field** (rule: never show data the API doesn't return).

---

## 8. Backend gaps (for the dev, not for the AI)

- 7.4 scans **all** installments. A "remind this installment/this client now" button on a single notification needs a new endpoint.
- Notification item lacks `contactId`, `contactName`, `hasContactEmail`, `daysOverdue`, `amount`. Adding `contactId` + `hasContactEmail` (+ `daysOverdue`) makes the card/email-warning exact with zero extra calls.
- Page response lacks `hasNextPage` (the app derives it from `page < totalPages`).
- No "overdue / due today" filter on 7.1 (only `unreadOnly`). Those filters must not be shown in the app until the API supports them.

---

## 9. Commands (after writing files)
```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs   # app_api.g.dart, notifications_responses.g.dart, *.freezed.dart, di.config.dart
flutter analyze                                             # must be 0 issues
```
`*.g.dart`, `*.freezed.dart`, `di.config.dart` are generated — never hand-edit.

## 10. Never
- ❌ New packages / new folders outside this file / renamed existing files or typos.
- ❌ Calling `AppServiceClient`/Dio from a Cubit or widget; skipping a layer.
- ❌ Handling 401 or throwing out of the repository.
- ❌ `setState`, `BlocSelector`, `dynamic`, `print`, `Image.network`, inline `MaterialPageRoute`.
- ❌ Hardcoded Arabic / colors / sizes / asset paths in views or cubits.
- ❌ Touching `NotificationService`, Firebase config, device endpoints, auth.
- ❌ Inventing notification `type` values, filters ("متأخرة"/"مستحقة") or fields the API doesn't return.

## 11. Definition of done
- [ ] Paths/methods/params/field names match Postman exactly (7.1–7.4).
- [ ] 19 items of section 3 done in order; nothing outside the feature modified.
- [ ] `build_runner` ran; `flutter analyze` → 0.
- [ ] Filters الكل / غير مقروءة each show loading / error+retry / empty / content via `FlowState`.
- [ ] Mark-one (optimistic + revert), mark-all (popup), run-reminders (popup + result) work.
- [ ] Pull-to-refresh + load-more work; tapping a card opens transaction details and refreshes on return.
- [ ] FCM tap still opens `/notifications`.
- [ ] Final report: files created/edited, tokens added to managers (if any), anything skipped because the API doesn't provide it.
