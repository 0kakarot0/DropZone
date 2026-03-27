/// Domain entity for user booking preferences.
class UserPreferences {
  const UserPreferences({
    this.defaultPickup,
    this.defaultDropoff,
    this.defaultVehicle,
    this.defaultPassengers = 1,
  });

  final String? defaultPickup;
  final String? defaultDropoff;
  final String? defaultVehicle;
  final int defaultPassengers;

  /// Returns a copy with the given fields replaced.
  UserPreferences copyWith({
    String? defaultPickup,
    String? defaultDropoff,
    String? defaultVehicle,
    int? defaultPassengers,
  }) {
    return UserPreferences(
      defaultPickup: defaultPickup ?? this.defaultPickup,
      defaultDropoff: defaultDropoff ?? this.defaultDropoff,
      defaultVehicle: defaultVehicle ?? this.defaultVehicle,
      defaultPassengers: defaultPassengers ?? this.defaultPassengers,
    );
  }

  static const empty = UserPreferences();
}
