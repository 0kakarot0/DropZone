/// Ride status progression state machine.
///
/// Backend enforces: ASSIGNED → DRIVER_EN_ROUTE → ARRIVED → IN_PROGRESS → COMPLETED
/// The driver app must only expose the valid next action.
library;

const _statusOrder = [
  'ASSIGNED',
  'DRIVER_EN_ROUTE',
  'ARRIVED',
  'IN_PROGRESS',
  'COMPLETED',
];

/// Returns the next valid status in the progression, or `null` if completed.
String? nextStatus(String currentStatus) {
  final index = _statusOrder.indexOf(currentStatus);
  if (index < 0 || index >= _statusOrder.length - 1) return null;
  return _statusOrder[index + 1];
}

/// User-facing label for the action button that advances to the next status.
String? nextStatusActionLabel(String currentStatus) {
  final next = nextStatus(currentStatus);
  return switch (next) {
    'DRIVER_EN_ROUTE' => 'Start Route',
    'ARRIVED' => 'Mark Arrived',
    'IN_PROGRESS' => 'Start Trip',
    'COMPLETED' => 'Complete Trip',
    _ => null,
  };
}

/// Icon for the next status action button.
String nextStatusIcon(String currentStatus) {
  final next = nextStatus(currentStatus);
  return switch (next) {
    'DRIVER_EN_ROUTE' => 'directions_car',
    'ARRIVED' => 'place',
    'IN_PROGRESS' => 'play_arrow',
    'COMPLETED' => 'check_circle',
    _ => 'help',
  };
}

/// Whether this status represents a terminal (final) state.
bool isTerminalStatus(String status) => status == 'COMPLETED';

/// Whether the ride is in an active (accepted, in-progress) state.
bool isActiveStatus(String status) {
  return status == 'DRIVER_EN_ROUTE' ||
      status == 'ARRIVED' ||
      status == 'IN_PROGRESS';
}

/// User-facing label for a status value.
String statusDisplayLabel(String status) {
  return switch (status) {
    'ASSIGNED' => 'Assigned',
    'DRIVER_EN_ROUTE' => 'En Route',
    'ARRIVED' => 'Arrived',
    'IN_PROGRESS' => 'In Progress',
    'COMPLETED' => 'Completed',
    'CANCELLED' => 'Cancelled',
    _ => status,
  };
}
