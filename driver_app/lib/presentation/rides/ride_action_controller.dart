import 'package:dio/dio.dart';
import 'package:dropzone_driver_app/core/di/providers.dart';
import 'package:dropzone_driver_app/core/network/api_exception.dart';
import 'package:dropzone_driver_app/domain/entities/ride_assignment.dart';
import 'package:dropzone_driver_app/domain/entities/driver_ride.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Ride action state
// ─────────────────────────────────────────────────────────────────────────────

sealed class RideActionState {
  const RideActionState();
}

class RideActionIdle extends RideActionState {
  const RideActionIdle();
}

class RideActionLoading extends RideActionState {
  const RideActionLoading(this.action);
  final String action; // e.g. 'accept', 'reject', 'status'
}

class RideActionSuccess extends RideActionState {
  const RideActionSuccess(this.message);
  final String message;
}

class RideActionError extends RideActionState {
  const RideActionError(this.message, {this.isConflict = false});
  final String message;
  final bool isConflict;
}

// ─────────────────────────────────────────────────────────────────────────────
// Ride action controller
// ─────────────────────────────────────────────────────────────────────────────

class RideActionController extends StateNotifier<RideActionState> {
  RideActionController(this._ref) : super(const RideActionIdle());

  final Ref _ref;

  /// Accept an offered ride.
  Future<RideAssignment?> acceptRide(int bookingId) async {
    state = const RideActionLoading('accept');
    try {
      final repo = _ref.read(driverRepositoryProvider);
      final assignment = await repo.acceptRide(bookingId);
      _ref.invalidate(assignedRidesProvider);
      state = const RideActionSuccess('Ride accepted!');
      return assignment;
    } catch (e) {
      _handleError(e, 'accept');
      return null;
    }
  }

  /// Reject an offered ride.
  Future<RideAssignment?> rejectRide(int bookingId) async {
    state = const RideActionLoading('reject');
    try {
      final repo = _ref.read(driverRepositoryProvider);
      final assignment = await repo.rejectRide(bookingId);
      _ref.invalidate(assignedRidesProvider);
      state = const RideActionSuccess('Ride declined.');
      return assignment;
    } catch (e) {
      _handleError(e, 'reject');
      return null;
    }
  }

  /// Advance the ride to the next status.
  Future<DriverRide?> updateStatus(int bookingId, String newStatus) async {
    state = const RideActionLoading('status');
    try {
      final repo = _ref.read(driverRepositoryProvider);
      final updatedRide = await repo.updateRideStatus(
        bookingId: bookingId,
        status: newStatus,
      );
      _ref.invalidate(assignedRidesProvider);
      state = RideActionSuccess('Status updated to ${_displayStatus(newStatus)}.');
      return updatedRide;
    } catch (e) {
      _handleError(e, 'status update');
      return null;
    }
  }

  /// Reset to idle state (e.g. after showing a snackbar).
  void reset() => state = const RideActionIdle();

  void _handleError(Object error, String action) {
    if (error is DioException && error.error is ApiException) {
      final apiError = error.error as ApiException;
      state = RideActionError(
        apiError.message,
        isConflict: apiError is ConflictException,
      );
    } else if (error is ApiException) {
      state = RideActionError(
        error.message,
        isConflict: error is ConflictException,
      );
    } else {
      state = RideActionError('Failed to $action. Please try again.');
    }
  }

  String _displayStatus(String status) {
    return switch (status) {
      'DRIVER_EN_ROUTE' => 'En Route',
      'ARRIVED' => 'Arrived',
      'IN_PROGRESS' => 'In Progress',
      'COMPLETED' => 'Completed',
      _ => status,
    };
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Provider
// ─────────────────────────────────────────────────────────────────────────────

final rideActionProvider =
    StateNotifierProvider<RideActionController, RideActionState>((ref) {
  return RideActionController(ref);
});
