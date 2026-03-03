import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dropzone_app/core/network/dio_client.dart';
import 'package:dropzone_app/data/api/api_booking_service.dart';
import 'package:dropzone_app/data/repositories/http_booking_repository.dart';
import 'package:dropzone_app/domain/entities/booking.dart';
import 'package:dropzone_app/domain/repositories/booking_repository.dart';

// ─── Repository ───────────────────────────────────────────────────────────────

final bookingApiServiceProvider = Provider<ApiBookingService>((ref) {
  return ApiBookingService(ref.read(dioProvider));
});

final bookingRepositoryProvider = Provider<BookingRepository>((ref) {
  return HttpBookingRepository(ref.read(bookingApiServiceProvider));
});

// ─── All Bookings Notifier ────────────────────────────────────────────────────
// Loads flat list from the API; UI filters by status.

class BookingsNotifier extends AsyncNotifier<List<Booking>> {
  BookingRepository get _repo => ref.read(bookingRepositoryProvider);

  @override
  Future<List<Booking>> build() => _repo.listBookings();

  Future<void> refresh() async {
    state = await AsyncValue.guard(() => _repo.listBookings());
  }

  Future<void> cancelBooking(int id) async {
    await _repo.cancelBooking(id);
    // Refresh the full list so status is updated.
    state = await AsyncValue.guard(() => _repo.listBookings());
  }

  Future<Booking> rescheduleBooking(int id, DateTime newDate) async {
    final updated = await _repo.rescheduleBooking(id, newDate);
    state = await AsyncValue.guard(() => _repo.listBookings());
    return updated;
  }
}

final bookingsProvider =
    AsyncNotifierProvider<BookingsNotifier, List<Booking>>(
  BookingsNotifier.new,
);

// ─── Derived: Upcoming ────────────────────────────────────────────────────────
// "Upcoming" = not cancelled, pickup in the future.

final upcomingBookingsProvider =
    Provider<AsyncValue<List<Booking>>>((ref) {
  return ref.watch(bookingsProvider).whenData(
        (all) => all
            .where((b) =>
                b.status != BookingStatus.cancelled &&
                b.dateTime.isAfter(DateTime.now()))
            .toList(),
      );
});

// ─── Derived: Past ────────────────────────────────────────────────────────────
// "Past" = cancelled OR pickup already in the past.

final pastBookingsProvider =
    Provider<AsyncValue<List<Booking>>>((ref) {
  return ref.watch(bookingsProvider).whenData(
        (all) => all
            .where((b) =>
                b.status == BookingStatus.cancelled ||
                b.dateTime.isBefore(DateTime.now()))
            .toList(),
      );
});

// ─── Booking Events ────────────────────────────────────────────────────────────

final bookingEventsProvider =
    FutureProvider.family<List<BookingEvent>, int>((ref, id) {
  final repo = ref.read(bookingRepositoryProvider);
  return repo.getBookingEvents(id);
});
