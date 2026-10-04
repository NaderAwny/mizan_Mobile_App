# Mizan Mobile App — Production Refactor Rules

> **Role:** You are a senior Flutter engineer. Refactor the existing `mizan` project (Flutter, Cubit/Bloc, get_it + injectable) so it is production-ready.
> **These rules are MANDATORY. Do NOT deviate from them. If a rule conflicts with existing code, change the code, not the rule.**
> Do not change app behavior or UI design. Only restructure, optimize, and enforce the rules below.

---

## 0. How to work

1. Scan the entire `lib/` folder first and list every violation of the rules below.
2. Fix feature by feature (one feature at a time), keeping the app compiling after each feature.
3. After finishing, run `flutter analyze` — it must return **0 issues**. Then run `dart run build_runner build --delete-conflicting-outputs` if injectable/freezed/json code was touched.
4. At the end, give a short report: what was fixed, per rule, with file names.

---

## 1. State management — NO `setState`

- `setState` is **forbidden everywhere**. Search the whole project for `setState` and remove every usage.
- Any value that changes (loading, selected tab, toggle, password visibility, counter, timer, selected index, form validity, etc.) must become a **state in a Cubit**.
- Every feature has its own Cubit + State class. States are written with **`freezed` ONLY** (`@freezed` sealed/union classes: `initial`, `loading`, `success`, `failure`, ...). `Equatable` is **forbidden** — if any state or model uses `Equatable`, convert it to `freezed`.
- Run `dart run build_runner build --delete-conflicting-outputs` after changing any freezed class.
- Convert `StatefulWidget` to `StatelessWidget` whenever the only reason it was stateful is `setState`.
  - `StatefulWidget` is allowed **only** to own and dispose controllers/focus nodes/animation controllers (see rule 3).
- Use the correct widget to avoid rebuilding the whole screen:
  - `BlocBuilder` with `buildWhen` — to rebuild only what is needed.
  - `BlocConsumer` (with `buildWhen` / `listenWhen`) — when the same widget needs to both build UI and react to side effects (navigation, snackbars, dialogs).
  - `BlocSelector` is **NOT allowed** in this project. Use only `BlocBuilder` and `BlocConsumer`.
  - Never put side effects (navigation, dialogs, snackbars) inside `builder`; they go in the `listener` of `BlocConsumer`.
- Wrap **only the smallest widget** that changes with `BlocBuilder`/`BlocConsumer`, never the whole `Scaffold` body unless the whole body changes.
- Never call `emit` after the Cubit is closed: check `isClosed` before `emit` in async code.

## 2. NO logic in View / Widgets

- Widgets and pages are **dumb**: they only render state and forward user events to the Cubit.
- Forbidden inside any widget/page/`build` method:
  - API calls, repository calls, database/cache calls
  - Validation rules, formatting, parsing, calculations, sorting, filtering, mapping
  - Conditional business decisions (`if user.role == ...`)
  - `Timer`, `Future.delayed` for logic, `async` business work
- All of the above lives in the **Cubit** (or in use cases/repositories called by the Cubit).
- The view may only contain: UI structure, passing callbacks like `onPressed: () => cubit.submit()`, and reading state.
- Navigation decisions are triggered by the Cubit emitting a state; the view reacts in the `listener` of `BlocConsumer`.

## 3. Dispose everything

- Every `TextEditingController`, `ScrollController`, `PageController`, `TabController`, `AnimationController`, `FocusNode`, `StreamSubscription`, `Timer`, `StreamController` **must be disposed/cancelled**.
- Widgets that own controllers: `StatefulWidget` with `dispose()` — or, preferably, keep controllers in the Cubit and override `close()` to dispose them.
- Every Cubit that owns subscriptions/timers/controllers must override `close()` and release them, then call `super.close()`.
- Register Cubits in the DI as `@injectable` (factory) unless they must live for the whole app (then `@lazySingleton`, and explain why in a comment).

## 4. Images — `CachedNetworkImage` only

- `Image.network` and `NetworkImage` are **forbidden** in the entire app. Replace every one with `CachedNetworkImage` (or `CachedNetworkImageProvider` when a provider is required, e.g. `CircleAvatar`/`DecorationImage`).
- Every `CachedNetworkImage` must have: `placeholder`, `errorWidget`, `fit`, and `memCacheWidth`/`memCacheHeight` when the displayed size is known.
- Create **one reusable** widget (e.g. `AppCachedImage`) in the shared widgets folder and use it everywhere, so the placeholder/error style is consistent.
- Local assets: use `Image.asset` with constants from the resources folder (see rule 9).

## 5. Flat widget tree — avoid deep nesting

- Do NOT stack many nested `Column` / `Row` / `Stack` / `Container` / `Padding` inside one `build` method.
- Rules of thumb:
  - A `build` method should stay short (target < 60 lines) and nesting depth should stay low (target ≤ 4–5 levels).
  - Extract parts of the UI into **separate `StatelessWidget` classes** (NOT helper methods like `_buildHeader()` — methods do not give rebuild isolation; classes with `const` constructors do).
  - Prefer the single-purpose widget over wrappers: use `Container(padding:, margin:, decoration:)` or `DecoratedBox`/`SizedBox`/`ColoredBox` instead of chaining `Padding > Container > Align > Center`; use `Column(spacing: ...)`/`Row(spacing: ...)` or `Gap` instead of many `SizedBox` spacers where appropriate.
- Each screen should be split into small widgets inside its own feature `widgets/` folder.

## 6. Performance — `const` and builders

- Use `const` on **every** widget/constructor that can be const (`const Text`, `const SizedBox`, `const Icon`, `const EdgeInsets`, …). Enable and obey these lints in `analysis_options.yaml`:
  - `prefer_const_constructors`, `prefer_const_literals_to_create_immutables`, `prefer_const_declarations`, `unnecessary_const`, `avoid_unnecessary_containers`, `sized_box_for_whitespace`, `use_key_in_widget_constructors`.
- Every custom stateless widget must have a `const` constructor.
- Lists/grids: **never** `ListView(children: [...])`, `GridView(children: [...])`, or `Column` with `.map(...).toList()` for dynamic/long data. Use:
  - `ListView.builder` / `ListView.separated`
  - `GridView.builder`
  - `SliverList.builder` / `SliverGrid.builder` with `CustomScrollView`
  - `PageView.builder`
- Provide `itemExtent`/`prototypeItem` or `cacheExtent` when item sizes are fixed.
- Use `ValueKey`/`Key` on list items that can reorder or change.
- Wrap heavy, frequently repainting subtrees in `RepaintBoundary` when profiling shows it helps.
- Do heavy parsing (large JSON) with `compute()`/isolates, not on the UI thread.

## 7. Dependency injection — `getIt` in the View

- Cubits are provided to the view using the injectable-generated `getIt`:

```dart
BlocProvider<VerifyOtpCubit>(
  create: (BuildContext context) => getIt<VerifyOtpCubit>(),
  child: const VerifyOtpView(),
)
```

- **Never** instantiate a Cubit/Repository/DataSource with `new`/direct constructor in the view (`VerifyOtpCubit(repo)` is forbidden).
- If a Cubit needs a dependency, it comes through the constructor and is registered with `@injectable` / `@lazySingleton` / `@singleton`; the view only calls `getIt<...>()`.
- A Cubit needed in another feature is also obtained via `getIt<TheCubit>()` — never by passing a manually created instance.
- Use `BlocProvider.value` only when passing an **existing** Cubit down the tree (e.g. to a bottom sheet/dialog).
- Run `build_runner` after adding/changing any `@injectable` class and commit the generated `injection.config.dart`.

## 8. Strict typing

- **No `dynamic`** anywhere in the app code: every variable, parameter, return type, list, map, and callback must have an explicit type. Avoid `var` when the type is not obvious, and never use raw/untyped `Map` or `List`.
- **The ONLY allowed exception:** `Map<String, dynamic>` as the parameter of `fromJson` and the return type of `toJson` inside the **model classes** (this is how Dart represents decoded JSON, it cannot be avoided). It must not appear anywhere else.
- Enable in `analysis_options.yaml`:

```yaml
analyzer:
  language:
    strict-casts: true
    strict-inference: true
    strict-raw-types: true
linter:
  rules:
    - always_specify_types
    - avoid_dynamic_calls
    - avoid_print
    - always_declare_return_types
    - type_annotate_public_apis
```

### JSON parsing (Response -> Model)

Parsing the server response into a typed model is **required and is the only way data enters the app**. Flow:

1. **Data source / API client** receives the response and passes `response.data` to the model's `fromJson` (inside the repository/data source, never in the Cubit or view).
2. **Model** (`freezed` + `json_serializable`) does the parsing:

```dart
@freezed
abstract class UserModel with _$UserModel {
  const factory UserModel({
    required int id,
    required String name,
    String? avatarUrl,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
}
```

3. **Repository** returns typed objects only (`Future<Either<Failure, UserModel>>` or the project's existing result type).
4. **Cubit** works only with typed models (`UserModel`, `List<UserModel>`), never with raw `Map`.
5. **View** reads typed fields from the state only (`state.user.name`).

So: a `Map<String, dynamic>` may exist only at the boundary (data source -> `fromJson`), and from there on everything is a typed model. Lists must be parsed too (`List<UserModel>`), with explicit types in `.map<UserModel>(...)`.

- No `print()` — use a logger utility that is disabled in release mode.

---

## 9. NO hard-coded strings / colors / sizes — use `resources`

- Hard-coded values are **forbidden** in views, widgets, and Cubits. Everything comes from the project's **`resources`** folder (use the existing structure; create the missing files inside it):
  - **Strings** → localization / `AppStrings` (`resources/strings` or `l10n`). All user-facing text, validation messages, error messages, hints, button labels.
  - **Colors** → `AppColors` + `ThemeData`/`ColorScheme`. No `Color(0xFF...)` or `Colors.xxx` inside widgets.
  - **Sizes / spacing / radius / font sizes / durations** → `AppSizes` / `AppSpacing` / `AppRadius` / `AppDurations`. No magic numbers in widgets. If the project uses `flutter_screenutil`, keep using it, but through the constants.
  - **Text styles** → `AppTextStyles` / `Theme.of(context).textTheme`.
  - **Assets** → `AppAssets` / `AppImages` / `AppIcons` constants (no raw `'assets/...'` strings in widgets).
  - **API endpoints, keys, storage keys, route names** → constants files (`ApiConstants`, `StorageKeys`, `AppRoutes`).
- Support light/dark theme properly through the theme, not by checking brightness in widgets.
- Secrets/base URLs must not be hard-coded in source: move to `--dart-define` / env config.

## 10. Splash screen — Preload all data (LAST TASK)

Goal: when the user enters the app after the splash, all required data is **already loaded** from the server and ready.

Implementation requirements:

1. Create `SplashCubit` (+ `SplashState`) obtained with `getIt<SplashCubit>()`. **No logic in the Splash view** — the view only listens to the state.
2. `SplashCubit.preload()` runs, in this order:
   1. Initialize / read local session (token, user, language, theme, onboarding flag).
   2. Decide the destination (onboarding / login / home) — decision logic lives in the Cubit.
   3. If the user is authenticated: fetch **all startup data of the app in parallel** with `Future.wait` (profile, home data, config/lookups, categories, etc. — identify every feature whose first screen needs server data). To trigger each feature's loading, call that feature's Cubit through DI: `getIt<HomeCubit>()`, `getIt<ProfileCubit>()`, … — never create instances manually.
   4. Prefetch critical images with `precacheImage(CachedNetworkImageProvider(url), context)` (hero banners, avatar, first-screen images) — the context call is triggered from the view via the `listener` of `BlocConsumer`, the list of URLs comes from the Cubit state.
3. **Singleton data holders:** the Cubits whose data must survive past the splash (Home, Profile, Config…) must be registered as `@lazySingleton` so the same instance (with data already loaded) is reused by the screens through `getIt<...>()`. Screens must show the existing data immediately and **not** re-fetch on open (refresh only on pull-to-refresh or when data is stale).
4. Cache the fetched startup data locally (e.g. Hive / shared_preferences / secure storage — use what the project already has) so the next launch shows data instantly, and refresh in the background.
5. Splash rules:
   - Minimum display time (e.g. 1–2 s, defined in `AppDurations`) combined with the preload using `Future.wait`, so the splash never flashes.
   - Global timeout for the preload (e.g. 10–15 s). On timeout/failure: continue to the app with cached data, or show a retry state — **never get stuck on splash**.
   - Handle no-internet and 401 (expired token → go to login) explicitly via states.
   - Splash states: `initial`, `loading`, `success(destination)`, `failure(message)`.
6. Navigation from splash happens only inside the `listener` of `BlocConsumer` reacting to `success(destination)`.

---

## 11. Production-readiness checklist (apply while refactoring)

- [ ] Zero `setState` (search the project)
- [ ] Zero `Image.network` / `NetworkImage`
- [ ] Zero `dynamic`, zero `print`
- [ ] Zero hard-coded strings/colors/sizes/asset paths in `lib/` outside `resources`
- [ ] All controllers/subscriptions/timers disposed; Cubits override `close()` when needed
- [ ] No business logic in any widget or page
- [ ] All lists use `.builder`
- [ ] `const` everywhere possible; `flutter analyze` = 0 issues
- [ ] All Cubits obtained via `getIt<...>()`; `build_runner` generated files are up to date
- [ ] Every Cubit state covers: initial / loading / success / failure (+ empty when relevant)
- [ ] Errors are handled and mapped to user-friendly messages (no raw exceptions shown to the user)
- [ ] Release build works: `flutter build apk --release` / `flutter build appbundle --release` with no warnings about debug-only code
- [ ] Splash preload implemented as described in section 10

## 12. Never Do These (summary)

- ❌ Business logic in widgets or pages
- ❌ `setState`
- ❌ `dynamic` types — always type everything explicitly
- ❌ `Image.network` — always `CachedNetworkImage`
- ❌ Hard-coded strings / colors / sizes — always constants & theme from `resources`
- ❌ Creating a Cubit manually in the view — always `getIt<TheCubit>()`
- ❌ Undisposed controllers
- ❌ `ListView(children: …)` for dynamic data
- ❌ Deeply nested widget trees and helper methods returning widgets instead of `const` widget classes
