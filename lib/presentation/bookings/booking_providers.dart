import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dropzone_app/data/repositories/mock_booking_repository.dart';
import 'package:dropzone_app/domain/entities/booking.dart';
import 'package:dropzone_app/domain/repositories/booking_repository.dart';

// ─── Repository ──────────────────────────────────────────────────────────────

final bookingRepositoryProvider = Provider<BookingRepository>((ref) {
  return MockBookingRepository();
});

// ─── Upcoming Bookings Notifier ───────────────────────────────────────────────

class UpcomingBookingsNotifier extends AsyncNotifier<List<Booking>> {
  BookingRepository get _repo => ref.read(bookingRepositoryProvider);

  @override
  Future<List<Booking>> build() => _repo.getUpcomingBookings();

  Future<void> deleteBooking(String id) async {
    await _repo.deleteBooking(id);
    state = await AsyncValue.guard(() => _repo.getUpcomingBookings());
  }

  Future<Booking> rescheduleBooking(String id, DateTime newDate) async {
    final updated = await _repo.rescheduleBooking(id, newDate);
    state = await AsyncValue.guard(() => _repo.getUpcomingBookings());
    return updated;
  }
}

final upcomingBookingsProvider =
    AsyncNotifierProvider<UpcomingBookingsNotifier, List<Booking>>(
  UpcomingBookingsNotifier.new,
);

// ─── Past Bookings ────────────────────────────────────────────────────────────

final pastBookingsProvider = FutureProvider<List<Booking>>((ref) async {
  final repo = ref.read(bookingRepositoryProvider);
  return repo.getPastBookings();
});

// ─── Price Estimate ───────────────────────────────────────────────────────────

final priceEstimateProvider =
    FutureProvider.family<double, VehicleClass>((ref, vehicleClass) async {
  final repo = ref.read(bookingRepositoryProvider);
  return repo.estimatePrice(
      tripType: TripType.airportPickup, vehicleClass: vehicleClass);
});
