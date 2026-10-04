# MIZAN — MASTER REFACTOR SPEC (for Antigravity IDE)

> This is the ONLY instruction file. Read the PROTOCOL + Part 1 + Part 2 fully once. For Parts 3 and 4, read ONLY the sections that match the current item (the file is long; do not reload it all every round).
> Arabic text = explanation. English text and code blocks = authoritative instructions.
> Your job is to **refactor the existing app to match this spec — nothing more.**

---

## 🔒 ZERO-INNOVATION PROTOCOL (highest priority — overrides any habit or default)

You are a refactoring tool, not a designer. You must NOT use your own ideas.

**FORBIDDEN (never do these, even if you think it is better):**
1. Do not add, remove, or upgrade packages in `pubspec.yaml`. The ONLY allowed change: add `cached_network_image` **if and only if** a real network image URL is displayed somewhere (verify first, report what you found).
2. Do not change UI: no layout, color, spacing, font, text, animation, or behavior changes. The app must look and behave exactly the same.
3. Do not add features, screens, endpoints, models, or fields that do not exist today.
4. Do not rename or "fix" existing names, files, classes, enums, or typos (e.g. `StateRandrer`, `popupErrorStatete`, `state_randrer_impl.dart`, `ColorManager`). Use them exactly as they are.
5. Do not change the architecture, folder structure, DI setup, routing, theme, API contracts, JSON keys, or Dio/Retrofit setup.
6. Do not replace `FlowState`/`StateRandrer` with anything else, and do not invent a different state pattern. Do not create tiny Cubits for single variables.
7. Do not change `Route<dynamic>` in `routes_manager.dart` (Flutter requires it).
8. Do not delete or rewrite code you were not asked to change. Do not do "cleanup", "optimizations", or "improvements" outside this spec.
9. Do not touch more than one feature per round. Do not touch generated files (`*.g.dart`, `*.freezed.dart`, `injection.config.dart`) by hand — regenerate with build_runner.

**REQUIRED:**
- Every change must be traceable to a rule in Part 1 or a recipe in Part 3. If you cannot point to the rule, do not make the change.
- If something is unclear, or the real code differs from an example (names, types, signatures), **do not guess**. Use the real names from the code. If still unsure, write the question in `REFACTOR_QUESTIONS.md` and skip that item.
- Examples in this file use placeholder names for use cases/data sources/models (e.g. `SendOtpUseCase`, `SessionLocalDataSource`, `HomeCubit.load()`). **Always replace them with the real ones found in the codebase.**

## ▶️ WORKFLOW (follow exactly)

1. Create `REFACTOR_PROGRESS.md` at the project root if it does not exist, with this checklist (all unchecked):
   `step1_foundations, send_otp, register, select_user_type, auth_verification, onboarding, transactions, statistics, voice_note, operations, customers, installments, home_drawer, shared_images, data_layer_dynamic, build_widgets_split, splash_preload`
2. Take the FIRST unchecked item only. Work ONLY on the files of that item.
3. Apply Part 1 (rules) + Part 2 (state pattern) + ONLY the matching recipe in Part 3 + ONLY the matching rows in Part 4.
4. Run `dart run build_runner build --delete-conflicting-outputs` then `flutter analyze` for the touched files. Fix only the errors you introduced.
5. Tick the item in `REFACTOR_PROGRESS.md`, add 2 lines (what changed + files touched).
6. Print a 3-line summary + a suggested git commit message. **STOP and wait for the word `next`.**
7. `splash_preload` is LAST: before writing code, print a short plan (which Cubits become `@lazySingleton`, which calls run in `Future.wait`) and wait for approval.

## ✅ DEFINITION OF DONE (per item)

- No remaining violation of the item's rules (see grep commands at the end of Part 3).
- UI identical, app compiles, `flutter analyze` clean for touched files.
- No new package, no renamed symbol, no extra files except the ones listed in the recipe.

---

# PART 1 — RULES

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
- Every feature has its own Cubit + State class, written **exactly** in the project's own pattern (see Part 2 — mandatory):
  - The State is a single `@freezed abstract class` with this field order: `FlowState? flowState`, then the typed `data` model(s) (nullable), then the new variables with `@Default(...)` (index, touched flags, seconds, selected items, ...).
  - Screen status (loading / error / empty / content) is expressed ONLY through `flowState` and rendered by the `StateRenderer` (`flowState?.getScreenWidget(...)`). No `isLoading` booleans, no `initial/loading/success/failure` union states.
  - **Never create a separate small Cubit for one variable** (tab index, touched flag, timer). Add the variable to the feature's existing State and add a method to the feature's existing Cubit.
  - `Equatable` is **forbidden**; `freezed` only.
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

### 📌 Example — Rule 1 (no `setState`)

❌ Wrong:
```dart
class _FiltersState extends State<Filters> {
  int _selected = 0;
  Widget build(BuildContext context) =>
      Chips(selected: _selected, onTap: (int i) => setState(() => _selected = i));
}
```
✅ Right — the variable lives in the feature State, the change is a Cubit method, the view only reads/forwards:
```dart
// state:  @Default(0) int selectedFilterIndex   (added after `data`)
// cubit:  void changeFilter(int i) { if (state.selectedFilterIndex == i) return; emit(state.copyWith(selectedFilterIndex: i)); }
BlocBuilder<GetListTransactionCubit, GetListTransactionState>(
  buildWhen: (GetListTransactionState p, GetListTransactionState c) =>
      p.selectedFilterIndex != c.selectedFilterIndex,
  builder: (BuildContext context, GetListTransactionState state) => Chips(
    selected: state.selectedFilterIndex,
    onTap: (int i) => context.read<GetListTransactionCubit>().changeFilter(i),
  ),
)
```
Why: only the chips rebuild, not the whole screen.

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

### 📌 Example — Rule 2 (no logic in views)

❌ Wrong (validation + timer + data source inside the view):
```dart
onPressed: () {
  if (!email.contains('@')) { showError('Invalid'); return; }
  getIt<OnboardingLocalDataSource>().markOnboardingAsSeen();
  Timer(const Duration(seconds: 1), () => Navigator.pop(context));
}
```
✅ Right — the view only forwards the event, the Cubit decides:
```dart
onPressed: () => context.read<OnboardingCubit>().complete(),
// cubit.complete(): await _localDataSource.markOnboardingAsSeen(); emit(state.copyWith(completed: true));
// view listener:    if (state.completed) Navigator.of(context).pushReplacementNamed(Routes.loginRoute);
```

## 3. Dispose everything

- Every `TextEditingController`, `ScrollController`, `PageController`, `TabController`, `AnimationController`, `FocusNode`, `StreamSubscription`, `Timer`, `StreamController` **must be disposed/cancelled**.
- Widgets that own controllers: `StatefulWidget` with `dispose()` — or, preferably, keep controllers in the Cubit and override `close()` to dispose them.
- Every Cubit that owns subscriptions/timers/controllers must override `close()` and release them, then call `super.close()`.
- Register Cubits in the DI as `@injectable` (factory) unless they must live for the whole app (then `@lazySingleton`, and explain why in a comment).

### 📌 Example — Rule 3 (dispose everything)

❌ Wrong:
```dart
class _FormState extends State<Form> {
  final TextEditingController _email = TextEditingController();
  // no dispose -> memory leak
}
```
✅ Right:
```dart
class _FormState extends State<Form> {
  final TextEditingController _email = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }
}
// Cubit with a Timer:
@override
Future<void> close() {
  _timer?.cancel();
  return super.close();
}
```

## 4. Images — `CachedNetworkImage` only

- `Image.network` and `NetworkImage` are **forbidden** in the entire app. Replace every one with `CachedNetworkImage` (or `CachedNetworkImageProvider` when a provider is required, e.g. `CircleAvatar`/`DecorationImage`).
- Every `CachedNetworkImage` must have: `placeholder`, `errorWidget`, `fit`, and `memCacheWidth`/`memCacheHeight` when the displayed size is known.
- Create **one reusable** widget (e.g. `AppCachedImage`) in the shared widgets folder and use it everywhere, so the placeholder/error style is consistent.
- Local assets: use `Image.asset` with constants from the resources folder (see rule 9).

### 📌 Example — Rule 4 (images)

❌ Wrong:
```dart
Image.network(user.avatarUrl)
CircleAvatar(backgroundImage: NetworkImage(user.avatarUrl))
```
✅ Right (only if the app really shows network images; one shared widget):
```dart
AppCachedImage(url: user.avatarUrl, width: 48, height: 48)
CircleAvatar(backgroundImage: CachedNetworkImageProvider(user.avatarUrl))
```
The scan found ZERO network images today, so first verify; if there are none, do not add the package and do not create the widget.

## 5. Flat widget tree — avoid deep nesting

- Do NOT stack many nested `Column` / `Row` / `Stack` / `Container` / `Padding` inside one `build` method.
- Rules of thumb:
  - A `build` method should stay short (target < 60 lines) and nesting depth should stay low (target ≤ 4–5 levels).
  - Extract parts of the UI into **separate `StatelessWidget` classes** (NOT helper methods like `_buildHeader()` — methods do not give rebuild isolation; classes with `const` constructors do).
  - Prefer the single-purpose widget over wrappers: use `Container(padding:, margin:, decoration:)` or `DecoratedBox`/`SizedBox`/`ColoredBox` instead of chaining `Padding > Container > Align > Center`; use `Column(spacing: ...)`/`Row(spacing: ...)` or `Gap` instead of many `SizedBox` spacers where appropriate.
- Each screen should be split into small widgets inside its own feature `widgets/` folder.

### 📌 Example — Rule 5 (flat widget tree)

❌ Wrong (helper method + deep nesting, no rebuild isolation):
```dart
Widget _buildHeader() {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: Column(children: <Widget>[Row(children: <Widget>[Stack(children: <Widget>[Text(title)])])]),
  );
}
```
✅ Right (separate const class in the feature `widgets/` folder, flat tree):
```dart
class TransactionsHeader extends StatelessWidget {
  const TransactionsHeader({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppPadding.p16),
      child: Text(title),
    );
  }
}
// usage: const TransactionsHeader(title: AppStrings.transactions)
```

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

### 📌 Example — Rule 6 (const and builders)

❌ Wrong:
```dart
ListView(children: items.map((Item e) => ItemTile(item: e)).toList())
Padding(padding: EdgeInsets.all(16), child: Text('Hi'))
```
✅ Right:
```dart
ListView.builder(
  itemCount: items.length,
  itemBuilder: (BuildContext context, int index) => ItemTile(item: items[index]),
)
const Padding(padding: EdgeInsets.all(AppPadding.p16), child: Text(AppStrings.hi))
```

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

### 📌 Example — Rule 7 (getIt for Cubits)

❌ Wrong:
```dart
BlocProvider<VerifyOtpCubit>(
  create: (BuildContext context) => VerifyOtpCubit(VerifyOtpUseCase(repository)),
  child: const VerifyOtpView(),
)
```
✅ Right:
```dart
BlocProvider<VerifyOtpCubit>(
  create: (BuildContext context) => getIt<VerifyOtpCubit>(),
  child: const VerifyOtpView(),
)
```
Also wrong: `getIt<OnboardingLocalDataSource>()` inside a view. A data source is only used inside a Cubit/repository.

## 8. Strict typing

- **No `dynamic`** anywhere in the app code: every variable, parameter, return type, list, map, and callback must have an explicit type. Avoid `var` when the type is not obvious, and never use raw/untyped `Map` or `List`.
- **The ONLY allowed exception:** `Map<String, dynamic>` as the parameter of `fromJson` and the return type of `toJson` inside the **Response classes** (and request `toJson`) (this is how Dart represents decoded JSON, it cannot be avoided). It must not appear anywhere else.
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

### JSON parsing (Server -> Response -> Model) — follow the project's EXISTING architecture

The project already separates **Response** classes from **Model** classes. Do NOT change this and do NOT add `fromJson` to Models.

1. **Response classes** (data layer, e.g. `*_response.dart`, `@JsonSerializable`, generated `*.g.dart`, used by Retrofit/`app_api`) are the ONLY place that parses JSON. Their fields mirror the server (usually nullable). They are the only classes that contain `fromJson`/`toJson` with `Map<String, dynamic>`.
2. A **mapper** (`toDomain()` extension, usually in a `mapper` file) converts each Response into a **Model** (domain/presentation object, non-null fields with defaults). The mapper is where `null` becomes a safe default.
3. **Repository** returns Models only (`Future<Either<Failure, XxxModel>>` or the project's existing result type), never Responses.
4. **Cubit** works only with Models (`XxxModel`, `List<XxxModel>`), never with Responses or raw `Map`.
5. **View** reads only Model fields from the state (`state.data?.name`).

Rules:
- Never use `response.data['key']` / `Map` access outside Response classes.
- Do not create new Response/Model classes, and do not move parsing into Models. Only touch this flow if a `Map<String, dynamic>` leaks outside the Response classes (for example request bodies in `auth_remote_data_source.dart`).
- Request bodies: follow the existing style in the project. If the project has request classes, use them; if requests are `Map<String, dynamic>` today, wrap them in a typed request class with `toJson()` **only if** doing so does not change the JSON keys sent to the server.
- Lists must keep explicit types (`List<XxxModel>`, `.map<XxxModel>(...)`).

- No `print()` — use a logger utility that is disabled in release mode.

### 📌 Example — Rule 8 (strict typing)

❌ Wrong:
```dart
var items = [];
dynamic data = response.data;
void onTap(x) { print(x); }
```
✅ Right:
```dart
final List<TransactionModel> items = <TransactionModel>[];
final TransactionModel? data = state.data;
void onTap(int index) { AppLogger.d('tap $index'); }
```

### 📌 Example — Request bodies (`auth_remote_data_source.dart`, lines 7-26)

❌ Wrong (untyped `Map` as a request body):
```dart
Future<Response<dynamic>> verifyOtp(Map<String, dynamic> body);
// caller: verifyOtp(<String, dynamic>{'email': email, 'otp': otp});
```
✅ Right (typed request class, **the JSON keys stay exactly the same**):
```dart
class VerifyOtpRequest {
  const VerifyOtpRequest({required this.email, required this.otp});

  final String email;
  final String otp;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'email': email, // same key the server already expects
        'otp': otp,     // same key the server already expects
      };
}
// data source:  verifyOtp(VerifyOtpRequest request)  -> sends request.toJson()
// caller:       verifyOtp(VerifyOtpRequest(email: email, otp: otp))
```
Use the project's existing request style if one already exists. Never change the key names. Responses are NOT touched here: they stay in their Response classes.

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

### 📌 Example — Rule 9 (no hard-coded values)

❌ Wrong:
```dart
Container(
  padding: const EdgeInsets.all(16),
  color: const Color(0xFF5E48B8),
  child: const Text('Send code', style: TextStyle(fontSize: 14, color: Colors.white)),
)
```
✅ Right (everything from `resources`):
```dart
Container(
  padding: const EdgeInsets.all(AppPadding.p16),
  color: ColorManager.voiceNotePurple,
  child: Text(AppStrings.sendCode, style: getRegularStyle(color: ColorManager.white)),
)
```
Use the helper names that already exist in `presentation/resources` (do not invent new naming styles).

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
   - Splash state follows the project pattern: `SplashState({FlowState? flowState, SplashDestination? data})`. Loading = `LoadingState`, failure = `ErrorState` (full screen, with retry), success = `ContentState` + `data` (the destination). Navigation happens in the `BlocConsumer` listener when `data != null`.
6. Navigation from splash happens only inside the `listener` of `BlocConsumer` reacting to `success(destination)`.

### 📌 Example — Rule 10 (splash preload)

❌ Wrong (view decides and navigates):
```dart
Future<void>.delayed(const Duration(seconds: 2), () {
  final bool seen = getIt<OnboardingLocalDataSource>().isSeen();
  Navigator.pushReplacementNamed(context, seen ? Routes.login : Routes.onboarding);
});
```
✅ Right (Cubit decides, view only listens, state uses the project pattern):
```dart
// cubit.preload(): emit(LoadingState) -> Future.wait(startup data) -> emit(flowState: ContentState(), data: SplashDestination.home)
BlocConsumer<SplashCubit, SplashState>(
  listenWhen: (SplashState p, SplashState c) => p.data != c.data,
  listener: (BuildContext context, SplashState state) { /* navigate by state.data */ },
  buildWhen: (SplashState p, SplashState c) => p.flowState != c.flowState,
  builder: (BuildContext context, SplashState state) =>
      state.flowState?.getScreenWidget(context, const SplashAnimation(), () => context.read<SplashCubit>().preload()) ??
      const SplashAnimation(),
)
```

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
- [ ] Every feature State follows `Part 2` (`flowState` + `data` + new vars) and the view uses `StateRenderer`
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


---

# PART 2 — STATE PATTERN (FlowState + data + new variables)

> **أي AI أو أي حد بيشتغل في الـ Cubit لازم يمشي على الملف ده بالظبط.**
> مفيش Cubit صغير منفصل لكل متغير. كل feature ليه **State واحد** فيه `flowState` + `data` + المتغيرات الجديدة، والـ view بتتعامل معاه بـ `StateRenderer`.

## الـ API الحقيقي لـ `FlowState` (مأخوذ من `state_randrer_impl.dart`)

> الأسماء دي **لا تتغير ولا تتصلح** (حتى الأخطاء الإملائية زي `StateRandrer` و `popupErrorStatete`). استخدمها زي ما هي.

| الـ class | الـ constructor الحقيقي |
|-----------|-------------------------|
| `LoadingState` | `LoadingState({required StateRendererType stateRendererType, String? message, String? title})` |
| `ErrorState` | `ErrorState(StateRendererType type, String message, {String? title})` |
| `SuccessState` | `SuccessState(StateRendererType type, String message, {String? title})` |
| `ContentState` | `ContentState()` |
| `EmptyState` | `EmptyState(String message)` |

- الـ widget اسمه `StateRandrer` (في `state_randrer.dart`) و الـ extension: `flowState?.getScreenWidget(context, contentWidget, retryFunction)` وبيرجع **`Widget?`** (فلازم `?? contentWidget`).
- `StateRendererType` المؤكد وجوده من الكود: `popupLoadingState`, `popupErrorStatete` (بالخطأ الإملائي), `successScreenState`, `fullScreenEmptyState`, `contentScreenState`. وللـ full-screen loading/error استخدم الأسماء الموجودة في `state_randrer.dart` (غالباً `fullScreenLoadingState` و `fullScreenErrorState`)، **افتح الملف وتأكد قبل الاستخدام**.

### ⚠️ 5 قواعد بتنتج من طريقة شغل الـ `FlowState` (لازم تتبعها)

1. **كل `emit` لازم يعمل instance جديد:** الـ `isShown` flag موجود على الـ instance نفسه (بيتغير جوه `getScreenWidget`). لو عملت reuse لنفس `ErrorState`/`ContentState`/`LoadingState` الـ popup مش هيظهر تاني أو مش هيتقفل. يعني دايماً `ContentState()` و `ErrorState(...)` جداد، **ممنوع** تخزنهم في `const`/`static`/field.
2. **`ContentState` هو اللي بيقفل الـ popup:** (`dismissDialog` بيتنادى لما `ContentState` جديد يوصل). فبعد أي popup loading/error/success لازم تـ emit `ContentState()` لما الشغل يخلص.
3. **`buildWhen: p.flowState != c.flowState`** على الـ `BlocConsumer`/`BlocBuilder` اللي بينادي `getScreenWidget`. الـ FlowState مش `Equatable`، فالمقارنة بالـ identity، وده المطلوب: الـ builder بيتنفذ مرة واحدة لكل instance، فالـ popup يظهر مرة واحدة.
4. **`getScreenWidget` بيعمل side effects (popup/dismiss) فمايتنادهوش غير من جوه `builder`** وبس.
5. **المتغيرات اللي بتتغير كتير (عداد، نص، index)** لازم يتقرأوا في `BlocBuilder` منفصل بـ `buildWhen` على المتغير نفسه، مش في الـ builder بتاع `getScreenWidget`.

### تعديل الـ typing في `state_randrer_impl.dart` (مرة واحدة، من غير تغيير سلوك)

الملف نفسه بيخالف الـ lints الجديدة (`always_specify_types` و `avoid_dynamic_calls` و `strict-inference`). عدّل **الـ typing بس**:

1. امسح كل الكود القديم المتعلق (commented-out) في أول الملف، وضيف في أول الملف: `// ignore_for_file: type_literal_in_constant_pattern`.
2. `Function retryActionFunction` ➜ `VoidCallback retryActionFunction` (في `getScreenWidget`). كل الاستدعاءات الحالية `() => ...` شغالة زي ما هي.
3. `var loadingState = this as LoadingState;` ➜ `final LoadingState loadingState = this as LoadingState;` (وكده في `successState` و `errorState` و `contentState`).
4. `String getTitle()` بدل `getTitle()` من غير return type (في `LoadingState` و `ErrorState` و `SuccessState`).
5. `showDialog(` ➜ `showDialog<void>(`، و `.then((_) {` ➜ `.then((void _) {`، و `builder: (dialogCtx)` ➜ `builder: (BuildContext dialogCtx)`، و `(_) {` في `addPostFrameCallback` ➜ `(Duration _) {`.
6. `_isCurrentDialogShowing` و `// ignore: strict_top_level_inference` اللي مبقوش لازمين، امسحهم لو مش مستخدمين.
7. **ممنوع تغيير منطق `isShown` أو `dismissDialog` أو `showPopup` أو الـ switch.**

---

## 1) القاعدة

الـ State = **3 حاجات بالترتيب ده**:

```dart
const factory XxxState({
  FlowState? flowState,          // 1) حالة الشاشة (loading / error / content ...)
  XxxModel? data,                // 2) الداتا اللي جاية من السيرفر (typed model)
  @Default(...) Type newVar,     // 3) متغيرات جديدة كانت setState (index, touched, seconds, ...)
}) = _XxxState;
```

- `flowState` و `data` دايماً **nullable**.
- المتغيرات الجديدة دايماً ليها `@Default(...)` عشان `const XxxState()` يشتغل.
- الـ State بـ `freezed` بس (من غير Equatable)، وفي ملف `xxx_state.dart` لوحده.
- ممنوع `dynamic`.

## 2) قبل ما تكتب أي كود في feature (5 أسئلة)

1. هل الشاشة بتجيب داتا من السيرفر؟ → `data` من نوع الـ model.
2. هل فيه loading / error / empty للشاشة؟ → `flowState`.
3. إيه كل الحاجات اللي كانت `setState` أو `ValueNotifier` أو `Timer` في الـ view؟ → كل واحدة متغير في الـ State.
4. إيه الـ methods اللي الـ view هتناديها؟ → كل واحدة method في الـ Cubit.
5. إيه الـ widgets اللي لازم تتبني بـ `BlocBuilder`؟ → أصغر widget بس، مع `buildWhen`.

## 3) شكل الملفات في كل feature

```
feature_name/
├── cubit/
│   ├── feature_state.dart        ← freezed (flowState + data + vars)
│   └── feature_cubit.dart        ← @injectable, كل الـ logic
├── view/
│   └── feature_view.dart         ← BlocProvider + BlocConsumer فقط
└── widgets/
    └── ...                        ← const StatelessWidget classes
```

## 4) مثال كامل — `send_otp`

### 4.1 الـ State — `send_otp/cubit/send_otp_state.dart`

```dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mizan/presentation/common/state_randrer/state_randrer_impl.dart';

part 'send_otp_state.freezed.dart';

@freezed
abstract class SendOtpState with _$SendOtpState {
  const factory SendOtpState({
    FlowState? flowState,
    SendOtpResponseModel? data,          // الـ model الحالي عندك
    @Default(0) int secondsLeft,         // كان ValueNotifier<int> في الـ view
    @Default(false) bool emailTouched,   // كان setState في الـ view
  }) = _SendOtpState;
}
```

### 4.2 الـ Cubit — `send_otp/cubit/send_otp_cubit.dart`

```dart
@injectable
class SendOtpCubit extends Cubit<SendOtpState> {
  SendOtpCubit(this._sendOtpUseCase) : super(const SendOtpState());

  final SendOtpUseCase _sendOtpUseCase;
  Timer? _timer;
  String _lastEmail = '';

  Future<void> sendOtp(String email) async {
    _lastEmail = email;
    emit(state.copyWith(
      flowState: LoadingState(
        stateRendererType: StateRendererType.popupLoadingState,
        message: AppStrings.loading,
      ),
    ));

    final Either<Failure, SendOtpResponseModel> result =
        await _sendOtpUseCase(email);
    if (isClosed) return;

    result.fold(
      (Failure failure) => emit(state.copyWith(
        flowState: ErrorState(
          StateRendererType.popupErrorStatete,
          failure.message,
        ),
      )),
      (SendOtpResponseModel model) {
        emit(state.copyWith(flowState: ContentState(), data: model));
        startTimer();
      },
    );
  }

  void retry() => sendOtp(_lastEmail);

  void touchEmail() {
    if (state.emailTouched) return;
    emit(state.copyWith(emailTouched: true));
  }

  void startTimer() {
    _timer?.cancel();
    emit(state.copyWith(secondsLeft: AppConstants.otpSeconds));
    _timer = Timer.periodic(AppDurations.oneSecond, (Timer timer) {
      if (isClosed || state.secondsLeft <= 1) {
        timer.cancel();
        if (!isClosed) emit(state.copyWith(secondsLeft: 0));
        return;
      }
      emit(state.copyWith(secondsLeft: state.secondsLeft - 1));
    });
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
```

### 4.3 الـ View — `send_otp/view/send_otp_view.dart`

```dart
class SendOtpView extends StatelessWidget {
  const SendOtpView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SendOtpCubit>(
      create: (BuildContext context) => getIt<SendOtpCubit>(),
      child: const SendOtpBody(),
    );
  }
}

class SendOtpBody extends StatelessWidget {
  const SendOtpBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SendOtpCubit, SendOtpState>(
      // الـ listener: navigation بس، لما data توصل
      listenWhen: (SendOtpState p, SendOtpState c) => p.data != c.data,
      listener: (BuildContext context, SendOtpState state) {
        if (state.data != null) {
          Navigator.of(context).pushNamed(Routes.verifyOtpRoute);
        }
      },
      // الـ builder: بيتعمله rebuild لما flowState بس يتغير (مش مع كل ثانية من العداد)
      buildWhen: (SendOtpState p, SendOtpState c) => p.flowState != c.flowState,
      builder: (BuildContext context, SendOtpState state) {
        return state.flowState?.getScreenWidget(
              context,
              const SendOtpContent(),
              () => context.read<SendOtpCubit>().retry(),
            ) ??
            const SendOtpContent();
      },
    );
  }
}
```

الـ widgets الصغيرة اللي بتتغير لوحدها (العداد والـ error بتاع الـ email):

```dart
class ResendCountdown extends StatelessWidget {
  const ResendCountdown({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SendOtpCubit, SendOtpState>(
      buildWhen: (SendOtpState p, SendOtpState c) =>
          p.secondsLeft != c.secondsLeft,
      builder: (BuildContext context, SendOtpState state) {
        return Text('${AppStrings.resendIn} ${state.secondsLeft}');
      },
    );
  }
}
```

### نقاط مهمة في المثال ده
- العداد بيغيّر `secondsLeft` كل ثانية، فالـ `buildWhen` على `flowState` بيمنع إن الشاشة كلها (وأي popup) تتبني تاني.
- الـ validation والـ `Timer` والـ `_lastEmail` كلهم في الـ Cubit، والـ view مفيهاش logic.
- الـ `StateRenderer` هو اللي بيعرض الـ loading/error، فمفيش `if (isLoading)` في الـ view.

---

## 5) لو الشاشة مفيهاش API (UI state بس)

زي tab أو filter. نفس الـ State، بس `flowState` و `data` ممكن يفضلوا `null`:

```dart
const factory StatisticsState({
  FlowState? flowState,
  StatisticsModel? data,
  @Default(0) int selectedTabIndex,
}) = _StatisticsState;
```

الـ Cubit بيضيف method لكل تغيير:

```dart
void selectTab(int index) {
  if (state.selectedTabIndex == index) return;
  emit(state.copyWith(selectedTabIndex: index));
}
```

## 6) أخطاء شائعة لازم تتجنبها

| ❌ غلط | ✅ صح |
|-------|------|
| Cubit صغير منفصل لـ index أو flag | متغير جديد في state الـ feature الموجود |
| `Equatable` | `freezed` |
| `BlocSelector` | `BlocBuilder` + `buildWhen` |
| `if (state.isLoading)` في الـ view | `state.flowState?.getScreenWidget(...)` |
| `Timer` / validation في الـ view | method في الـ Cubit |
| `emit` بعد `close` | `if (isClosed) return;` قبل أي `emit` بعد `await` |
| `BlocBuilder` حوالين الـ Scaffold كله | `BlocBuilder` حوالين أصغر widget بس |


---

# PART 3 — RECIPES (copy-paste patterns, per violation)

> مبني على `violations_report.md` + قواعد `Part 1`.
> **مهم:** كل الأمثلة هنا مكتوبة على **طريقتك**: State واحد بـ `freezed` فيه `flowState` + `data` + متغيرات جديدة، والـ view بتستخدم `StateRenderer`. اقرا Part 2 الأول.
> **مفيش Cubit منفصل لأي متغير.** كل `setState` بيتحول لمتغير في state الـ feature الموجود + method في الـ Cubit بتاعه.
> أسماء `FlowState` والـ classes الحقيقية موجودة في `Part 2` (اتأكدت منها من `state_randrer_impl.dart`). أسماء الـ use cases والـ data sources في الأمثلة **افتراضية**، طابقها على كودك.

## طريقة الشغل

1. اعمل branch: `git checkout -b refactor/production`
2. نفذ الخطوات بالترتيب. بعد **كل خطوة**:
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   flutter analyze
   git add -A && git commit -m "refactor: <step name>"
   ```
3. أوامر تتأكد بيها إن المخالفة اتشالت:
   ```bash
   grep -rn "setState" lib/
   grep -rn "ValueNotifier\|ValueListenableBuilder" lib/
   grep -rn "Colors\.\|Color(0x" lib/ --include=*.dart | grep -v "presentation/resources"
   grep -rn "print(" lib/
   grep -rn "Image.network\|NetworkImage" lib/
   grep -rn "BlocSelector\|Equatable" lib/
   grep -rn "Widget _build" lib/
   ```

## الترتيب

| # | الخطوة | الوقت التقريبي |
|---|--------|----------------|
| 1 | analysis_options + ColorManager + Logger | 15 د |
| 2 | send_otp | 30 د |
| 3 | register | 20 د |
| 4 | select_user_type | 25 د |
| 5 | onboarding | 15 د |
| 6 | transactions + statistics (tab/filter index) | 30 د |
| 7 | customers (debounce) | 20 د |
| 8 | voice_note / operations / installments / auth_verification | حسب الوقت |
| 9 | error_handler + auth_remote_data_source | 30 د |
| 10 | drawer ListView + AppCachedImage | 15 د |
| 11 | Splash preload (آخر حاجة) | 1-2 س |

---

# الخطوة 1 — الأساسيات

## 1.1 `analysis_options.yaml`

```yaml
include: package:flutter_lints/flutter.yaml

analyzer:
  language:
    strict-casts: true
    strict-inference: true
    strict-raw-types: true
  errors:
    # الـ generated code
    invalid_annotation_target: ignore
  exclude:
    - "**/*.g.dart"
    - "**/*.freezed.dart"
    - "lib/**/injection.config.dart"

linter:
  rules:
    - prefer_const_constructors
    - prefer_const_literals_to_create_immutables
    - prefer_const_declarations
    - unnecessary_const
    - avoid_unnecessary_containers
    - sized_box_for_whitespace
    - use_key_in_widget_constructors
    - always_specify_types
    - avoid_dynamic_calls
    - avoid_print
    - always_declare_return_types
    - type_annotate_public_apis
```

> `always_specify_types` هيطلع warnings كتير. ماتصلحهاش كلها دلوقتي، صلحها في كل ملف وانت بتعدله.

## 1.2 `ColorManager` — ضيف الألوان الناقصة

افتح ملف `ColorManager` (في `presentation/resources/`) وضيف:

```dart
static const Color transparent = Colors.transparent;
static const Color white = Colors.white;
static const Color black = Colors.black;

// Voice note
static const Color voiceNotePurple = Color(0xFF5E48B8);
static const Color voiceNoteContainer = Color(0xFFF0EDFC);

// Transaction type
static const Color transactionTypeBg = Color(0xFFEEF2FF);
static const Color transactionTypeText = Color(0xFF4F46E5);

// Error / warning
static const Color errorRedVariant = Color(0xFFE53935);
static const Color warningBg = Color(0xFFFFF9EE);
static const Color warningBorder = Color(0xFFE8D8B7);
static const Color successBg = Color(0xFFEBF3EC);

// Shadows
static const Color shadowLight = Color(0x06000000);
static const Color shadowMedium = Color(0x0A000000);
static const Color shadowDark = Color(0x1A000000);
static const Color shadowWarm = Color(0x061C1816);
```

> لو الأسماء (`white`, `black`) موجودة عندك بالفعل، ماتكررهاش.

## 1.3 Find & Replace على المشروع كله (VS Code: `Ctrl+Shift+H`)

فعّل **Use Regular Expression** (`Alt+R`) وحدد **files to include**: `lib/presentation/**`، و **exclude**: `lib/presentation/resources/**`.

| Find | Replace |
|------|---------|
| `Colors\.transparent` | `ColorManager.transparent` |
| `Color\(0xFF5E48B8\)` | `ColorManager.voiceNotePurple` |
| `Color\(0xFFF0EDFC\)` | `ColorManager.voiceNoteContainer` |
| `Color\(0xFFEEF2FF\)` | `ColorManager.transactionTypeBg` |
| `Color\(0xFF4F46E5\)` | `ColorManager.transactionTypeText` |
| `Color\(0xFFE53935\)` | `ColorManager.errorRedVariant` |
| `Color\(0xFFFFF9EE\)` | `ColorManager.warningBg` |
| `Color\(0xFFE8D8B7\)` | `ColorManager.warningBorder` |
| `Color\(0xFFEBF3EC\)` | `ColorManager.successBg` |
| `Color\(0x06000000\)` | `ColorManager.shadowLight` |
| `Color\(0x0A000000\)` | `ColorManager.shadowMedium` |
| `Color\(0x1A000000\)` | `ColorManager.shadowDark` |
| `Color\(0x061C1816\)` | `ColorManager.shadowWarm` |
| `Colors\.white\b` | `ColorManager.white` |
| `Colors\.black\.withAlpha\(90\)` | `ColorManager.black.withAlpha(90)` |
| `Colors\.black\b` | `ColorManager.black` |

بعد الـ replace: الـ `const` قدام الـ widget اللي جواه `ColorManager.xxx` هيفضل شغال طالما الـ constants `static const`. وكل ملف محتاج `import` للـ ColorManager، والـ VS Code بيقترحه بـ `Ctrl+.`.

> ملاحظة: `Colors.white` ممكن يتأثر في ملفات فيها theme بتستخدمه عن قصد. راجع بسرعة بعد الـ replace وشغل التطبيق.

## 1.4 Logger (بدل `print`)

ملف جديد `lib/app/app_logger.dart`:

```dart
import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';

class AppLogger {
  const AppLogger._();

  static void d(String message, {String tag = 'Mizan'}) {
    if (kDebugMode) {
      developer.log(message, name: tag);
    }
  }

  static void e(String message, {Object? error, StackTrace? stackTrace, String tag = 'Mizan'}) {
    if (kDebugMode) {
      developer.log(message, name: tag, error: error, stackTrace: stackTrace);
    }
  }
}
```

بدّل الـ `print(...)` في 3 أماكن:
- `send_otp/cubit/send_otp_cubit/send_otp_cubit.dart` سطر 46
- `resources/media_type_enum.dart` سطر 11
- `register/cubit/register_cubit.dart` سطر 48

```dart
// قبل
print('error: $e');
// بعد
AppLogger.e('error', error: e);
```

---

# الأنماط المتكررة (Patterns)

## Pattern A — tab / filter index (من `setState` إلى متغير في الـ State)

**هيتعدل فين:**
| الملف | التعديل |
|-------|---------|
| `transactions/get_list_transaction/get_list_transaction_state.dart` | ضيف `selectedFilterIndex` |
| `transactions/get_list_transaction/get_list_transaction_cubit.dart` | ضيف method `changeFilter` |
| `transactions/transactions_view.dart` | شيل `_selectedFilterIndex` و `setState` (سطور 90, 833, 864)، واستخدم `BlocBuilder` |
| `statistics/statistics_state.dart` + `statistics_cubit.dart` + `statistics_view.dart` | نفس الفكرة لـ `selectedTabIndex` (سطور 113, 144, 160, 164, 1372, 1392, 1421) |

**اكتب إيه قبل ما تبدأ:** إيه اللي بيتغير لما الـ index يتغير؟ (لو بيفلتر القايمة، الفلترة هتتعمل في الـ Cubit مش في الـ view.)

**1) الـ State** — ضيف المتغير الجديد بعد `data`:

```dart
@freezed
abstract class GetListTransactionState with _$GetListTransactionState {
  const factory GetListTransactionState({
    FlowState? flowState,
    List<TransactionModel>? data,          // موجود عندك أصلاً
    @Default(0) int selectedFilterIndex,   // ← جديد (كان _selectedFilterIndex)
  }) = _GetListTransactionState;
}
```

**2) الـ Cubit** — ضيف method:

```dart
void changeFilter(int index) {
  if (state.selectedFilterIndex == index) return;
  emit(state.copyWith(selectedFilterIndex: index));
  // لو الفلتر بيجيب داتا جديدة من السيرفر: loadTransactions(filterIndex: index);
}
```

**3) الـ View:**

```dart
// الـ widget اللي بيعرض الـ chips بس هو اللي بيتبني
class TransactionFilterChips extends StatelessWidget {
  const TransactionFilterChips({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetListTransactionCubit, GetListTransactionState>(
      buildWhen: (GetListTransactionState p, GetListTransactionState c) =>
          p.selectedFilterIndex != c.selectedFilterIndex,
      builder: (BuildContext context, GetListTransactionState state) {
        return FilterChipsRow(
          selectedIndex: state.selectedFilterIndex,
          onSelected: (int i) =>
              context.read<GetListTransactionCubit>().changeFilter(i),
        );
      },
    );
  }
}
```

بعدها `transactions_view` لو بقى من غير controllers → `StatelessWidget`.

---

## Pattern B — عداد OTP (من `ValueNotifier` + `Timer` إلى الـ State)

**هيتعدل فين:**
| الملف | التعديل |
|-------|---------|
| `send_otp/cubit/send_otp_state.dart` | ضيف `secondsLeft` و `emailTouched` |
| `send_otp/cubit/send_otp_cubit/send_otp_cubit.dart` | ضيف `startTimer()` و `touchEmail()` و `close()`، وبدّل `print` (سطر 46) بـ `AppLogger` |
| `send_otp/send_otp_view.dart` | امسح `ValueNotifier` (سطور 74, 84, 764, 770, 821, 835) و `_startTimer()` (109-141) و `setState` (227) |

**اكتب إيه قبل ما تبدأ:** مين بيبدأ العداد؟ (بعد نجاح `sendOtp`.) مين بيوقفه؟ (الـ Cubit في `close()`.)

الكود الكامل (State + Cubit + View) موجود في **Part 2 القسم 4**، انسخه منه وطابق الأسماء.

الخلاصة اللي تتطبق على الـ view:
- الشاشة كلها: `BlocConsumer` فيه `buildWhen: p.flowState != c.flowState`.
- نص العداد: `BlocBuilder` منفصل فيه `buildWhen: p.secondsLeft != c.secondsLeft`.
- زرار "إعادة الإرسال": `onPressed: () => context.read<SendOtpCubit>().retry()` ومفعّل لما `state.secondsLeft == 0`.

---

## Pattern C — touched flags (من `setState` إلى متغيرات في الـ State)

**هيتعدل فين:**
| الملف | المتغيرات الجديدة في الـ State | الـ method في الـ Cubit |
|-------|-------------------------------|-------------------------|
| `register/cubit/register_state.dart` + `register_cubit.dart` | `firstNameTouched`, `lastNameTouched`, `emailTouched` | `touchFirstName()`, `touchLastName()`, `touchEmail()` |
| `register/register_view.dart` (181, 201, 221) | شيل `_firstNameTouched` و `_lastNameTouched` و `_emailTouched` و كل `setState` | — |
| `select_user_type/.../select_user_type_state.dart` + cubit | `shopNameTouched`, `selectedType` | `touchShopName()`, `selectType(UserType type)` |
| `select_user_type/select_user_type_view.dart` (96, 342, 357, 411, 531) | شيل `setState` | — |

**اكتب إيه قبل ما تبدأ:** لكل حقل في الـ form: هل ليه touched flag؟ هل ليه validation؟ (الـ validation ينتقل للـ Cubit.)

**1) الـ State:**

```dart
@freezed
abstract class RegisterState with _$RegisterState {
  const factory RegisterState({
    FlowState? flowState,
    RegisterResponseModel? data,            // موجود عندك
    @Default(false) bool firstNameTouched,  // ← جديد
    @Default(false) bool lastNameTouched,   // ← جديد
    @Default(false) bool emailTouched,      // ← جديد
  }) = _RegisterState;
}
```

**2) الـ Cubit:**

```dart
void touchFirstName() {
  if (state.firstNameTouched) return;
  emit(state.copyWith(firstNameTouched: true));
}

void touchLastName() {
  if (state.lastNameTouched) return;
  emit(state.copyWith(lastNameTouched: true));
}

void touchEmail() {
  if (state.emailTouched) return;
  emit(state.copyWith(emailTouched: true));
}

// الـ validation في الـ Cubit مش في الـ view
String? validateEmail(String value) {
  if (value.isEmpty) return AppStrings.emailRequired;
  if (!AppRegex.email.hasMatch(value)) return AppStrings.emailInvalid;
  return null;
}
```

**3) الـ View** — الحقل لوحده بـ `BlocBuilder`:

```dart
class EmailField extends StatelessWidget {
  const EmailField({super.key, required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterCubit, RegisterState>(
      buildWhen: (RegisterState p, RegisterState c) =>
          p.emailTouched != c.emailTouched,
      builder: (BuildContext context, RegisterState state) {
        return AppTextField(
          controller: controller,
          onChanged: (_) => context.read<RegisterCubit>().touchEmail(),
          errorText: state.emailTouched
              ? context.read<RegisterCubit>().validateEmail(controller.text)
              : null,
        );
      },
    );
  }
}
```

> الـ `TextEditingController` يفضل في `StatefulWidget` (الصفحة أو الحقل) مع `dispose()`، وده الاستخدام الوحيد المسموح لـ `StatefulWidget`.

---

## Pattern D — Debounce البحث (من الـ widget إلى الـ Cubit)

**هيتعدل فين:**
| الملف | التعديل |
|-------|---------|
| `customers/contacts_cubit/contacts_state.dart` | ضيف `query` |
| `customers/contacts_cubit/contacts_cubit.dart` | ضيف `onSearchChanged` + `_debounceTimer` + `close()` |
| `customers/widgets/contacts_search_bar.dart` (سطر 54) | امسح الـ `Timer` ونادي `onSearchChanged` بس |
| `transactions/get_list_transaction/get_list_transaction_cubit.dart` | اتأكد إن `close()` بيلغي `_debounceTimer` |

**1) الـ State:**

```dart
@freezed
abstract class ContactsState with _$ContactsState {
  const factory ContactsState({
    FlowState? flowState,
    List<ContactModel>? data,     // موجود عندك
    @Default('') String query,    // ← جديد
  }) = _ContactsState;
}
```

**2) الـ Cubit:**

```dart
Timer? _debounceTimer;

void onSearchChanged(String value) {
  _debounceTimer?.cancel();
  _debounceTimer = Timer(AppDurations.searchDebounce, () {
    if (isClosed) return;
    emit(state.copyWith(query: value.trim()));
    loadContacts(query: value.trim()); // الـ method الموجودة عندك
  });
}

@override
Future<void> close() {
  _debounceTimer?.cancel();
  return super.close();
}
```

**3) الـ View (`contacts_search_bar.dart`):**

```dart
onChanged: (String value) =>
    context.read<ContactsCubit>().onSearchChanged(value),
```

وفي `AppDurations`: `static const Duration searchDebounce = Duration(milliseconds: 400);`

---

## Pattern E — إخراج الـ logic من الـ view (لونين الـ type)
**يتطبق على:** `transaction_by_id_view.dart` سطور 1069-1089 (`_getTypeColor` و `_getTypeTextColor`).

الأسهل: اعمل extension/mapper في طبقة الـ presentation (مش جوه الـ widget):

```dart
// transactions/get_transaction_by_id/transaction_type_style.dart
import 'package:flutter/material.dart';

class TransactionTypeStyle {
  const TransactionTypeStyle({required this.background, required this.text});
  final Color background;
  final Color text;
}

// الـ Cubit/State بيطلع الـ style جاهز
extension TransactionTypeStyleX on String {
  TransactionTypeStyle get typeStyle {
    switch (this) {
      case 'sale':
        return const TransactionTypeStyle(
          background: ColorManager.successBg,
          text: ColorManager.success,
        );
      // ... باقي الأنواع نفس الـ switch اللي موجود عندك
      default:
        return const TransactionTypeStyle(
          background: ColorManager.transactionTypeBg,
          text: ColorManager.transactionTypeText,
        );
    }
  }
}
```

انقل الـ `switch` الحالي كما هو، وبدّل الألوان بـ `ColorManager.*`، وفي الـ view استخدم `transaction.type.typeStyle`. الأنظف: الـ Cubit يحسب `typeStyle` في الـ State.

---

# الخطوة 5 — Onboarding

**هيتعدل فين:**
| الملف | التعديل |
|-------|---------|
| `onboarding/cubit/onboarding_state.dart` | ملف جديد (أو عدّل الموجود) |
| `onboarding/cubit/onboarding_cubit.dart` | ملف جديد: `complete()` + inject للـ `OnboardingLocalDataSource` |
| `onboarding/onboarding_view.dart` سطر 200-201 | امسح `getIt<OnboardingLocalDataSource>().markOnboardingAsSeen()` ونادي الـ Cubit |
| `onboarding/onboarding_view.dart` (`_getFooterWidget()`) | حوّلها لـ class `OnboardingFooter` (Pattern F) |

**اكتب إيه قبل ما تبدأ:** مفيش API هنا، فـ `data` مش محتاجة model. هنستخدم `bool completed` متغير جديد.

**1) الـ State:**

```dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mizan/presentation/common/state_randrer/state_randrer_impl.dart';

part 'onboarding_state.freezed.dart';

@freezed
abstract class OnboardingState with _$OnboardingState {
  const factory OnboardingState({
    FlowState? flowState,
    @Default(false) bool completed,   // ← جديد
  }) = _OnboardingState;
}
```

**2) الـ Cubit:**

```dart
@injectable
class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit(this._localDataSource) : super(const OnboardingState());

  final OnboardingLocalDataSource _localDataSource;

  Future<void> complete() async {
    await _localDataSource.markOnboardingAsSeen();
    if (isClosed) return;
    emit(state.copyWith(completed: true));
  }
}
```

**3) الـ View:**

```dart
BlocProvider<OnboardingCubit>(
  create: (BuildContext context) => getIt<OnboardingCubit>(),
  child: const OnboardingBody(),
)

// داخل OnboardingBody
BlocConsumer<OnboardingCubit, OnboardingState>(
  listenWhen: (OnboardingState p, OnboardingState c) => p.completed != c.completed,
  listener: (BuildContext context, OnboardingState state) {
    if (state.completed) {
      Navigator.of(context).pushReplacementNamed(Routes.loginRoute);
    }
  },
  buildWhen: (OnboardingState p, OnboardingState c) => p.flowState != c.flowState,
  builder: (BuildContext context, OnboardingState state) =>
      const OnboardingContent(),
)

// الزرار
onPressed: () => context.read<OnboardingCubit>().complete(),
```

---

## Pattern F — تحويل `_buildXxx()` إلى widget class

قبل:
```dart
Widget _buildHeader() {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: Text(title),
  );
}
// في build: _buildHeader(),
```

بعد (ملف جديد في `feature/widgets/`):
```dart
class TransactionsHeader extends StatelessWidget {
  const TransactionsHeader({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppPadding.p16),
      child: Text(title),
    );
  }
}
// في build: TransactionsHeader(title: title),
```

قواعد سريعة:
- كل `_buildXxx` بياخد متغيرات من الـ State/الـ widget → خليهم `final` parameters.
- لو `_buildXxx` بيستخدم `setState` أو callback → مرّر `VoidCallback`/`ValueChanged<T>`.
- الـ constructor لازم `const`.
- الملفات الكبيرة (`create_voice_note_view` و `statistics_view`): اقسمها كل section (header / list / bottom bar) لملف. اشتغل فيها آخر حاجة.

---

# الخطوة 9 — `dynamic` في الـ data layer

## 9.1 `data/network/error_handler.dart` (سطور 11, 69, 116)

```dart
// قبل
ErrorHandler.handle(dynamic error)
// بعد
ErrorHandler.handle(Object error)
```

ولو بتقرا الـ response data:

```dart
// قبل
Failure _handleResponse(dynamic data) { ... }

// بعد
Failure _handleResponse(Object? data) {
  if (data is Map<String, Object?>) {
    final Object? message = data['message'];
    if (message is String) return Failure(message);
  }
  return const Failure(AppStrings.unknownError);
}
```

> `Object?` + `is` check بدل `dynamic` calls. ده بيرضي `avoid_dynamic_calls`.

## 9.2 `data/data_source/auth_remote_data_source.dart` (سطور 7-26)

اعمل request classes typed بنفس أسلوب المشروع الموجود (لو مفيش أسلوب، `freezed` مع `toJson`) **من غير ما تغيّر الـ keys اللي بتتبعت للسيرفر**. ده بيخص الـ requests بس، الـ Response بيفضل زي ما هو والـ parsing بتاعه في الـ Response classes:

```dart
@freezed
abstract class VerifyOtpRequest with _$VerifyOtpRequest {
  const factory VerifyOtpRequest({
    required String email,
    required String otp,
  }) = _VerifyOtpRequest;

  factory VerifyOtpRequest.fromJson(Map<String, dynamic> json) =>
      _$VerifyOtpRequestFromJson(json);
}
```
> ماتغيّرش أسماء الـ keys اللي السيرفر بيستناها. استخدم `@JsonKey(name: 'otp_code')` لو لازم.

وفي الـ data source:
```dart
// قبل
Future<Response<...>> verifyOtp(Map<String, dynamic> body);
// بعد
Future<...> verifyOtp(VerifyOtpRequest request); // وجواها: request.toJson()
```
نفس الشيء لـ `selectUserType` و `logout`.

## 9.3 `routes_manager.dart` — `Route<dynamic>`
**سيبه زي ما هو.** Flutter نفسه بيطلب `Route<dynamic>` في `onGenerateRoute`، وتغييره لـ `Route<Object?>` هيكسر الـ build. استثناء مقبول (ضيف تعليق `// required by Flutter's RouteFactory signature`).

## 9.4 `auth_interceptor.dart` سطر 87
سيبه (network boundary) أو غيّر لـ `Map<String, Object?>.from(o.headers)` لو كمل الـ compile.

---

# الخطوة 10 — Drawer + الصور

## 10.1 `home/widgets/mizan_drawer.dart` سطر 34

```dart
// قبل
ListView(children: <Widget>[ item1, item2, ... ])

// بعد
final List<DrawerItemData> items = DrawerItems.all; // const list في ملف constants

ListView.builder(
  itemCount: items.length,
  itemBuilder: (BuildContext context, int index) {
    return DrawerItem(data: items[index]);
  },
)
```

## 10.2 `AppCachedImage`

> التقرير لقى صفر `Image.network` و صفر `CachedNetworkImage`. اتأكد الأول: ابحث عن أي حقل URL لصورة (`avatar`, `image`, `photo`, `imageUrl`) في الـ models. لو مفيش صور من الإنترنت، **ماتضيفش** الـ package ومتكتبش الـ widget.

لو فيه صور:
```bash
flutter pub add cached_network_image
```

```dart
// lib/presentation/common/widgets/app_cached_image.dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class AppCachedImage extends StatelessWidget {
  const AppCachedImage({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
  });

  final String url;
  final double? width;
  final double? height;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: url,
      width: width,
      height: height,
      fit: fit,
      memCacheWidth: width == null ? null : (width! * MediaQuery.devicePixelRatioOf(context)).round(),
      placeholder: (BuildContext context, String url) =>
          const Center(child: CircularProgressIndicator(strokeWidth: 2)),
      errorWidget: (BuildContext context, String url, Object error) =>
          const Icon(Icons.broken_image_outlined),
    );
  }
}
```

---

# الخطوة 3-4-8 — باقي الـ features (ملخص لكل ملف)

| الملف | اللي يتعمل |
|-------|-----------|
| `register_view.dart` (181,201,221) | Pattern C (touched flags في `RegisterState`)، حوّله `StatelessWidget` لو مفيش controllers، وبدّل `print` في `register_cubit.dart` |
| `select_user_type_view.dart` (96,342,357,411,531) | Pattern C: ضيف `selectedType` و `shopNameTouched` في state الـ feature |
| `auth_verification.dart` | اتأكد إن الـ `setState` للـ controllers/focus، وانقل أي حالة لـ Cubit، وسيبه `StatefulWidget` لو فيه controllers |
| `get_voice_note_view.dart` (10 setState) | الـ playing state والـ position والـ recording flags في `GetVoiceNoteCubit` state. الـ `AnimationController`/`AudioPlayer` يفضل في `State` أو في Cubit مع `close()` |
| `get_voice_note_by_id_view.dart` (66,70,75,83) | نفس اللي فوق |
| `create_voice_note_view.dart` (16 setState) | recording/timer/playback → `CreateVoiceNoteCubit` state. الـ Timer يتنقل للـ Cubit (Pattern B) |
| `contact_picker_bottom_sheet.dart` (175+) | search/selection → Cubit state |
| `customers_view.dart` / `contact_form_view.dart` | Pattern A / C |
| `quick_sale_view.dart` / `quick_purchase_view.dart` | `Colors.black` → ColorManager (الـ replace عمله)، و`_build` → Pattern F |
| `pay_installment_sheet.dart` | نفس اللي فوق |
| `installments_view.dart` + history | `setState` → Cubit state، و`_build` → Pattern F |

**قاعدة ثابتة لأي setState تقابله:**
1. اسأل: ده بيتغير؟ → field في الـ Cubit state.
2. اعمل method في الـ Cubit تغيره.
3. الـ view تقرا بـ `BlocBuilder` (أصغر widget) وتنادي method الـ Cubit.
4. لو الـ widget مبقاش فيه controllers → `StatelessWidget`.

---

# الخطوة 11 — Splash Preload (آخر حاجة)

**هيتعدل فين:**
| الملف | التعديل |
|-------|---------|
| `splash/cubit/splash_state.dart` | موجود عندك (`flowState` + `data`)، مفيش تعديل |
| `splash/cubit/splash_cubit.dart` | اكتب `preload()` الكامل (تحت) |
| `splash/splash_view.dart` | امسح `_splashCubit.close()` (سطر 214) وامسح `_navigate()` و `_destination` (سطور 178-185) وانقل الـ navigation للـ listener |
| `resources/app_durations.dart` | ضيف `splashMin` و `splashTimeout` |
| الـ Cubits اللي داتاها تفضل بعد الـ splash (Home/Profile...) | غيّر `@injectable` لـ `@lazySingleton` |

**اكتب إيه قبل ما تبدأ:**
1. إيه الشاشات اللي بتحتاج داتا من السيرفر أول ما تفتح؟ (Home/Profile/Config...) دول اللي يتحملوا في الـ splash.
2. كل واحدة فيهم ليها method `load()` في الـ Cubit بتاعها.
3. الـ Cubits دي لازم `@lazySingleton` عشان نفس الـ instance (الداتا جاهزة) تتستخدم بعد الـ splash.

**الـ State (موجود عندك):**

```dart
enum SplashDestination { home, login, onboarding }

@freezed
abstract class SplashState with _$SplashState {
  const factory SplashState({
    FlowState? flowState,
    SplashDestination? data,
  }) = _SplashState;
}
```

**الـ Cubit:**

```dart
@injectable
class SplashCubit extends Cubit<SplashState> {
  SplashCubit(this._session, this._onboarding, this._homeCubit)
      : super(const SplashState());

  final SessionLocalDataSource _session;      // اسم افتراضي
  final OnboardingLocalDataSource _onboarding;
  final HomeCubit _homeCubit;                 // لازم @lazySingleton

  Future<void> preload() async {
    emit(state.copyWith(
      flowState: LoadingState(
        stateRendererType: StateRendererType.fullScreenLoadingState,
        message: AppStrings.loading,
      ),
    ));

    final Future<void> minDelay = Future<void>.delayed(AppDurations.splashMin);

    try {
      final SplashDestination destination =
          await _decideDestination().timeout(AppDurations.splashTimeout);
      await minDelay;
      if (isClosed) return;
      emit(state.copyWith(flowState: ContentState(), data: destination));
    } on TimeoutException {
      await minDelay;
      if (isClosed) return;
      emit(state.copyWith(
        flowState: ContentState(),
        data: await _fallbackDestination(),
      ));
    } on Object catch (e, s) {
      AppLogger.e('splash preload failed', error: e, stackTrace: s);
      if (isClosed) return;
      emit(state.copyWith(
        flowState: ErrorState(
          StateRendererType.fullScreenErrorState,
          AppStrings.somethingWentWrong,
        ),
      ));
    }
  }

  Future<SplashDestination> _decideDestination() async {
    if (!await _onboarding.isOnboardingSeen()) return SplashDestination.onboarding;
    if (!await _session.hasValidToken()) return SplashDestination.login;

    // داتا البداية بالتوازي (ضيف كل Cubit/use case محتاجه)
    await Future.wait<void>(<Future<void>>[
      _homeCubit.load(),
      // _profileCubit.load(),
    ]);
    return SplashDestination.home;
  }

  Future<SplashDestination> _fallbackDestination() async {
    return await _session.hasValidToken()
        ? SplashDestination.home
        : SplashDestination.login;
  }
}
```

> أسماء `SessionLocalDataSource` و `isOnboardingSeen()` و `hasValidToken()` و `_homeCubit.load()` افتراضية. 401 (token منتهي) لازم يرجع `SplashDestination.login` من `hasValidToken()` أو من الـ interceptor.

**الـ View:**

```dart
class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SplashCubit>(
      create: (BuildContext context) => getIt<SplashCubit>()..preload(),
      child: const SplashBody(),
    );
  }
}

class SplashBody extends StatelessWidget {
  const SplashBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SplashCubit, SplashState>(
      listenWhen: (SplashState p, SplashState c) => p.data != c.data,
      listener: (BuildContext context, SplashState state) {
        final SplashDestination? destination = state.data;
        if (destination == null) return;
        final String route = switch (destination) {
          SplashDestination.onboarding => Routes.onboardingRoute,
          SplashDestination.login => Routes.loginRoute,
          SplashDestination.home => Routes.homeRoute,
        };
        Navigator.of(context).pushReplacementNamed(route);
      },
      buildWhen: (SplashState p, SplashState c) => p.flowState != c.flowState,
      builder: (BuildContext context, SplashState state) {
        return state.flowState?.getScreenWidget(
              context,
              const SplashAnimation(),
              () => context.read<SplashCubit>().preload(),
            ) ??
            const SplashAnimation();
      },
    );
  }
}
```

في `AppDurations`:
```dart
static const Duration splashMin = Duration(seconds: 2);
static const Duration splashTimeout = Duration(seconds: 12);
```

> الـ `precacheImage` لصور الشبكة (لو فيه) من الـ listener. الـ cache المحلي للداتا (Hive/SharedPreferences) جوه الـ repository.

---

# Checklist نهائي

- [ ] `grep` للأوامر في أول الملف كلها رجعت فاضية (ما عدا `Route<dynamic>` والـ `fromJson`/`toJson`)
- [ ] `dart run build_runner build --delete-conflicting-outputs` بدون errors
- [ ] `flutter analyze` = 0 issues
- [ ] `flutter run` وجرّب: OTP (العداد + إعادة الإرسال)، register، select_user_type، onboarding → login، transactions filter، statistics tabs، voice note، customers search
- [ ] `flutter build apk --release` بينجح
- [ ] الـ splash مش بيعلق (جرّب من غير نت)


---

# PART 4 — VIOLATIONS REPORT (scan results: exact files and lines to fix)

> Generated: 2026-10-02 | Scan: `lib/` (presentation, data, app, domain layers)
> Status: **SCAN ONLY — no code changed yet**

---

## Rule 1 — `setState` Forbidden

| File | Lines (sample) |
|------|---------------|
| `presentation/voice_note/get_voice_note_cubit/get_voice_note_view.dart` | 86, 92, 102, 134, 143, 156, 168, 434, 465, 496 |
| `presentation/voice_note/get_voice_note_by_id_cubit/get_voice_note_by_id_view.dart` | 66, 70, 75, 83 |
| `presentation/voice_note/create_voice_note_cubit/create_voice_note_view.dart` | 101, 110, 118, 127, 162, 175, 203, 209, 216, 233, 248, 254, 273, 303, 936, 1156 |
| `presentation/transactions/transactions_view.dart` | 90, 833, 864 |
| `presentation/statistics/statistics_view.dart` | 113, 144, 160, 164, 1372, 1392, 1421 |
| `presentation/send_otp/send_otp_view.dart` | 227 |
| `presentation/select_user_type/select_user_type_view.dart` | 96, 342, 357, 411, 531 |
| `presentation/register/register_view.dart` | 181, 201, 221 |
| `presentation/operations/widgets/contact_picker_bottom_sheet.dart` | 175 + more |
| `presentation/customers/customers_view.dart` | (detected via StatefulWidget scan) |
| `presentation/customers/contact_form_view.dart` | (detected via StatefulWidget scan) |
| `presentation/auth_verification/auth_verification.dart` | (detected via StatefulWidget scan) |

**Summary:** 11+ files, 50+ `setState` calls. The states managed by `setState` (selected tab index, filter index, playing state, timer countdown, form touch flags, recording state, audio playback position, etc.) must all move into Cubit states with `@freezed`.

---

## Rule 1b — `ValueNotifier` / `ValueListenableBuilder` used instead of Cubit state

| File | Lines |
|------|-------|
| `presentation/send_otp/send_otp_view.dart` | 74, 84, 764, 770, 821, 835 — `ValueNotifier<int>` for countdown timer |

**Fix:** Timer countdown state must go into `SendOtpCubit` as a freezed state field.

---

## Rule 1c — `StatefulWidget` used where only reason is `setState` (must convert to `StatelessWidget`)

Stateful widgets that hold `setState`-only state (i.e., the widget has no controllers/animations that justify being stateful):

| File | Violating state field |
|------|----------------------|
| `presentation/transactions/transactions_view.dart` | `_selectedFilterIndex` |
| `presentation/statistics/statistics_view.dart` | `_selectedTabIndex` |
| `presentation/send_otp/send_otp_view.dart` | `_emailTouched`, timer |
| `presentation/register/register_view.dart` | `_firstNameTouched`, `_lastNameTouched`, `_emailTouched` |
| `presentation/select_user_type/select_user_type_view.dart` | `_shopNameTouched` + type selection |

> Note: `StatefulWidget` is **allowed** where it owns controllers/AnimationControllers (splash, auth_verification, voice_note views, etc.) — those are NOT violations for the widget type itself, but the `setState` calls inside them are still violations.

---

## Rule 2 — Logic / Side Effects in Views

| File | Violation |
|------|-----------|
| `presentation/onboarding/onboarding_view.dart` L200–201 | Calls `getIt<OnboardingLocalDataSource>().markOnboardingAsSeen()` directly in the view — this is a data/business operation. Must move to `OnboardingCubit`. |
| `presentation/splash/splash_view.dart` L178–185 | `_progressController` status listener sets `_animationFinished` and calls `_navigate()` with `_destination` — navigation decision logic (`switch` on destination) lives inside `_navigate()` in the view; navigation must happen from the `listener` of `BlocConsumer` reacting to a Cubit state. |
| `presentation/transactions/transaction_by_id_view.dart` L1069–1089 | Helper methods `_getTypeColor()` / `_getTypeTextColor()` return `Color` based on business `type` — this is a formatting/business decision inside a view. |
| `presentation/send_otp/send_otp_view.dart` L109–141 | `_startTimer()` method with its own `Timer` lives in the view; timer countdown is business logic and must live in `SendOtpCubit`. |
| `presentation/customers/widgets/contacts_search_bar.dart` L54 | Debounce `Timer` created directly in a widget — debounce logic belongs in `ContactsCubit`. |

---

## Rule 3 — Dispose / Resource Leaks

Most views **do** call `dispose()` on controllers — ✅ generally compliant.  
However:

| File | Issue |
|------|-------|
| `presentation/splash/splash_view.dart` L214 | `_splashCubit.close()` called manually — Cubits provided via `BlocProvider` are auto-closed; calling `.close()` manually here may cause double-close issues. |
| `presentation/customers/contacts_cubit/contacts_cubit.dart` | Owns a `_debounceTimer` — need to verify it is cancelled in `close()`. |
| `presentation/transactions/get_list_transaction/get_list_transaction_cubit.dart` | Owns a `_debounceTimer` — need to verify it is cancelled in `close()`. |
| All cubits with `isClosed` check | ✅ Good — `isClosed` is already used before `emit` in async code (multiple cubits). |

---

## Rule 4 — `Image.network` / `NetworkImage`

- **`Image.network`**: No occurrences found ✅
- **`NetworkImage`**: No occurrences found ✅
- **`CachedNetworkImage`**: **Zero usages found anywhere in `lib/`** ❌

**Violation:** Network images may be loaded elsewhere (e.g., profile avatars, transaction contacts). Need to audit any place a URL string from a model is passed to an image widget. Once found, they must use `CachedNetworkImage` via a shared `AppCachedImage` widget.  
Also: **no shared `AppCachedImage` widget exists** — it must be created.

---

## Rule 5 — Flat Widget Tree / No `_buildXxx()` Helper Methods

| File | Issue |
|------|-------|
| `presentation/voice_note/get_voice_note_cubit/get_voice_note_view.dart` | Uses `_build...()` helper methods; file is 800+ lines |
| `presentation/voice_note/get_voice_note_by_id_cubit/get_voice_note_by_id_view.dart` | `_build...()` helpers |
| `presentation/voice_note/create_voice_note_cubit/create_voice_note_view.dart` | `_build...()` helpers; file is 1400+ lines |
| `presentation/transactions/transactions_view.dart` | `_build...()` helpers |
| `presentation/transactions/pay_installment/pay_installment_sheet.dart` | `_build...()` helpers |
| `presentation/transactions/get_transaction_by_id/transaction_by_id_view.dart` | `_build...()` helpers |
| `presentation/statistics/statistics_view.dart` | `_build...()` helpers; file is 1400+ lines |
| `presentation/send_otp/send_otp_view.dart` | `_build...()` helpers |
| `presentation/select_user_type/select_user_type_view.dart` | `_build...()` helpers |
| `presentation/register/register_view.dart` | `_build...()` helpers |
| `presentation/operations/quick_sale_view.dart` | `_build...()` helpers |
| `presentation/operations/quick_purchase_view.dart` | `_build...()` helpers |
| `presentation/onboarding/onboarding_view.dart` | `_getFooterWidget()` method |
| `presentation/installments/installments_view.dart` | `_build...()` helpers |
| `presentation/installments/installments_history/installments_history_view.dart` | `_build...()` helpers |
| `presentation/home.dart` | 10793-byte file — `_build...()` helpers |
| `presentation/home/widgets/recent_transactions_section.dart` | `_build...()` helpers |
| `presentation/customers/customers_view.dart` | `_build...()` helpers |
| `presentation/customers/contact_profile_view.dart` | `_build...()` helpers |
| `presentation/customers/contact_form_view.dart` | `_build...()` helpers |
| `presentation/auth_verification/auth_verification.dart` | `_build...()` helpers |

**Rule:** All `_buildXxx()` helper methods returning widgets must be extracted to `const StatelessWidget` classes.

---

## Rule 6 — Performance (`const`, `ListView.builder`)

| File | Issue |
|------|-------|
| `presentation/home/widgets/mizan_drawer.dart` L34 | `ListView(children: [...])` — must use `ListView.builder` |

`const` coverage not fully audited yet (requires `flutter analyze` output) — will be verified post-analysis.

---

## Rule 7 — Dependency Injection ✅ (mostly compliant)

All Cubits are obtained via `getIt<...>()` in the view layer. ✅  
One notable issue:

| File | Issue |
|------|-------|
| `presentation/onboarding/onboarding_view.dart` L200–201 | `getIt<OnboardingLocalDataSource>()` called directly in view — data source must only be used by Cubits/repositories, not views. |

---

## Rule 8 — Strict Typing / `dynamic` / `print()`

### `print()` violations (3 occurrences):
| File | Line |
|------|------|
| `presentation/send_otp/cubit/send_otp_cubit/send_otp_cubit.dart` | 46 |
| `presentation/resources/media_type_enum.dart` | 11 |
| `presentation/register/cubit/register_cubit.dart` | 48 |

### `dynamic` violations (outside `fromJson`/`toJson`):
| File | Issue |
|------|-------|
| `presentation/resources/routes_manager.dart` L84, L193 | `Route<dynamic>` return type — should be `Route<Object?>` |
| `data/network/error_handler.dart` L11, L69, L116 | `dynamic error`, `dynamic data`, `dynamic errors` params — must be typed (e.g., `Object`, `Map<String, Object?>`) |
| `data/network/auth_interceptor.dart` L87 | `Map<String, dynamic>.from(o.headers)` — acceptable at network boundary but could be `Map<String, Object?>` |
| `data/data_source/auth_remote_data_source.dart` L7–26 | `Map<String, dynamic>` params for `verifyOtp`, `selectUserType`, `logout` — these are request bodies; should use typed request classes |

> Note: All `dynamic` in generated `.g.dart` files (`app_api.g.dart`, `*.g.dart` response files) are **auto-generated** and are allowed per Rule 8's exception for `fromJson`/`toJson` boundaries.

---

## Rule 9 — Hard-Coded Strings / Colors / Sizes

### Hard-coded `Color(0xFF...)` / `Colors.xxx` in views (outside `resources/`):

| File | Sample violations |
|------|-------------------|
| `presentation/voice_note/get_voice_note_cubit/get_voice_note_view.dart` | `Color(0xFF5E48B8)`, `Color(0xFFF0EDFC)`, `Color(0x06000000)`, `Colors.transparent` |
| `presentation/voice_note/get_voice_note_by_id_cubit/get_voice_note_by_id_view.dart` | `Color(0x0A000000)`, `Color(0xFF5E48B8)`, `Color(0xFFF0EDFC)`, `Colors.transparent` |
| `presentation/voice_note/create_voice_note_cubit/create_voice_note_view.dart` | `Color(0x0A000000)`, `Color(0xFF5E48B8)`, `Color(0xFFF0EDFC)`, `Colors.white`, `Colors.transparent` |
| `presentation/transactions/transactions_view.dart` | `Color(0x061C1816)`, `Colors.transparent` |
| `presentation/transactions/get_transaction_by_id/transaction_by_id_view.dart` | `Color(0xFFEEF2FF)`, `Color(0xFF4F46E5)` |
| `presentation/send_otp/send_otp_view.dart` | `Color(0x1A000000)`, `Color(0xFFEBF3EC)`, `Color(0xFFFFF9EE)`, `Color(0xFFE8D8B7)`, `Color(0xFFE53935)` |
| `presentation/operations/quick_sale_view.dart` | `Colors.black`, `Colors.transparent` |
| `presentation/operations/quick_purchase_view.dart` | `Colors.black`, `Colors.transparent` |
| `presentation/transactions/pay_installment/pay_installment_sheet.dart` | `Colors.black.withAlpha(90)`, `Colors.transparent` |
| `presentation/statistics/statistics_view.dart` | `Colors.transparent` |
| `presentation/splash/splash_view.dart` | `Colors.transparent` |
| (many more files with `Colors.transparent`) | All `Colors.transparent` should be `ColorManager.transparent` |

**Colors that must be added to `ColorManager`:**
- `Color(0xFF5E48B8)` — voice note type (purple)
- `Color(0xFFF0EDFC)` — voice note type container
- `Color(0xFFEEF2FF)` — transaction type bg
- `Color(0xFF4F46E5)` — transaction type color
- `Color(0xFFE53935)` — error red variant
- `Color(0xFFFFF9EE)`, `Color(0xFFE8D8B7)` — warning tones
- `Colors.transparent` → `ColorManager.transparent`

---

## Rule 9b — `analysis_options.yaml` Missing Required Lints

Current `analysis_options.yaml` only has `include: package:flutter_lints/flutter.yaml` with no custom rules.

**Missing analyzer settings:**
```yaml
analyzer:
  language:
    strict-casts: true
    strict-inference: true
    strict-raw-types: true
linter:
  rules:
    - prefer_const_constructors
    - prefer_const_literals_to_create_immutables
    - prefer_const_declarations
    - avoid_unnecessary_containers
    - sized_box_for_whitespace
    - use_key_in_widget_constructors
    - always_specify_types
    - avoid_dynamic_calls
    - avoid_print
    - always_declare_return_types
    - type_annotate_public_apis
```

---

## Rule 10 — Splash Preload (LAST — do not fix yet)

Current splash state does NOT implement full preload:
- `SplashCubit.decide()` only checks session/onboarding — it does **not** prefetch startup data in parallel with `Future.wait`
- No `SplashState` variants: `initial` / `loading` / `success(destination)` / `failure(message)` — current state is a generic wrapper
- No minimum display time constant in `AppDurations`
- No global timeout for preload
- No prefetching of critical images with `precacheImage`
- No caching of startup data to local storage for instant next-launch

---

## Summary Table

| # | Rule | Severity | Files Affected |
|---|------|----------|---------------|
| 1 | `setState` forbidden | 🔴 Critical | 11+ files, 50+ occurrences |
| 1b | `ValueNotifier` instead of Cubit | 🔴 Critical | 1 file |
| 2 | Logic in views | 🔴 Critical | 5+ files |
| 3 | Dispose leaks | 🟡 Medium | 2–3 cubits |
| 4 | No `CachedNetworkImage` / no `AppCachedImage` | 🔴 Critical | App-wide |
| 5 | Helper `_buildXxx()` methods, deep nesting | 🟡 Medium | 20+ files |
| 6 | `ListView(children:[])` | 🟠 Minor | 1 file |
| 7 | Data source called in view | 🔴 Critical | 1 file |
| 8 | `print()`, `dynamic` outside JSON boundary | 🟠 Minor | 4 files |
| 9 | Hard-coded `Color`/`Colors.xxx` in views | 🟡 Medium | 10+ files |
| 9b | `analysis_options.yaml` incomplete | 🟡 Medium | 1 file |
| 10 | Splash preload not implemented | 🔴 Critical (last) | splash feature |

---

## Proposed Refactor Order (feature-by-feature)

1. **`analysis_options.yaml`** — add all required lints first
2. **Resources** — add missing `ColorManager` entries (transparent, purple tones, etc.)
3. **`send_otp`** — setState → Cubit state, timer → Cubit, ValueNotifier → Cubit
4. **`register`** — setState (touched flags) → Cubit state
5. **`select_user_type`** — setState → Cubit state
6. **`auth_verification`** — setState → Cubit state (if any)
7. **`onboarding`** — move `markOnboardingAsSeen` to Cubit; navigation from listener
8. **`transactions`** — setState (filter index, search) → Cubit state
9. **`statistics`** — setState (tab index, filter) → Cubit state
10. **`voice_note`** — setState (playback state, recording state) → Cubit state
11. **`operations`** — setState → Cubit state
12. **`customers`** — debounce timer → Cubit; setState → Cubit state
13. **`installments`** — setState → Cubit state
14. **`home`** — extract widgets, fix ListView
15. **Shared** — create `AppCachedImage` widget, replace all image usages
16. **`print()`** — replace with logger
17. **`dynamic`** — fix routes_manager, error_handler
18. **`_buildXxx()` helpers** — extract to `const StatelessWidget` classes across all features
19. **Rule 10 — Splash preload** — implement last
