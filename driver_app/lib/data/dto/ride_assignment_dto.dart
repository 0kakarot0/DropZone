import 'package:dropzone_driver_app/domain/entities/ride_assignment.dart';

class RideAssignmentDto {
  const RideAssignmentDto({
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

  factory RideAssignmentDto.fromJson(Map<String, dynamic> json) {
    return RideAssignmentDto(
      id: (json['id'] as num?)?.toInt() ?? 0,
      bookingId: (json['bookingId'] as num?)?.toInt() ?? 0,
      driverId: (json['driverId'] as num?)?.toInt() ?? 0,
      status: json['status'] as String? ?? 'UNKNOWN',
      offeredAt: DateTime.tryParse(json['offeredAt'] as String? ?? '') ??
          DateTime.now(),
      respondedAt: DateTime.tryParse(json['respondedAt'] as String? ?? ''),
    );
  }

  RideAssignment toDomain() {
    return RideAssignment(
      id: id,
      bookingId: bookingId,
      driverId: driverId,
      status: status,
      offeredAt: offeredAt,
      respondedAt: respondedAt,
    );
  }
}
