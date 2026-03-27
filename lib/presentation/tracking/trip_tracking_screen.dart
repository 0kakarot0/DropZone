import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dropzone_app/core/network/dio_client.dart';
import 'package:dropzone_app/data/api/api_tracking_service.dart';
import 'package:dropzone_app/data/dto/tracking_dto.dart';
import 'package:dropzone_app/domain/entities/tracking_info.dart';
import 'package:dropzone_app/presentation/widgets/primary_button.dart';
import 'package:dropzone_app/l10n/app_localizations.dart';

// ── Provider ─────────────────────────────────────────────────────────────────

final trackingServiceProvider = Provider<ApiTrackingService>((ref) {
  return ApiTrackingService(ref.read(dioProvider));
});

// ── Screen ───────────────────────────────────────────────────────────────────

class TripTrackingScreen extends ConsumerStatefulWidget {
  const TripTrackingScreen({super.key, required this.bookingId});

  final int bookingId;

  @override
  ConsumerState<TripTrackingScreen> createState() => _TripTrackingScreenState();
}

class _TripTrackingScreenState extends ConsumerState<TripTrackingScreen> {
  Timer? _pollTimer;
  TrackingInfo? _trackingInfo;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchTracking();
    // Poll every 5 seconds for live location updates.
    _pollTimer = Timer.periodic(
      const Duration(seconds: 5),
      (_) => _fetchTracking(),
    );
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    super.dispose();
  }

  Future<void> _fetchTracking() async {
    try {
      final service = ref.read(trackingServiceProvider);
      final dto = await service.track(widget.bookingId);
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = null;
        _trackingInfo = dto != null ? _fromDto(dto) : null;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = '$e';
      });
    }
  }

  TrackingInfo _fromDto(TrackingResponseDto dto) {
    return TrackingInfo(
      bookingId: dto.bookingId ?? widget.bookingId,
      driverId: dto.driverId ?? 0,
      driverName: dto.driverName ?? 'Driver',
      vehicleType: dto.vehicleType,
      vehiclePlate: dto.vehiclePlate,
      latitude: dto.latitude,
      longitude: dto.longitude,
      rideStatus: dto.rideStatus ?? '',
    );
  }

  IconData _statusIcon(String status) {
    switch (status) {
      case 'ASSIGNED':
        return Icons.person_pin;
      case 'DRIVER_EN_ROUTE':
        return Icons.navigation;
      case 'ARRIVED':
        return Icons.place;
      case 'IN_PROGRESS':
        return Icons.directions_car;
      default:
        return Icons.info_outline;
    }
  }

  String _statusMessage(String status) {
    switch (status) {
      case 'ASSIGNED':
        return 'Driver assigned — waiting for pickup';
      case 'DRIVER_EN_ROUTE':
        return 'Driver is on the way';
      case 'ARRIVED':
        return 'Driver has arrived at pickup';
      case 'IN_PROGRESS':
        return 'Ride in progress';
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(localizations.tripTrackingTitle)),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text('Error: $_error'))
              : _trackingInfo == null
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.location_off, size: 64, color: Colors.grey.shade400),
                          const SizedBox(height: 16),
                          Text(
                            'No tracking available for this ride',
                            style: theme.textTheme.bodyLarge?.copyWith(color: Colors.grey),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Tracking is available once a driver is assigned',
                            style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
                          ),
                        ],
                      ),
                    )
                  : _buildTrackingContent(theme, localizations),
    );
  }

  Widget _buildTrackingContent(ThemeData theme, AppLocalizations l) {
    final info = _trackingInfo!;

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        // ── Map placeholder / location card ──────────────────────────────
        Container(
          height: 200,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                theme.colorScheme.primaryContainer,
                theme.colorScheme.secondaryContainer,
              ],
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(_statusIcon(info.rideStatus), size: 48,
                    color: theme.colorScheme.onPrimaryContainer),
                const SizedBox(height: 8),
                Text(
                  _statusMessage(info.rideStatus),
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
                if (info.latitude != null && info.longitude != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    '${info.latitude!.toStringAsFixed(4)}, ${info.longitude!.toStringAsFixed(4)}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onPrimaryContainer.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),

        // ── Driver info card ─────────────────────────────────────────────
        Card(
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: theme.colorScheme.primary,
              child: Icon(Icons.person, color: theme.colorScheme.onPrimary),
            ),
            title: Text(info.driverName),
            subtitle: Text([
              if (info.vehicleType != null) info.vehicleType!,
              if (info.vehiclePlate != null) info.vehiclePlate!,
            ].join(' · ')),
            trailing: const Icon(Icons.directions_car),
          ),
        ),
        const SizedBox(height: 12),

        // ── Ride status chip ─────────────────────────────────────────────
        Card(
          child: ListTile(
            title: Text(l.etaLabel),
            subtitle: Text(_statusMessage(info.rideStatus)),
            trailing: Chip(
              label: Text(info.rideStatus.replaceAll('_', ' ')),
              backgroundColor: theme.colorScheme.primaryContainer,
            ),
          ),
        ),
        const SizedBox(height: 20),

        // ── Contact driver button ────────────────────────────────────────
        PrimaryButton(
          label: l.contactDriver,
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l.contactDriverHint)),
            );
          },
        ),
      ],
    );
  }
}
