import 'package:dropzone_app/domain/entities/booking.dart';

abstract class BookingRepository {
  Future<List<Booking>> getUpcomingBookings();
  Future<List<Booking>> getPastBookings();
  Future<Booking?> getBookingById(String id);
  Future<Booking> createBooking(Booking booking);
  Future<void> cancelBooking(String id);
  Future<void> rescheduleBooking(String id, DateTime newDate);
  Future<double> estimatePrice({
    required TripType tripType,
    required VehicleClass vehicleClass,
  });
}
