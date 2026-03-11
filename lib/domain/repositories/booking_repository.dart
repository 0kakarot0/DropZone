import 'package:dropzone_app/domain/entities/booking.dart';

abstract class BookingRepository {
  /// List bookings for the current user (paginated).
  Future<List<Booking>> listBookings({int limit = 20, int offset = 0});

  /// Create a new booking.
  Future<Booking> createBooking(Booking booking);

  /// Get the details of a single booking.
  Future<Booking> getBooking(int id);

  /// Cancel a booking.
  Future<Booking> cancelBooking(int id);

  /// Reschedule a booking's pickup time.
  Future<Booking> rescheduleBooking(int id, DateTime newPickupTime);

  /// Get a deterministic price estimate in AED.
  Future<PriceEstimate> estimatePrice({
    required TripType serviceType,
    required DateTime pickupTime,
    int? passengers,
  });

  /// Get the event timeline for a booking.
  Future<List<BookingEvent>> getBookingEvents(int id);
}
