import 'dart:async';

import 'package:dio/dio.dart';
import 'package:dropzone_driver_app/core/config/app_config.dart';
import 'package:dropzone_driver_app/core/network/dio_client.dart';
import 'package:dropzone_driver_app/data/api/driver_api_service.dart';
import 'package:dropzone_driver_app/data/auth/firebase_driver_auth_repository.dart';
import 'package:dropzone_driver_app/data/auth/placeholder_driver_auth_repository.dart';
import 'package:dropzone_driver_app/data/repositories/http_driver_repository.dart';
import 'package:dropzone_driver_app/data/repositories/mock_driver_repository.dart';
import 'package:dropzone_driver_app/domain/entities/driver_profile.dart';
import 'package:dropzone_driver_app/domain/entities/driver_ride.dart';
import 'package:dropzone_driver_app/domain/entities/driver_auth_session.dart';
import 'package:dropzone_driver_app/domain/repositories/driver_auth_repository.dart';
import 'package:dropzone_driver_app/domain/repositories/driver_repository.dart';
import 'package:dropzone_driver_app/presentation/auth/auth_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Config
// ─────────────────────────────────────────────────────────────────────────────

final appConfigProvider = Provider<DriverAppConfig>(
  (ref) => const DriverAppConfig.development(),
);

// ─────────────────────────────────────────────────────────────────────────────
// Auth
// ─────────────────────────────────────────────────────────────────────────────

final driverAuthRepositoryProvider = Provider<DriverAuthRepository>((ref) {
  final config = ref.watch(appConfigProvider);
  final repository = config.enableFirebaseAuth
      ? FirebaseDriverAuthRepository()
      : PlaceholderDriverAuthRepository();
  ref.onDispose(repository.dispose);
  return repository;
});

final authSessionProvider =
    StateNotifierProvider<DriverAuthController, DriverAuthSession>((ref) {
  final repository = ref.watch(driverAuthRepositoryProvider);
  return DriverAuthController(repository);
});

// ─────────────────────────────────────────────────────────────────────────────
// Network
// ─────────────────────────────────────────────────────────────────────────────

final dioProvider = Provider<Dio>((ref) {
  final config = ref.watch(appConfigProvider);
  final session = ref.watch(authSessionProvider);
  return buildDioClient(
    baseUrl: config.apiBaseUrl,
    idToken: session.idToken,
    useFirebaseInterceptor: config.enableFirebaseAuth,
  );
});

final driverApiServiceProvider = Provider<DriverApiService>((ref) {
  final dio = ref.watch(dioProvider);
  return DriverApiService(dio);
});

// ─────────────────────────────────────────────────────────────────────────────
// Repository
// ─────────────────────────────────────────────────────────────────────────────

final driverRepositoryProvider = Provider<DriverRepository>((ref) {
  final config = ref.watch(appConfigProvider);
  if (config.useMockDriverBackend) {
    return MockDriverRepository();
  }

  final apiService = ref.watch(driverApiServiceProvider);
  return HttpDriverRepository(apiService);
});

// ─────────────────────────────────────────────────────────────────────────────
// Profile
// ─────────────────────────────────────────────────────────────────────────────

final driverProfileProvider = FutureProvider<DriverProfile>((ref) async {
  final authSession = ref.watch(authSessionProvider);
  if (!authSession.isAuthenticated) {
    throw StateError('Driver must be signed in to load profile.');
  }

  final repository = ref.watch(driverRepositoryProvider);
  return repository.getProfile();
});

// ─────────────────────────────────────────────────────────────────────────────
// Rides — with auto-polling every 30 seconds
// ─────────────────────────────────────────────────────────────────────────────

final assignedRidesProvider = FutureProvider<List<DriverRide>>((ref) async {
  final authSession = ref.watch(authSessionProvider);
  if (!authSession.isAuthenticated) {
    return const [];
  }

  final repository = ref.watch(driverRepositoryProvider);
  final rides = await repository.getAssignedRides();

  // Auto-refresh every 30 seconds while the provider is alive.
  final timer = Timer(const Duration(seconds: 30), () {
    ref.invalidateSelf();
  });
  ref.onDispose(timer.cancel);

  return rides;
});

final rideByIdProvider = FutureProvider.family<DriverRide?, int>(
  (ref, bookingId) async {
    final rides = await ref.watch(assignedRidesProvider.future);
    for (final ride in rides) {
      if (ride.id == bookingId) {
        return ride;
      }
    }
    return null;
  },
);
