import 'package:dio/dio.dart';
import 'package:dropzone_app/data/dto/preferences_dto.dart';
import 'package:dropzone_app/core/utils/app_exception.dart';

/// Raw Dio wrapper for profile-related APIs (preferences).
class ApiProfileService {
  const ApiProfileService(this._dio);

  final Dio _dio;

  // ── GET /api/profile/preferences ──────────────────────────────────────────
  Future<UserPreferencesResponseDto> getPreferences() async {
    final response = await _call(() => _dio.get<Map<String, dynamic>>(
          '/api/profile/preferences',
        ));
    return UserPreferencesResponseDto.fromJson(response.data!);
  }

  // ── PUT /api/profile/preferences ──────────────────────────────────────────
  Future<UserPreferencesResponseDto> updatePreferences(
    UpdatePreferencesRequestDto request,
  ) async {
    final response = await _call(() => _dio.put<Map<String, dynamic>>(
          '/api/profile/preferences',
          data: request.toJson(),
        ));
    return UserPreferencesResponseDto.fromJson(response.data!);
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
    final statusCode = e.response?.statusCode;
    final responseData = e.response?.data;
    final message =
        (responseData is Map<String, dynamic>
                ? responseData['message'] as String?
                : null) ??
            e.message ??
            'Unknown error';
    switch (statusCode) {
      case 400:
        return BadRequestException(message);
      case 401:
        return const UnauthorizedException(
            'Session expired. Please sign in again.');
      case 404:
        return NotFoundException(message);
      default:
        return ServerException(
            'Server error (${statusCode ?? "?"}): $message');
    }
  }
}
