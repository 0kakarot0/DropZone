import 'package:dropzone_app/data/api/api_booking_service.dart';
import 'package:dropzone_app/data/dto/booking_dto.dart';
import 'package:dropzone_app/domain/entities/booking.dart';
import 'package:dropzone_app/domain/repositories/booking_repository.dart';

/// Production implementation of [BookingRepository] backed by the
/// DropZone Chauffeur REST API.
class HttpBookingRepository implements BookingRepository {
  const HttpBookingRepository(this._service);

  final ApiBookingService _service;

  // ── List ───────────────────────────────────────────────────────────────────
  @override
  Future<List<Booking>> listBookings({int limit = 20, int offset = 0}) async {
    final dtos = await _service.list(limit: limit, offset: offset);
    return dtos.map(_fromDto).toList();
  }

  // ── Create ─────────────────────────────────────────────────────────────────
  @override
  Future<Booking> createBooking(Booking booking) async {
    final dto = await _service.create(
      CreateBookingRequestDto(
        serviceType: booking.tripType.apiValue,
        pickupLocation: booking.pickup,
        dropoffLocation: booking.dropoff,
        pickupTime: booking.dateTime,
        passengers: booking.passengers,
        notes: booking.notes,
      ),
    );
    return _fromDto(dto);
  }

  // ── Get ────────────────────────────────────────────────────────────────────
  @override
  Future<Booking> getBooking(int id) async {
    final dto = await _service.getById(id);
    return _fromDto(dto);
  }

  // ── Cancel ─────────────────────────────────────────────────────────────────
  @override
  Future<Booking> cancelBooking(int id) async {
    final dto = await _service.cancel(id);
    return _fromDto(dto);
  }

  // ── Reschedule ─────────────────────────────────────────────────────────────
  @override
  Future<Booking> rescheduleBooking(int id, DateTime newPickupTime) async {
    final dto = await _service.reschedule(
      id,
      RescheduleBookingRequestDto(pickupTime: newPickupTime),
    );
    return _fromDto(dto);
  }

  // ── Estimate ───────────────────────────────────────────────────────────────
  @override
  Future<PriceEstimate> estimatePrice({
    required TripType serviceType,
    required DateTime pickupTime,
    int? passengers,
  }) async {
    final dto = await _service.estimate(
      PriceEstimateRequestDto(
        serviceType: serviceType.apiValue,
        pickupTime: pickupTime,
        passengers: passengers,
      ),
    );
    return PriceEstimate(
      totalCents: dto.totalCents ?? 0,
      currency: dto.currency ?? 'AED',
    );
  }

  // ── Events ─────────────────────────────────────────────────────────────────
  @override
  Future<List<BookingEvent>> getBookingEvents(int id) async {
    final dtos = await _service.events(id);
    return dtos
        .map((d) => BookingEvent(
              eventType: d.eventType ?? '',
              description: d.description ?? '',
              createdAt: d.createdAt ?? DateTime.now(),
            ))
        .toList();
  }

  // ── DTO → Domain ───────────────────────────────────────────────────────────
  Booking _fromDto(BookingResponseDto dto) {
    return Booking(
      id: dto.id ?? -1,
      tripType: TripTypeApi.fromApi(dto.serviceType ?? ''),
      pickup: dto.pickupLocation ?? '',
      dropoff: dto.dropoffLocation ?? '',
      dateTime: dto.pickupTime ?? DateTime.now(),
      status: BookingStatusApi.fromApi(dto.status ?? 'CREATED'),
      passengers: dto.passengers,
      notes: dto.notes,
      priceEstimateCents: dto.priceEstimateCents,
      currency: dto.currency,
    );
  }
}
