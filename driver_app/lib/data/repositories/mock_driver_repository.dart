import 'package:dropzone_driver_app/domain/entities/driver_profile.dart';
import 'package:dropzone_driver_app/domain/entities/driver_ride.dart';
import 'package:dropzone_driver_app/domain/entities/ride_assignment.dart';
import 'package:dropzone_driver_app/domain/repositories/driver_repository.dart';

class MockDriverRepository implements DriverRepository {
  @override
  Future<DriverProfile> getProfile() async {
    return const DriverProfile(
      id: 12,
      displayName: 'Ahmed Kareem',
      phone: '+971 50 123 4567',
      email: 'ahmed.kareem@dropzone.local',
      status: 'BUSY',
      rating: 4.9,
      vehicleType: 'Lexus ES',
      vehiclePlate: 'DXB 1234',
    );
  }

  @override
  Future<List<DriverRide>> getAssignedRides() async {
    final now = DateTime.now();
    return <DriverRide>[
      DriverRide(
        id: 401,
        pickupLocation: 'DXB Terminal 3 Arrivals',
        dropoffLocation: 'DIFC Gate Avenue',
        pickupTime: now.add(const Duration(minutes: 25)),
        passengers: 2,
        notes: 'Meet passenger near the premium pickup zone.',
        bookingStatus: 'ASSIGNED',
        paymentMethod: 'CARD',
        currency: 'AED',
        priceEstimateCents: 18500,
        pickupLatitude: 25.2528,
        pickupLongitude: 55.3644,
        dropoffLatitude: 25.2114,
        dropoffLongitude: 55.2796,
        assignmentStatus: 'OFFERED',
      ),
      DriverRide(
        id: 387,
        pickupLocation: 'Address Sky View Hotel',
        dropoffLocation: 'Al Maktoum Airport',
        pickupTime: now.subtract(const Duration(minutes: 10)),
        passengers: 1,
        notes: 'VIP guest with one checked bag.',
        bookingStatus: 'DRIVER_EN_ROUTE',
        paymentMethod: 'CASH',
        currency: 'AED',
        priceEstimateCents: 26000,
        pickupLatitude: 25.1987,
        pickupLongitude: 55.2744,
        dropoffLatitude: 24.8964,
        dropoffLongitude: 55.1614,
        assignmentStatus: 'ACCEPTED',
      ),
      DriverRide(
        id: 365,
        pickupLocation: 'Dubai Marina Gate 2',
        dropoffLocation: 'Jumeirah Emirates Towers',
        pickupTime: now.add(const Duration(hours: 2)),
        passengers: 3,
        notes: null,
        bookingStatus: 'ASSIGNED',
        paymentMethod: 'CARD',
        currency: 'AED',
        priceEstimateCents: 14500,
      ),
    ];
  }

  @override
  Future<RideAssignment> acceptRide(int bookingId) async {
    return RideAssignment(
      id: bookingId + 1000,
      bookingId: bookingId,
      driverId: 12,
      status: 'ACCEPTED',
      offeredAt: DateTime.now().subtract(const Duration(minutes: 5)),
      respondedAt: DateTime.now(),
    );
  }

  @override
  Future<RideAssignment> rejectRide(int bookingId) async {
    return RideAssignment(
      id: bookingId + 1000,
      bookingId: bookingId,
      driverId: 12,
      status: 'REJECTED',
      offeredAt: DateTime.now().subtract(const Duration(minutes: 5)),
      respondedAt: DateTime.now(),
    );
  }

  @override
  Future<DriverRide> updateRideStatus({
    required int bookingId,
    required String status,
  }) async {
    return DriverRide(
      id: bookingId,
      pickupLocation: 'Placeholder pickup',
      dropoffLocation: 'Placeholder dropoff',
      pickupTime: DateTime.now(),
      passengers: 1,
      bookingStatus: status,
      paymentMethod: 'CARD',
    );
  }

  @override
  Future<void> updateLocation({
    required double latitude,
    required double longitude,
  }) async {}
}
