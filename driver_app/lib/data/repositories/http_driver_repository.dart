import 'package:dropzone_driver_app/data/api/driver_api_service.dart';
import 'package:dropzone_driver_app/domain/entities/driver_profile.dart';
import 'package:dropzone_driver_app/domain/entities/driver_ride.dart';
import 'package:dropzone_driver_app/domain/entities/ride_assignment.dart';
import 'package:dropzone_driver_app/domain/repositories/driver_repository.dart';

class HttpDriverRepository implements DriverRepository {
  HttpDriverRepository(this._apiService);

  final DriverApiService _apiService;

  @override
  Future<DriverProfile> getProfile() async {
    final dto = await _apiService.getProfile();
    return dto.toDomain();
  }

  @override
  Future<List<DriverRide>> getAssignedRides() async {
    final dtos = await _apiService.getAssignedRides();
    return dtos.map((dto) => dto.toDomain()).toList();
  }

  @override
  Future<RideAssignment> acceptRide(int bookingId) async {
    final dto = await _apiService.acceptRide(bookingId);
    return dto.toDomain();
  }

  @override
  Future<RideAssignment> rejectRide(int bookingId) async {
    final dto = await _apiService.rejectRide(bookingId);
    return dto.toDomain();
  }

  @override
  Future<DriverRide> updateRideStatus({
    required int bookingId,
    required String status,
  }) async {
    final dto = await _apiService.updateRideStatus(
      bookingId: bookingId,
      status: status,
    );
    return dto.toDomain();
  }

  @override
  Future<void> updateLocation({
    required double latitude,
    required double longitude,
  }) {
    return _apiService.updateLocation(
      latitude: latitude,
      longitude: longitude,
    );
  }
}
