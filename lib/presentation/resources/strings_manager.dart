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
  static const String financialTransactions = "المعاملات المالية";
  static const String transactionsSubtitle = "أضف وتتبع الدفاتر";
  static const String searchTransactionsHint = "ابحث برقم المعاملة أو الطرف الثاني...";
  static const String allTransactions = "الكل";
  static const String today = "اليوم";
  static const String yesterday = "أمس";
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

  // --- Contacts Feature ---
  static const String addContact = "إضافة طرف";
  static const String editContact = "تعديل بيانات الطرف";
  static const String contactName = "اسم الطرف";
  static const String notes = "ملاحظات";
  static const String contactEmail = "البريد الإلكتروني";
  static const String markAsVip = "عميل مميز";
  static const String allContacts = "الكل";
  static const String vipContacts = "العملاء المميزون";
  static const String noContactsYet = "لا يوجد عملاء حتى الآن";
  static const String searchContacts = "ابحث بالاسم أو رقم الهاتف";
  static const String totalTransactions = "عدد العمليات";
  static const String totalAmount = "إجمالي التعاملات";
  static const String deleteContactConfirm = "هل أنت متأكد من حذف هذا الطرف؟";
  static const String contactDeleted = "تم حذف الطرف بنجاح";
  static const String nameLettersOnly = "اسم الطرف يجب أن يحتوي على أحرف فقط";

  // --- Figma Specific UI Strings (Nodes: #3:206, #2025:647, #3:1402, #2175:14, #3:1234, #2175:84) ---
  static const String contactsDirectory = "دليل الأطراف";
  static const String contactsSubtitle = "العملاء والموردين المسجلين";
  static const String searchContactsHint = "البحث عن عميل أو مورد...";
  static const String vipClientBadge = "عميل VIP";
  static const String vipSubtitle = "شركاء النجاح الأكثر نشاطاً";
  static const String vipStatsTitle = "إحصائيات عملاء VIP";
  static const String vipTopClients = "كبار العملاء";
  static const String totalVipClients = "إجمالي العملاء المميزين";
  static const String totalPagesTitle = "إجمالي الصفحات";
  static const String pages = "صفحات";
  static const String client = "عميل";
  static const String latest = "الأحدث";
  static const String oldest = "الأقدم";
  static const String phoneCall = "اتصال هاتفي";
  static const String sendReminder = "إرسال تذكير";
  static const String addNewContactTitle = "إضافة طرف جديد";
  static const String addContactSubtitle = "تسجيل عميل، مورد، أو شريك";
  static const String clientOrBusinessName = "اسم العميل / المؤسسة *";
  static const String personalPhoneNumber = "رقم الجوال الشخصي";
  static const String optionalNotes = "ملاحظات (اختياري)";
  static const String notesHint = "أضف ملاحظة عن العميل أو المورد...";
  static const String saveContactToDirectory = "حفظ الطرف في الدليل";
  static const String editContactSubtitle = "تحديث معلومات العميل أو المورد";
  static const String optionalEmail = "البريد الإلكتروني (اختياري)";
  static const String markAsVipToggle = "تحديد كعميل مميز (VIP)";
  static const String saveChanges = "حفظ التعديلات";
  static const String clientDetails = "تفاصيل العميل";
  static const String financialProfile = "الملف المالي الشخصي";
  static const String totalAccountBalance = "إجمالي الحساب";
  static const String transactionUnit = "عملية";
  static const String whatsapp = "واتساب";
  static const String call = "اتصال";
  static const String recentTransactions = "سجل آخر المعاملات";
  static const String clientCollection = "تحصيل عملاء";
  static const String accountPayment = "دفعة من الحساب";
  static const String purchaseSupplier = "مشتريات";
  static const String cash = "كاش";
  static const String credit = "آجل";
  static const String deleteContactQuestion = "حذف الطرف؟";
  static const String finalDelete = "حذف نهائي";
  static const String deleteContactWarning =
      "سيتم حذف بيانات هذا الطرف وجميع بيانات المعاملات والأقساط الخاصة به نهائياً. لا يمكن التراجع عن هذا الإجراء بعد إتمامه.";

  // --- Profile Feature ---
  static const String profileAccountInfo = "معلومات الحساب";
  static const String profileFullName = "الاسم الكامل";
  static const String profileEmail = "البريد الإلكتروني";
  static const String profileAccountStatus = "حالة الحساب";
  static const String profileUserType = "نوع المستخدم";
  static const String profileShopInfo = "بيانات المحل / النشاط";
  static const String profileNoName = "بدون اسم";
  static const String profileActive = "نشط";
  static const String profileInactive = "غير نشط";
  static const String profileLogout = "تسجيل الخروج";
  static const String profileLogoutConfirmTitle = "تسجيل الخروج";
  static const String profileLogoutConfirmMsg =
      "هل أنت متأكد من رغبتك في تسجيل الخروج من التطبيق؟";

  // --- Transaction Details (Figma Node #3:1126) ---
  static const String txDetailsTitle = "تفاصيل العملية";
  static const String txDetailsSubtitle = "بيانات العملية المالية";
  static const String txDetailsLoading = "جاري جلب تفاصيل العملية...";
  static const String txDetailsErrorTitle = "تعذر تحميل تفاصيل العملية";
  static const String txDetailsTransactionInfo = "بيانات العملية";
  static const String txDetailsContactLabel = "الطرف الثاني";
  static const String txDetailsTypeLabel = "نوع العملية";
  static const String txDetailsAmountLabel = "المبلغ الإجمالي";
  static const String txDetailsPaymentMethodLabel = "طريقة الدفع";
  static const String txDetailsDateLabel = "تاريخ العملية";
  static const String txDetailsInstallmentsTitle = "جدول الأقساط";
  static const String txDetailsInstallmentNo = "القسط";
  static const String txDetailsInstallmentDueDate = "تاريخ الاستحقاق";
  static const String txDetailsInstallmentAmount = "المبلغ";
  static const String txDetailsInstallmentStatus = "الحالة";
  static const String txDetailsStatusPaid = "مدفوع";
  static const String txDetailsStatusPending = "معلق";
  static const String txDetailsCashPayment = "كاش";
  static const String txDetailsInstallmentPayment = "تقسيط";
  static const String txDetailsSaleType = "بيع";
  static const String txDetailsPurchaseType = "شراء";
  static const String txDetailsCollectType = "تحصيل";
  static const String txDetailsPayType = "دفع";
}

