import 'dart:math';

import 'package:dropzone_app/domain/entities/booking.dart';
import 'package:dropzone_app/domain/repositories/booking_repository.dart';

/// In-memory mock used in unit/widget tests.
/// NOT used by the production DI graph.
class MockBookingRepository implements BookingRepository {
  final List<Booking> _bookings = [
    Booking(
      id: 1024,
      tripType: TripType.airportPickup,
      pickup: 'DXB Terminal 3',
      dropoff: 'Downtown Dubai',
      dateTime: DateTime.now().add(const Duration(days: 1)),
      vehicleClass: VehicleClass.luxury,
      status: BookingStatus.created,
      priceEstimateCents: 48000,
      currency: 'AED',
    ),
    Booking(
      id: 1029,
      tripType: TripType.business,
      pickup: 'Abu Dhabi Global Market',
      dropoff: 'Rosewood Abu Dhabi',
      dateTime: DateTime.now().add(const Duration(days: 3)),
      vehicleClass: VehicleClass.sedan,
      status: BookingStatus.created,
      priceEstimateCents: 22000,
      currency: 'AED',
    ),
    Booking(
      id: 999,
      tripType: TripType.airportDrop,
      pickup: 'Palm Jumeirah',
      dropoff: 'DXB Terminal 1',
      dateTime: DateTime.now().subtract(const Duration(days: 2)),
      vehicleClass: VehicleClass.suv,
      status: BookingStatus.cancelled,
      priceEstimateCents: 35000,
      currency: 'AED',
    ),
  ];

  @override
  Future<List<Booking>> listBookings({int limit = 20, int offset = 0}) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return _bookings.skip(offset).take(limit).toList();
  }

  @override
  Future<Booking> createBooking(Booking booking) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    final created = Booking(
      id: 1000 + Random().nextInt(900),
      tripType: booking.tripType,
      pickup: booking.pickup,
      dropoff: booking.dropoff,
      dateTime: booking.dateTime,
      vehicleClass: booking.vehicleClass,
      status: BookingStatus.created,
      passengers: booking.passengers,
      notes: booking.notes,
      priceEstimateCents: booking.priceEstimateCents ?? 25000,
      currency: booking.currency ?? 'AED',
    );
    _bookings.insert(0, created);
    return created;
  }

  @override
  Future<Booking> getBooking(int id) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return _bookings.firstWhere(
      (b) => b.id == id,
      orElse: () => throw StateError('Booking $id not found'),
    );
  }

  @override
  Future<Booking> cancelBooking(int id) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    final index = _bookings.indexWhere((b) => b.id == id);
    if (index == -1) throw StateError('Booking $id not found');
    final old = _bookings[index];
    final updated = Booking(
      id: old.id,
      tripType: old.tripType,
      pickup: old.pickup,
      dropoff: old.dropoff,
      dateTime: old.dateTime,
      vehicleClass: old.vehicleClass,
      status: BookingStatus.cancelled,
      passengers: old.passengers,
      notes: old.notes,
      priceEstimateCents: old.priceEstimateCents,
      currency: old.currency,
    );
    _bookings[index] = updated;
    return updated;
  }

  @override
  Future<Booking> rescheduleBooking(int id, DateTime newPickupTime) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    final index = _bookings.indexWhere((b) => b.id == id);
    if (index == -1) throw StateError('Booking $id not found');
    final old = _bookings[index];
    final updated = Booking(
      id: old.id,
      tripType: old.tripType,
      pickup: old.pickup,
      dropoff: old.dropoff,
      dateTime: newPickupTime,
      vehicleClass: old.vehicleClass,
      status: BookingStatus.rescheduled,
      passengers: old.passengers,
      notes: old.notes,
      priceEstimateCents: old.priceEstimateCents,
      currency: old.currency,
    );
    _bookings[index] = updated;
    return updated;
  }

  @override
  Future<PriceEstimate> estimatePrice({
    required TripType serviceType,
    required DateTime pickupTime,
    int? passengers,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    final base = serviceType == TripType.business ? 25000 : 30000;
    final perPassenger = ((passengers ?? 1) - 1) * 1000;
    return PriceEstimate(
      totalCents: base + perPassenger,
      currency: 'AED',
    );
  }

  @override
  Future<List<BookingEvent>> getBookingEvents(int id) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return [
      BookingEvent(
        eventType: 'BOOKING_CREATED',
        description: 'Booking was created.',
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
    ];
  }
}
