import 'package:dropzone_driver_app/domain/entities/driver_profile.dart';
import 'package:dropzone_driver_app/domain/entities/driver_ride.dart';
import 'package:dropzone_driver_app/domain/entities/ride_assignment.dart';

abstract class DriverRepository {
  Future<DriverProfile> getProfile();

  Future<List<DriverRide>> getAssignedRides();

  Future<RideAssignment> acceptRide(int bookingId);

  Future<RideAssignment> rejectRide(int bookingId);

  Future<DriverRide> updateRideStatus({
    required int bookingId,
    required String status,
  });

  Future<void> updateLocation({
    required double latitude,
    required double longitude,
  });
}
