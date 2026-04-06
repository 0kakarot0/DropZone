class UserProfile {
  const UserProfile({
    this.id,
    this.email,
    this.displayName,
    this.corporateMode = false,
  });

  final int? id;
  final String? email;
  final String? displayName;
  final bool corporateMode;

  UserProfile copyWith({
    int? id,
    String? email,
    String? displayName,
    bool? corporateMode,
  }) {
    return UserProfile(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      corporateMode: corporateMode ?? this.corporateMode,
    );
  }
}
