import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:go_router/go_router.dart';
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

  GoogleMapController? _mapController;
  final Set<Marker> _markers = {};

  // Default to Islamabad center if no position yet.
  static const _defaultCenter = LatLng(33.6844, 73.0479);

  /// Once the map has been created we never remove it from the widget tree.
  bool _mapReady = false;
  late CameraPosition _initialCameraPos;

  @override
  void initState() {
    super.initState();
    _initialCameraPos = const CameraPosition(target: _defaultCenter, zoom: 15);
    _fetchTracking();
    _pollTimer = Timer.periodic(
      const Duration(seconds: 5),
      (_) => _fetchTracking(),
    );
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    _mapController?.dispose();
    super.dispose();
  }

  Future<void> _fetchTracking() async {
    try {
      final service = ref.read(trackingServiceProvider);
      final dto = await service.track(widget.bookingId);
      if (!mounted) return;

      final info = dto != null ? _fromDto(dto) : null;

      // Set the initial camera position on first successful fetch.
      if (info != null && !_mapReady) {
        final hasPos = info.latitude != null && info.longitude != null;
        _initialCameraPos = CameraPosition(
          target: hasPos ? LatLng(info.latitude!, info.longitude!) : _defaultCenter,
          zoom: 15,
        );
      }

      setState(() {
        _loading = false;
        _error = null;
        _trackingInfo = info;
        _mapReady = _mapReady || (info != null);
        if (info != null) _updateMarkers(info);
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
      driverName: dto.driverName ?? AppLocalizations.of(context).trackingFallbackDriver,
      vehicleType: dto.vehicleType,
      vehiclePlate: dto.vehiclePlate,
      latitude: dto.latitude,
      longitude: dto.longitude,
      rideStatus: dto.rideStatus ?? '',
    );
  }

  void _updateMarkers(TrackingInfo info) {
    _markers.clear();

    if (info.latitude != null && info.longitude != null) {
      final driverPos = LatLng(info.latitude!, info.longitude!);

      _markers.add(Marker(
        markerId: const MarkerId('driver'),
        position: driverPos,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
        infoWindow: InfoWindow(
          title: info.driverName,
          snippet: [
            if (info.vehicleType != null) info.vehicleType!,
            if (info.vehiclePlate != null) info.vehiclePlate!,
          ].join(' · '),
        ),
      ));

      // Animate camera to driver position.
      _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(driverPos, 15),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      body: Stack(
        children: [
          // ── Google Map — always mounted once _mapReady ──────────────────
          if (_mapReady)
            Positioned.fill(
              child: GoogleMap(
                key: const ValueKey('tracking_map'),
                initialCameraPosition: _initialCameraPos,
                markers: _markers,
                style: theme.brightness == Brightness.dark ? _darkMapStyle : null,
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
                mapToolbarEnabled: false,
                onMapCreated: (controller) => _mapController = controller,
              ),
            ),

          // ── Overlay states ─────────────────────────────────────────────
          if (_loading)
            const Center(child: CircularProgressIndicator())
          else if (_error != null)
            _buildErrorState(theme)
          else if (_trackingInfo == null)
            _buildNoTrackingState(theme)
          else
            ..._buildTrackingOverlays(theme, localizations),
        ],
      ),
    );
  }

  Widget _buildErrorState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline, size: 64, color: theme.colorScheme.error),
          const SizedBox(height: 16),
          Text(AppLocalizations.of(context).trackingErrorTitle,
              style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          Text('$_error', style: theme.textTheme.bodySmall),
        ],
      ),
    );
  }

  Widget _buildNoTrackingState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.location_off, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(AppLocalizations.of(context).noTrackingAvailable,
              style: theme.textTheme.bodyLarge?.copyWith(color: Colors.grey)),
          const SizedBox(height: 8),
          Text(AppLocalizations.of(context).trackingAvailableAfterAssignment,
              style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey)),
        ],
      ),
    );
  }

  String _statusMessage(String status) {
    final localizations = AppLocalizations.of(context);
    switch (status) {
      case 'ASSIGNED':
        return localizations.trackingStatusAssigned;
      case 'DRIVER_EN_ROUTE':
        return localizations.trackingStatusEnRoute;
      case 'ARRIVED':
        return localizations.trackingStatusArrived;
      case 'IN_PROGRESS':
        return localizations.trackingStatusInProgress;
      default:
        return status;
    }
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'ASSIGNED':
        return Colors.orange;
      case 'DRIVER_EN_ROUTE':
        return Colors.blue;
      case 'ARRIVED':
        return Colors.green;
      case 'IN_PROGRESS':
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }

  /// Returns the UI overlay widgets (top bar + bottom sheet) for the tracking view.
  List<Widget> _buildTrackingOverlays(ThemeData theme, AppLocalizations l) {
    final info = _trackingInfo!;

    return [
      // ── Top bar (back + status pill) ──────────────────────────────────
      SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: theme.colorScheme.surface,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: _statusColor(info.rideStatus),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _statusMessage(info.rideStatus),
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      // ── Bottom sheet with driver info ──────────────────────────────────
      DraggableScrollableSheet(
        initialChildSize: 0.30,
        minChildSize: 0.15,
        maxChildSize: 0.50,
        builder: (context, scrollController) {
          return Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 20,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: ListView(
              controller: scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                // Drag handle
                Center(
                  child: Container(
                    margin: const EdgeInsets.only(top: 12, bottom: 16),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),

                // ── Driver card ─────────────────────────────────────────
                Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: theme.colorScheme.primaryContainer,
                      child: Icon(Icons.person,
                          size: 32,
                          color: theme.colorScheme.onPrimaryContainer),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            info.driverName,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            [
                              if (info.vehicleType != null) info.vehicleType!,
                              if (info.vehiclePlate != null) info.vehiclePlate!,
                            ].join(' · '),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Status badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: _statusColor(info.rideStatus).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _statusMessage(info.rideStatus),
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: _statusColor(info.rideStatus),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // ── Status progress bar ─────────────────────────────────
                _StatusStepper(currentStatus: info.rideStatus),
                const SizedBox(height: 20),

                // ── Contact button ──────────────────────────────────────
                PrimaryButton(
                  label: l.contactDriver,
                  onPressed: () {
                    context.push('/contact');
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    ];
  }
}

// ── Status Stepper ──────────────────────────────────────────────────────────

class _StatusStepper extends StatelessWidget {
  const _StatusStepper({required this.currentStatus});

  final String currentStatus;

  static const _steps = ['ASSIGNED', 'DRIVER_EN_ROUTE', 'ARRIVED', 'IN_PROGRESS'];

  int get _currentIndex {
    final idx = _steps.indexOf(currentStatus);
    return idx >= 0 ? idx : -1;
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final labels = [
      localizations.trackingStepAssigned,
      localizations.trackingStepEnRoute,
      localizations.trackingStepArrived,
      localizations.trackingStepInProgress,
    ];

    return Row(
      children: List.generate(_steps.length * 2 - 1, (i) {
        if (i.isOdd) {
          // Connector line
          final stepIndex = i ~/ 2;
          final isComplete = stepIndex < _currentIndex;
          return Expanded(
            child: Container(
              height: 3,
              color: isComplete
                  ? theme.colorScheme.primary
                  : theme.colorScheme.outlineVariant,
            ),
          );
        }
        // Step circle
        final stepIndex = i ~/ 2;
        final isActive = stepIndex <= _currentIndex;
        final isCurrent = stepIndex == _currentIndex;
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: isCurrent ? 28 : 20,
              height: isCurrent ? 28 : 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isActive
                    ? theme.colorScheme.primary
                    : theme.colorScheme.outlineVariant,
                border: isCurrent
                    ? Border.all(
                        color: theme.colorScheme.primary.withValues(alpha: 0.3),
                        width: 3)
                    : null,
              ),
              child: Icon(
                isActive ? Icons.check : Icons.circle,
                size: isCurrent ? 14 : 10,
                color: isActive
                    ? theme.colorScheme.onPrimary
                    : theme.colorScheme.outline,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              labels[stepIndex],
              style: theme.textTheme.labelSmall?.copyWith(
                color: isActive
                    ? theme.colorScheme.primary
                    : theme.colorScheme.outline,
                fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                fontSize: 9,
              ),
            ),
          ],
        );
      }),
    );
  }
}

// ── Dark Map Style ──────────────────────────────────────────────────────────

const String _darkMapStyle = '''
[
  {"elementType":"geometry","stylers":[{"color":"#242f3e"}]},
  {"elementType":"labels.text.fill","stylers":[{"color":"#746855"}]},
  {"elementType":"labels.text.stroke","stylers":[{"color":"#242f3e"}]},
  {"featureType":"administrative.locality","elementType":"labels.text.fill","stylers":[{"color":"#d59563"}]},
  {"featureType":"poi","elementType":"labels.text.fill","stylers":[{"color":"#d59563"}]},
  {"featureType":"poi.park","elementType":"geometry","stylers":[{"color":"#263c3f"}]},
  {"featureType":"poi.park","elementType":"labels.text.fill","stylers":[{"color":"#6b9a76"}]},
  {"featureType":"road","elementType":"geometry","stylers":[{"color":"#38414e"}]},
  {"featureType":"road","elementType":"geometry.stroke","stylers":[{"color":"#212a37"}]},
  {"featureType":"road","elementType":"labels.text.fill","stylers":[{"color":"#9ca5b3"}]},
  {"featureType":"road.highway","elementType":"geometry","stylers":[{"color":"#746855"}]},
  {"featureType":"road.highway","elementType":"geometry.stroke","stylers":[{"color":"#1f2835"}]},
  {"featureType":"road.highway","elementType":"labels.text.fill","stylers":[{"color":"#f3d19c"}]},
  {"featureType":"transit","elementType":"geometry","stylers":[{"color":"#2f3948"}]},
  {"featureType":"transit.station","elementType":"labels.text.fill","stylers":[{"color":"#d59563"}]},
  {"featureType":"water","elementType":"geometry","stylers":[{"color":"#17263c"}]},
  {"featureType":"water","elementType":"labels.text.fill","stylers":[{"color":"#515c6d"}]},
  {"featureType":"water","elementType":"labels.text.stroke","stylers":[{"color":"#17263c"}]}
]
''';
