/// Tracking info for a live ride — returned by GET /api/tracking/{bookingId}.
class TrackingInfo {
  const TrackingInfo({
    required this.bookingId,
    required this.driverId,
    required this.driverName,
    this.vehicleType,
    this.vehiclePlate,
    this.latitude,
    this.longitude,
    required this.rideStatus,
  });

  final int bookingId;
  final int driverId;
  final String driverName;
  final String? vehicleType;
  final String? vehiclePlate;
  final double? latitude;
  final double? longitude;
  final String rideStatus;
}
