import 'package:flutter/material.dart';
import 'package:dropzone_app/domain/entities/booking.dart';
import 'package:dropzone_app/l10n/app_localizations.dart';

class BookingLocationSummary extends StatelessWidget {
  const BookingLocationSummary({
    super.key,
    required this.booking,
    this.compact = false,
  });

  final Booking booking;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _LocationRow(
          icon: Icons.trip_origin,
          label: localizations.pickup,
          value: booking.pickup,
          latitude: booking.pickupLatitude,
          longitude: booking.pickupLongitude,
          compact: compact,
          color: theme.colorScheme.primary,
        ),
        const SizedBox(height: 8),
        _LocationRow(
          icon: Icons.location_on,
          label: localizations.dropoff,
          value: booking.dropoff,
          latitude: booking.dropoffLatitude,
          longitude: booking.dropoffLongitude,
          compact: compact,
          color: theme.colorScheme.secondary,
        ),
      ],
    );
  }
}

class _LocationRow extends StatelessWidget {
  const _LocationRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.latitude,
    required this.longitude,
    required this.compact,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final double? latitude;
  final double? longitude;
  final bool compact;
  final Color color;

  bool get hasCoordinates => latitude != null && longitude != null;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final labelStyle = compact
        ? theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w700,
          )
        : theme.textTheme.labelMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w700,
          );
    final valueStyle = compact
        ? theme.textTheme.bodySmall
        : theme.textTheme.bodyMedium;
    final coordsStyle = theme.textTheme.bodySmall?.copyWith(
      color: color,
      fontWeight: FontWeight.w600,
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Icon(icon, size: compact ? 14 : 16, color: color),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: labelStyle),
              const SizedBox(height: 2),
              Text(value, style: valueStyle),
              if (hasCoordinates) ...[
                const SizedBox(height: 2),
                Text(
                  '${latitude!.toStringAsFixed(4)}, ${longitude!.toStringAsFixed(4)}',
                  style: coordsStyle,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
