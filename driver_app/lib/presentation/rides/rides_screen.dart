import 'package:dropzone_driver_app/core/di/providers.dart';
import 'package:dropzone_driver_app/domain/entities/driver_ride.dart';
import 'package:dropzone_driver_app/domain/entities/ride_status_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class RidesScreen extends ConsumerWidget {
  const RidesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ridesAsync = ref.watch(assignedRidesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ride inbox'),
      ),
      body: ridesAsync.when(
        data: (rides) {
          final offered = rides.where((r) => r.isOffered).toList();
          final accepted =
              rides.where((r) => r.isAccepted && !isTerminalStatus(r.bookingStatus)).toList();
          final completed =
              rides.where((r) => isTerminalStatus(r.bookingStatus)).toList();
          final unknown =
              rides.where((r) => !r.hasKnownAssignmentState).toList();

          if (rides.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.inbox_outlined,
                    size: 64,
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No rides right now',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'New ride offers will appear here.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(assignedRidesProvider);
              await ref.read(assignedRidesProvider.future);
            },
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              children: [
                if (offered.isNotEmpty) ...[
                  _SectionHeader(
                    title: 'Offered',
                    count: offered.length,
                    color: const Color(0xFFF59E0B),
                  ),
                  const SizedBox(height: 8),
                  ...offered.map((ride) => _RideCard(ride: ride)),
                  const SizedBox(height: 20),
                ],
                if (accepted.isNotEmpty) ...[
                  _SectionHeader(
                    title: 'Active',
                    count: accepted.length,
                    color: const Color(0xFF2D8B4E),
                  ),
                  const SizedBox(height: 8),
                  ...accepted.map((ride) => _RideCard(ride: ride)),
                  const SizedBox(height: 20),
                ],
                if (completed.isNotEmpty) ...[
                  _SectionHeader(
                    title: 'Completed',
                    count: completed.length,
                    color: const Color(0xFF64748B),
                  ),
                  const SizedBox(height: 8),
                  ...completed.map((ride) => _RideCard(ride: ride)),
                  const SizedBox(height: 20),
                ],
                if (unknown.isNotEmpty) ...[
                  _SectionHeader(
                    title: 'Other',
                    count: unknown.length,
                    color: const Color(0xFF64748B),
                  ),
                  const SizedBox(height: 8),
                  ...unknown.map((ride) => _RideCard(ride: ride)),
                ],
              ],
            ),
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
                  onPressed: () => ref.invalidate(assignedRidesProvider),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Section header
// ─────────────────────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.count,
    required this.color,
  });

  final String title;
  final int count;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 20,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            '$count',
            style: TextStyle(
              color: color,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Ride card
// ─────────────────────────────────────────────────────────────────────────────

class _RideCard extends StatelessWidget {
  const _RideCard({required this.ride});

  final DriverRide ride;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Card(
        child: InkWell(
          onTap: () => context.go('/rides/${ride.id}'),
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        ride.pickupLocation,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    _RideStatusBadge(ride: ride),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.arrow_forward,
                        size: 14, color: theme.textTheme.bodyMedium?.color),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        ride.dropoffLocation,
                        style: theme.textTheme.bodyMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.schedule,
                        size: 14, color: theme.textTheme.bodyMedium?.color),
                    const SizedBox(width: 4),
                    Text(
                      DateFormat('dd MMM • HH:mm').format(ride.pickupTime),
                      style: theme.textTheme.bodySmall,
                    ),
                    const SizedBox(width: 12),
                    Icon(Icons.people_outline,
                        size: 14, color: theme.textTheme.bodyMedium?.color),
                    const SizedBox(width: 4),
                    Text(
                      '${ride.passengers}',
                      style: theme.textTheme.bodySmall,
                    ),
                    const Spacer(),
                    Text(
                      ride.paymentMethod,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RideStatusBadge extends StatelessWidget {
  const _RideStatusBadge({required this.ride});

  final DriverRide ride;

  @override
  Widget build(BuildContext context) {
    final (label, color) = _badgeInfo();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  (String, Color) _badgeInfo() {
    if (ride.isOffered) {
      return ('OFFER', const Color(0xFFF59E0B));
    }
    if (isTerminalStatus(ride.bookingStatus)) {
      return ('DONE', const Color(0xFF64748B));
    }
    return (
      statusDisplayLabel(ride.bookingStatus).toUpperCase(),
      const Color(0xFF3B82F6),
    );
  }
}
