class DriverRide {
  const DriverRide({
    required this.id,
    required this.pickupLocation,
    required this.dropoffLocation,
    required this.pickupTime,
    required this.passengers,
    required this.bookingStatus,
    required this.paymentMethod,
    this.notes,
    this.priceEstimateCents,
    this.currency,
    this.driverId,
    this.pickupLatitude,
    this.pickupLongitude,
    this.dropoffLatitude,
    this.dropoffLongitude,
    this.assignmentStatus,
  });

  final int id;
  final String pickupLocation;
  final String dropoffLocation;
  final DateTime pickupTime;
  final int passengers;
  final String? notes;
  final String bookingStatus;
  final int? priceEstimateCents;
  final String? currency;
  final int? driverId;
  final String paymentMethod;
  final double? pickupLatitude;
  final double? pickupLongitude;
  final double? dropoffLatitude;
  final double? dropoffLongitude;
  final String? assignmentStatus;

  bool get isOffered => assignmentStatus == 'OFFERED';
  bool get isAccepted => assignmentStatus == 'ACCEPTED';
  bool get hasKnownAssignmentState => assignmentStatus != null;
}
