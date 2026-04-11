import 'package:dropzone_driver_app/core/di/providers.dart';
import 'package:dropzone_driver_app/domain/entities/driver_ride.dart';
import 'package:dropzone_driver_app/domain/entities/ride_status_helpers.dart';
import 'package:dropzone_driver_app/presentation/rides/ride_action_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class RideDetailScreen extends ConsumerWidget {
  const RideDetailScreen({
    super.key,
    required this.bookingId,
  });

  final int bookingId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rideAsync = ref.watch(rideByIdProvider(bookingId));
    final actionState = ref.watch(rideActionProvider);

    // Listen for action results and show snackbars.
    ref.listen<RideActionState>(rideActionProvider, (prev, next) {
      if (next is RideActionSuccess) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(
            content: Text(next.message),
            backgroundColor: const Color(0xFF2D8B4E),
          ));
        ref.read(rideActionProvider.notifier).reset();
      } else if (next is RideActionError) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(
            content: Text(next.message),
            backgroundColor: next.isConflict
                ? const Color(0xFFF59E0B)
                : Theme.of(context).colorScheme.error,
            duration: const Duration(seconds: 4),
          ));
        if (next.isConflict) {
          // Ride was taken by another driver — navigate back.
          Future.delayed(
            const Duration(seconds: 2),
            () {
              if (context.mounted) context.pop();
            },
          );
        }
        ref.read(rideActionProvider.notifier).reset();
      }
    });

    final isLoading = actionState is RideActionLoading;

    return Scaffold(
      appBar: AppBar(
        title: Text('Ride #$bookingId'),
      ),
      body: rideAsync.when(
        data: (ride) {
          if (ride == null) {
            return const Center(
              child: Text('Ride not found in the current inbox.'),
            );
          }

          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            children: [
              _RideSummaryCard(ride: ride),
              const SizedBox(height: 16),
              _MetadataCard(ride: ride),
              const SizedBox(height: 16),
              _ActionCard(
                ride: ride,
                isLoading: isLoading,
                onAccept: () => ref
                    .read(rideActionProvider.notifier)
                    .acceptRide(bookingId),
                onReject: () => _showRejectDialog(context, ref),
                onAdvanceStatus: (newStatus) => ref
                    .read(rideActionProvider.notifier)
                    .updateStatus(bookingId, newStatus),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, size: 48),
                const SizedBox(height: 12),
                Text(error.toString()),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: () => ref.invalidate(rideByIdProvider(bookingId)),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showRejectDialog(BuildContext context, WidgetRef ref) {
    showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Decline ride?'),
        content: const Text(
          'This ride will be removed from your inbox and may be '
          'offered to another driver.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Decline'),
          ),
        ],
      ),
    ).then((confirmed) {
      if (confirmed == true) {
        ref.read(rideActionProvider.notifier).rejectRide(bookingId);
      }
    });
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Ride summary card
// ─────────────────────────────────────────────────────────────────────────────

class _RideSummaryCard extends StatelessWidget {
  const _RideSummaryCard({required this.ride});

  final DriverRide ride;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.trip_origin, size: 16, color: Color(0xFF2D8B4E)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    ride.pickupLocation,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 7),
              child: Container(
                width: 2,
                height: 20,
                color: theme.dividerColor,
              ),
            ),
            Row(
              children: [
                const Icon(Icons.location_on, size: 16, color: Color(0xFFE53E3E)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    ride.dropoffLocation,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                const Icon(Icons.schedule, size: 16),
                const SizedBox(width: 6),
                Text(
                  DateFormat('dd MMM yyyy • HH:mm').format(ride.pickupTime),
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _StatusChip(
                  label: statusDisplayLabel(ride.bookingStatus),
                  color: _statusColor(ride.bookingStatus),
                ),
                if (ride.assignmentStatus != null)
                  _StatusChip(
                    label: ride.isOffered ? 'Offered' : 'Accepted',
                    color: ride.isOffered
                        ? const Color(0xFFF59E0B)
                        : const Color(0xFF2D8B4E),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _statusColor(String status) {
    return switch (status) {
      'ASSIGNED' => const Color(0xFF6366F1),
      'DRIVER_EN_ROUTE' => const Color(0xFF3B82F6),
      'ARRIVED' => const Color(0xFF0EA5E9),
      'IN_PROGRESS' => const Color(0xFFF59E0B),
      'COMPLETED' => const Color(0xFF2D8B4E),
      _ => const Color(0xFF64748B),
    };
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Metadata card
// ─────────────────────────────────────────────────────────────────────────────

class _MetadataCard extends StatelessWidget {
  const _MetadataCard({required this.ride});

  final DriverRide ride;

  @override
  Widget build(BuildContext context) {
    final rows = <MapEntry<IconData, String>>[
      MapEntry(Icons.people_outline, '${ride.passengers} passenger(s)'),
      MapEntry(Icons.payment_outlined, ride.paymentMethod),
      if (ride.currency != null && ride.priceEstimateCents != null)
        MapEntry(
          Icons.attach_money,
          '${ride.currency} ${(ride.priceEstimateCents! / 100).toStringAsFixed(2)}',
        ),
      MapEntry(
        Icons.my_location,
        ride.pickupLatitude == null || ride.dropoffLatitude == null
            ? 'Coordinates not fully available'
            : '${ride.pickupLatitude!.toStringAsFixed(4)}, '
                '${ride.pickupLongitude!.toStringAsFixed(4)} → '
                '${ride.dropoffLatitude!.toStringAsFixed(4)}, '
                '${ride.dropoffLongitude!.toStringAsFixed(4)}',
      ),
      MapEntry(Icons.notes_outlined, ride.notes ?? 'No notes'),
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ride details',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            ...rows.map(
              (row) => Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(row.key, size: 20, color: const Color(0xFF64748B)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        row.value,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Action card — accept/reject for offered, status progression for active
// ─────────────────────────────────────────────────────────────────────────────

class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.ride,
    required this.isLoading,
    required this.onAccept,
    required this.onReject,
    required this.onAdvanceStatus,
  });

  final DriverRide ride;
  final bool isLoading;
  final VoidCallback onAccept;
  final VoidCallback onReject;
  final void Function(String newStatus) onAdvanceStatus;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // ── Offered ride → accept / reject ──
    if (ride.isOffered) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Ride offer', style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),
              Text(
                'This ride has been offered to you. Accept to start '
                'the ride lifecycle or decline to pass.',
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: isLoading ? null : onAccept,
                icon: const Icon(Icons.check_circle_outline),
                label: const Text('Accept ride'),
              ),
              const SizedBox(height: 10),
              OutlinedButton.icon(
                onPressed: isLoading ? null : onReject,
                icon: const Icon(Icons.cancel_outlined),
                label: const Text('Decline ride'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: theme.colorScheme.error,
                  side: BorderSide(
                    color: theme.colorScheme.error.withValues(alpha: 0.3),
                  ),
                ),
              ),
              if (isLoading) ...[
                const SizedBox(height: 12),
                const LinearProgressIndicator(),
              ],
            ],
          ),
        ),
      );
    }

    // ── Terminal state ──
    if (isTerminalStatus(ride.bookingStatus)) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              const Icon(Icons.check_circle, color: Color(0xFF2D8B4E), size: 28),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'This ride has been completed.',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // ── Active ride → status progression ──
    final next = nextStatus(ride.bookingStatus);
    final nextLabel = nextStatusActionLabel(ride.bookingStatus);

    if (next == null || nextLabel == null) {
      return const SizedBox.shrink();
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Ride actions', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(
              'Current status: ${statusDisplayLabel(ride.bookingStatus)}',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            // Status progression stepper
            _StatusStepper(currentStatus: ride.bookingStatus),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: isLoading ? null : () => onAdvanceStatus(next),
              icon: Icon(_actionIcon(next)),
              label: Text(nextLabel),
            ),
            if (isLoading) ...[
              const SizedBox(height: 12),
              const LinearProgressIndicator(),
            ],
          ],
        ),
      ),
    );
  }

  IconData _actionIcon(String status) {
    return switch (status) {
      'DRIVER_EN_ROUTE' => Icons.directions_car,
      'ARRIVED' => Icons.place,
      'IN_PROGRESS' => Icons.play_arrow,
      'COMPLETED' => Icons.check_circle_outline,
      _ => Icons.arrow_forward,
    };
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Status stepper — visual progression indicator
// ─────────────────────────────────────────────────────────────────────────────

class _StatusStepper extends StatelessWidget {
  const _StatusStepper({required this.currentStatus});

  final String currentStatus;

  static const _steps = [
    ('ASSIGNED', 'Assigned', Icons.assignment_outlined),
    ('DRIVER_EN_ROUTE', 'En Route', Icons.directions_car),
    ('ARRIVED', 'Arrived', Icons.place),
    ('IN_PROGRESS', 'In Progress', Icons.play_circle_outline),
    ('COMPLETED', 'Done', Icons.check_circle),
  ];

  @override
  Widget build(BuildContext context) {
    final currentIndex =
        _steps.indexWhere((step) => step.$1 == currentStatus);

    return Row(
      children: [
        for (int i = 0; i < _steps.length; i++) ...[
          _StepDot(
            icon: _steps[i].$3,
            label: _steps[i].$2,
            isCompleted: i < currentIndex,
            isCurrent: i == currentIndex,
          ),
          if (i < _steps.length - 1)
            Expanded(
              child: Container(
                height: 2,
                color: i < currentIndex
                    ? const Color(0xFF2D8B4E)
                    : const Color(0xFFE2E8F0),
              ),
            ),
        ],
      ],
    );
  }
}

class _StepDot extends StatelessWidget {
  const _StepDot({
    required this.icon,
    required this.label,
    required this.isCompleted,
    required this.isCurrent,
  });

  final IconData icon;
  final String label;
  final bool isCompleted;
  final bool isCurrent;

  @override
  Widget build(BuildContext context) {
    final color = isCompleted
        ? const Color(0xFF2D8B4E)
        : isCurrent
            ? const Color(0xFF3B82F6)
            : const Color(0xFFCBD5E1);

    return Tooltip(
      message: label,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: (isCompleted || isCurrent)
              ? color.withValues(alpha: 0.15)
              : Colors.transparent,
          shape: BoxShape.circle,
          border: Border.all(color: color, width: 2),
        ),
        child: Icon(icon, size: 14, color: color),
      ),
    );
  }
}
