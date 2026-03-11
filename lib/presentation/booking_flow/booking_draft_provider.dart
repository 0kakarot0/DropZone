import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dropzone_app/domain/entities/booking.dart';

/// Holds an in-memory draft of the booking flow fields.
/// Written to as the user fills each step; cleared on successful submission
/// or explicit abandon. Survives tab switches within the same app session.
class BookingDraft {
  const BookingDraft({
    this.tripType = TripType.airportPickup,
    this.vehicleClass = VehicleClass.sedan,
    this.pickup = '',
    this.dropoff = '',
    this.passengers = 1,
    this.notes = '',
    this.pickedDate,
    this.pickedTime,
    this.currentStep = 0,
  });

  final TripType tripType;
  final VehicleClass vehicleClass;
  final String pickup;
  final String dropoff;
  final int passengers;
  final String notes;
  final DateTime? pickedDate;
  final TimeOfDay? pickedTime;
  final int currentStep;

  /// True when the user has meaningfully started filling the form.
  bool get hasProgress =>
      pickup.isNotEmpty ||
      dropoff.isNotEmpty ||
      passengers != 1 ||
      notes.isNotEmpty ||
      pickedDate != null ||
      currentStep > 0;

  BookingDraft copyWith({
    TripType? tripType,
    VehicleClass? vehicleClass,
    String? pickup,
    String? dropoff,
    int? passengers,
    String? notes,
    DateTime? pickedDate,
    TimeOfDay? pickedTime,
    int? currentStep,
    bool clearDate = false,
    bool clearTime = false,
  }) {
    return BookingDraft(
      tripType: tripType ?? this.tripType,
      vehicleClass: vehicleClass ?? this.vehicleClass,
      pickup: pickup ?? this.pickup,
      dropoff: dropoff ?? this.dropoff,
      passengers: passengers ?? this.passengers,
      notes: notes ?? this.notes,
      pickedDate: clearDate ? null : pickedDate ?? this.pickedDate,
      pickedTime: clearTime ? null : pickedTime ?? this.pickedTime,
      currentStep: currentStep ?? this.currentStep,
    );
  }
}

class BookingDraftNotifier extends Notifier<BookingDraft> {
  @override
  BookingDraft build() => const BookingDraft();

  void update(BookingDraft Function(BookingDraft) updater) =>
      state = updater(state);

  void clear() => state = const BookingDraft();
}

final bookingDraftProvider =
    NotifierProvider<BookingDraftNotifier, BookingDraft>(
  BookingDraftNotifier.new,
);
