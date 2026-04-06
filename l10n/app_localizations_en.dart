// ignore: unused_import
import 'package:intl/intl.dart' as intl;
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
  String get activeRideTitle => 'Active ride';

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
  String get profileSavedTitle => 'Profile saved';

  @override
  String get profileSavedMessage => 'Your profile has been updated.';

  @override
  String get fullNameLabel => 'Full name';

  @override
  String get emailLabel => 'Email';

  @override
  String get bookingPreferencesTitle => 'Booking preferences';

  @override
  String get bookingPreferencesSubtitle =>
      'Set defaults that pre-fill your booking form.';

  @override
  String get defaultPickupHint => 'Default pickup location';

  @override
  String get defaultDropoffHint => 'Default drop-off location';

  @override
  String get defaultPassengersLabel => 'Default passengers: ';

  @override
  String get savePreferences => 'Save preferences';

  @override
  String get preferencesSaved => 'Preferences saved';

  @override
  String preferencesSaveError(Object error) {
    return 'Could not save preferences: $error';
  }

  @override
  String profileSaveError(Object error) {
    return 'Could not save profile: $error';
  }

  @override
  String profileLoadError(Object error) {
    return 'Could not load profile: $error';
  }

  @override
  String get profileFieldsManagedNotice =>
      'Company details, cost center, rider notes, and saved passengers are not editable from the rider app yet.';

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
  String get policyBody =>
      'Free cancellation up to 2 hours before pickup. Fees may apply afterwards.';

  @override
  String get reschedule => 'Reschedule';

  @override
  String get cancelBooking => 'Cancel booking';

  @override
  String get cancelConfirmTitle => 'Cancel booking?';

  @override
  String get cancelConfirmMessage =>
      'Are you sure you want to cancel this booking?';

  @override
  String get keepBooking => 'Keep booking';

  @override
  String get confirmCancel => 'Cancel booking';

  @override
  String get editBookingTitle => 'Edit booking';

  @override
  String get saveChanges => 'Save changes';

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
  String get statusPendingPayment => 'Pending payment';

  @override
  String get statusArrivedShort => 'Arrived';

  @override
  String get statusInProgressShort => 'In progress';

  @override
  String get statusRescheduled => 'Rescheduled';

  @override
  String get statusCreated => 'Created';

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
  String get paymentSuccessTitle => 'Payment successful';

  @override
  String get paymentFailedTitle => 'Payment failed';

  @override
  String get paymentFailedMessage =>
      'We couldn’t process the payment. Please try again later.';

  @override
  String get paymentBookingConfirmed =>
      'Payment successful! Booking confirmed.';

  @override
  String paymentFailedError(Object error) {
    return 'Payment failed: $error';
  }

  @override
  String get paymentPendingTitle => 'Payment pending';

  @override
  String paymentPendingMessage(Object dateTime) {
    return 'This booking will be automatically cancelled if payment is not received before the scheduled ride ($dateTime).';
  }

  @override
  String get goHome => 'Go to Home';

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
  String driverNumber(Object id) {
    return 'Driver #$id';
  }

  @override
  String get etaLabel => 'ETA';

  @override
  String etaValue(Object minutes) {
    return '$minutes';
  }

  @override
  String get trackRide => 'Track ride';

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
  String get maskedCallUnavailableTitle => 'Masked calling unavailable';

  @override
  String get maskedCallUnavailableMessage =>
      'Masked calling is not available from the rider app yet.';

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
  String get issueSubmittedTitle => 'Issue submitted';

  @override
  String get issueSubmittedMessage =>
      'Thanks — our team will get back to you shortly.';

  @override
  String get supportSubmissionUnavailableTitle =>
      'Support submission unavailable';

  @override
  String get supportSubmissionUnavailableMessage =>
      'Issue submission is not available from the rider app yet. Please use the listed help topics or contact operations directly.';

  @override
  String get dismissLabel => 'Dismiss';

  @override
  String get issueDescriptionHint => 'Describe your issue';

  @override
  String get airportEnhancementsTitle => 'Airport enhancements';

  @override
  String get flightTrackingTitle => 'Flight tracking';

  @override
  String get flightNumberHint => 'Flight number';

  @override
  String get flightStatusLabel => 'Flight status';

  @override
  String get flightStatusValue => 'On time · Terminal 3';

  @override
  String get meetGreetTitle => 'Meet & greet';

  @override
  String get meetGreetBody =>
      'Your driver will wait at arrivals with your name sign.';

  @override
  String get flightSaveUnavailableMessage =>
      'Flight detail saving is not available in the rider app yet.';

  @override
  String get selectTime => 'Select time';

  @override
  String get noDateSelected => 'No date selected';

  @override
  String get noTimeSelected => 'No time selected';

  @override
  String get deleteBookingTitle => 'Delete booking?';

  @override
  String get deleteBookingMessage =>
      'This booking will be permanently removed.';

  @override
  String get confirmDelete => 'Delete';

  @override
  String get bookingDeletedConfirmed => 'Booking deleted';

  @override
  String get rescheduleSuccess => 'Booking rescheduled successfully';

  @override
  String get authEmailLabel => 'Email';

  @override
  String get authPasswordLabel => 'Password';

  @override
  String get authSignIn => 'Sign in';

  @override
  String get authCreateAccount => 'Create account';

  @override
  String get authFillTestCredentials => 'Tap to fill test credentials';

  @override
  String get authMissingCredentialsSignIn => 'Enter email and password.';

  @override
  String get authMissingCredentialsCreate => 'Enter email and password first.';

  @override
  String authGenericError(Object error) {
    return 'Error: $error';
  }

  @override
  String get leaveBookingTitle => 'Leave booking?';

  @override
  String get leaveBookingMessage =>
      'You have unsaved booking details. Your progress will be saved as a draft so you can continue later.';

  @override
  String get continueBooking => 'Continue booking';

  @override
  String get menuLabel => 'Menu';

  @override
  String get leaveLabel => 'Leave';

  @override
  String get signOut => 'Sign out';

  @override
  String get guestLabel => 'Guest';

  @override
  String get paymentCancelled => 'Payment cancelled.';

  @override
  String get trackingErrorTitle => 'Something went wrong';

  @override
  String get noTrackingAvailable => 'No tracking available';

  @override
  String get trackingAvailableAfterAssignment =>
      'Tracking is available once a driver is assigned';

  @override
  String get trackingStatusAssigned => 'Driver assigned, waiting for pickup';

  @override
  String get trackingStatusEnRoute => 'Driver is on the way';

  @override
  String get trackingStatusArrived => 'Driver has arrived at pickup';

  @override
  String get trackingStatusInProgress => 'Ride in progress';

  @override
  String get trackingStepAssigned => 'Assigned';

  @override
  String get trackingStepEnRoute => 'En Route';

  @override
  String get trackingStepArrived => 'Arrived';

  @override
  String get trackingStepInProgress => 'In Progress';

  @override
  String get trackingFallbackDriver => 'Driver';

  @override
  String get pickupLocationHint => 'Pickup location';

  @override
  String get dropoffLocationHint => 'Drop-off location';

  @override
  String get pickOnMapTooltip => 'Pick on map';

  @override
  String get pickPickupLocationTitle => 'Pick pickup location';

  @override
  String get pickDropoffLocationTitle => 'Pick drop-off location';

  @override
  String get selectDateFirst => 'Select a date first';

  @override
  String get notesForDriverHint => 'Notes for driver (optional)';

  @override
  String get paymentMethodTitle => 'Payment method';

  @override
  String get payByCard => 'Pay by card';

  @override
  String get payWithCash => 'Pay with cash';

  @override
  String get cashPaymentHint =>
      'Pay the driver directly at the end of the ride.';

  @override
  String get priceEstimateLoadingMessage =>
      'Price estimate is still loading, please wait.';

  @override
  String get priceEstimateRetryMessage =>
      'Could not load price estimate, retrying.';

  @override
  String bookingCompleteError(Object error) {
    return 'Unable to complete booking: $error';
  }

  @override
  String get rebookLastRide => 'Re-book last ride';
}
