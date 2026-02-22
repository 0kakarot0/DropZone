import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dropzone_app/data/repositories/mock_booking_repository.dart';
import 'package:dropzone_app/domain/entities/booking.dart';
import 'package:dropzone_app/domain/repositories/booking_repository.dart';

final bookingRepositoryProvider = Provider<BookingRepository>((ref) {
  return MockBookingRepository();
});

final upcomingBookingsProvider = FutureProvider<List<Booking>>((ref) async {
  final repo = ref.read(bookingRepositoryProvider);
  return repo.getUpcomingBookings();
});

final pastBookingsProvider = FutureProvider<List<Booking>>((ref) async {
  final repo = ref.read(bookingRepositoryProvider);
  return repo.getPastBookings();
});

final bookingDetailProvider = FutureProvider.family<Booking?, String>((ref, id) async {
  final repo = ref.read(bookingRepositoryProvider);
  return repo.getBookingById(id);
});

final priceEstimateProvider = FutureProvider.family<double, VehicleClass>((ref, vehicleClass) async {
  final repo = ref.read(bookingRepositoryProvider);
  return repo.estimatePrice(tripType: TripType.airportPickup, vehicleClass: vehicleClass);
});
