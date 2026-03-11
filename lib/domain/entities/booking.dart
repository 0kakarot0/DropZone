// ─────────────────────────────────────────────────────────────────────────────
// Enums
// ─────────────────────────────────────────────────────────────────────────────

enum BookingStatus {
  pendingPayment,
  confirmed,
  created,
  cancelled,
  rescheduled,
}

// Client-side enums not on the server — kept for UX in booking flow.
enum TripType {
  airportPickup,  // → "AIRPORT_PICKUP"
  airportDrop,    // → "AIRPORT_DROPOFF"
  business,       // → "BUSINESS"
}

// Client-side only (not sent to the real API).
enum VehicleClass { sedan, suv, luxury, van }

// ─────────────────────────────────────────────────────────────────────────────
// Helpers
// ─────────────────────────────────────────────────────────────────────────────

extension TripTypeApi on TripType {
  String get apiValue {
    switch (this) {
      case TripType.airportPickup:
        return 'AIRPORT_PICKUP';
      case TripType.airportDrop:
        return 'AIRPORT_DROPOFF';
      case TripType.business:
        return 'BUSINESS';
    }
  }

  static TripType fromApi(String value) {
    switch (value) {
      case 'AIRPORT_PICKUP':
        return TripType.airportPickup;
      case 'AIRPORT_DROPOFF':
        return TripType.airportDrop;
      case 'BUSINESS':
        return TripType.business;
      default:
        return TripType.business;
    }
  }
}

extension BookingStatusApi on BookingStatus {
  static BookingStatus fromApi(String value) {
    switch (value.toUpperCase()) {
      case 'PENDING_PAYMENT':
        return BookingStatus.pendingPayment;
      case 'CONFIRMED':
        return BookingStatus.confirmed;
      case 'CREATED':
        return BookingStatus.created;
      case 'CANCELLED':
        return BookingStatus.cancelled;
      case 'RESCHEDULED':
        return BookingStatus.rescheduled;
      default:
        return BookingStatus.pendingPayment;
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Booking
// ─────────────────────────────────────────────────────────────────────────────

class Booking {
  const Booking({
    required this.id,
    required this.tripType,
    required this.pickup,
    required this.dropoff,
    required this.dateTime,
    required this.status,
    this.vehicleClass = VehicleClass.sedan,
    this.passengers,
    this.notes,
    this.priceEstimateCents,
    this.currency,
  });

  /// Server-assigned integer ID. -1 when not yet persisted.
  final int id;
  final TripType tripType;
  final String pickup;
  final String dropoff;
  final DateTime dateTime;
  final BookingStatus status;

  /// Client-only — used in the booking flow UI but not sent to the API.
  final VehicleClass vehicleClass;

  final int? passengers;
  final String? notes;
  final int? priceEstimateCents;
  final String? currency;

  /// Convenience: price in AED as double.
  double get priceAed =>
      priceEstimateCents != null ? priceEstimateCents! / 100.0 : 0.0;
}

// ─────────────────────────────────────────────────────────────────────────────
// PriceEstimate
// ─────────────────────────────────────────────────────────────────────────────

class PriceEstimate {
  const PriceEstimate({required this.totalCents, required this.currency});

  final int totalCents;
  final String currency;

  double get totalAed => totalCents / 100.0;
}

// ─────────────────────────────────────────────────────────────────────────────
// BookingEvent
// ─────────────────────────────────────────────────────────────────────────────

class BookingEvent {
  const BookingEvent({
    required this.eventType,
    required this.description,
    required this.createdAt,
  });

  final String eventType;
  final String description;
  final DateTime createdAt;
}
