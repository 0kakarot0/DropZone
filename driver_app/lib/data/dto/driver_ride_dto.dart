import 'package:dropzone_driver_app/domain/entities/driver_ride.dart';

class DriverRideDto {
  const DriverRideDto({
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

  factory DriverRideDto.fromJson(Map<String, dynamic> json) {
    return DriverRideDto(
      id: (json['id'] as num?)?.toInt() ?? 0,
      pickupLocation: json['pickupLocation'] as String? ?? 'Unknown pickup',
      dropoffLocation:
          json['dropoffLocation'] as String? ?? 'Unknown dropoff',
      pickupTime: DateTime.tryParse(json['pickupTime'] as String? ?? '') ??
          DateTime.now(),
      passengers: (json['passengers'] as num?)?.toInt() ?? 1,
      notes: json['notes'] as String?,
      bookingStatus: json['status'] as String? ?? 'UNKNOWN',
      priceEstimateCents: (json['priceEstimateCents'] as num?)?.toInt(),
      currency: json['currency'] as String?,
      driverId: (json['driverId'] as num?)?.toInt(),
      paymentMethod: json['paymentMethod'] as String? ?? 'CARD',
      pickupLatitude: (json['pickupLatitude'] as num?)?.toDouble(),
      pickupLongitude: (json['pickupLongitude'] as num?)?.toDouble(),
      dropoffLatitude: (json['dropoffLatitude'] as num?)?.toDouble(),
      dropoffLongitude: (json['dropoffLongitude'] as num?)?.toDouble(),
      assignmentStatus: json['assignmentStatus'] as String?,
    );
  }

  DriverRide toDomain() {
    return DriverRide(
      id: id,
      pickupLocation: pickupLocation,
      dropoffLocation: dropoffLocation,
      pickupTime: pickupTime,
      passengers: passengers,
      notes: notes,
      bookingStatus: bookingStatus,
      priceEstimateCents: priceEstimateCents,
      currency: currency,
      driverId: driverId,
      paymentMethod: paymentMethod,
      pickupLatitude: pickupLatitude,
      pickupLongitude: pickupLongitude,
      dropoffLatitude: dropoffLatitude,
      dropoffLongitude: dropoffLongitude,
      assignmentStatus: assignmentStatus,
    );
  }
}
