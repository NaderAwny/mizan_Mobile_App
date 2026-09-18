---
name: mizan-flutter-expert
description: >
  Nader's personal Flutter expertise skill — extracted directly from the real
  production codebases `mizan_Mobile_App` and `Glowy`. It captures the exact
  architecture, folder structure, naming, networking stack, error handling,
  state management, design-system managers and Figma→Code workflow used in
  those projects. USE THIS SKILL ALWAYS on any Flutter/Dart task for Mizan:
  new feature, new screen, new endpoint integration, code review, refactor,
  bug fix, or design implementation.
  Trigger on: "flutter", "dart", "mizan", "cubit", "بلوك", "feature",
  "screen", "endpoint", "retrofit", "repository", "usecase", "figma",
  "design", "pubspec", or any request to scaffold / generate / review code.
---

# Mizan Flutter Expert Skill (Nader's Standards)

> **Contract:** Every line of code you produce must match the patterns in this
> document. This is **not** generic Clean Architecture. Do **not** import
> patterns from other tutorials, other repos, or other skills.
> If something is not written here and not present in the repo — **ask, don't invent.**

---

## 0. Anti-Hallucination Rules (read first, every time)

| # | Rule |
|---|---|
| 1 | **Never invent an endpoint.** Only use endpoints listed in §11 (Mizan API Reference) or given by the user from the Postman collection. |
| 2 | **Never invent a JSON field.** Field names are case-sensitive and come from the API contract exactly as documented (`isVip`, `contactEmail`, `phoneNumber`, `totalCount`, `pageSize`, `totalPages`). |
| 3 | **Never invent a package.** The allowed dependency list is §2. If a task needs a new package, stop and ask. |
| 4 | **Never invent a color, size, string or asset.** Use `ColorManager`, `AppSize/AppPadding/AppMargin`, `AppStrings`, `ImageAssets/IconAssets/JsonAssets`. If a token is missing → **add it to the manager first**, then use it. |
| 5 | **Never skip a layer.** `View → Cubit → UseCase → Repository → RemoteDataSource → AppServiceClient`. No shortcuts, ever. |
| 6 | **Never rename existing classes** (even the ones with typos like `state_randrer`, `AuthSessionMappr`, `funcation.dart`, `popupErrorStatete`). They are the project's public API. Keep them. |
| 7 | Before writing a file, **read the sibling file of the same type** in the repo (e.g. before `contact_repository_impl.dart`, read `auth_repository_impl.dart`) and copy its shape. |
| 8 | After any change to models / responses / injectables / retrofit → **must** run: `flutter pub run build_runner build --delete-conflicting-outputs`. |
| 9 | Output must compile. No `TODO` stubs in the middle of a flow, no pseudo-code, no `dynamic`. |
| 10 | If you are unsure about a response shape → say so explicitly and ask for the Postman example. Do **not** guess. |

---

## 1. Project Identity

| Item | Value |
|---|---|
| App | **ميزان / Mizan** — smart accounting ledger for shop owners |
| Language of UI | **Arabic (RTL)** — all user-facing text is Arabic |
| Backend | .NET 9 REST API, Clean Architecture |
| Base URL | `https://mizanapi.duckdns.org` (in `Constants.baseUrl`) |
| Dart SDK | `^3.12.2` |
| Design canvas | **402 × 874** (iPhone 16 / 15 Pro) via `flutter_screenutil` |
| Fonts | **Cairo** (primary, Arabic) + **Montserrat** (Latin/numbers) |
| Sister repo w/ same architecture | `Glowy` — use it as reference for list/pagination/grid patterns |

---

## 2. Approved Stack (do not add anything else without asking)

**Runtime**
```
flutter_bloc ^9.1.1 · bloc ^9.2.1        → state management (Cubit-first)
dio ^5.9.1 · retrofit ^4.9.2             → networking (code-gen client)
json_annotation ^4.11.0                  → response serialization
freezed_annotation ^3.1.0                → Cubit states only
dartz ^0.10.1                            → Either<Failure, T>
get_it ^9.2.0 · injectable ^3.0.0        → DI
flutter_secure_storage ^11.1.1           → tokens (NEVER SharedPreferences)
shared_preferences ^2.5.5                → onboarding flags / non-sensitive prefs
hive_flutter ^1.1.0                      → structured local cache
internet_connection_checker ^3.0.1       → NetworkInfo
flutter_screenutil ^5.9.3                → responsive sizing (.w .h .r .sp)
flutter_svg ^2.0.17                      → all icons/illustrations
cached_network_image ^3.4.1              → all remote images
lottie ^3.3.2                            → state renderer animations
skeletonizer ^3.0.0                      → list loading shimmer
pretty_dio_logger ^1.4.0                 → debug logging
```

**Dev**
```
build_runner · freezed · json_serializable · injectable_generator · retrofit_generator
```

---

## 3. Architecture — Layer-First Clean/MVVM

> ⚠️ Mizan is organized **by layer, then by name** — *not* feature-first.
> Do not restructure into `features/` folders.

```
lib/
├── app/
│   ├── app.dart                  # MyApp singleton + ScreenUtilInit + MaterialApp
│   ├── app_module.dart           # @module — Dio, SecureStorage, AppServiceClient…
│   ├── constants.dart            # Constants.baseUrl, apiTimeOut, empty, zero…
│   ├── di.dart                   # getIt + configureDependencies()
│   ├── extensions.dart           # orEmpty() / orZero() / orFalse()
│   ├── funcation.dart            # shared helper functions
│   └── session_manager.dart      # broadcast stream → force logout on 401
│
├── data/
│   ├── data_source/              # <name>_remote_data_source.dart (abstract + Impl)
│   ├── local/                    # token / onboarding local data sources
│   ├── mapper/                   # <name>_mapper.dart — Response → Domain Model
│   ├── network/
│   │   ├── app_api.dart          # @RestApi AppServiceClient (ALL endpoints)
│   │   ├── auth_interceptor.dart # attaches Bearer + refresh-token retry
│   │   ├── dio_client.dart       # DioFactory (@lazySingleton)
│   │   ├── error_handler.dart    # ErrorHandler / DataSource / ResponseCode
│   │   ├── failure.dart          # Failure(code, message)
│   │   └── network_info.dart
│   ├── repository_impl/          # <name>_repository_impl.dart
│   ├── request/                  # plain request DTOs (optional)
│   └── response/<name>_responses/ # @JsonSerializable, extends BaseResponse
│
├── domain/
│   ├── model/                    # plain Dart models (non-nullable, no json)
│   ├── repository/               # abstract contracts returning Either
│   └── use_case/                 # BaseUsecase<In, Out> — one class per action
│
└── presentation/
    ├── common/state_randrer/     # StateRandrer + FlowState (shared UI states)
    ├── resources/                # color / font / styles / values / strings /
    │                             # assets / icons / constants / routes / theme managers
    └── <screen_name>/
        ├── <screen_name>_view.dart
        ├── widgets/              # screen-specific widgets
        └── <action>_cubit/
            ├── <action>_cubit.dart
            └── <action>_state.dart   (Freezed)
```

### Data flow (one direction, no skipping)

```
View (StatelessWidget + BlocProvider)
  └─ Cubit (@injectable)            → emits FlowState + data
       └─ UseCase (@injectable)     → BaseUsecase<Input, Output>.execute()
            └─ Repository (abstract, domain)
                 └─ RepositoryImpl (@LazySingleton(as:)) → _guard() + NetworkInfo
                      └─ RemoteDataSource (abstract + Impl)
                           └─ AppServiceClient (@RestApi, retrofit)
                                └─ Dio (+ AuthInterceptor)

Response (@JsonSerializable)  --toDomain()-->  Domain Model  -->  Cubit state
```

### Layer rules
- **domain/** → pure Dart. No Flutter, no Dio, no json. (Exception kept from repo: it imports `Failure` from `data/network/failure.dart` — keep that import style, don't "fix" it.)
- **data/** → owns serialization, mapping, caching, HTTP.
- **presentation/** → UI + Cubit only. **Zero** business logic in widgets.

---

## 4. Naming Conventions (as used in the repo)

| Thing | Pattern | Example |
|---|---|---|
| Files | `snake_case` | `contact_remote_data_source.dart` |
| Classes | `PascalCase` | `ContactRepositoryImpl` |
| Abstract + impl | `X` / `XImpl` | `ContactRemoteDataSource` / `ContactRemoteDataSourceImpl` |
| Retrofit client | single class | `AppServiceClient` |
| Response envelope | `<Name>Response` extends `BaseResponse` | `ContactsListResponse` |
| Response payload | `<Name>Data` | `ContactData` |
| Domain model | plain noun | `Contact`, `AuthSession` |
| Mapper | extension on `<Name>Data` | `extension ContactResponseMapper on ContactData` |
| UseCase | `<Verb><Noun>UseCase` + `<Verb><Noun>Input` | `CreateContactUseCase`, `CreateContactInput` |
| Cubit / State | `<Action>Cubit` / `<Action>State` | `ContactsCubit` / `ContactsState` |
| View | `<Name>View` | `CustomersView` |
| Private members | `_` prefix | `_repository`, `_usecase` |
| Route constants | camelCase + `Route` | `Routes.customersRoute = "/customers"` |

---

## 5. Networking

### 5.1 Retrofit client — one file for everything
`lib/data/network/app_api.dart`

```dart
@RestApi(baseUrl: Constants.baseUrl)
abstract class AppServiceClient {
  factory AppServiceClient(Dio dio, {String baseUrl}) = _AppServiceClient;

  // Legacy style kept for register/send-otp — @Field
  @POST("/api/auth/register")
  Future<RegisterDataResponse> register(
    @Field('email') String email,
    @Field('firstName') String firstName,
    @Field('lastName') String lastName,
  );

  // ✅ Default style for ALL new endpoints — @Body() Map<String, dynamic>
  @POST("/api/auth/verify-otp")
  Future<AuthSessionResponse> verifyOtp(@Body() Map<String, dynamic> body);

  // Query params
  @GET("/api/contacts")
  Future<ContactsListResponse> getContacts(
    @Query("page") int page,
    @Query("pageSize") int pageSize,
    @Query("search") String? search,
  );

  // Path params
  @GET("/api/contacts/{id}")
  Future<ContactResponse> getContactById(@Path("id") String id);
}
```

**Rules**
- Every new endpoint is added to `AppServiceClient` — never a raw `dio.get(...)` in a data source.
- New endpoints use `@Body() Map<String, dynamic>` (matches `verifyOtp` / `selectUserType`).
- Return type is always a `*Response` class, never `dynamic` / `Map`.
- `@DELETE` returning `204 No Content` → return `Future<void>`.

### 5.2 The API envelope
Every Mizan response looks like:
```json
{ "success": true, "message": "…", "data": { … } }
```
Errors look like:
```json
{ "statusCode": 400, "message": "…" }
```
So: `BaseResponse { bool? success; String? message; }` and every response extends it and adds `data`.

### 5.3 Auth & token refresh (already implemented — don't touch)
- `DioFactory` builds two Dio instances: `dio` (with `AuthInterceptor`) and `authDio` (clean, used for refresh + retry → avoids interceptor loops).
- `AuthInterceptor.onRequest` attaches `Authorization: Bearer <accessToken>` from `TokenLocalDataSource`.
- On `401`: refreshes via `POST /api/auth/refresh-token`, saves the new session, **retries the original request with the new token**, and queues concurrent requests via `Completer`.
- If refresh fails → `tokenLocalDataSource.clear()` + `sessionManager.notifySessionExpired()` → `MyApp` listens and pushes `Routes.sendOtpRoute`.
- **Consequence for new features: never handle 401 manually in a Cubit or repository.**

---

## 6. Error Handling — `Either<Failure, T>`

### 6.1 Repository pattern (copy this exactly)
```dart
@LazySingleton(as: ContactRepository)
class ContactRepositoryImpl implements ContactRepository {
  final ContactRemoteDataSource _remote;
  final NetworkInfo _networkInfo;

  ContactRepositoryImpl(this._remote, this._networkInfo);

  Future<Either<Failure, T>> _guard<T>(Future<T> Function() call) async {
    if (!await _networkInfo.isConnected) {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
    try {
      return Right(await call());
    } catch (error) {
      return Left(ErrorHandler.handle(error).failure);
    }
  }

  @override
  Future<Either<Failure, Contact>> createContact({...}) => _guard(() async {
        final r = await _remote.createContact({...});
        if (r.success != true) {
          throw Exception(r.message ?? ResponseMessage.DEAFULT);
        }
        return r.data!.toDomain();
      });
}
```

**Non-negotiables**
- Always `_guard`. Always check `success != true` → `throw Exception(r.message)`.
- `ErrorHandler` already extracts the server's Arabic message (`message`, `errors{}`, `detail`, `msg`) and falls back to a friendly Arabic message per status code — **so never write your own English error strings.**
- Exceptions never cross the repository boundary. The Cubit only sees `Failure(code, message)`.

---

## 7. State Management — Cubit + Freezed + FlowState

### 7.1 State (always Freezed, always `flowState` + `data`)
```dart
part 'contacts_state.freezed.dart';

@freezed
abstract class ContactsState with _$ContactsState {
  const factory ContactsState({
    FlowState? flowState,
    List<Contact>? data,
    @Default(false) bool isLoadingMore,
    @Default(true) bool hasMore,
  }) = _ContactsState;
}
```

### 7.2 Cubit
```dart
@injectable
class ContactsCubit extends Cubit<ContactsState> {
  final GetContactsUseCase _usecase;
  ContactsCubit(this._usecase) : super(const ContactsState());

  int currentPage = 1;
  final int pageSize = 20;

  Future<void> getContacts({String? search}) async {
    currentPage = 1;
    emit(state.copyWith(
      flowState: LoadingState(
        stateRendererType: StateRendererType.fullScreenLoadingState,
        title: "جاري التحميل",
        message: "جاري جلب قائمة العملاء...",
      ),
      hasMore: true,
    ));

    final result = await _usecase.execute(
      GetContactsInput(page: currentPage, pageSize: pageSize, search: search),
    );

    result.fold(
      (failure) {
        if (isClosed) return;
        emit(state.copyWith(
          flowState: ErrorState(
            StateRendererType.fullScreenErrorState,
            failure.message,
            title: "تعذر تحميل العملاء",
          ),
        ));
      },
      (page) {
        if (isClosed) return;
        emit(state.copyWith(
          data: page.items,
          flowState: page.items.isEmpty
              ? EmptyState("لا يوجد عملاء حتى الآن")
              : ContentState(),
          hasMore: currentPage < page.totalPages,
        ));
      },
    );
  }
}
```

**Rules**
- `@injectable` on every Cubit, resolved via `getIt<XCubit>()` inside `BlocProvider`.
- `if (isClosed) return;` before **every** emit inside a `fold`.
- Loading/error `title` + `message` are **Arabic**, written for the end user.
- Popup vs full-screen: **forms/actions → popup** (`popupLoadingState` / `popupErrorStatete`); **list/first load → full screen** (`fullScreenLoadingState` / `fullScreenErrorState`); **empty list → `EmptyState`**.

### 7.3 FlowState types available
`LoadingState` · `ErrorState` · `SuccessState` · `ContentState` · `EmptyState`
→ rendered by `StateRendererType`: `popupLoadingState`, `popupErrorStatete` *(keep the typo)*, `fullScreenLoadingState`, `fullScreenErrorState`, `fullScreenEmptyState`, `successScreenState`, `contentScreenState`.

### 7.4 View wiring
```dart
class ContactsView extends StatelessWidget {
  const ContactsView({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider<ContactsCubit>(
        create: (_) => getIt<ContactsCubit>()..getContacts(),
        child: const _ContactsScreen(),
      );
}

// inside _ContactsScreen:
BlocConsumer<ContactsCubit, ContactsState>(
  listenWhen: (p, c) => c.actionSuccess && !p.actionSuccess,
  listener: (ctx, state) { /* dismiss dialog → navigate / refresh */ },
  builder: (ctx, state) =>
      state.flowState?.getScreenWidget(
        ctx,
        _content(ctx, state),
        () => ctx.read<ContactsCubit>().getContacts(),
      ) ??
      _content(ctx, state),
)
```
- Navigation **never** happens inside `builder` — only inside `listener`, wrapped in `WidgetsBinding.instance.addPostFrameCallback`.
- Before navigating after a popup: `Navigator.of(ctx, rootNavigator: true).popUntil((r) => r is! PopupRoute);`

### 7.5 Pagination (pattern from `Glowy`)
- Cubit holds `int currentPage` + `final int pageSize`.
- `loadMore()` guards with `if (state.isLoadingMore || !state.hasMore) return;`
- Merge: `[...?state.data, ...newPage.items]`, then `currentPage = nextPage`.
- A `loadMore` failure only resets `isLoadingMore` — it must **never** blow up the whole screen.
- `hasMore = currentPage < totalPages`.

---

## 8. Dependency Injection

```dart
// app/di.dart
final getIt = GetIt.instance;

@InjectableInit(initializerName: 'init', preferRelativeImports: true, asExtension: true)
Future<void> configureDependencies() async {
  final prefs = await SharedPreferences.getInstance(); // async → manual first
  getIt.registerLazySingleton<SharedPreferences>(() => prefs);
  getIt.init();
}
```

| Type | Annotation |
|---|---|
| Cubit | `@injectable` |
| UseCase | `@injectable` |
| RepositoryImpl | `@LazySingleton(as: XRepository)` |
| RemoteDataSourceImpl | `@LazySingleton(as: XRemoteDataSource)` |
| LocalDataSourceImpl | `@LazySingleton(as: XLocalDataSource)` |
| External (Dio, SecureStorage, AppServiceClient, InternetConnectionChecker) | `@module abstract class AppModule` |

➡️ After adding any of these: `flutter pub run build_runner build --delete-conflicting-outputs`

---

## 9. UI & Design System

### 9.1 The managers (single source of truth)
| Manager | File | Use |
|---|---|---|
| `ColorManager` | `resources/color_manager.dart` | every color |
| `AppStrings` | `resources/strings_manager.dart` | every Arabic string |
| `FontSize` / `FontWeightManager` / `FontConstants` | `resources/font_manager.dart` | typography atoms |
| `getBoldStyle()` `getSemiBoldStyle()` `getMediumStyle()` `getRegularStyle()` `getLightStyle()` | `resources/styles_manager.dart` | every `TextStyle` |
| `AppPadding` / `AppMargin` / `AppSize` | `resources/values_manager.dart` | every spacing & radius |
| `ImageAssets` / `IconAssets` / `JsonAssets` | `resources/assets_manager.dart` | every asset path |
| `AppConstants` | `resources/constants_manager.dart` | design size, currency `EGP`, `+20`, delays |
| `Routes` / `RouteGenerator` | `resources/routes_manager.dart` | navigation |
| `getApplicationTheme()` / `getDarkApplicationTheme()` | `resources/them_manager.dart` | ThemeData |

### 9.2 Brand tokens (already defined — reuse, don't redefine)
```
primary        #C57B57  (terracotta)   darkPrimary  #A8623B   lightPrimary   #FAF0EC
secondary      #D1A153  (warm gold)    brandGreen   #1C4A38
background     #FCFAF7   surface #FFFFFF   surfaceVariant #F6F2EB   surfaceMuted #F0EAE1
border #EBE6DF · borderDark #E5DCD0 · divider #EBE6DF
textPrimary #1C1816 · textSecondary #6C6360 · textTertiary #9C938E · textSubtle #7D6E65
success #2D5C43 / successContainer #EBF3EC · error #9B3A2C / errorContainer #F7ECE9
```

### 9.3 Sizing
- `ScreenUtilInit(designSize: AppConstants.designSize /* 402×874 */)`.
- Widths `.w`, heights `.h`, radii/icons/squares `.r`, font sizes `.sp` (already applied inside `styles_manager`, so **don't** add `.sp` again on top of `getBoldStyle`).

### 9.4 Widget rules
- Screen = `StatelessWidget` wrapper (`BlocProvider`) + private `_Screen` widget holding controllers/animations.
- Icons → `SvgPicture.asset(IconAssets.x, width: 20.r, height: 20.r, colorFilter: ColorFilter.mode(ColorManager.textPrimary, BlendMode.srcIn))`.
- Remote images → `CachedNetworkImage` (never `Image.network`).
- List loading → `skeletonizer`; empty → `EmptyState` via the state renderer.
- RTL: back arrow is `Icons.arrow_forward_ios_rounded`, `centerTitle: true`, AppBar `elevation: 0` + `scrolledUnderElevation: 0`, `backgroundColor: ColorManager.surface`, body background `ColorManager.background`.
- `const` constructors everywhere possible; `mounted` check after every `await` that touches `BuildContext`.
- Reusable across screens → `presentation/common/`; used by one screen → that screen's `widgets/`.

---

## 10. Figma → Code Workflow (MCP)

When the user sends a **Figma link** (`.../design/<fileKey>/<name>?node-id=<id>`), work like this:

1. **Read before writing.** Call the Figma MCP server tools on that node — typically:
   - `get_code` / `get_design_context` → structure & layout of the node
   - `get_variable_defs` → colors, spacings, radii, text styles as design variables
   - `get_image` / `get_screenshot` → visual reference to verify the result
   - `get_metadata` → node tree + child node-ids when you need to drill into sub-components
2. **Extract the node-id** from the URL (`node-id=3-1001` → `3:1001`) and always pass it explicitly. Never render the whole file.
3. **Map, don't copy.** Figma raw values → nearest existing token in `ColorManager` / `AppSize` / `FontSize`. Only if it genuinely doesn't exist: add a new named token to the manager (with a `/// #HEX` doc comment, like the existing ones) and then use it.
4. **Never** paste hex codes, magic paddings, or hardcoded font sizes into a widget.
5. Convert Figma px → `.w/.h/.r/.sp` against the **402×874** canvas.
6. Export icons/illustrations as **SVG** into `assets/icons` or `assets/images`, register them in `IconAssets`/`ImageAssets`, then reference by constant.
7. Add a comment header on the screen file referencing the node, exactly like the existing code:
   ```dart
   // ─────────────────────────────────────────────────────────────
   // ContactsView — Mizan design system & Figma Node #3:1001 compliant
   // ─────────────────────────────────────────────────────────────
   ```
8. All text pulled from the design must be moved into `AppStrings` — never inline.
9. If the Figma MCP server is unavailable or the node can't be read → **say so and ask**, don't approximate a design from imagination.

---

## 11. Mizan API Reference

**Base URL:** `https://mizanapi.duckdns.org`
**Auth:** `Authorization: Bearer {{access_token}}` on everything except `auth/*`.
**Envelope:** `{ success, message, data }` · **Errors:** `{ statusCode, message }` (Arabic messages).

### 11.1 Auth flow
`register` → OTP mail → `verify-otp` (returns tokens) → `select-user-type` (`shop_owner` | `customer`) → app.
Returning user: `send-otp` → `verify-otp`. Token lifetime `expiresInSeconds: 604800`. OTP = **6 digits**, valid **120s**.

### 11.2 Endpoint map

| # | Method | Path | Purpose |
|---|---|---|---|
| 1.1 | POST | `/api/auth/register` | register (`email`, `firstName`, `lastName`) |
| 1.2 | POST | `/api/auth/send-otp` | login OTP (`email`) — 404 if not registered |
| 1.3 | POST | `/api/auth/verify-otp` | verify (`email`, `code`) → session |
| 1.4 | POST | `/api/auth/select-user-type` | `userType`, `shopName?`, `address?` |
| 1.5 | POST | `/api/auth/refresh-token` | `refreshToken` → new session |
| 1.6 | POST | `/api/auth/logout` | `refreshToken` |
| 2.1 | GET | `/api/users/profile` | user + shop |
| 3.1 | POST | `/api/contacts` | create contact |
| 3.3 | GET | `/api/contacts?page&pageSize&search` | paged list |
| 3.4 | GET | `/api/contacts/{id}` | one contact |
| 3.5 | PATCH | `/api/contacts/{id}/toggle-vip` | toggle VIP |
| 3.6 | GET | `/api/contacts/{id}/transactions` | contact financial profile |
| 3.7 | GET | `/api/contacts/vip?page&pageSize` | VIP only |
| 3.8 | PUT | `/api/contacts/{id}` | update (+`isVip`, `contactEmail`) |
| 3.9 | DELETE | `/api/contacts/{id}` | soft delete → **204** |
| 4.1–4.6 | POST | `/api/transactions` | sale/purchase · cash / auto installments / custom installments |
| 4.7 | GET | `/api/transactions?page&pageSize&contactId&type&dateFrom&dateTo` | list |
| 4.8 | GET | `/api/transactions/{id}` | details + installments |
| 4.9 | DELETE | `/api/transactions/{id}` | soft delete |
| 5.1 | POST | `/api/installments/{id}/pay` | mark paid |
| 6.1 | GET | `/api/statistics/summary` | today |
| 6.2 | GET | `/api/statistics/daily?date=YYYY-MM-DD` | daily |
| 6.3 | GET | `/api/statistics/monthly?year&month` | monthly |
| 7.1 | GET | `/api/notifications?page&pageSize&unreadOnly` | list |
| 7.2 | PATCH | `/api/notifications/{id}/read` | mark read |
| 7.3 | PATCH | `/api/notifications/read-all` | mark all read |
| 7.4 | POST | `/api/notifications/run-reminders-scan` | trigger reminders |
| 8.1 | POST | `/api/voice-notes` | upload voice note |
| 8.2 | GET | `/api/voice-notes?page&pageSize` | list |
| 8.3 | GET | `/api/voice-notes/{id}` | details |
| 8.4 | DELETE | `/api/voice-notes/{id}` | soft delete |

### 11.3 Enums & constants
- `userType`: `"shop_owner"` \| `"customer"`
- `type` (transaction): `"Sale"` \| `"Purchase"` — **string, never a number** (sending `0` → 400)
- `paymentMethod`: `"Cash"` \| installment variants
- `pageSize`: 1–50, default 20 · `page` default 1
- Dates: ISO-8601 UTC (`2026-08-19T14:30:00Z`)

### 11.4 Known server validations (surface them, don't duplicate them blindly)
- Contact `name`: letters only — digits/symbols → `400 "اسم الطرف يجب أن يحتوي على أحرف فقط"`
- `amount` must be `> 0`
- Email must have live MX records; temp-mail domains rejected
- `429` rate-limit on OTP endpoints
- `401` → handled globally by `AuthInterceptor`

---

## 12. Recipe — Adding a new feature end-to-end

Always produce the files in this exact order:

1. `data/response/<name>_responses/<name>_responses.dart` — `@JsonSerializable`, `<Name>Data` + `<Name>Response extends BaseResponse`, nullable fields.
2. `domain/model/<name>_model.dart` — non-nullable plain model.
3. `data/mapper/<name>_mapper.dart` — `extension <Name>ResponseMapper on <Name>Data { <Name> toDomain() => ... }` using `orEmpty()/orZero()/orFalse()`.
4. `data/network/app_api.dart` — add the retrofit method(s).
5. `data/data_source/<name>_remote_data_source.dart` — abstract + `@LazySingleton(as:)` impl delegating to `_api`.
6. `domain/repository/<name>_repository.dart` — abstract, returns `Future<Either<Failure, T>>`.
7. `data/repository_impl/<name>_repository_impl.dart` — `_guard` + `success != true` check + `toDomain()`.
8. `domain/use_case/<verb>_<name>_use_case.dart` — `<Verb><Name>Input` + `extends BaseUsecase<Input, Output>`.
9. `presentation/<screen>/<action>_cubit/<action>_state.dart` — Freezed.
10. `presentation/<screen>/<action>_cubit/<action>_cubit.dart` — `@injectable`.
11. `presentation/<screen>/<screen>_view.dart` (+ `widgets/`) — design-system only.
12. `presentation/resources/strings_manager.dart` + `routes_manager.dart` — add strings & route.
13. **Run** `flutter pub run build_runner build --delete-conflicting-outputs`, then `flutter analyze`.

---

## 13. 🚫 Never Do These

- ❌ Restructure into `features/` — Mizan is layer-first.
- ❌ Call `AppServiceClient` / Dio directly from a Cubit or a widget.
- ❌ Return `dynamic`, `Map<String, dynamic>`, or a `*Response` object out of the domain layer.
- ❌ Throw exceptions out of a repository — always `Either<Failure, T>`.
- ❌ Hardcode a color, size, font size, asset path, or Arabic string in a widget.
- ❌ `Image.network` (use `CachedNetworkImage`) or `Navigator.push(MaterialPageRoute(...))` inline (use `Routes` + `RouteGenerator`).
- ❌ Store tokens in `SharedPreferences` — `flutter_secure_storage` only.
- ❌ Manual `copyWith` / manual state classes — Freezed only.
- ❌ Emit after close — always `if (isClosed) return;`.
- ❌ Handle `401` or refresh tokens manually in a feature.
- ❌ English user-facing text. English is for code/comments only.
- ❌ Add a package, rename an existing class, or invent an endpoint/field without asking.

---

## 14. Definition of Done ✅

- [ ] All 13 recipe files created in the right folders with the right names
- [ ] `build_runner` run; `.g.dart` / `.freezed.dart` generated
- [ ] `flutter analyze` → 0 errors
- [ ] Every endpoint, field name and enum matches §11 exactly
- [ ] Every color/size/string/asset comes from a manager
- [ ] Loading / error / empty / content states all handled via `FlowState`
- [ ] Pagination: `hasMore`, `isLoadingMore`, page merge — if the screen is a list
- [ ] Arabic RTL layout verified against the Figma node
- [ ] No business logic inside any widget
