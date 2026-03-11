import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dropzone_app/core/di/providers.dart';

// ─────────────────────────────────────────────────────────────────────────────
// FirebaseAuthInterceptor
// Attaches the current user's Firebase ID token to every request.
// ─────────────────────────────────────────────────────────────────────────────

class FirebaseAuthInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      // currentUser can be null on cold-start before Firebase restores the session.
      // Waiting on authStateChanges().first gives it a moment to rehydrate.
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
      // Token fetch failed — proceed without header; server returns 401.
      debugPrint('[FirebaseAuthInterceptor] Could not attach token: $e');
    }
    handler.next(options);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Dio provider
// ─────────────────────────────────────────────────────────────────────────────

final dioProvider = Provider<Dio>((ref) {
  final env = ref.read(envProvider);
  final dio = Dio(
    BaseOptions(
      baseUrl: env.apiBaseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      contentType: 'application/json',
    ),
  );

  dio.interceptors.addAll([
    FirebaseAuthInterceptor(),
    LogInterceptor(requestBody: true, responseBody: true),
  ]);

  return dio;
});
