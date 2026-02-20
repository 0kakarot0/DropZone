import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'DropZone Chauffeur';

  @override
  String get navHome => 'Home';

  @override
  String get navBookings => 'Bookings';

  @override
  String get navSupport => 'Support';

  @override
  String get navProfile => 'Profile';

  @override
  String get homeHeroTitle => 'Private Chauffeur, pre‑booked.';

  @override
  String get homeHeroSubtitle => 'Airport & business rides across the UAE';

  @override
  String get bookNow => 'Book now';

  @override
  String get bookingTitle => 'Book a ride';

  @override
  String get tripType => 'Trip type';

  @override
  String get tripAirportPickup => 'Airport pickup';

  @override
  String get tripAirportDrop => 'Airport drop';

  @override
  String get tripBusiness => 'Business ride';

  @override
  String get pickup => 'Pickup';

  @override
  String get dropoff => 'Drop‑off';

  @override
  String get date => 'Date';

  @override
  String get time => 'Time';

  @override
  String get passengers => 'Passengers';

  @override
  String get luggage => 'Luggage';

  @override
  String get vehicleClass => 'Vehicle class';

  @override
  String get vehicleSedan => 'Sedan';

  @override
  String get vehicleSUV => 'SUV';

  @override
  String get vehicleLuxury => 'Luxury';

  @override
  String get vehicleVan => 'Van';

  @override
  String get continueLabel => 'Continue';

  @override
  String get summary => 'Summary';

  @override
  String get estimatedPrice => 'Estimated price';

  @override
  String get pricePlaceholder => 'AED —';

  @override
  String get confirmRequest => 'Confirm request';

  @override
  String get supportTitle => 'Support';

  @override
  String get profileTitle => 'Profile';

  @override
  String get bookingsTitle => 'My bookings';

  @override
  String get emptyBookings => 'No bookings yet';

  @override
  String get comingSoon => 'Coming soon';

  @override
  String get authTitle => 'Sign in';

  @override
  String get sendOtp => 'Send OTP';

  @override
  String get verifyPhone => 'Verify phone';

  @override
  String get otpPrompt => 'Enter the 4-digit code sent to you';

  @override
  String get verifyAndContinue => 'Verify & continue';

  @override
  String get profileDetails => 'Profile details';

  @override
  String get savedPassengers => 'Saved passengers';

  @override
  String get passengerSelf => 'Self';

  @override
  String get passengerAssistant => 'Assistant';

  @override
  String get passengerExecutive => 'Executive';

  @override
  String get corporateMode => 'Corporate mode';

  @override
  String get businessAccountToggle => 'Business account';

  @override
  String get corporateSubtitle => 'Enable to add company details';

  @override
  String get saveProfile => 'Save profile';

  @override
  String get upcoming => 'Upcoming';

  @override
  String get past => 'Past';

  @override
  String get bookingDetails => 'Booking details';

  @override
  String get statusTimeline => 'Status timeline';

  @override
  String get statusRequested => 'Requested';

  @override
  String get statusConfirmed => 'Confirmed';

  @override
  String get statusDriverAssigned => 'Driver assigned';

  @override
  String get statusEnRoute => 'En route';

  @override
  String get statusCompleted => 'Completed';

  @override
  String get statusCancelled => 'Cancelled';

  @override
  String get policyTitle => 'Cancellation policy';

  @override
  String get policyBody => 'Free cancellation up to 2 hours before pickup. Fees may apply afterwards.';

  @override
  String get reschedule => 'Reschedule';

  @override
  String get cancelBooking => 'Cancel booking';

  @override
  String get bookingCreated => 'Booking request submitted';

  @override
  String get surchargeNote => 'Airport fees and night surcharges may apply';

  @override
  String get errorLabel => 'Error';

  @override
  String get rescheduleConfirmed => 'Reschedule request sent';

  @override
  String get cancelConfirmed => 'Booking cancelled';

  @override
  String get paymentTitle => 'Payment';

  @override
  String get chooseCard => 'Choose a card';

  @override
  String expires(Object expiry) {
    return 'Expires $expiry';
  }

  @override
  String amountDue(Object amount) {
    return 'Amount due: AED $amount';
  }

  @override
  String get payNow => 'Pay now';

  @override
  String paymentSuccess(Object id) {
    return 'Payment successful: $id';
  }

  @override
  String get receiptTitle => 'Receipt';

  @override
  String receiptId(Object id) {
    return 'Receipt ID: $id';
  }

  @override
  String get tripTrackingTitle => 'Trip tracking';

  @override
  String get mapPlaceholder => 'Live map preview';

  @override
  String get driverAssignedTitle => 'Driver assigned';

  @override
  String get driverAssignedSubtitle => 'Ahmed • Lexus ES • DXB 1234';

  @override
  String get etaLabel => 'ETA';

  @override
  String etaValue(Object minutes) {
    return '$minutes';
  }

  @override
  String get contactDriver => 'Contact driver';

  @override
  String get contactDriverHint => 'Calling masked number';

  @override
  String get notificationsTitle => 'Notifications';

  @override
  String get notificationConfirmed => 'Booking confirmed';

  @override
  String get notificationConfirmedBody => 'Your driver is being assigned';

  @override
  String get notificationDriverAssigned => 'Driver assigned';

  @override
  String get notificationDriverAssignedBody => 'Ahmed will arrive soon';

  @override
  String get saveFlightInfo => 'Save flight details';

  @override
  String get contactDriverTitle => 'Contact driver';

  @override
  String get maskedCallTitle => 'Masked call';

  @override
  String get maskedCallBody => 'Use a masked number for privacy';

  @override
  String get inAppChatTitle => 'In-app chat';

  @override
  String get inAppChatBody => 'Secure messaging with driver';

  @override
  String get startMaskedCall => 'Start masked call';

  @override
  String get maskedCallHint => 'Calling via masked number';

  @override
  String get notificationArriving => 'Driver arriving';

  @override
  String get notificationArrivingBody => 'ETA 8 minutes';

  @override
  String get helpCenterTitle => 'Help center';

  @override
  String get helpTopicPayment => 'Payment issues';

  @override
  String get helpTopicDriver => 'Driver support';

  @override
  String get helpTopicLostItem => 'Lost items';

  @override
  String get reportIssueTitle => 'Report an issue';

  @override
  String get issueCategoryPayment => 'Payment';

  @override
  String get issueCategoryDriver => 'Driver';

  @override
  String get issueCategoryOther => 'Other';

  @override
  String get selectCategory => 'Select category';

  @override
  String get submitIssue => 'Submit issue';

  @override
  String get airportEnhancementsTitle => 'Airport enhancements';

  @override
  String get flightTrackingTitle => 'Flight tracking';

  @override
  String get flightStatusLabel => 'Flight status';

  @override
  String get flightStatusValue => 'On time · Terminal 3';

  @override
  String get meetGreetTitle => 'Meet & greet';

  @override
  String get meetGreetBody => 'Your driver will wait at arrivals with your name sign.';
}
