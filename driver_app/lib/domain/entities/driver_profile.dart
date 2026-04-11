class DriverProfile {
  const DriverProfile({
    required this.id,
    required this.displayName,
    required this.phone,
    required this.email,
    required this.status,
    required this.rating,
    required this.vehicleType,
    required this.vehiclePlate,
  });

  final int id;
  final String displayName;
  final String phone;
  final String email;
  final String status;
  final double? rating;
  final String vehicleType;
  final String vehiclePlate;
}
