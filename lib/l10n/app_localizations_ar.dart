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
  String get policyBody => 'إلغاء مجاني حتى ساعتين قبل الموعد. قد تُطبّق رسوم بعد ذلك.';

  @override
  String get reschedule => 'إعادة جدولة';

  @override
  String get cancelBooking => 'إلغاء الحجز';

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
  String get etaLabel => 'الوقت المتوقع';

  @override
  String etaValue(Object minutes) {
    return '$minutes';
  }

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
  String get issueDescriptionHint => 'صف مشكلتك';

  @override
  String get airportEnhancementsTitle => 'خدمات المطار';

  @override
  String get flightTrackingTitle => 'تتبع الرحلة';

  @override
  String get flightStatusLabel => 'حالة الرحلة';

  @override
  String get flightStatusValue => 'في الوقت المحدد · المبنى 3';

  @override
  String get meetGreetTitle => 'الاستقبال والترحيب';

  @override
  String get meetGreetBody => 'سيكون السائق بانتظارك عند الوصول مع لوحة باسمك.';
}
