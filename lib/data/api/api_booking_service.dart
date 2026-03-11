import 'package:dio/dio.dart';
import 'package:dropzone_app/data/dto/booking_dto.dart';
import 'package:dropzone_app/core/utils/app_exception.dart';

/// Raw Dio wrapper for the DropZone Chauffeur booking API.
/// Each method maps to exactly one endpoint and returns the DTO directly.
/// Throws a typed [AppException] subclass on any failure.
class ApiBookingService {
  const ApiBookingService(this._dio);

  final Dio _dio;

  // ── GET /api/bookings ──────────────────────────────────────────────────────
  Future<List<BookingResponseDto>> list({int limit = 20, int offset = 0}) async {
    final response = await _call(() => _dio.get<List<dynamic>>(
          '/api/bookings',
          queryParameters: {'limit': limit, 'offset': offset},
        ));
    final data = response.data;
    if (data == null) return [];
    return data
        .whereType<Map<String, dynamic>>()
        .map(BookingResponseDto.fromJson)
        .toList();
  }

  // ── POST /api/bookings ─────────────────────────────────────────────────────
  Future<BookingResponseDto> create(CreateBookingRequestDto request) async {
    final response = await _call(() => _dio.post<Map<String, dynamic>>(
          '/api/bookings',
          data: request.toJson(),
        ));
    return BookingResponseDto.fromJson(response.data!);
  }

  // ── GET /api/bookings/{id} ─────────────────────────────────────────────────
  Future<BookingResponseDto> getById(int id) async {
    final response = await _call(() => _dio.get<Map<String, dynamic>>(
          '/api/bookings/$id',
        ));
    return BookingResponseDto.fromJson(response.data!);
  }

  // ── POST /api/bookings/{id}/cancel ────────────────────────────────────────
  Future<BookingResponseDto> cancel(int id) async {
    final response = await _call(() => _dio.post<Map<String, dynamic>>(
          '/api/bookings/$id/cancel',
        ));
    return BookingResponseDto.fromJson(response.data!);
  }

  // ── POST /api/bookings/{id}/reschedule ────────────────────────────────────
  Future<BookingResponseDto> reschedule(
    int id,
    RescheduleBookingRequestDto request,
  ) async {
    final response = await _call(() => _dio.post<Map<String, dynamic>>(
          '/api/bookings/$id/reschedule',
          data: request.toJson(),
        ));
    return BookingResponseDto.fromJson(response.data!);
  }

  // ── POST /api/bookings/estimate ───────────────────────────────────────────
  Future<PriceEstimateResponseDto> estimate(
    PriceEstimateRequestDto request,
  ) async {
    final response = await _call(() => _dio.post<Map<String, dynamic>>(
          '/api/bookings/estimate',
          data: request.toJson(),
        ));
    return PriceEstimateResponseDto.fromJson(response.data!);
  }

  // ── GET /api/bookings/{id}/events ─────────────────────────────────────────
  Future<List<BookingEventResponseDto>> events(int id) async {
    final response = await _call(() => _dio.get<List<dynamic>>(
          '/api/bookings/$id/events',
        ));
    final data = response.data;
    if (data == null) return [];
    return data
        .whereType<Map<String, dynamic>>()
        .map(BookingEventResponseDto.fromJson)
        .toList();
  }

  // ── Error translation ──────────────────────────────────────────────────────
  Future<Response<T>> _call<T>(Future<Response<T>> Function() fn) async {
    try {
      return await fn();
    } on DioException catch (e) {
      throw _translateDioException(e);
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  AppException _translateDioException(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout ||
        e.type == DioExceptionType.connectionError) {
      return const NetworkException('No connection or request timed out.');
    }
    final statusCode = e.response?.statusCode;
    final responseData = e.response?.data;
    final message =
        (responseData is Map<String, dynamic> ? responseData['message'] as String? : null) ??
            e.message ??
            'Unknown error';
    switch (statusCode) {
      case 400:
        return BadRequestException(message.toString());
      case 401:
        return const UnauthorizedException(
            'Session expired. Please sign in again.');
      case 403:
        return const ForbiddenException('You do not have permission.');
      case 404:
        return NotFoundException(message.toString());
      default:
        return ServerException(
            'Server error (${statusCode ?? "?"}): $message');
    }
  }
}
