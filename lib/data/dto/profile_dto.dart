// ─────────────────────────────────────────────────────────────────────────────
// ProfileResponse
// ─────────────────────────────────────────────────────────────────────────────

class ProfileResponseDto {
  const ProfileResponseDto({
    this.id,
    this.email,
    this.displayName,
    this.corporateMode,
    this.createdAt,
    this.updatedAt,
  });

  final int? id;
  final String? email;
  final String? displayName;
  final bool? corporateMode;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory ProfileResponseDto.fromJson(Map<String, dynamic> json) {
    return ProfileResponseDto(
      id: (json['id'] as num?)?.toInt(),
      email: json['email'] as String?,
      displayName: json['displayName'] as String?,
      corporateMode: json['corporateMode'] as bool?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// UpdateProfileRequest
// ─────────────────────────────────────────────────────────────────────────────

class UpdateProfileRequestDto {
  const UpdateProfileRequestDto({this.displayName, this.corporateMode});

  final String? displayName;
  final bool? corporateMode;

  Map<String, dynamic> toJson() => {
        if (displayName != null) 'displayName': displayName,
        if (corporateMode != null) 'corporateMode': corporateMode,
      };
}
