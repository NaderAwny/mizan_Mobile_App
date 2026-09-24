---
name: mizan-feature-cycle
description: >
  The exact, repo-verified cycle for adding ONE API endpoint as a complete
  feature to the Mizan Flutter app (`NaderAwny/mizan_Mobile_App`): data layer →
  domain layer → Cubit/State → View built from a Figma node via the Figma MCP
  server, using only the design-system managers in `presentation/resources`.
  Use it whenever the user gives an endpoint (Postman collection / Apidog link)
  plus a Figma node and asks to "implement / نفّذ / اشتغل على feature".
  Follow it literally — do not improve, rename or restructure anything.
---

# Mizan Feature Cycle — one endpoint → one working screen

> **Contract.** This file was extracted from the real code of the repo, not from
> generic Clean Architecture. Every step below is something the repo already
> does. If the repo and this file disagree → **the repo wins**; if the repo and
> `flutter-expert-SKILL.md` disagree → **the repo wins** (see §2.5).
> If something is not covered → **stop and ask. Never invent.**

---

## 0. Inputs you must have before writing code

| Input | Where it comes from | If missing |
|---|---|---|
| Endpoint contract (method, path, params, body, response, errors) | The Postman collection the user attached (`*_postman_collection.json`). Parse it, print the exact request + the `200`/error examples. | Ask for it. Never guess a field. |
| Figma node URL | `https://www.figma.com/design/<fileKey>/<name>?node-id=3-1126` → node id `3:1126` | Ask. Do not design from imagination. |
| Repo | Open it and **read siblings first** (§1). | — |

Parse the collection like this (don't eyeball a 5000-line JSON):
```bash
python3 - <<'EOF'
import json
d=json.load(open('<collection>.json'))
def walk(items):
    for i in items:
        if 'item' in i: walk(i['item'])
        elif i['name'].startswith('<endpoint number e.g. 4.8>'):
            print(json.dumps(i, ensure_ascii=False, indent=1))
walk(d['item'])
EOF
```
Field names are **case-sensitive and exact**. Do not rename, do not add fields.
If a field is absent from the response example (e.g. `createdAt` missing in 4.8)
keep the model/response as-is — response fields are nullable and the mapper
falls back via `orEmpty()/orZero()/orFalse()`.

---

## 1. Read before you write (mandatory, in this order)

1. `pubspec.yaml` — package name is **`mizan`** (`package:mizan/...`). Approved stack only: `flutter_bloc, dio, retrofit, json_serializable, freezed, dartz, get_it, injectable, flutter_screenutil, flutter_svg, cached_network_image, lottie, skeletonizer`. **No new packages.**
2. `lib/data/network/app_api.dart` — where every endpoint lives.
3. The **closest existing feature** (same HTTP verb / same shape) and copy its shape file-by-file:
   - single-resource GET by id → `contact_profile` chain (`GetContactProfileUseCase`, `ContactProfileCubit`, `contact_profile_view.dart`)
   - transactions → `transaction_*` chain (create) and `get_list_transaction_*` chain (list)
4. `presentation/resources/*` — every token you are allowed to use (§5).
5. `presentation/common/state_randrer/*` — `FlowState`, `StateRendererType`, `getScreenWidget`.

**Reuse before you create.** Before adding a response/model/mapper, search
`data/response`, `domain/model`, `data/mapper` for an existing one with the same
shape. Example: endpoint 4.8 returns exactly `TransactionData` (+ `InstallmentData`),
which already exist from 4.1 → **reuse** `TransactionResponse`, `Transaction`,
`Installment`, `TransactionResponseMapper`. Do not duplicate them.

---

## 2. Architecture (layer-first — NOT feature-first)

```
lib/
├─ app/            di.dart, di.config.dart (GENERATED), extensions.dart, constants.dart
├─ data/
│  ├─ network/     app_api.dart (@RestApi AppServiceClient) ← ALL endpoints, error_handler.dart, failure.dart, network_info.dart
│  ├─ data_source/ <name>_remote_data_source.dart   (abstract + @LazySingleton Impl)
│  ├─ repository_impl/ <name>_repository_impl.dart  (@LazySingleton(as: …))
│  ├─ mapper/      <name>_mapper.dart               (extension on <X>Data? → toDomain())
│  ├─ request/     <name>_request.dart              (only for POST/PUT bodies)
│  └─ response/<name>_responses/<name>_responses.dart (+ .g.dart GENERATED)
├─ domain/
│  ├─ model/       plain Dart, non-nullable, no json
│  ├─ repository/  abstract, returns Future<Either<Failure, T>>
│  └─ use_case/    <verb>_<noun>_use_case.dart
└─ presentation/
   ├─ common/state_randrer/   FlowState + renderer
   ├─ resources/              color / font / styles / values / strings / assets / constants / routes managers
   └─ <screen>/<action_name>/<action_name>_cubit.dart + _state.dart (+ .freezed.dart GENERATED)
      <screen>/<name>_view.dart
```

One-way flow, never skip a layer:
```
View → Cubit → UseCase → Repository(abstract) → RepositoryImpl → RemoteDataSource → AppServiceClient(Retrofit) → Dio(+AuthInterceptor)
Response(@JsonSerializable) --toDomain()--> Domain Model --> Cubit state --> View
```

### 2.1 Retrofit (`app_api.dart`)
Add the method inside the matching section comment block. GET-by-id template:
```dart
  // ======================== get Transaction By Id Endpoint ========================
  @GET("/api/transactions/{id}")
  Future<TransactionResponse> getTransactionById(@Path("id") String id);
```
- Return type is always a `*Response` class. Never `dynamic`/`Map`.
- Query params → `@Query("page") int page`; path params → `@Path("id")`; POST/PUT bodies → `@Body() Map<String, dynamic>` (or `@Field`, as the sibling does).
- `204 No Content` → `Future<void>`.
- Static paths (`/vip`) must be declared **before** `/{id}`.

### 2.2 Data source (`data/data_source/`)
Add the method to the **abstract class and the Impl**; the Impl only delegates:
```dart
Future<TransactionResponse> getTransactionById(String id);          // abstract
@override
Future<TransactionResponse> getTransactionById(String id) {         // impl
  return _appServiceClient.getTransactionById(id);
}
```
Same-resource endpoints extend the existing data-source/repository pair
(precedent: `getContactById` lives in `ContactRepository`). A brand-new resource
gets its own pair, named like `get_list_transaction_*`.

### 2.3 Repository contract + impl
Contract (`domain/repository/`):
```dart
Future<Either<Failure, Transaction>> getTransactionById(String id);
```
Impl — **copy this exact shape** (this is what every `*_repository_impl.dart` in the repo does; there is no `_guard` helper in the real code):
```dart
@override
Future<Either<Failure, Transaction>> getTransactionById(String id) async {
  if (await _networkInfo.isConnected) {
    try {
      final response = await _remote.getTransactionById(id);
      if (response.success == true) {
        return Right(response.data.toDomain());
      } else {
        return Left(Failure(
          ApiInternalStatus.FAILURE,
          response.message ?? ResponseMessage.DEAFULT,
        ));
      }
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  } else {
    return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
  }
}
```
Exceptions never leave the repository. `401` / refresh is handled globally by
`AuthInterceptor` — never handle it in a feature. `404` etc. arrive as `Failure`
with the server's Arabic message via `ErrorHandler`.

### 2.4 Use case (`domain/use_case/<verb>_<noun>_use_case.dart`)
Single-id input → mirror `GetContactProfileUseCase`:
```dart
@injectable
class GetTransactionByIdUseCase extends BaseUsecase<String, Transaction> {
  final TransactionRepository _repository;
  GetTransactionByIdUseCase(this._repository);

  @override
  Future<Either<Failure, Transaction>> execute(String input) =>
      _repository.getTransactionById(input);
}
```
Multi-param input → a `<Verb><Noun>Params` class in the same file (see `GetListTransactionsUseCase`).

### 2.5 Known differences between the docs and the real code (repo wins)
| Topic | `flutter-expert-SKILL.md` says | Real code does |
|---|---|---|
| Repository error handling | `_guard()` helper | inline `if (await _networkInfo.isConnected) { try … }` |
| Use case input class | `<Verb><Noun>Input` | `…Params` (list) / plain `String` (by id) |
| Use-case annotation | `@injectable` | `@injectable` (contacts, by-id) or `@lazySingleton` (list) — copy the sibling |
| Retrofit bodies | `@Body() Map` for all new | contacts use `@Field`, transactions use `@Body() Map` — copy the sibling |
Keep the existing typos (`state_randrer`, `popupErrorStatete`, `get_list_ transaction_repository.dart`, `DEAFULT`). They are public API.

---

## 3. Presentation layer

### 3.1 State (Freezed — always `flowState` + `data`)
`presentation/<screen>/<action_name>/<action_name>_state.dart`
```dart
part 'get_transaction_by_id_state.freezed.dart';

@freezed
abstract class GetTransactionByIdState with _$GetTransactionByIdState {
  const factory GetTransactionByIdState({
    FlowState? flowState,
    Transaction? data,
  }) = _GetTransactionByIdState;
}
```

### 3.2 Cubit
```dart
@injectable
class GetTransactionByIdCubit extends Cubit<GetTransactionByIdState> {
  final GetTransactionByIdUseCase _getTransactionByIdUseCase;
  GetTransactionByIdCubit(this._getTransactionByIdUseCase)
      : super(const GetTransactionByIdState());

  Future<void> getTransactionById(String id) async {
    emit(state.copyWith(flowState: LoadingState(
      stateRendererType: StateRendererType.fullScreenLoadingState,
      title: AppStrings.loading,
      message: "جاري جلب تفاصيل العملية...",
    )));

    final result = await _getTransactionByIdUseCase.execute(id);

    result.fold(
      (failure) {
        if (isClosed) return;                                   // ← before EVERY emit in a fold
        emit(state.copyWith(flowState: ErrorState(
          StateRendererType.fullScreenErrorState,
          failure.message,
          title: "تعذر تحميل تفاصيل العملية",
        )));
      },
      (transaction) {
        if (isClosed) return;
        emit(state.copyWith(data: transaction, flowState: ContentState()));
      },
    );
  }
}
```
Rules: first load / detail screen → **full-screen** loading/error; forms & actions
(delete, toggle) → **popup** states; lists → `EmptyState(...)` when empty.
Loading/error `title` + `message` are Arabic and written for the end user.

### 3.3 View (mirror `contact_profile_view.dart`)
- File: `presentation/<screen>/<name>_view.dart`; public `StatelessWidget` that owns the `BlocProvider`, then a private `_…Screen` widget.
```dart
create: (_) => getIt<GetTransactionByIdCubit>()..getTransactionById(transactionId),
```
- Body wiring (exactly this pattern):
```dart
state.flowState?.getScreenWidget(context, content, () => cubit.getX(id)) ?? content
```
- AppBar: `backgroundColor: ColorManager.surface`, `elevation: 0`, `scrolledUnderElevation: 0`, `centerTitle: true`, circular back button with `Icons.arrow_forward_ios_rounded` (RTL), title = bold 16 + subtitle regular 11.
- Scaffold background `ColorManager.background`. All UI text Arabic, RTL.
- Cards: `ColorManager.surface`, `AppRadius.r14/r16`, `border: ColorManager.border`, same soft shadow the sibling cards use.
- Money: `"$amountPrefix${amount} ${AppConstants.defaultCurrency}"` with `textDirection: TextDirection.ltr`. Sale → `ColorManager.success` / `successContainer` + `IconAssets.arrowDownLeft`; Purchase → `ColorManager.error` / `errorContainer` + `IconAssets.arrowUpRight`.
- Navigation only through `Routes` + `RouteGenerator`; never inline `MaterialPageRoute`.
- Business logic **never** in the widget (formatting helpers are OK, decisions/state are not).
- File header comment, exactly like the siblings:
```dart
// ─────────────────────────────────────────────────────────────
// TransactionDetailsView — Mizan design system & Figma Node #3:1126 compliant
// ─────────────────────────────────────────────────────────────
```
and a `// (Figma Node #3:1126)` comment above each major block.

### 3.4 Strings + routes
- Every Arabic string → `AppStrings` (new block with a `// --- <Feature> ---` comment). Check for name collisions first (`grep`).
- Route: `static const String transactionDetailsRoute = "/transactionDetails";` in `Routes`, then a `case` in `RouteGenerator.getRoute` reading `settings.arguments is String ? … : ""`, plus the import.
- Wire the entry points that should open the screen — replace the existing empty `onTap: () {}` on the list card (`transactions_view.dart → _TransactionCardItem`) and on the contact-profile tile (`contact_profile_view.dart → ContactTransactionTile`) with `Navigator.pushNamed(context, Routes.…, arguments: tx.id)`.

---

## 4. Figma → Code (via the Figma MCP server)

Never write UI before completing all of these:
1. Extract the node id from the URL (`node-id=3-1126` → `3:1126`) and pass it explicitly. Never render the whole file.
2. Call, in order: `get_design_context` (or `get_code`) → `get_variable_defs` → `get_screenshot`/`get_image` → `get_metadata` for child nodes.
3. **Map every value to an existing token** (§5). Only when a token genuinely does not exist: add a named constant to the right manager with a `/// #HEX` doc comment, then use it. Never paste a hex, a magic padding or a font size into a widget.
4. Convert px against the **402 × 874** canvas: widths `.w`, heights `.h`, radii/icons/squares `.r`. `.sp` is already applied inside `getBoldStyle()` & friends — don't add it again.
5. Export missing icons as SVG into `assets/icons`, register in `IconAssets`, reference by constant. Remote images → `CachedNetworkImage`.
6. Text in the design → `AppStrings`. Data in the design → **only what the API returns** (e.g. rows for `type`, `paymentMethod`, `transactionDate`, `contactName`, `amount`, `installments[]`). If the design shows something the API does not provide, do **not** fake it — leave it out and report it.
7. Compare your result with the screenshot. If the MCP server is unavailable or the node can't be read → **say so and ask**; do not approximate.

---

## 5. Design-system managers (single source of truth)

| Need | Use | File |
|---|---|---|
| Colors | `ColorManager.primary #C57B57 · secondary #D1A153 · background #FCFAF7 · surface #FFF · surfaceVariant #F6F2EB · border #EBE6DF · divider · textPrimary #1C1816 · textSecondary #6C6360 · textTertiary #9C938E · success #2D5C43 / successContainer · error #9B3A2C / errorContainer · warning / warningContainer · lightPrimary · lightSecondary` | `resources/color_manager.dart` |
| Text | `getBoldStyle / getSemiBoldStyle / getMediumStyle / getRegularStyle / getLightStyle(color:, fontSize: FontSize.sXX, height:)` | `resources/styles_manager.dart`, `font_manager.dart` |
| Spacing / radius | `AppPadding.pX`, `AppMargin.mX`, `AppSize.sX`, `AppRadius.rX` (`r4 r6 r8 r10 r12 r14 r16 r18 r20 r24 …`) | `resources/values_manager.dart` |
| Strings | `AppStrings.*` | `resources/strings_manager.dart` |
| Assets | `IconAssets.*`, `ImageAssets.*`, `JsonAssets.*` | `resources/assets_manager.dart` |
| Constants | `AppConstants.defaultCurrency ("EGP")`, `designSize` | `resources/constants_manager.dart` |
| Navigation | `Routes.*`, `RouteGenerator` | `resources/routes_manager.dart` |

Fonts: Cairo (Arabic) + Montserrat (Latin). Icons: `SvgPicture.asset(IconAssets.x, width: 20.r, height: 20.r, colorFilter: ColorFilter.mode(color, BlendMode.srcIn))`.

---

## 6. Execution order (do it in exactly this order)

1. Print back, in ≤ 5 lines: the endpoint contract you parsed + which existing files you will reuse. List anything unclear. (Ask instead of guessing.)
2. **Data:** (response/model/mapper — only if new) → `app_api.dart` → data source (abstract + impl).
3. **Domain:** repository contract → repository impl → use case.
4. **Presentation:** state → cubit → strings → route → view (after the Figma MCP read, §4) → wire `onTap` entry points.
5. Run:
   ```bash
   flutter pub get
   flutter pub run build_runner build --delete-conflicting-outputs   # regenerates app_api.g.dart, *.freezed.dart, di.config.dart
   flutter analyze
   ```
   Fix every error. `di.config.dart`, `*.g.dart`, `*.freezed.dart` are generated — never hand-edit them.
6. Final report: files created, files edited, endpoint covered, tokens added to managers (if any), design elements skipped because the API doesn't provide them, and the `flutter analyze` output.

---

## 7. 🚫 Never

- ❌ Move to a `features/` structure or restructure anything.
- ❌ Call `AppServiceClient`/Dio from a Cubit or widget; skip a layer.
- ❌ Invent an endpoint, field, package, color, size, string or asset.
- ❌ Hardcode colors / sizes / font sizes / asset paths / Arabic strings in a widget.
- ❌ Return `Response` objects, `Map` or `dynamic` from the domain layer.
- ❌ Throw out of a repository; handle 401 manually.
- ❌ Manual `copyWith`/state classes (Freezed only); emit after close.
- ❌ `Image.network` (use `CachedNetworkImage`), inline `Navigator.push(MaterialPageRoute…)`.
- ❌ Store tokens in SharedPreferences.
- ❌ English user-facing text.
- ❌ Rename existing classes/files (even typos) or "fix" sibling code you were not asked to touch.
- ❌ Duplicate a response/model/mapper that already exists.

## 8. Definition of done ✅
- [ ] Endpoint path, method, params and field names match the Postman collection exactly
- [ ] Every layer touched in the order of §6, nothing skipped
- [ ] `build_runner` ran; `flutter analyze` → 0 errors
- [ ] Every color/size/string/asset comes from a manager
- [ ] Loading / error / content (and empty, if a list) handled via `FlowState`
- [ ] View matches the Figma node (screenshot compared) and shows only API-backed data
- [ ] Entry points navigate to the new route; back-navigation works
- [ ] Nothing outside the feature was modified

---

## 9. Worked example — Feature 4.8 `GET /api/transactions/{id}`

Contract (from the collection): `GET {{base_url}}/api/transactions/{{transaction_id}}`, Bearer token (auto-attached), `200`:
```json
{ "success": true, "message": null,
  "data": { "id": "…", "contactId": "…", "contactName": "…", "type": "Sale",
            "amount": 500, "paymentMethod": "Cash",
            "transactionDate": "2026-08-19T10:00:00Z",
            "isInstallment": false, "installments": [] } }
```
Installment item: `{ id, installmentNumber, amount, dueDate, isPaid, status }` — `status` values seen: `Pending`, `Paid`.
`type`: `"Sale" | "Purchase"` (string). `paymentMethod`: `"Cash"` or the installment variant.

| Step | File | Action |
|---|---|---|
| Response / model / mapper | `transaction_responses.dart`, `transaction_model.dart`, `transaction_mapper.dart` | **Reuse** — no change |
| Retrofit | `data/network/app_api.dart` | + `getTransactionById(@Path("id"))` |
| Data source | `data/data_source/transaction_remote_data_source.dart` | + method (abstract + impl) |
| Repository | `domain/repository/transaction_repository.dart` + `data/repository_impl/transaction_repository_impl.dart` | + `getTransactionById` |
| Use case | `domain/use_case/get_transaction_by_id_use_case.dart` | new (`BaseUsecase<String, Transaction>`) |
| State/Cubit | `presentation/transactions/get_transaction_by_id/get_transaction_by_id_{state,cubit}.dart` | new |
| View | `presentation/transactions/transaction_details_view.dart` | new (Figma node `3:1126`) |
| Strings / Route | `strings_manager.dart`, `routes_manager.dart` | + `transactionDetailsRoute`, args = `String id` |
| Entry points | `transactions_view.dart`, `contact_profile_view.dart` | `onTap: () {}` → `pushNamed(transactionDetailsRoute, arguments: id)` |
