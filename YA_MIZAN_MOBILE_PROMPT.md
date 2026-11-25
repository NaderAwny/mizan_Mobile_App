# YA_MIZAN — Mobile (Flutter): app + data + domain + presentation state (بدون Views)

> المطلوب: تنفيذ **Feature 11: المساعد الذكي «يا ميزان»** في تطبيق Flutter، من الـ API لحد الـ Cubit والـ State، **بنفس معمارية وأسلوب كتابة الكود الموجود بالظبط**.
> **ممنوع تكتب أي View/Widget/Screen.** الـ Views هتتعمل بعدين من التصميم. المطلوب إن الـ Cubit والـ State يبقوا جاهزين تتربط بيهم أي شاشة.
> الـ Backend جاهز وشغال على السيرفر. ما تلمسش أي حاجة تخصه.

---

## 0. قواعد التشغيل (إلزامية)

1. **Plan-first:** اقرأ المشروع، اعمل Implementation Plan، **وانتظر موافقتي** قبل أي كتابة كود.
2. **اقرأ قبل ما تكتب. ما تفترضش.** الشغل الأساسي هو إنك **تقلّد المشروع**:
   - اقرأ `skills/antigravity/` (فيه إرشادات الشغل بالمشروع) و`README.md` و`analysis_options.yaml` و`pubspec.yaml`.
   - اختار **feature واحدة مكتملة وقريبة** من المطلوب (الأقساط أو الملاحظات الصوتية أو الإشعارات) وخليها **نموذج**. اقرأ من أولها لآخرها: `AppServiceClient` (app_api)، الـ remote data source، الـ repository impl، الـ mapper، الـ response والـ request، الـ use case، الـ cubit والـ state.
   - اكتب في الخطة الـ feature اللي اخترتها كنموذج وليه.
3. **طابق الأسلوب حرفيًا:** أسماء الملفات والكلاسات والـ folders (بما فيها `state_randrer` زي ما هي، لا تصلّحها)، ترتيب الـ imports، طريقة الـ annotations، شكل الـ Failure والـ Either، تسمية الـ use cases (فعل + اسم)، طريقة استدعاء الـ use case (`call`/`execute`… زي الموجود)، وشكل الـ FlowState.
4. **المعمارية layer-first** وتدفق اتجاه واحد من غير تخطي طبقة:
   `Cubit → UseCase → Repository(abstract) → RepositoryImpl → RemoteDataSource → AppServiceClient(Retrofit) → Dio`
   `Response (@JsonSerializable) → toDomain() → Domain Model → Cubit state`
5. **الكود المتولد:** ما تعدّلش `*.g.dart` ولا `*.freezed.dart` ولا `di.config.dart` بإيدك. شغّل `dart run build_runner build --delete-conflicting-outputs`.
6. **حزم جديدة:** ما تضيفش إلا للضرورة، وفي المرحلة اللي محتاجاها بس، واكتبها في الخطة بسبب. تأكد من أحدث نسخة متوافقة مع الـ SDK الحالي من pub.dev (الـ SDK الحالي `^3.12.2`).
7. **أسرار:** مفيش base URL أو توكن أو مفتاح مكتوب في الكود. استخدم الإعدادات الموجودة (نفس مصدر الـ base URL الحالي).
8. **نصوص عربي:** كل نص بيظهر للمستخدم يتحط في `strings_manager` (أو المكان المعتمد) بنفس أسلوب باقي الشاشات، مفيش hardcoded strings.
9. اشتغل على branch جديد (`feature/assistant`). **لا commit ولا push** إلا لو طلبت.
10. بعد كل مرحلة: `flutter analyze` (صفر errors وصفر warnings جديدة) + الاختبارات. ما تقولش «تم» لأي بند ما اتأكدتش منه.

---

## 1. الـ API Contract

**كل endpoint محتاج Authorization** (الـ `AuthInterceptor` الموجود هو اللي بيتولى ده، ما تكتبش حاجة جديدة للتوكن).
**كل الردود** بنفس الـ envelope المستخدم في باقي الـ API: `{ "success": bool, "message": string, "data": ... }`. استخدم نفس الـ generic wrapper/الأسلوب الموجود في المشروع لو فيه.
أسماء الحقول **camelCase**.

| # | Method | Path | Body | Success |
|---|---|---|---|---|
| 11.1 | POST | `/api/assistant/sessions` | لا شيء | **201** `data: { sessionId, expiresAt }` |
| 11.2 | POST | `/api/assistant/command` | `{ "sessionId": "<guid>?", "text": "..." }` | **200** `data: AssistantResponse` |
| 11.3 | POST | `/api/assistant/sessions/{sessionId}/actions/{actionId}/confirm` | لا شيء | 200 `data: AssistantResponse` (`type == "success"`) |
| 11.4 | POST | `/api/assistant/sessions/{sessionId}/actions/{actionId}/cancel` | لا شيء | 200 `data: AssistantResponse` (`type == "cancelled"`) |
| 11.5 | DELETE | `/api/assistant/sessions/{sessionId}` | لا شيء | 200 |

### شكل `AssistantResponse` (المتوقع)
```
sessionId: string (guid)
sessionReset: bool            // true = السياق اتمسح وبدأت جلسة جديدة
type: string                  // answer | question | clarification | confirmation | success | cancelled | error
message: string               // نص الرد الجاهز للعرض (المصدر الأساسي للحقيقة)
data: object | array | null   // بيانات منظمة للكروت، شكلها بيختلف حسب السؤال
options: string[] | null      // اختيارات في حالة clarification
pendingAction: { actionId, intent, summary, expiresAt } | null
```

### ⚠️ تحذير مهم: الشكل ده مش مؤكد 100%
ملف Postman **مفيهوش أمثلة ردود محفوظة** (بس سكريبتات اختبار بتأكد `sessionId` و`message` و`type` و`pendingAction.actionId`). لذلك:
- **اعتبر `sessionId` و`message` بس إجباريين.** باقي الحقول **nullable مع قيمة افتراضية آمنة** (`sessionReset` ← false، `type` ← unknown…).
- **`data` ما تعملهاش models typed دلوقتي.** احتفظ بيها خام (`dynamic`/`Map<String, dynamic>?`/`List<dynamic>?`) في الـ response وفي الـ domain (`payload`). الـ models المحددة للكروت (إحصائيات، أقساط، عملاء…) هتتضاف بعد ما نشوف ردود حقيقية. اتركلها مكان واضح (مثلاً TODO محدد) من غير ما تكسر شيء.
- **ما تخترعش حقول.** لو احتجت حقل مش في الجدول، اسأل.
- **`type` غير معروف** ← يتحول لـ `unknown` ويتعامل كـ `answer` (يعرض `message`). ما يكسرش التطبيق أبدًا.
- مطابقة `type` **case-insensitive**.
- `expiresAt` تاريخ ISO. اتعامل معاه بحذر: لو من غير offset اعتبره UTC، وحوّله للتوقيت المحلي عند الحاجة. وضّح الافتراض في التقرير.

### أخطاء الـ HTTP المتوقعة
| الكود | المعنى | المطلوب |
|---|---|---|
| 400 | نص فاضي أو أطول من 500 حرف | رسالة من السيرفر لو موجودة |
| 401 | توكن منتهي | يمشي على نظام الـ refresh/logout الموجود (من غير كود جديد) |
| 404 | جلسة/عملية مش بتاعتك أو مش موجودة | Failure مناسب |
| 429 | تجاوز حد الطلبات (حوالي 20/دقيقة) | **Failure مخصص** برسالة «استنى شوية وجرّب تاني»، وخليه سهل التمييز في الـ Cubit |
| 5xx / timeout / مفيش نت | | زي باقي التطبيق |
اعتمد على `error_handler.dart` و`Failure` الموجودين. لو 429 مش معالج، زوّده **بأقل تعديل** وبنفس الأسلوب.

---

## 2. طبقة الـ App و الـ Data

اتبع النموذج اللي اخترته بالحرف. المطلوب (بأسماء تتوافق مع تسمية المشروع، عدّلها لو أسلوبه مختلف):

**`data/network/app_api.dart`:** أضف الـ 5 endpoints في `AppServiceClient` بنفس طريقة الـ annotations والـ return types المستخدمة.

**`data/request/assistant_request.dart`:** `AssistantCommandRequest { String? sessionId; String text; }`. (`sessionId` يتشال من الـ JSON لو null، نفس أسلوب الـ requests الموجودة.)

**`data/response/assistant_responses/assistant_responses.dart`:** Responses بـ `@JsonSerializable`: الجلسة، الـ `AssistantResponse`، والـ `PendingAction`. كلها nullable وفق التحذير أعلاه. (`.g.dart` يتولد.)

**`data/mapper/assistant_mapper.dart`:** extensions بنفس شكل الموجود (`extension on <X>Data? → toDomain()`)، بقيم افتراضية آمنة، وتحويل الـ `type` لـ enum.

**`data/data_source/assistant_remote_data_source.dart`:** abstract + `@LazySingleton` impl.

**`data/repository_impl/assistant_repository_impl.dart`:** `@LazySingleton(as: …)`، بنفس شكل الـ try/catch وتحويل الأخطاء لـ Failure، ونفس فحص الشبكة (`network_info`) المستخدم في باقي الـ repositories.

**`app/di.dart`:** سجّل كل ده بنفس الطريقة (annotations) وشغّل الـ generator.

---

## 3. طبقة الـ Domain

**Models** (Dart خالصة، non-nullable، من غير json):
- `AssistantSession { sessionId, expiresAt }`
- `AssistantReply { sessionId, sessionReset, type (enum), message, payload (خام, nullable), options (قائمة), pendingAction? }`
- `AssistantPendingAction { actionId, intent, summary, expiresAt }`
- `enum AssistantReplyType { answer, question, clarification, confirmation, success, cancelled, error, unknown }`

**Repository (abstract):** كل method بترجع `Future<Either<Failure, T>>`: `startSession`, `sendCommand(sessionId?, text)`, `confirmAction(sessionId, actionId)`, `cancelAction(sessionId, actionId)`, `endSession(sessionId)`.

**Use cases** (واحد لكل عملية، بنفس أسلوب تسمية وشكل الموجود): `StartAssistantSessionUseCase`, `SendAssistantCommandUseCase`, `ConfirmAssistantActionUseCase`, `CancelAssistantActionUseCase`, `EndAssistantSessionUseCase`.

---

## 4. طبقة الـ Presentation (Cubit + State فقط)

**مهم:** أسلوب المشروع غالبًا `presentation/<screen>/<action_name>/<action_name>_cubit.dart + _state.dart` (freezed). **اقرأ إزاي بتتعامل الشاشات متعددة الخطوات في المشروع** (الأقساط/الملاحظات الصوتية) وتصرّف بنفس الطريقة. المحادثة بتشارك حالة واحدة (الجلسة والرسائل والعملية المعلّقة)، فلو الأسلوب الصارم «cubit لكل action» هيكسر ده، اكتب في الخطة التصميم اللي تقترحه وليه. المقترح الافتراضي:

### `assistant` folder
- **`AssistantChatCubit`** (المحادثة)، وهو **المرجع الوحيد للجلسة** (`sessionId` في الذاكرة فقط، **مش في Hive ولا shared_preferences**، لأنها بتموت بعد 15 دقيقة).
- **`AssistantVoiceCubit`** (الصوت، المرحلة B).

### محتوى الـ State (جاهز لأي View)
- `messages`: قايمة رسائل (دور: مستخدم/مساعد، نص، النوع، الـ payload، الـ pendingAction، الـ options، الوقت).
- `status`: idle / sending (بيفكر) / executing (أثناء confirm/cancel) / error(failure).
- `pendingAction` الحالية (لو فيه)، و`isPendingExpired` محسوبة من `expiresAt`.
- `sessionResetNotice` (علم يظهر مرة واحدة لما `sessionReset == true`).
- `rateLimited` مع رسالة، بحيث الـ View تعرض «استنى شوية».
- استخدم **`FlowState`/state renderer الموجود** لو الأسلوب المعتمد، بدل ما تخترع نظام حالات جديد.

### سلوك الـ Cubit
1. `ensureSession()`: بيفتح جلسة (11.1) لو مفيش، أو لو قاربت تنتهي (أقل من دقيقة).
2. `sendText(String)`:
   - يرفض الفاضي، ويقص المسافات، ويرفض أكتر من **500 حرف** محليًا من غير ما يبعت.
   - يضيف رسالة المستخدم فورًا (optimistic)، ويدخل `sending`، ويبعت الأمر.
   - **يحدّث `sessionId` من الرد دايمًا** (لو `sessionReset` أو اتغير).
   - يضيف رد المساعد ويحدّث `pendingAction`: لو النوع `confirmation` يحفظها، ولو `success`/`cancelled`/`error`/أي رد جديد غير تأكيد **يمسحها**.
   - **ما يعيدش إرسال أمر فشل تلقائيًا.** يعرض الخطأ ويسيب للمستخدم زرار «حاول تاني» (`retryLast()`).
3. `confirm()` / `cancel()`:
   - تشتغل بس لو فيه `pendingAction`، **ومش `executing` بالفعل** (منع الضغط المزدوج، لأن التأكيد عملية مالية).
   - لو الـ `expiresAt` عدّى محليًا: ما تبعتش، حوّل الرسالة لحالة منتهية (السيرفر هو الحَكَم النهائي، فلو رجع خطأ انتهاء اعرضه).
   - **ما تعيدش محاولة `confirm` تلقائيًا أبدًا** حتى لو فشل بسبب الشبكة. اعرض الخطأ وخلي المستخدم يقرر. (السيرفر بيحمي من التنفيذ المزدوج، بس ما نعتمدش على ده.)
4. `selectOption(int index)`: للـ clarification، يبعت الاختيار كنص بنفس الطريقة (السيرفر بيفهم «التاني»/اسم الخيار). **اسأل أو افترض الأبسط:** يبعت نص الخيار نفسه، ووضّح الافتراض.
5. `endSession()`: يمسح الجلسة والرسائل عند الخروج (ومن غير ما يفشل الخروج لو الطلب فشل).
6. أي Failure ← رسالة عربي مناسبة من الموجود، و429 ← `rateLimited`.

---

## 5. الصوت (المرحلة B، بعد ما A تتجرب)

الموبايل بيحوّل الكلام لنص، **والنص هو اللي بيتبعت للـ API**. ما نبعتش صوت للسيرفر.

- **حزمة:** `speech_to_text` (تأكد من أحدث نسخة متوافقة). لو محتاج `permission_handler` عشان تفتح إعدادات النظام عند الرفض الدائم، اكتب ده في الخطة بسبب.
- **`SpeechRecognitionService` (abstract + impl):** `initialize()`, `start(...)`, `stop()`, `cancel()`، وStreams/Callbacks للنص الجزئي (live) والنص النهائي ومستوى الصوت (`soundLevel`) والحالة والأخطاء. حطها في الطبقة المناسبة حسب أسلوب المشروع (واكتب قرارك في الخطة) بحيث يتبدل التنفيذ بسهولة.
- **اللغة:** حاول `ar_EG` أولًا، ولو مش متاحة على الجهاز استخدم `ar` ثم لغة النظام. ما تفترضش إن `ar_EG` موجودة. اسأل `locales()` فعليًا.
- **`AssistantVoiceCubit` states:** `idle` ← `requestingPermission` ← `permissionDenied(permanent: bool)` / `listening(partialText, soundLevel)` ← `reviewing(text)` ← (تلقائيًا تبعت للـ `AssistantChatCubit.sendText`) / `error(kind)` (لا سمع، لا نت، خدمة غير متاحة).
- **مراجعة الجملة:** بعد ما التسجيل يقف، تدخل `reviewing(text)`. فيه مهلة إرسال تلقائي قصيرة (**قيمة قابلة للضبط، حوالي 1.5 ثانية**) تتلغي لو المستخدم عدّل أو لغى. نفّذها في الـ Cubit بـ Timer يتلغي في `close()`.
- **الإلغاء:** `cancelListening()` لما المستخدم يسحب لجنب: يوقف ومن غير أي إرسال.
- **وضع الضغط المرة الواحدة:** ادعم `toggleListening()` بجانب الضغط المطوّل (للي مش مرتاح يمسك الزرار).
- **تعارض الميكروفون:** المشروع فيه ميزة **ملاحظات صوتية** بتستخدم الميكروفون. اقرا تنفيذها وتأكد إن المساعد ما يبدأش والميكروفون مشغول، وإنه يحرره بعد ما يخلص. لو في ميكروفون مشغول، `error(kind: busy)`.
- **تنضيف:** الـ Cubit يوقف الـ service في `close()`.
- **إعدادات المنصات:** Android: إذن `RECORD_AUDIO` وإعداد `<queries>` للخدمة (اتأكد من README الحزمة). iOS: `NSMicrophoneUsageDescription` و`NSSpeechRecognitionUsageDescription` بنص عربي واضح. تأكد من `minSdk` المطلوب وقارنه بالحالي.
- **وضّح في التقرير** إن الدقة بتختلف من جهاز لجهاز وإن لازم تجربة على موبايل حقيقي.

---

## 6. الاختبارات

**اقرا مجلد `test/` الحالي واتبع نفس الأسلوب.** `pubspec.yaml` مفيهوش `bloc_test` ولا `mocktail`، فاستخدم **fakes مكتوبة بإيدك**، ولا تضيف حزمة اختبار إلا لو في المشروع بالفعل أو اتفقنا.

- **Mapper:** كل أنواع `type` (بما فيها غير معروف وبحروف كبيرة/صغيرة)، حقول ناقصة/null، `pendingAction` موجود وغايب، `sessionReset`، تواريخ بدون offset.
- **Repository:** نجاح، وتحويل 400/401/404/429/5xx/مفيش نت لـ Failure الصحيح.
- **Cubit (محادثة):**
  - فتح جلسة تلقائيًا، وتحديث `sessionId` عند `sessionReset`.
  - رسالة ← `question` ← رسالة ← `confirmation` ← confirm ← `success` (والـ pendingAction تتمسح).
  - confirm مرتين ورا بعض ← طلب واحد بس.
  - confirm بعد انتهاء المهلة محليًا ← مفيش طلب.
  - cancel ← `cancelled`.
  - نص فاضي أو أطول من 500 ← مفيش طلب.
  - 429 ← `rateLimited`.
  - فشل الشبكة في confirm ← لا إعادة محاولة تلقائية.
  - `type` غير معروف ← يتعامل كـ answer ولا يكسر.
- **Cubit (صوت)** بـ service مزيفة: النص الجزئي، المراجعة والإرسال التلقائي، إلغاء المراجعة بالتعديل، السحب للإلغاء، رفض الإذن (مؤقت/دائم)، خطأ.
- حط عينات JSON الاختبار كـ fixtures **وعلّمها «مفترضة من العقد، تحتاج تأكيد بردود حقيقية»**.

---

## 7. ترتيب التنفيذ

1. قراءة المشروع والـ feature النموذج ← **Implementation Plan، وانتظر موافقتي.**
2. **المرحلة A:** app/data/domain + build_runner + اختبارات الـ mapper والـ repository.
3. **المرحلة A2:** `AssistantChatCubit` + State + اختباراتهم. **وقف هنا وراجع معايا قبل الصوت.**
4. **المرحلة B:** الصوت (`speech_to_text`، الـ service، `AssistantVoiceCubit`، إعدادات المنصات، اختبارات).
5. التقرير النهائي.

---

## 8. Acceptance Criteria

- [ ] `flutter analyze` نضيف، و`build_runner` اشتغل بدون conflicts، والاختبارات الجديدة والقديمة ناجحة.
- [ ] مفيش View/Widget/Screen اتضاف، ومفيش ملف متولد اتعدّل بإيد.
- [ ] الكود الجديد **لا يمكن تمييزه في الأسلوب** عن باقي المشروع (أسماء، annotations، error handling).
- [ ] `sessionId` في الذاكرة فقط.
- [ ] لا إعادة محاولة تلقائية لـ confirm، ولا ضغط مزدوج.
- [ ] `type` غير معروف أو حقول ناقصة ما بتكسرش التطبيق.
- [ ] كل النصوص العربية في الـ strings، ومفيش أسرار أو URLs في الكود.
- [ ] الـ Cubit والـ State تقدر أي View تقراهم من غير ما تحتاج أي منطق إضافي.

---

## 9. التقرير النهائي (`docs/ASSISTANT_MOBILE_REPORT.md`، من غير commit)

- الـ feature اللي اتخذت نموذج، وأي اختلاف عنها وليه.
- قائمة الملفات المضافة والمعدّلة.
- القرارات والافتراضات (تاريخ `expiresAt`، شكل الـ `data` الخام، إرسال اختيار الـ clarification كنص، تصميم الـ Cubits).
- الحزم المضافة (الاسم والنسخة والسبب).
- إعدادات المنصات (Android/iOS) اللي اتعدلت.
- نتايج `flutter analyze` والاختبارات.
- **اللي محتاج أشوفه من ردود حقيقية** عشان نكمل الكروت (الإحصائيات، الأقساط المتأخرة، الديون، رصيد عميل، الإشعارات).
- أي مخاطر أو حاجات ما اتنفذتش وليه.

ممنوع تقول «تم» لأي بند ما اتأكدتش منه فعليًا.
