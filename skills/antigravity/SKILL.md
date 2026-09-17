---
name: antigravity
description: >
  Builds the Authentication & Accounts feature (register, send-otp, verify-otp,
  select-user-type, refresh-token, logout, splash session-decision) for a Flutter
  app: data layer through domain to Cubit/State only, no UI. Follows the real,
  verified architecture of the NaderAwny/Glowy repo (get_it + injectable, dio,
  dartz Either results, json_serializable responses with a BaseResponse wrapper,
  the FlowState/StateRendererType renderer pattern), plus one addition: a secure
  access/refresh-token session layer via flutter_secure_storage, an
  onboarding-seen flag via shared_preferences, and an auto-refresh Dio
  AuthInterceptor. Use whenever the user asks to build/finish/wire up login,
  register, OTP, auth, session, token refresh, or splash-decision flow in a
  Flutter project — especially if they say "زي Glowy", "على نهج Glowy", mention
  Mizan API, or reference NaderAwny/Glowy or Tut_App-with-mvvmCleanArc. Do NOT
  use for login/register UI screens or visual design — out of scope by design.
---

# antigravity — Auth & Accounts (Glowy architecture, up to Cubit)

## نطاق الشغل (Scope) — مهم جدًا
هذا الـ skill بيبني **من الـ data layer لحد الـ Cubit/State بس**. **ما ينفعش** يعمل أي
صفحة (`*_page.dart`) أو widget أو أي حاجة UI — ده متروك عمدًا للمستخدم يعمله بنفسه بأداة
تصميم (MCP design server / Visualizer). لو المستخدم طلب صفحة أو شاشة، فكّره إن الاتفاق
كان لغاية الـ Cubit بس واسأله إذا حابب يكمل UI بنفسه أو بأداة تانية.

## قبل ما تكتب أي كود — افحص المشروع الحقيقي
1. اقرأ `pubspec.yaml` بتاع المستخدم لتعرف اسم الـ package الحقيقي (استبدل `glowy` في كل
   الأمثلة بيه) والـ dependencies الموجودة فعلاً.
2. دوّر جوه `lib/` على أي حاجة عاملها المستخدم قبل كده متعلقة بالـ auth (هو قال صراحة إنه
   عمل `register` بطريقته الخاصة). **متبنيش فوق كلامه من غير ما تشوفه.** لو لقيت تنفيذ
   موجود، قارنه بالـ templates هنا وقرر: تدمجه / تعدّله ليتماشى / تسيبه زي ما هو وتكمل
   الباقي حواليه. اعرض على المستخدم القرار قبل ما تمسح أي حاجة موجودة.
3. تأكد إن `flutter_secure_storage` مضافة في `pubspec.yaml` (زيها لو مش موجودة) — دي
   الإضافة الوحيدة الحقيقية فوق باكدجات Glowy الأصلية. باقي الباكدجات (`dio`,
   `json_annotation`+`json_serializable`, `freezed`+`freezed_annotation`, `get_it`,
   `injectable`, `dartz`, `shared_preferences`, `flutter_bloc`) المفروض موجودة أصلاً.
4. اتأكد إن `shared_preferences` مضافة برضه (onboarding flag)، منفصلة تمامًا عن التوكنز.

## المصادر اللي المفروض تشوفها (بالترتيب)
- **`references/glowy_conventions.md`** — قواعد Glowy الحقيقية، مسحوبة من الكود نفسه
  (مش من الـ README ولا من تخمين). اقرأه الأول عشان تعرف تفرّق بين اللي لازم يتاخد
  زي ما هو ("خد ده بالظبط") واللي ينفع يتكيّف مع مشروع المستخدم.
- **`references/api_contract.md`** — عقد الـ Mizan API الحقيقي (مستخرج من الـ Postman
  collection اللي رفعها المستخدم)، الـ 6 endpoints بأشكال الـ request/response بالظبط.
  **استخدم الأشكال دي حرفيًا، ومتفترضش أشكال تانية.**
- **`references/templates.md`** — الكود الكامل لكل ملف مطلوب (data/domain/presentation)،
  جاهز تنسخه وتظبطه على اسم الـ package بتاع المستخدم.

## خطوات التنفيذ
1. اعمل طبقة التوكن الجديدة أولًا (قسم أ في `templates.md`): `TokenLocalDataSource` +
   `SecureTokenLocalDataSource`، `OnboardingLocalDataSource` + الـ shared_prefs impl،
   `AuthInterceptor`، وربطهم في `DioFactory`/`AppModule`/`di.dart` الموجودين فعلاً
   عند المستخدم (عدّل عليهم، متعملش نسخة تانية منفصلة).
2. اعمل الـ Responses (قسم ب): `OtpResponse` و`AuthSessionResponse` بس (مش 6 موديلز —
   الـ endpoints بترجع نفس الشكل في مجموعات، شوف `api_contract.md`).
3. اعمل `domain/model/auth_models.dart` (قسم ج)، الـ mapper (قسم د)، الـ
   `AuthRepository` (قسم هـ)، الـ `AuthRemoteDataSource` (قسم و)، إضافات الـ
   `AppServiceClient` (قسم ز)، الـ `AuthRepositoryImpl` (قسم ح).
4. اعمل الـ 5 Usecases (قسم ط) — `register`, `sendOtp`, `verifyOtp`, `selectUserType`,
   `logout`. الـ `refresh-token` مالوش usecase/cubit — بيحصل جوه الـ interceptor بس.
5. اعمل الـ 5 Cubits المقابلة + `SplashCubit` (قسم ي وك) — كل واحد في فولدر لوحده
   `presentation/auth/<action>_cubit/` بالظبط زي نمط Glowy (`presentation/home/list_app_cubit/`).
6. شغّل `dart run build_runner build --delete-conflicting-outputs` بعد أي تعديل على
   ملفات فيها `@JsonSerializable`/`@freezed`/`@injectable`/`@LazySingleton`، عشان
   `.g.dart`/`.freezed.dart`/`di.config.dart` يتحدّثوا.
7. **قف هنا.** متعملش `*_page.dart` ولا أي widget. قول للمستخدم إن الطبقة لغاية الـ
   Cubit خلصت وجاهزة، وإن الـ UI/design خطوة تانية منفصلة.

## قواعد صارمة (متتجاوزش عنها)
- الأولوية دايمًا لعقد الـ API الحقيقي (`api_contract.md`) فوق أي تخمين، حتى لو موجود
  في أي ملف تاني مرفوع (زي افتراض `status` بدل `success`، أو افتراض إن الموديلز
  freezed — دي افتراضات غلط، اتقالت هي نفسها في الملف الأصلي كـ "أفضل تخمين").
- الأولوية لنمط Glowy الحقيقي (`glowy_conventions.md`) فوق أي نمط متخيَّل — يعني
  Responses بـ `json_serializable` (مش freezed)، وأسماء الفولدرات `data_source`/
  `repository_impl`/`responses`/`mapper` (مش `local`/`repositories` لوحدها من غير
  باقي البنية).
- الإضافة الوحيدة المسموح بيها فوق Glowy: طبقة التوكن (`flutter_secure_storage`) +
  onboarding flag (`shared_preferences`) + `AuthInterceptor` + `SplashCubit`. أي حاجة
  تانية غريبة عن نمط Glowy (زي `Hive` للتوكنز، أو `enum` + `switch` قديم الطراز بدل
  الـ pattern الموجود) — ارجع لنمط Glowy الحقيقي.
- لو فيه تعارض بين حاجة عملها المستخدم بنفسه (زي الـ `register` القديم) وبين الـ
  template هنا: اسأله أو اقترح التوحيد، ومتكسرش الكود الشغال بتاعه من غير مناقشة.
