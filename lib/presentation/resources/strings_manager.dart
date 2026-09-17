/// Localized string tokens for Mizan (ميزان) based on the Figma UI/UX Redesign
class AppStrings {
  // --- Branding ---
  static const String appName = "ميزان";
  static const String appNameEn = "MIZAN";
  static const String appTagline = "دفتر المحاسبة الذكي";

  // --- Common Actions ---
  static const String ok = "موافق";
  static const String cancel = "إلغاء";
  static const String save = "حفظ";
  static const String edit = "تعديل";
  static const String delete = "حذف";
  static const String confirm = "تأكيد";
  static const String apply = "تطبيق";
  static const String reset = "إعادة تعيين";
  static const String retry = "إعادة المحاولة";
  static const String tryAgain = "حاول مجدداً";
  static const String search = "بحث...";
  static const String filter = "فلترة";
  static const String share = "مشاركة";
  static const String viewAll = "عرض الكل";
  static const String next = "التالي";
  static const String skip = "تخطي";
  static const String startNow = "ابدأ الآن";
  static const String submit = "إرسال";
  static const String loading = "جاري التحميل...";

  // --- Navigation Tabs ---
  static const String home = "الرئيسية";
  static const String transactions = "المعاملات";
  static const String contacts = "العملاء";
  static const String installments = "الأقساط";
  static const String analytics = "التقارير";
  static const String notifications = "التنبيهات";
  static const String settings = "الإعدادات";
  static const String profile = "الملف الشخصي";

  // --- Financial Actions ---
  static const String quickSale = "بيع";
  static const String quickPurchase = "شراء";
  static const String quickCollect = "تحصيل";
  static const String quickPay = "دفع";

  static const String newTransaction = "تسجيل معاملة جديدة";
  static const String newContact = "إضافة عميل جديد";
  static const String newInstallment = "إنشاء خطة أقساط";
  static const String voiceRecording = "تسجيل صوتي ذكي";

  // --- Financial Dashboard Labels ---
  static const String totalBalance = "إجمالي الرصيد";
  static const String totalDebts = "الديون المستحقة لك";
  static const String totalPayables = "المستحقات عليك";
  static const String sales = "المبيعات";
  static const String purchases = "المشتريات";
  static const String collections = "التحصيلات";
  static const String payments = "المدفوعات";
  static const String egp = "جنيه";
  static const String egpSymbol = "EGP";

  // --- Empty States ---
  static const String noTransactionsTitle = "لا توجد عمليات مسجلة حتى الآن";
  static const String noTransactionsSubtitle =
      "ابدأ بضبط دفترك المالي وإدخال أول عملية بيع، شراء أو تحصيل مالي لتبدأ في مراجعة تقاريرك الفورية.";
  static const String recordFirstTransaction = "سجل أول عملية الآن";
  static const String noContactsTitle = "لا يوجد عملاء مضافون";
  static const String noInstallmentsTitle = "لا توجد أقساط نشطة";

  // --- Onboarding ---
  static const String onBoardingTitle1 = "الدفتر المالي الرقمي";
  static const String onBoardingSubTitle1 =
      "تخلص من الدفاتر الورقية المعقدة. ميزان يمنحك سجلاً مالياً رقمياً آمناً لتوثيق مبيعاتك ومشترياتك بكل سهولة ويسر.";

  static const String onBoardingTitle2 = "التذكير ثنائي الاتجاه";
  static const String onBoardingSubTitle2 =
      "أرسل تذكيرات تلقائية بعملائك عبر الايميل والرسائل القصيرة. ميزان يتيح للطرفين تأكيد الدفع وتحديث السجلات بشكل متبادل وفوري.";

  static const String onBoardingTitle3 = "التسجيل الصوتي الذكي";
  static const String onBoardingSubTitle3 =
      "لا وقت للكتابة؟ سجل المعاملة بصوتك، وسيقوم الذكاء الاصطناعي في ميزان بتحليلها وإدخالها فوراً في حساباتك بدقة متناهية.";

  // --- Auth & Session ---
  static const String loginTitle = "تسجيل الدخول";
  static const String loginSubtitle = "أدخل رقم هاتفك لتسجيل الدخول إلى حسابك";
  static const String phoneNumber = "رقم الهاتف";
  static const String verificationCode = "رمز التحقق";
  static const String enterOtp = "أدخل الرمز المكون من 6 أرقام";
  static const String resendCode = "إعادة إرسال الرمز";
  static const String authSuccess = "تم تأكيد الدخول بنجاح";
  static const String sessionExpired = "انتهت صلاحية الجلسة";
  static const String sessionExpiredMsg =
      "يرجى تسجيل الدخول مرة أخرى لحماية أمان بياناتك.";
  static const String rateLimitExceeded = "تجاوز حد الطلبات";
  static const String offlineMode = "أنت تعمل الآن دون اتصال بالإنترنت";

  // --- Select User Type / Account Setup (Figma Node #2025:10) ---
  static const String accountSetupTitle = "إعداد الحساب";
  static const String accountSetupSubtitle =
      "حدد نوع استخدامك للتطبيق وأدخل تفاصيل نشاطك التجاري";
  static const String accountType = "نوع الحساب";
  static const String merchantTypeTitle = "صاحب محل / تاجر";
  static const String merchantTypeSubtitle =
      "لتسجيل المبيعات، المشتريات، وتتبع حسابات العملاء والأقساط";
  static const String customerTypeTitle = "عميل / مندوب";
  static const String customerTypeSubtitle =
      "لمتابعة فواتيرك، مدفوعاتك، والأقساط المستحقة عليك للتجار";
  static const String businessInfo = "بيانات النشاط التجاري";
  static const String shopNameLabel = "اسم المحل / النشاط";
  static const String shopNameHint = "محل ميزان التجاري";
  static const String shopNameRequired = "اسم المحل أو النشاط التجاري مطلوب";
  static const String addressLabel = "العنوان";
  static const String addressHint = "مثال: القاهرة، مصر";
  static const String setLocation = "تحديد الموقع";
  static const String step3Of3 = "الخطوة ٣ من ٣";
  static const String confirmAndContinue = "تأكيد ومتابعة";

  // --- Error & Exception Handling (API Compatibility) ---
  static const String success = "نجاح";
  static const String badRequestError = "طلب غير صالح";
  static const String noContent = "لا يوجد محتوى";
  static const String forbiddenError = "طلب محظور";
  static const String unauthorizedError = "غير مصرح بالدخول";
  static const String notFoundError = "العنصر غير موجود";
  static const String conflictError = "تعارض في البيانات";
  static const String internalServerError = "حدث خطأ في الخادم";
  static const String unknownError = "حدث خطأ غير متوقع";
  static const String timeoutError = "انتهت مهلة الاتصال";
  static const String defaultError = "حدث خطأ ما، يرجى المحاولة لاحقاً";
  static const String cacheError = "خطأ في قراءة الذاكرة المؤقتة";
  static const String noInternetError = "يرجى التحقق من اتصالك بالإنترنت";
  static const String noRouteFound = "الصفحة غير موجودة";
}
