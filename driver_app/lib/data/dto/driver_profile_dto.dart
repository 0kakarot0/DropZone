import 'package:dropzone_driver_app/domain/entities/driver_profile.dart';

class DriverProfileDto {
  const DriverProfileDto({
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

  factory DriverProfileDto.fromJson(Map<String, dynamic> json) {
    return DriverProfileDto(
      id: (json['id'] as num?)?.toInt() ?? 0,
      displayName: json['displayName'] as String? ?? 'Unknown driver',
      phone: json['phone'] as String? ?? '',
      email: json['email'] as String? ?? '',
      status: json['status'] as String? ?? 'OFFLINE',
      rating: (json['rating'] as num?)?.toDouble(),
      vehicleType: json['vehicleType'] as String? ?? 'Unknown vehicle',
      vehiclePlate: json['vehiclePlate'] as String? ?? 'N/A',
    );
  }

  DriverProfile toDomain() {
    return DriverProfile(
      id: id,
      displayName: displayName,
      phone: phone,
      email: email,
      status: status,
      rating: rating,
      vehicleType: vehicleType,
      vehiclePlate: vehiclePlate,
    );
  }
}
