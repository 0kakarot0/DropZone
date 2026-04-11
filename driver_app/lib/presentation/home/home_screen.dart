import 'package:dropzone_driver_app/core/di/providers.dart';
import 'package:dropzone_driver_app/domain/entities/driver_ride.dart';
import 'package:dropzone_driver_app/domain/entities/ride_status_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(driverProfileProvider);
    final ridesAsync = ref.watch(assignedRidesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(driverProfileProvider);
          ref.invalidate(assignedRidesProvider);
          await Future.wait([
            ref.read(driverProfileProvider.future),
            ref.read(assignedRidesProvider.future),
          ]);
        },
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          children: [
            // ── Driver card ──
            profileAsync.when(
              data: (profile) => _DriverCard(
                name: profile.displayName,
                vehicle: '${profile.vehicleType} • ${profile.vehiclePlate}',
                status: profile.status,
                rating: profile.rating,
              ),
              loading: () => const _LoadingCard(height: 100),
              error: (error, _) => _ErrorCard(message: error.toString()),
            ),
            const SizedBox(height: 16),

            // ── Rides summary ──
            ridesAsync.when(
              data: (rides) {
                final offered = rides.where((r) => r.isOffered).toList();
                final active = _findActiveRide(rides);

                return Column(
                  children: [
                    // Active ride
                    if (active != null) ...[
                      _ActiveRideCard(ride: active),
                      const SizedBox(height: 16),
                    ],

                    // Offered rides count
                    _OfferedRidesBanner(
                      count: offered.length,
                      onTap: () => context.go('/rides'),
                    ),
                  ],
                );
              },
              loading: () => const _LoadingCard(height: 80),
              error: (error, _) => _ErrorCard(message: error.toString()),
            ),
          ],
        ),
      ),
    );
  }

  DriverRide? _findActiveRide(List<DriverRide> rides) {
    for (final ride in rides) {
      if (ride.isAccepted && !isTerminalStatus(ride.bookingStatus)) {
        return ride;
      }
    }
    return null;
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Driver identity card
// ─────────────────────────────────────────────────────────────────────────────

class _DriverCard extends StatelessWidget {
  const _DriverCard({
    required this.name,
    required this.vehicle,
    required this.status,
    this.rating,
  });

  final String name;
  final String vehicle;
  final String status;
  final double? rating;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF1A2332), const Color(0xFF0D1B2A)]
              : [const Color(0xFF16324F), const Color(0xFF1B4065)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: Colors.white.withValues(alpha: 0.15),
                child: const Icon(Icons.person, color: Colors.white),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      vehicle,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withValues(alpha: 0.75),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              _InfoPill(
                icon: Icons.circle,
                iconSize: 10,
                iconColor: _statusDotColor(status),
                label: status,
              ),
              if (rating != null) ...[
                const SizedBox(width: 8),
                _InfoPill(
                  icon: Icons.star_rounded,
                  iconSize: 16,
                  iconColor: const Color(0xFFC89B3C),
                  label: rating!.toStringAsFixed(1),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Color _statusDotColor(String status) {
    return switch (status) {
      'AVAILABLE' => const Color(0xFF2D8B4E),
      'BUSY' => const Color(0xFFF59E0B),
      'OFFLINE' => const Color(0xFF64748B),
      _ => const Color(0xFF64748B),
    };
  }
}

class _InfoPill extends StatelessWidget {
  const _InfoPill({
    required this.icon,
    required this.iconSize,
    required this.iconColor,
    required this.label,
  });

  final IconData icon;
  final double iconSize;
  final Color iconColor;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: iconSize, color: iconColor),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Active ride card
// ─────────────────────────────────────────────────────────────────────────────

class _ActiveRideCard extends StatelessWidget {
  const _ActiveRideCard({required this.ride});

  final DriverRide ride;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: InkWell(
        onTap: () => context.go('/rides/${ride.id}'),
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Color(0xFF2D8B4E),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Active ride',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: const Color(0xFF2D8B4E),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF3B82F6).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      statusDisplayLabel(ride.bookingStatus),
                      style: const TextStyle(
                        color: Color(0xFF3B82F6),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.trip_origin,
                      size: 14, color: Color(0xFF2D8B4E)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      ride.pickupLocation,
                      style: theme.textTheme.bodyLarge,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(Icons.location_on,
                      size: 14, color: Color(0xFFE53E3E)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      ride.dropoffLocation,
                      style: theme.textTheme.bodyLarge,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(Icons.schedule, size: 14),
                  const SizedBox(width: 6),
                  Text(
                    DateFormat('dd MMM • HH:mm').format(ride.pickupTime),
                    style: theme.textTheme.bodyMedium,
                  ),
                  const Spacer(),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 14,
                    color: theme.textTheme.bodyMedium?.color,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Offered rides banner
// ─────────────────────────────────────────────────────────────────────────────

class _OfferedRidesBanner extends StatelessWidget {
  const _OfferedRidesBanner({
    required this.count,
    required this.onTap,
  });

  final int count;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFFF59E0B).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    '$count',
                    style: const TextStyle(
                      color: Color(0xFFF59E0B),
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      count == 0
                          ? 'No ride offers'
                          : '$count ride offer${count > 1 ? 's' : ''}',
                      style: theme.textTheme.titleMedium,
                    ),
                    Text(
                      count == 0
                          ? 'New ride offers will appear here.'
                          : 'Tap to view and respond.',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: theme.textTheme.bodyMedium?.color,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Utility cards
// ─────────────────────────────────────────────────────────────────────────────

class _LoadingCard extends StatelessWidget {
  const _LoadingCard({this.height = 72});

  final double height;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(
        height: height,
        child: const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

class _ErrorCard extends StatelessWidget {
  const _ErrorCard({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Icon(Icons.error_outline,
                size: 24, color: Theme.of(context).colorScheme.error),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
