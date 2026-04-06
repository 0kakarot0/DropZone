// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'دروب زون شوفير';

  @override
  String get navHome => 'الرئيسية';

  @override
  String get navBookings => 'الحجوزات';

  @override
  String get navSupport => 'الدعم';

  @override
  String get navProfile => 'الملف الشخصي';

  @override
  String get activeRideTitle => 'رحلة نشطة';

  @override
  String get homeHeroTitle => 'سائق خاص بالحجز المسبق.';

  @override
  String get homeHeroSubtitle => 'خدمة المطار والأعمال داخل الإمارات';

  @override
  String get bookNow => 'احجز الآن';

  @override
  String get bookingTitle => 'احجز مشوار';

  @override
  String get tripType => 'نوع الرحلة';

  @override
  String get tripAirportPickup => 'استقبال من المطار';

  @override
  String get tripAirportDrop => 'توصيل إلى المطار';

  @override
  String get tripBusiness => 'رحلة أعمال';

  @override
  String get pickup => 'نقطة الانطلاق';

  @override
  String get dropoff => 'نقطة الوصول';

  @override
  String get date => 'التاريخ';

  @override
  String get time => 'الوقت';

  @override
  String get passengers => 'الركاب';

  @override
  String get luggage => 'الأمتعة';

  @override
  String get vehicleClass => 'فئة المركبة';

  @override
  String get vehicleSedan => 'سيدان';

  @override
  String get vehicleSUV => 'دفع رباعي';

  @override
  String get vehicleLuxury => 'فاخرة';

  @override
  String get vehicleVan => 'فان';

  @override
  String get continueLabel => 'متابعة';

  @override
  String get summary => 'الملخص';

  @override
  String get estimatedPrice => 'السعر التقديري';

  @override
  String get pricePlaceholder => '— درهم';

  @override
  String get confirmRequest => 'تأكيد الطلب';

  @override
  String get supportTitle => 'الدعم';

  @override
  String get profileTitle => 'الملف الشخصي';

  @override
  String get bookingsTitle => 'حجوزاتي';

  @override
  String get emptyBookings => 'لا توجد حجوزات';

  @override
  String get comingSoon => 'قريباً';

  @override
  String get authTitle => 'تسجيل الدخول';

  @override
  String get sendOtp => 'إرسال رمز التحقق';

  @override
  String get verifyPhone => 'تأكيد الهاتف';

  @override
  String get otpPrompt => 'أدخل الرمز المكون من 4 أرقام المرسل إليك';

  @override
  String get verifyAndContinue => 'تأكيد والمتابعة';

  @override
  String get profileDetails => 'بيانات الملف الشخصي';

  @override
  String get savedPassengers => 'الركاب المحفوظون';

  @override
  String get passengerSelf => 'أنا';

  @override
  String get passengerAssistant => 'المساعد';

  @override
  String get passengerExecutive => 'التنفيذي';

  @override
  String get corporateMode => 'وضع الشركات';

  @override
  String get businessAccountToggle => 'حساب أعمال';

  @override
  String get corporateSubtitle => 'فعّل لإضافة بيانات الشركة';

  @override
  String get saveProfile => 'حفظ الملف';

  @override
  String get profileSavedTitle => 'تم حفظ الملف';

  @override
  String get profileSavedMessage => 'تم تحديث ملفك الشخصي.';

  @override
  String get fullNameLabel => 'الاسم الكامل';

  @override
  String get emailLabel => 'البريد الإلكتروني';

  @override
  String get bookingPreferencesTitle => 'تفضيلات الحجز';

  @override
  String get bookingPreferencesSubtitle =>
      'اضبط القيم الافتراضية لتعبئة نموذج الحجز مسبقاً.';

  @override
  String get defaultPickupHint => 'موقع الانطلاق الافتراضي';

  @override
  String get defaultDropoffHint => 'موقع الوصول الافتراضي';

  @override
  String get defaultPassengersLabel => 'الركاب الافتراضيون: ';

  @override
  String get savePreferences => 'حفظ التفضيلات';

  @override
  String get preferencesSaved => 'تم حفظ التفضيلات';

  @override
  String preferencesSaveError(Object error) {
    return 'تعذر حفظ التفضيلات: $error';
  }

  @override
  String profileSaveError(Object error) {
    return 'تعذر حفظ الملف الشخصي: $error';
  }

  @override
  String profileLoadError(Object error) {
    return 'تعذر تحميل الملف الشخصي: $error';
  }

  @override
  String get profileFieldsManagedNotice =>
      'تفاصيل الشركة ومركز التكلفة وملاحظات الراكب والركاب المحفوظون غير قابلة للتعديل من تطبيق الراكب حالياً.';

  @override
  String get upcoming => 'القادمة';

  @override
  String get past => 'السابقة';

  @override
  String get bookingDetails => 'تفاصيل الحجز';

  @override
  String get statusTimeline => 'حالة الرحلة';

  @override
  String get statusRequested => 'تم الطلب';

  @override
  String get statusConfirmed => 'تم التأكيد';

  @override
  String get statusDriverAssigned => 'تم تعيين السائق';

  @override
  String get statusEnRoute => 'في الطريق';

  @override
  String get statusCompleted => 'مكتمل';

  @override
  String get statusCancelled => 'ملغي';

  @override
  String get policyTitle => 'سياسة الإلغاء';

  @override
  String get policyBody =>
      'إلغاء مجاني حتى ساعتين قبل الموعد. قد تُطبّق رسوم بعد ذلك.';

  @override
  String get reschedule => 'إعادة جدولة';

  @override
  String get cancelBooking => 'إلغاء الحجز';

  @override
  String get cancelConfirmTitle => 'إلغاء الحجز؟';

  @override
  String get cancelConfirmMessage => 'هل أنت متأكد أنك تريد إلغاء هذا الحجز؟';

  @override
  String get keepBooking => 'الاحتفاظ بالحجز';

  @override
  String get confirmCancel => 'إلغاء الحجز';

  @override
  String get editBookingTitle => 'تعديل الحجز';

  @override
  String get saveChanges => 'حفظ التغييرات';

  @override
  String get bookingCreated => 'تم إرسال طلب الحجز';

  @override
  String get surchargeNote => 'قد تُطبق رسوم المطار والرسوم الليلية';

  @override
  String get errorLabel => 'خطأ';

  @override
  String get rescheduleConfirmed => 'تم إرسال طلب إعادة الجدولة';

  @override
  String get cancelConfirmed => 'تم إلغاء الحجز';

  @override
  String get statusPendingPayment => 'الدفع معلق';

  @override
  String get statusArrivedShort => 'وصل';

  @override
  String get statusInProgressShort => 'قيد التنفيذ';

  @override
  String get statusRescheduled => 'أعيدت الجدولة';

  @override
  String get statusCreated => 'تم الإنشاء';

  @override
  String get paymentTitle => 'الدفع';

  @override
  String get chooseCard => 'اختر بطاقة';

  @override
  String expires(Object expiry) {
    return 'ينتهي $expiry';
  }

  @override
  String amountDue(Object amount) {
    return 'المبلغ المستحق: $amount درهم';
  }

  @override
  String get payNow => 'ادفع الآن';

  @override
  String paymentSuccess(Object id) {
    return 'تم الدفع بنجاح: $id';
  }

  @override
  String get paymentSuccessTitle => 'تم الدفع بنجاح';

  @override
  String get paymentFailedTitle => 'فشل الدفع';

  @override
  String get paymentFailedMessage => 'تعذر معالجة الدفع. يرجى المحاولة لاحقاً.';

  @override
  String get paymentBookingConfirmed => 'تم الدفع بنجاح! تم تأكيد الحجز.';

  @override
  String paymentFailedError(Object error) {
    return 'فشل الدفع: $error';
  }

  @override
  String get paymentPendingTitle => 'الدفع معلق';

  @override
  String paymentPendingMessage(Object dateTime) {
    return 'سيتم إلغاء هذا الحجز تلقائياً إذا لم يتم استلام الدفع قبل موعد الرحلة المجدول ($dateTime).';
  }

  @override
  String get goHome => 'العودة للرئيسية';

  @override
  String get receiptTitle => 'الإيصال';

  @override
  String receiptId(Object id) {
    return 'رقم الإيصال: $id';
  }

  @override
  String get tripTrackingTitle => 'تتبع الرحلة';

  @override
  String get mapPlaceholder => 'معاينة الخريطة';

  @override
  String get driverAssignedTitle => 'تم تعيين السائق';

  @override
  String get driverAssignedSubtitle => 'أحمد • لكزس ES • DXB 1234';

  @override
  String driverNumber(Object id) {
    return 'السائق #$id';
  }

  @override
  String get etaLabel => 'الوقت المتوقع';

  @override
  String etaValue(Object minutes) {
    return '$minutes';
  }

  @override
  String get trackRide => 'تتبع الرحلة';

  @override
  String get contactDriver => 'تواصل مع السائق';

  @override
  String get contactDriverHint => 'الاتصال برقم مخفي';

  @override
  String get notificationsTitle => 'الإشعارات';

  @override
  String get notificationConfirmed => 'تم تأكيد الحجز';

  @override
  String get notificationConfirmedBody => 'جارٍ تعيين السائق';

  @override
  String get notificationDriverAssigned => 'تم تعيين السائق';

  @override
  String get notificationDriverAssignedBody => 'أحمد سيصل قريباً';

  @override
  String get saveFlightInfo => 'حفظ تفاصيل الرحلة';

  @override
  String get contactDriverTitle => 'التواصل مع السائق';

  @override
  String get maskedCallTitle => 'مكالمة مخفية';

  @override
  String get maskedCallBody => 'استخدم رقمًا مخفيًا للخصوصية';

  @override
  String get inAppChatTitle => 'دردشة داخل التطبيق';

  @override
  String get inAppChatBody => 'مراسلة آمنة مع السائق';

  @override
  String get startMaskedCall => 'بدء مكالمة مخفية';

  @override
  String get maskedCallHint => 'الاتصال عبر رقم مخفي';

  @override
  String get maskedCallUnavailableTitle => 'المكالمة المخفية غير متاحة';

  @override
  String get maskedCallUnavailableMessage =>
      'المكالمة المخفية غير متاحة من تطبيق الراكب حالياً.';

  @override
  String get notificationArriving => 'السائق في الطريق';

  @override
  String get notificationArrivingBody => 'الوقت المتوقع 8 دقائق';

  @override
  String get helpCenterTitle => 'مركز المساعدة';

  @override
  String get helpTopicPayment => 'مشاكل الدفع';

  @override
  String get helpTopicDriver => 'الدعم مع السائق';

  @override
  String get helpTopicLostItem => 'المفقودات';

  @override
  String get reportIssueTitle => 'الإبلاغ عن مشكلة';

  @override
  String get issueCategoryPayment => 'الدفع';

  @override
  String get issueCategoryDriver => 'السائق';

  @override
  String get issueCategoryOther => 'أخرى';

  @override
  String get selectCategory => 'اختر الفئة';

  @override
  String get submitIssue => 'إرسال المشكلة';

  @override
  String get issueSubmittedTitle => 'تم إرسال المشكلة';

  @override
  String get issueSubmittedMessage => 'شكراً لك — سنعود إليك قريباً.';

  @override
  String get supportSubmissionUnavailableTitle => 'إرسال طلب الدعم غير متاح';

  @override
  String get supportSubmissionUnavailableMessage =>
      'إرسال المشاكل غير متاح من تطبيق الراكب حالياً. يرجى استخدام مواضيع المساعدة المعروضة أو التواصل مع فريق العمليات مباشرة.';

  @override
  String get dismissLabel => 'إغلاق';

  @override
  String get issueDescriptionHint => 'صف مشكلتك';

  @override
  String get airportEnhancementsTitle => 'خدمات المطار';

  @override
  String get flightTrackingTitle => 'تتبع الرحلة';

  @override
  String get flightNumberHint => 'رقم الرحلة';

  @override
  String get flightStatusLabel => 'حالة الرحلة';

  @override
  String get flightStatusValue => 'في الوقت المحدد · المبنى 3';

  @override
  String get meetGreetTitle => 'الاستقبال والترحيب';

  @override
  String get meetGreetBody => 'سيكون السائق بانتظارك عند الوصول مع لوحة باسمك.';

  @override
  String get flightSaveUnavailableMessage =>
      'حفظ تفاصيل الرحلة غير متاح في تطبيق الراكب حالياً.';

  @override
  String get selectTime => 'اختر الوقت';

  @override
  String get noDateSelected => 'لم يتم اختيار تاريخ';

  @override
  String get noTimeSelected => 'لم يتم اختيار وقت';

  @override
  String get deleteBookingTitle => 'حذف الحجز؟';

  @override
  String get deleteBookingMessage => 'سيتم حذف هذا الحجز نهائياً.';

  @override
  String get confirmDelete => 'حذف';

  @override
  String get bookingDeletedConfirmed => 'تم حذف الحجز';

  @override
  String get rescheduleSuccess => 'تم إعادة جدولة الحجز بنجاح';

  @override
  String get authEmailLabel => 'البريد الإلكتروني';

  @override
  String get authPasswordLabel => 'كلمة المرور';

  @override
  String get authSignIn => 'تسجيل الدخول';

  @override
  String get authCreateAccount => 'إنشاء حساب';

  @override
  String get authFillTestCredentials => 'اضغط لملء بيانات الاختبار';

  @override
  String get authMissingCredentialsSignIn =>
      'أدخل البريد الإلكتروني وكلمة المرور.';

  @override
  String get authMissingCredentialsCreate =>
      'أدخل البريد الإلكتروني وكلمة المرور أولاً.';

  @override
  String authGenericError(Object error) {
    return 'خطأ: $error';
  }

  @override
  String get leaveBookingTitle => 'مغادرة الحجز؟';

  @override
  String get leaveBookingMessage =>
      'لديك تفاصيل حجز غير محفوظة. سيتم حفظ التقدم كمسودة لتتمكن من المتابعة لاحقاً.';

  @override
  String get continueBooking => 'متابعة الحجز';

  @override
  String get menuLabel => 'القائمة';

  @override
  String get leaveLabel => 'مغادرة';

  @override
  String get signOut => 'تسجيل الخروج';

  @override
  String get guestLabel => 'زائر';

  @override
  String get paymentCancelled => 'تم إلغاء الدفع.';

  @override
  String get trackingErrorTitle => 'حدث خطأ ما';

  @override
  String get noTrackingAvailable => 'لا يوجد تتبع متاح';

  @override
  String get trackingAvailableAfterAssignment =>
      'يصبح التتبع متاحاً بعد تعيين سائق';

  @override
  String get trackingStatusAssigned => 'تم تعيين السائق، بانتظار الانطلاق';

  @override
  String get trackingStatusEnRoute => 'السائق في الطريق';

  @override
  String get trackingStatusArrived => 'وصل السائق إلى نقطة الانطلاق';

  @override
  String get trackingStatusInProgress => 'الرحلة جارية';

  @override
  String get trackingStepAssigned => 'تم التعيين';

  @override
  String get trackingStepEnRoute => 'في الطريق';

  @override
  String get trackingStepArrived => 'وصل';

  @override
  String get trackingStepInProgress => 'قيد التنفيذ';

  @override
  String get trackingFallbackDriver => 'السائق';

  @override
  String get pickupLocationHint => 'موقع الانطلاق';

  @override
  String get dropoffLocationHint => 'موقع الوصول';

  @override
  String get pickOnMapTooltip => 'اختر على الخريطة';

  @override
  String get pickPickupLocationTitle => 'اختر موقع الانطلاق';

  @override
  String get pickDropoffLocationTitle => 'اختر موقع الوصول';

  @override
  String get selectDateFirst => 'اختر التاريخ أولاً';

  @override
  String get notesForDriverHint => 'ملاحظات للسائق (اختياري)';

  @override
  String get paymentMethodTitle => 'طريقة الدفع';

  @override
  String get payByCard => 'الدفع بالبطاقة';

  @override
  String get payWithCash => 'الدفع نقداً';

  @override
  String get cashPaymentHint => 'ادفع للسائق مباشرة عند نهاية الرحلة.';

  @override
  String get priceEstimateLoadingMessage =>
      'لا يزال السعر التقديري قيد التحميل، يرجى الانتظار.';

  @override
  String get priceEstimateRetryMessage =>
      'تعذر تحميل السعر التقديري، تتم إعادة المحاولة.';

  @override
  String bookingCompleteError(Object error) {
    return 'تعذر إكمال الحجز: $error';
  }

  @override
  String get rebookLastRide => 'إعادة حجز آخر رحلة';
}
