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
