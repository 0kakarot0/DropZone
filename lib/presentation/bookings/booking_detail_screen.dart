import 'package:flutter/material.dart';
import 'package:dropzone_app/domain/entities/booking.dart';
import 'package:dropzone_app/presentation/widgets/primary_button.dart';
import 'package:dropzone_app/l10n/app_localizations.dart';

class BookingDetailScreen extends StatelessWidget {
  const BookingDetailScreen({super.key, required this.booking});

  final Booking booking;

  String _statusLabel(AppLocalizations localizations, BookingStatus status) {
    switch (status) {
      case BookingStatus.requested:
        return localizations.statusRequested;
      case BookingStatus.confirmed:
        return localizations.statusConfirmed;
      case BookingStatus.driverAssigned:
        return localizations.statusDriverAssigned;
      case BookingStatus.enRoute:
        return localizations.statusEnRoute;
      case BookingStatus.completed:
        return localizations.statusCompleted;
      case BookingStatus.cancelled:
        return localizations.statusCancelled;
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(localizations.bookingDetails)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Card(
            child: ListTile(
              title: Text(booking.id),
              subtitle: Text('${booking.pickup} → ${booking.dropoff}'),
              trailing: Text('AED ${booking.price.toStringAsFixed(0)}'),
            ),
          ),
          const SizedBox(height: 20),
          Text(localizations.statusTimeline, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          _StatusTile(label: _statusLabel(localizations, booking.status), active: true),
          _StatusTile(label: localizations.statusConfirmed, active: booking.status.index >= 1),
          _StatusTile(label: localizations.statusDriverAssigned, active: booking.status.index >= 2),
          _StatusTile(label: localizations.statusEnRoute, active: booking.status.index >= 3),
          _StatusTile(label: localizations.statusCompleted, active: booking.status.index >= 4),
          const SizedBox(height: 20),
          Text(localizations.policyTitle, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(localizations.policyBody),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  child: Text(localizations.reschedule),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: PrimaryButton(
                  label: localizations.cancelBooking,
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusTile extends StatelessWidget {
  const _StatusTile({required this.label, required this.active});

  final String label;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(active ? Icons.check_circle : Icons.circle_outlined,
          color: active ? Colors.green : Colors.grey),
      title: Text(label),
    );
  }
}
