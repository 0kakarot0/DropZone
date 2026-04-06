import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dropzone_app/core/network/dio_client.dart';
import 'package:dropzone_app/data/api/api_profile_service.dart';
import 'package:dropzone_app/data/dto/preferences_dto.dart';
import 'package:dropzone_app/domain/entities/user_preferences.dart';
import 'package:dropzone_app/domain/entities/user_profile.dart';
import 'package:dropzone_app/domain/entities/booking.dart';
import 'package:dropzone_app/data/dto/profile_dto.dart';
import 'package:dropzone_app/presentation/bookings/booking_providers.dart';

// ── API Service ─────────────────────────────────────────────────────────────

final profileApiServiceProvider = Provider<ApiProfileService>((ref) {
  return ApiProfileService(ref.read(dioProvider));
});

// ── User Profile ────────────────────────────────────────────────────────────

final userProfileProvider =
    AsyncNotifierProvider<UserProfileNotifier, UserProfile>(
  UserProfileNotifier.new,
);

class UserProfileNotifier extends AsyncNotifier<UserProfile> {
  @override
  Future<UserProfile> build() async {
    final api = ref.read(profileApiServiceProvider);
    final dto = await api.getProfile();
    return _fromProfileDto(dto);
  }

  Future<void> updateProfile(UserProfile profile) async {
    final api = ref.read(profileApiServiceProvider);
    final dto = await api.updateProfile(
      UpdateProfileRequestDto(
        displayName: profile.displayName,
        corporateMode: profile.corporateMode,
      ),
    );
    state = AsyncValue.data(_fromProfileDto(dto));
  }

  UserProfile _fromProfileDto(ProfileResponseDto dto) {
    return UserProfile(
      id: dto.id,
      email: dto.email,
      displayName: dto.displayName,
      corporateMode: dto.corporateMode ?? false,
    );
  }
}

// ── User Preferences ────────────────────────────────────────────────────────

final userPreferencesProvider =
    AsyncNotifierProvider<UserPreferencesNotifier, UserPreferences>(
  UserPreferencesNotifier.new,
);

class UserPreferencesNotifier extends AsyncNotifier<UserPreferences> {
  @override
  Future<UserPreferences> build() async {
    try {
      final api = ref.read(profileApiServiceProvider);
      final dto = await api.getPreferences();
      return UserPreferences(
        defaultPickup: dto.defaultPickup,
        defaultDropoff: dto.defaultDropoff,
        defaultVehicle: dto.defaultVehicle,
        defaultPassengers: dto.defaultPassengers ?? 1,
      );
    } catch (_) {
      // Graceful fallback — user has no saved preferences yet.
      return UserPreferences.empty;
    }
  }

  Future<void> updatePreferences(UserPreferences prefs) async {
    final api = ref.read(profileApiServiceProvider);
    await api.updatePreferences(UpdatePreferencesRequestDto(
      defaultPickup: prefs.defaultPickup,
      defaultDropoff: prefs.defaultDropoff,
      defaultVehicle: prefs.defaultVehicle,
      defaultPassengers: prefs.defaultPassengers,
    ));
    state = AsyncValue.data(prefs);
  }
}

// ── Last Booking (for Quick Re-book) ────────────────────────────────────────

final lastBookingProvider = FutureProvider<Booking?>((ref) async {
  final repo = ref.read(bookingRepositoryProvider);
  try {
    return await repo.getLastBooking();
  } catch (_) {
    return null;
  }
});
