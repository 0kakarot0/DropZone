enum BookingStatus {
  requested,
  confirmed,
  driverAssigned,
  enRoute,
  completed,
  cancelled,
}

enum TripType { airportPickup, airportDrop, business }

enum VehicleClass { sedan, suv, luxury, van }

class Booking {
  const Booking({
    required this.id,
    required this.tripType,
    required this.pickup,
    required this.dropoff,
    required this.dateTime,
    required this.vehicleClass,
    required this.status,
    required this.price,
  });

  final String id;
  final TripType tripType;
  final String pickup;
  final String dropoff;
  final DateTime dateTime;
  final VehicleClass vehicleClass;
  final BookingStatus status;
  final double price;
}
