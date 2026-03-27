// DTOs for user preferences API (GET/PUT /api/profile/preferences).

// ─────────────────────────────────────────────────────────────────────────────
// Response
// ─────────────────────────────────────────────────────────────────────────────

class UserPreferencesResponseDto {
  const UserPreferencesResponseDto({
    this.defaultPickup,
    this.defaultDropoff,
    this.defaultVehicle,
    this.defaultPassengers,
  });

  final String? defaultPickup;
  final String? defaultDropoff;
  final String? defaultVehicle;
  final int? defaultPassengers;

  factory UserPreferencesResponseDto.fromJson(Map<String, dynamic> json) {
    return UserPreferencesResponseDto(
      defaultPickup: json['defaultPickup'] as String?,
      defaultDropoff: json['defaultDropoff'] as String?,
      defaultVehicle: json['defaultVehicle'] as String?,
      defaultPassengers: (json['defaultPassengers'] as num?)?.toInt(),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Request
// ─────────────────────────────────────────────────────────────────────────────

class UpdatePreferencesRequestDto {
  const UpdatePreferencesRequestDto({
    this.defaultPickup,
    this.defaultDropoff,
    this.defaultVehicle,
    this.defaultPassengers,
  });

  final String? defaultPickup;
  final String? defaultDropoff;
  final String? defaultVehicle;
  final int? defaultPassengers;

  Map<String, dynamic> toJson() => {
        if (defaultPickup != null) 'defaultPickup': defaultPickup,
        if (defaultDropoff != null) 'defaultDropoff': defaultDropoff,
        if (defaultVehicle != null) 'defaultVehicle': defaultVehicle,
        if (defaultPassengers != null) 'defaultPassengers': defaultPassengers,
      };
}
