// DTO for tracking API response (GET /api/tracking/{bookingId}).

class TrackingResponseDto {
  const TrackingResponseDto({
    this.bookingId,
    this.driverId,
    this.driverName,
    this.vehicleType,
    this.vehiclePlate,
    this.latitude,
    this.longitude,
    this.rideStatus,
  });

  final int? bookingId;
  final int? driverId;
  final String? driverName;
  final String? vehicleType;
  final String? vehiclePlate;
  final double? latitude;
  final double? longitude;
  final String? rideStatus;

  factory TrackingResponseDto.fromJson(Map<String, dynamic> json) {
    return TrackingResponseDto(
      bookingId: (json['bookingId'] as num?)?.toInt(),
      driverId: (json['driverId'] as num?)?.toInt(),
      driverName: json['driverName'] as String?,
      vehicleType: json['vehicleType'] as String?,
      vehiclePlate: json['vehiclePlate'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      rideStatus: json['rideStatus'] as String?,
    );
  }
}
