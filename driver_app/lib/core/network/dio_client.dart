import 'package:dio/dio.dart';
import 'package:dropzone_driver_app/core/network/api_exception.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

// ─────────────────────────────────────────────────────────────────────────────
// FirebaseAuthInterceptor
// Attaches the current user's Firebase ID token to every request.
// Matches the rider app pattern in lib/core/network/dio_client.dart.
// ─────────────────────────────────────────────────────────────────────────────

class FirebaseAuthInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      user ??= await FirebaseAuth.instance
          .authStateChanges()
          .first
          .timeout(const Duration(seconds: 3), onTimeout: () => null);

      if (user != null) {
        final token = await user.getIdToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
      }
    } catch (e) {
      debugPrint('[FirebaseAuthInterceptor] Could not attach token: $e');
    }
    handler.next(options);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// ErrorInterceptor
// Transforms DioException responses into typed ApiExceptions.
// ─────────────────────────────────────────────────────────────────────────────

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final statusCode = err.response?.statusCode;
    final data = err.response?.data;

    String? serverMessage;
    if (data is Map<String, dynamic>) {
      serverMessage =
          data['message'] as String? ?? data['error'] as String?;
    }

    final apiException = apiExceptionFromStatusCode(statusCode, serverMessage);
    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        response: err.response,
        type: err.type,
        error: apiException,
        message: apiException.message,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Dio factory
// ─────────────────────────────────────────────────────────────────────────────

Dio buildDioClient({
  required String baseUrl,
  String? idToken,
  bool useFirebaseInterceptor = false,
}) {
  final dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      sendTimeout: const Duration(seconds: 15),
      contentType: 'application/json',
      headers: {
        // Fallback static token for placeholder auth mode.
        if (!useFirebaseInterceptor &&
            idToken != null &&
            idToken.isNotEmpty)
          'Authorization': 'Bearer $idToken',
      },
    ),
  );

  dio.interceptors.addAll([
    if (useFirebaseInterceptor) FirebaseAuthInterceptor(),
    ErrorInterceptor(),
    LogInterceptor(
      requestBody: kDebugMode,
      responseBody: kDebugMode,
    ),
  ]);

  return dio;
}
