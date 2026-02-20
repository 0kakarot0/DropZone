import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'DropZone Chauffeur'**
  String get appTitle;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navBookings.
  ///
  /// In en, this message translates to:
  /// **'Bookings'**
  String get navBookings;

  /// No description provided for @navSupport.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get navSupport;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @homeHeroTitle.
  ///
  /// In en, this message translates to:
  /// **'Private Chauffeur, pre‑booked.'**
  String get homeHeroTitle;

  /// No description provided for @homeHeroSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Airport & business rides across the UAE'**
  String get homeHeroSubtitle;

  /// No description provided for @bookNow.
  ///
  /// In en, this message translates to:
  /// **'Book now'**
  String get bookNow;

  /// No description provided for @bookingTitle.
  ///
  /// In en, this message translates to:
  /// **'Book a ride'**
  String get bookingTitle;

  /// No description provided for @tripType.
  ///
  /// In en, this message translates to:
  /// **'Trip type'**
  String get tripType;

  /// No description provided for @tripAirportPickup.
  ///
  /// In en, this message translates to:
  /// **'Airport pickup'**
  String get tripAirportPickup;

  /// No description provided for @tripAirportDrop.
  ///
  /// In en, this message translates to:
  /// **'Airport drop'**
  String get tripAirportDrop;

  /// No description provided for @tripBusiness.
  ///
  /// In en, this message translates to:
  /// **'Business ride'**
  String get tripBusiness;

  /// No description provided for @pickup.
  ///
  /// In en, this message translates to:
  /// **'Pickup'**
  String get pickup;

  /// No description provided for @dropoff.
  ///
  /// In en, this message translates to:
  /// **'Drop‑off'**
  String get dropoff;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @time.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time;

  /// No description provided for @passengers.
  ///
  /// In en, this message translates to:
  /// **'Passengers'**
  String get passengers;

  /// No description provided for @luggage.
  ///
  /// In en, this message translates to:
  /// **'Luggage'**
  String get luggage;

  /// No description provided for @vehicleClass.
  ///
  /// In en, this message translates to:
  /// **'Vehicle class'**
  String get vehicleClass;

  /// No description provided for @vehicleSedan.
  ///
  /// In en, this message translates to:
  /// **'Sedan'**
  String get vehicleSedan;

  /// No description provided for @vehicleSUV.
  ///
  /// In en, this message translates to:
  /// **'SUV'**
  String get vehicleSUV;

  /// No description provided for @vehicleLuxury.
  ///
  /// In en, this message translates to:
  /// **'Luxury'**
  String get vehicleLuxury;

  /// No description provided for @vehicleVan.
  ///
  /// In en, this message translates to:
  /// **'Van'**
  String get vehicleVan;

  /// No description provided for @continueLabel.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueLabel;

  /// No description provided for @summary.
  ///
  /// In en, this message translates to:
  /// **'Summary'**
  String get summary;

  /// No description provided for @estimatedPrice.
  ///
  /// In en, this message translates to:
  /// **'Estimated price'**
  String get estimatedPrice;

  /// No description provided for @pricePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'AED —'**
  String get pricePlaceholder;

  /// No description provided for @confirmRequest.
  ///
  /// In en, this message translates to:
  /// **'Confirm request'**
  String get confirmRequest;

  /// No description provided for @supportTitle.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get supportTitle;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @bookingsTitle.
  ///
  /// In en, this message translates to:
  /// **'My bookings'**
  String get bookingsTitle;

  /// No description provided for @emptyBookings.
  ///
  /// In en, this message translates to:
  /// **'No bookings yet'**
  String get emptyBookings;

  /// No description provided for @comingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get comingSoon;

  /// No description provided for @authTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get authTitle;

  /// No description provided for @sendOtp.
  ///
  /// In en, this message translates to:
  /// **'Send OTP'**
  String get sendOtp;

  /// No description provided for @verifyPhone.
  ///
  /// In en, this message translates to:
  /// **'Verify phone'**
  String get verifyPhone;

  /// No description provided for @otpPrompt.
  ///
  /// In en, this message translates to:
  /// **'Enter the 4-digit code sent to you'**
  String get otpPrompt;

  /// No description provided for @verifyAndContinue.
  ///
  /// In en, this message translates to:
  /// **'Verify & continue'**
  String get verifyAndContinue;

  /// No description provided for @profileDetails.
  ///
  /// In en, this message translates to:
  /// **'Profile details'**
  String get profileDetails;

  /// No description provided for @savedPassengers.
  ///
  /// In en, this message translates to:
  /// **'Saved passengers'**
  String get savedPassengers;

  /// No description provided for @passengerSelf.
  ///
  /// In en, this message translates to:
  /// **'Self'**
  String get passengerSelf;

  /// No description provided for @passengerAssistant.
  ///
  /// In en, this message translates to:
  /// **'Assistant'**
  String get passengerAssistant;

  /// No description provided for @passengerExecutive.
  ///
  /// In en, this message translates to:
  /// **'Executive'**
  String get passengerExecutive;

  /// No description provided for @corporateMode.
  ///
  /// In en, this message translates to:
  /// **'Corporate mode'**
  String get corporateMode;

  /// No description provided for @businessAccountToggle.
  ///
  /// In en, this message translates to:
  /// **'Business account'**
  String get businessAccountToggle;

  /// No description provided for @corporateSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enable to add company details'**
  String get corporateSubtitle;

  /// No description provided for @saveProfile.
  ///
  /// In en, this message translates to:
  /// **'Save profile'**
  String get saveProfile;

  /// No description provided for @upcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get upcoming;

  /// No description provided for @past.
  ///
  /// In en, this message translates to:
  /// **'Past'**
  String get past;

  /// No description provided for @bookingDetails.
  ///
  /// In en, this message translates to:
  /// **'Booking details'**
  String get bookingDetails;

  /// No description provided for @statusTimeline.
  ///
  /// In en, this message translates to:
  /// **'Status timeline'**
  String get statusTimeline;

  /// No description provided for @statusRequested.
  ///
  /// In en, this message translates to:
  /// **'Requested'**
  String get statusRequested;

  /// No description provided for @statusConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Confirmed'**
  String get statusConfirmed;

  /// No description provided for @statusDriverAssigned.
  ///
  /// In en, this message translates to:
  /// **'Driver assigned'**
  String get statusDriverAssigned;

  /// No description provided for @statusEnRoute.
  ///
  /// In en, this message translates to:
  /// **'En route'**
  String get statusEnRoute;

  /// No description provided for @statusCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get statusCompleted;

  /// No description provided for @statusCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get statusCancelled;

  /// No description provided for @policyTitle.
  ///
  /// In en, this message translates to:
  /// **'Cancellation policy'**
  String get policyTitle;

  /// No description provided for @policyBody.
  ///
  /// In en, this message translates to:
  /// **'Free cancellation up to 2 hours before pickup. Fees may apply afterwards.'**
  String get policyBody;

  /// No description provided for @reschedule.
  ///
  /// In en, this message translates to:
  /// **'Reschedule'**
  String get reschedule;

  /// No description provided for @cancelBooking.
  ///
  /// In en, this message translates to:
  /// **'Cancel booking'**
  String get cancelBooking;

  /// No description provided for @bookingCreated.
  ///
  /// In en, this message translates to:
  /// **'Booking request submitted'**
  String get bookingCreated;

  /// No description provided for @surchargeNote.
  ///
  /// In en, this message translates to:
  /// **'Airport fees and night surcharges may apply'**
  String get surchargeNote;

  /// No description provided for @errorLabel.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get errorLabel;

  /// No description provided for @rescheduleConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Reschedule request sent'**
  String get rescheduleConfirmed;

  /// No description provided for @cancelConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Booking cancelled'**
  String get cancelConfirmed;

  /// No description provided for @paymentTitle.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get paymentTitle;

  /// No description provided for @chooseCard.
  ///
  /// In en, this message translates to:
  /// **'Choose a card'**
  String get chooseCard;

  /// No description provided for @expires.
  ///
  /// In en, this message translates to:
  /// **'Expires {expiry}'**
  String expires(Object expiry);

  /// No description provided for @amountDue.
  ///
  /// In en, this message translates to:
  /// **'Amount due: AED {amount}'**
  String amountDue(Object amount);

  /// No description provided for @payNow.
  ///
  /// In en, this message translates to:
  /// **'Pay now'**
  String get payNow;

  /// No description provided for @paymentSuccess.
  ///
  /// In en, this message translates to:
  /// **'Payment successful: {id}'**
  String paymentSuccess(Object id);

  /// No description provided for @receiptTitle.
  ///
  /// In en, this message translates to:
  /// **'Receipt'**
  String get receiptTitle;

  /// No description provided for @receiptId.
  ///
  /// In en, this message translates to:
  /// **'Receipt ID: {id}'**
  String receiptId(Object id);

  /// No description provided for @tripTrackingTitle.
  ///
  /// In en, this message translates to:
  /// **'Trip tracking'**
  String get tripTrackingTitle;

  /// No description provided for @mapPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Live map preview'**
  String get mapPlaceholder;

  /// No description provided for @driverAssignedTitle.
  ///
  /// In en, this message translates to:
  /// **'Driver assigned'**
  String get driverAssignedTitle;

  /// No description provided for @driverAssignedSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Ahmed • Lexus ES • DXB 1234'**
  String get driverAssignedSubtitle;

  /// No description provided for @etaLabel.
  ///
  /// In en, this message translates to:
  /// **'ETA'**
  String get etaLabel;

  /// No description provided for @etaValue.
  ///
  /// In en, this message translates to:
  /// **'{minutes}'**
  String etaValue(Object minutes);

  /// No description provided for @contactDriver.
  ///
  /// In en, this message translates to:
  /// **'Contact driver'**
  String get contactDriver;

  /// No description provided for @contactDriverHint.
  ///
  /// In en, this message translates to:
  /// **'Calling masked number'**
  String get contactDriverHint;

  /// No description provided for @notificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationsTitle;

  /// No description provided for @notificationConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Booking confirmed'**
  String get notificationConfirmed;

  /// No description provided for @notificationConfirmedBody.
  ///
  /// In en, this message translates to:
  /// **'Your driver is being assigned'**
  String get notificationConfirmedBody;

  /// No description provided for @notificationDriverAssigned.
  ///
  /// In en, this message translates to:
  /// **'Driver assigned'**
  String get notificationDriverAssigned;

  /// No description provided for @notificationDriverAssignedBody.
  ///
  /// In en, this message translates to:
  /// **'Ahmed will arrive soon'**
  String get notificationDriverAssignedBody;

  /// No description provided for @notificationArriving.
  ///
  /// In en, this message translates to:
  /// **'Driver arriving'**
  String get notificationArriving;

  /// No description provided for @notificationArrivingBody.
  ///
  /// In en, this message translates to:
  /// **'ETA 8 minutes'**
  String get notificationArrivingBody;

  /// No description provided for @helpCenterTitle.
  ///
  /// In en, this message translates to:
  /// **'Help center'**
  String get helpCenterTitle;

  /// No description provided for @helpTopicPayment.
  ///
  /// In en, this message translates to:
  /// **'Payment issues'**
  String get helpTopicPayment;

  /// No description provided for @helpTopicDriver.
  ///
  /// In en, this message translates to:
  /// **'Driver support'**
  String get helpTopicDriver;

  /// No description provided for @helpTopicLostItem.
  ///
  /// In en, this message translates to:
  /// **'Lost items'**
  String get helpTopicLostItem;

  /// No description provided for @reportIssueTitle.
  ///
  /// In en, this message translates to:
  /// **'Report an issue'**
  String get reportIssueTitle;

  /// No description provided for @issueCategoryPayment.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get issueCategoryPayment;

  /// No description provided for @issueCategoryDriver.
  ///
  /// In en, this message translates to:
  /// **'Driver'**
  String get issueCategoryDriver;

  /// No description provided for @issueCategoryOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get issueCategoryOther;

  /// No description provided for @selectCategory.
  ///
  /// In en, this message translates to:
  /// **'Select category'**
  String get selectCategory;

  /// No description provided for @submitIssue.
  ///
  /// In en, this message translates to:
  /// **'Submit issue'**
  String get submitIssue;

  /// No description provided for @airportEnhancementsTitle.
  ///
  /// In en, this message translates to:
  /// **'Airport enhancements'**
  String get airportEnhancementsTitle;

  /// No description provided for @flightTrackingTitle.
  ///
  /// In en, this message translates to:
  /// **'Flight tracking'**
  String get flightTrackingTitle;

  /// No description provided for @flightStatusLabel.
  ///
  /// In en, this message translates to:
  /// **'Flight status'**
  String get flightStatusLabel;

  /// No description provided for @flightStatusValue.
  ///
  /// In en, this message translates to:
  /// **'On time · Terminal 3'**
  String get flightStatusValue;

  /// No description provided for @meetGreetTitle.
  ///
  /// In en, this message translates to:
  /// **'Meet & greet'**
  String get meetGreetTitle;

  /// No description provided for @meetGreetBody.
  ///
  /// In en, this message translates to:
  /// **'Your driver will wait at arrivals with your name sign.'**
  String get meetGreetBody;

  /// No description provided for @saveFlightInfo.
  ///
  /// In en, this message translates to:
  /// **'Save flight details'**
  String get saveFlightInfo;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar': return AppLocalizationsAr();
    case 'en': return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
