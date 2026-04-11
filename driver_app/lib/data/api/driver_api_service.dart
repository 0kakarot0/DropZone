import 'package:dio/dio.dart';
import 'package:dropzone_driver_app/data/dto/driver_profile_dto.dart';
import 'package:dropzone_driver_app/data/dto/driver_ride_dto.dart';
import 'package:dropzone_driver_app/data/dto/ride_assignment_dto.dart';

class DriverApiService {
  DriverApiService(this._dio);

  final Dio _dio;

  Future<DriverProfileDto> getProfile() async {
    final response = await _dio.get<Map<String, dynamic>>('/api/driver/profile');
    return DriverProfileDto.fromJson(response.data ?? const {});
  }

  Future<List<DriverRideDto>> getAssignedRides() async {
    final response =
        await _dio.get<List<dynamic>>('/api/driver/rides/assigned');
    final data = response.data ?? const <dynamic>[];
    return data
        .whereType<Map<String, dynamic>>()
        .map(DriverRideDto.fromJson)
        .toList();
  }

  Future<RideAssignmentDto> acceptRide(int bookingId) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/api/driver/rides/$bookingId/accept',
    );
    return RideAssignmentDto.fromJson(response.data ?? const {});
  }

  Future<RideAssignmentDto> rejectRide(int bookingId) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/api/driver/rides/$bookingId/reject',
    );
    return RideAssignmentDto.fromJson(response.data ?? const {});
  }

  Future<DriverRideDto> updateRideStatus({
    required int bookingId,
    required String status,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/api/driver/rides/$bookingId/status',
      data: {
        'status': status,
      },
    );
    return DriverRideDto.fromJson(response.data ?? const {});
  }

  Future<void> updateLocation({
    required double latitude,
    required double longitude,
  }) async {
    await _dio.post<void>(
      '/api/driver/location',
      data: {
        'latitude': latitude,
        'longitude': longitude,
      },
    );
  }
}
