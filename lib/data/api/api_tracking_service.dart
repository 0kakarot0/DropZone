import 'package:dio/dio.dart';
import 'package:dropzone_app/data/dto/tracking_dto.dart';
import 'package:dropzone_app/core/utils/app_exception.dart';

/// Dio wrapper for the tracking API.
class ApiTrackingService {
  const ApiTrackingService(this._dio);

  final Dio _dio;

  // ── GET /api/tracking/{bookingId} ─────────────────────────────────────────
  /// Returns tracking data or null if no tracking is available (204 / 404).
  Future<TrackingResponseDto?> track(int bookingId) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/api/tracking/$bookingId',
      );
      if (response.statusCode == 204 || response.data == null) return null;
      return TrackingResponseDto.fromJson(response.data!);
    } on DioException catch (e) {
      if (e.response?.statusCode == 204 || e.response?.statusCode == 404) {
        return null;
      }
      throw _translate(e);
    }
  }

  AppException _translate(DioException e) {
    final statusCode = e.response?.statusCode;
    final message = e.message ?? 'Unknown error';
    switch (statusCode) {
      case 401:
        return const UnauthorizedException('Session expired.');
      default:
        return ServerException('Server error ($statusCode): $message');
    }
  }
}
