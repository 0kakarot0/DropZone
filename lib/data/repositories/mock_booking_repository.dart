import 'dart:math';

import 'package:dropzone_app/domain/entities/booking.dart';
import 'package:dropzone_app/domain/repositories/booking_repository.dart';

class MockBookingRepository implements BookingRepository {
  final List<Booking> _upcoming = [
    Booking(
      id: 'DZ-1024',
      tripType: TripType.airportPickup,
      pickup: 'DXB Terminal 3',
      dropoff: 'Downtown Dubai',
      dateTime: DateTime.now().add(const Duration(days: 1)),
      vehicleClass: VehicleClass.luxury,
      status: BookingStatus.confirmed,
      price: 480,
    ),
    Booking(
      id: 'DZ-1029',
      tripType: TripType.business,
      pickup: 'Abu Dhabi Global Market',
      dropoff: 'Rosewood Abu Dhabi',
      dateTime: DateTime.now().add(const Duration(days: 3)),
      vehicleClass: VehicleClass.sedan,
      status: BookingStatus.driverAssigned,
      price: 220,
    ),
  ];

  final List<Booking> _past = [
    Booking(
      id: 'DZ-0999',
      tripType: TripType.airportDrop,
      pickup: 'Palm Jumeirah',
      dropoff: 'DXB Terminal 1',
      dateTime: DateTime.now().subtract(const Duration(days: 2)),
      vehicleClass: VehicleClass.suv,
      status: BookingStatus.completed,
      price: 350,
    ),
  ];

  @override
  Future<Booking> createBooking(Booking booking) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    final created = Booking(
      id: 'DZ-${1000 + Random().nextInt(900)}',
      tripType: booking.tripType,
      pickup: booking.pickup,
      dropoff: booking.dropoff,
      dateTime: booking.dateTime,
      vehicleClass: booking.vehicleClass,
      status: BookingStatus.requested,
      price: booking.price,
    );
    _upcoming.insert(0, created);
    return created;
  }

  @override
  Future<void> cancelBooking(String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    _upcoming.removeWhere((booking) => booking.id == id);
  }

  @override
  Future<List<Booking>> getPastBookings() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return _past;
  }

  @override
  Future<List<Booking>> getUpcomingBookings() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return _upcoming;
  }

  @override
  Future<void> rescheduleBooking(String id, DateTime newDate) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    _upcoming.replaceRange(
      0,
      _upcoming.length,
      _upcoming.map(
        (booking) => booking.id == id
            ? Booking(
                id: booking.id,
                tripType: booking.tripType,
                pickup: booking.pickup,
                dropoff: booking.dropoff,
                dateTime: newDate,
                vehicleClass: booking.vehicleClass,
                status: booking.status,
                price: booking.price,
              )
            : booking,
      ),
    );
  }

  @override
  Future<double> estimatePrice({
    required TripType tripType,
    required VehicleClass vehicleClass,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return 250 + (vehicleClass.index * 60);
  }

  @override
  Future<Booking?> getBookingById(String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    try {
      return _upcoming.firstWhere((booking) => booking.id == id);
    } catch (_) {
      try {
        return _past.firstWhere((booking) => booking.id == id);
      } catch (_) {
        return null;
      }
    }
  }
}
