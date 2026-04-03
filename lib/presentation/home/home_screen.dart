import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:dropzone_app/domain/entities/booking.dart';
import 'package:dropzone_app/presentation/bookings/booking_providers.dart';
import 'package:dropzone_app/presentation/theme/app_colors.dart';
import 'package:dropzone_app/presentation/widgets/primary_button.dart';
import 'package:dropzone_app/l10n/app_localizations.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context);
    final bookingsAsync = ref.watch(bookingsProvider);

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Active Ride Card (if any) ──────────────────────────────────
            bookingsAsync.when(
              data: (bookings) {
                final active = bookings.where(_isTrackable).toList();
                if (active.isEmpty) return const SizedBox.shrink();
                return _ActiveRideCard(booking: active.first);
              },
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
            ),

            // ── Hero card ─────────────────────────────────────────────────
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    localizations.homeHeroTitle,
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          color: Colors.white,
                        ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    localizations.homeHeroSubtitle,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white70,
                        ),
                  ),
                  const SizedBox(height: 20),
                  PrimaryButton(
                    label: localizations.bookNow,
                    onPressed: () => context.go('/book'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              localizations.bookingTitle,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView(
                children: [
                  _FeatureCard(
                    title: localizations.tripAirportPickup,
                    subtitle: localizations.tripType,
                  ),
                  _FeatureCard(
                    title: localizations.tripAirportDrop,
                    subtitle: localizations.tripType,
                  ),
                  _FeatureCard(
                    title: localizations.tripBusiness,
                    subtitle: localizations.tripType,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
  }

  bool _isTrackable(Booking b) {
    return b.status == BookingStatus.assigned ||
        b.status == BookingStatus.driverEnRoute ||
        b.status == BookingStatus.arrived ||
        b.status == BookingStatus.inProgress;
  }
}

// ── Active Ride Card ──────────────────────────────────────────────────────────

class _ActiveRideCard extends StatelessWidget {
  const _ActiveRideCard({required this.booking});

  final Booking booking;

  String _statusLabel(BookingStatus status) {
    switch (status) {
      case BookingStatus.assigned:
        return 'Driver Assigned';
      case BookingStatus.driverEnRoute:
        return 'Driver En Route';
      case BookingStatus.arrived:
        return 'Driver Arrived';
      case BookingStatus.inProgress:
        return 'Ride In Progress';
      default:
        return status.name;
    }
  }

  Color _statusColor(BookingStatus status) {
    switch (status) {
      case BookingStatus.assigned:
        return Colors.orange;
      case BookingStatus.driverEnRoute:
        return Colors.blue;
      case BookingStatus.arrived:
        return Colors.green;
      case BookingStatus.inProgress:
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = _statusColor(booking.status);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Material(
        borderRadius: BorderRadius.circular(20),
        color: theme.colorScheme.surface,
        elevation: 2,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => context.push('/tracking/${booking.id}'),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: color.withValues(alpha: 0.3),
                width: 1.5,
              ),
            ),
            child: Row(
              children: [
                // Pulsing icon
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.directions_car, color: color, size: 24),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Active Ride',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${booking.pickup} → ${booking.dropoff}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        _statusLabel(booking.status),
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: color,
                          fontWeight: FontWeight.w700,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 4),
                Icon(Icons.chevron_right,
                    color: theme.colorScheme.onSurfaceVariant),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Feature Card ──────────────────────────────────────────────────────────────

class _FeatureCard extends StatelessWidget {
  const _FeatureCard({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      ),
    );
  }
}
