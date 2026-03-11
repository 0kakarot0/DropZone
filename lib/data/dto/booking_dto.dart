// DTOs that mirror the DropZone Chauffeur OpenAPI schema.
// All fields are nullable to be permissive on deserialization.

// ─────────────────────────────────────────────────────────────────────────────
// BookingResponse
// ─────────────────────────────────────────────────────────────────────────────

class BookingResponseDto {
  const BookingResponseDto({
    this.id,
    this.serviceType,
    this.pickupLocation,
    this.dropoffLocation,
    this.pickupTime,
    this.passengers,
    this.notes,
    this.status,
    this.priceEstimateCents,
    this.currency,
    this.createdAt,
    this.updatedAt,
  });

  final int? id;
  final String? serviceType;
  final String? pickupLocation;
  final String? dropoffLocation;
  final DateTime? pickupTime;
  final int? passengers;
  final String? notes;
  final String? status;
  final int? priceEstimateCents;
  final String? currency;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory BookingResponseDto.fromJson(Map<String, dynamic> json) {
    return BookingResponseDto(
      id: (json['id'] as num?)?.toInt(),
      serviceType: json['serviceType'] as String?,
      pickupLocation: json['pickupLocation'] as String?,
      dropoffLocation: json['dropoffLocation'] as String?,
      pickupTime: json['pickupTime'] != null
          ? DateTime.parse(json['pickupTime'] as String)
          : null,
      passengers: (json['passengers'] as num?)?.toInt(),
      notes: json['notes'] as String?,
      status: json['status'] as String?,
      priceEstimateCents: (json['priceEstimateCents'] as num?)?.toInt(),
      currency: json['currency'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// CreateBookingRequest
// ─────────────────────────────────────────────────────────────────────────────

class CreateBookingRequestDto {
  const CreateBookingRequestDto({
    required this.serviceType,
    required this.pickupLocation,
    required this.dropoffLocation,
    required this.pickupTime,
    this.passengers,
    this.notes,
  });

  final String serviceType;
  final String pickupLocation;
  final String dropoffLocation;
  final DateTime pickupTime;
  final int? passengers;
  final String? notes;

  Map<String, dynamic> toJson() => {
        'serviceType': serviceType,
        'pickupLocation': pickupLocation,
        'dropoffLocation': dropoffLocation,
        'pickupTime': pickupTime.toUtc().toIso8601String(),
        if (passengers != null) 'passengers': passengers,
        if (notes != null && notes!.isNotEmpty) 'notes': notes,
      };
}

// ─────────────────────────────────────────────────────────────────────────────
// RescheduleBookingRequest
// ─────────────────────────────────────────────────────────────────────────────

class RescheduleBookingRequestDto {
  const RescheduleBookingRequestDto({required this.pickupTime});

  final DateTime pickupTime;

  Map<String, dynamic> toJson() => {
        'pickupTime': pickupTime.toUtc().toIso8601String(),
      };
}

// ─────────────────────────────────────────────────────────────────────────────
// PriceEstimateRequest
// ─────────────────────────────────────────────────────────────────────────────

class PriceEstimateRequestDto {
  const PriceEstimateRequestDto({
    required this.serviceType,
    required this.pickupTime,
    this.passengers,
  });

  final String serviceType;
  final DateTime pickupTime;
  final int? passengers;

  Map<String, dynamic> toJson() => {
        'serviceType': serviceType,
        'pickupTime': pickupTime.toUtc().toIso8601String(),
        if (passengers != null) 'passengers': passengers,
      };
}

// ─────────────────────────────────────────────────────────────────────────────
// PriceEstimateResponse
// ─────────────────────────────────────────────────────────────────────────────

class PriceEstimateResponseDto {
  const PriceEstimateResponseDto({this.totalCents, this.currency});

  final int? totalCents;
  final String? currency;

  factory PriceEstimateResponseDto.fromJson(Map<String, dynamic> json) {
    return PriceEstimateResponseDto(
      totalCents: (json['totalCents'] as num?)?.toInt(),
      currency: json['currency'] as String?,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// BookingEventResponse
// ─────────────────────────────────────────────────────────────────────────────

class BookingEventResponseDto {
  const BookingEventResponseDto({
    this.eventType,
    this.description,
    this.createdAt,
  });

  final String? eventType;
  final String? description;
  final DateTime? createdAt;

  factory BookingEventResponseDto.fromJson(Map<String, dynamic> json) {
    return BookingEventResponseDto(
      eventType: json['eventType'] as String?,
      description: json['description'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
    );
  }
}
