class RideAssignment {
  const RideAssignment({
    required this.id,
    required this.bookingId,
    required this.driverId,
    required this.status,
    required this.offeredAt,
    this.respondedAt,
  });

  final int id;
  final int bookingId;
  final int driverId;
  final String status;
  final DateTime offeredAt;
  final DateTime? respondedAt;
}
