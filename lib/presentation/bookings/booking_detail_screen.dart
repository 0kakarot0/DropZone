import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dropzone_app/domain/entities/booking.dart';
import 'package:dropzone_app/presentation/widgets/primary_button.dart';
import 'package:dropzone_app/l10n/app_localizations.dart';
import 'package:dropzone_app/presentation/bookings/booking_providers.dart';

class BookingDetailScreen extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context);
    final bookingAsync = ref.watch(bookingDetailProvider(booking.id));

    return bookingAsync.when(
      data: (bookingData) {
        if (bookingData == null) {
          return Scaffold(
            appBar: AppBar(title: Text(localizations.bookingDetails)),
            body: Center(child: Text(localizations.emptyBookings)),
          );
        }
        return Scaffold(
          appBar: AppBar(title: Text(localizations.bookingDetails)),
          body: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Card(
                child: ListTile(
                  title: Text(bookingData.id),
                  subtitle: Text('${bookingData.pickup} → ${bookingData.dropoff}'),
                  trailing: Text('AED ${bookingData.price.toStringAsFixed(0)}'),
                ),
              ),
              const SizedBox(height: 20),
              Text(localizations.statusTimeline,
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
              _StatusTile(
                  label: _statusLabel(localizations, bookingData.status), active: true),
              _StatusTile(
                  label: localizations.statusConfirmed,
                  active: bookingData.status.index >= 1),
              _StatusTile(
                  label: localizations.statusDriverAssigned,
                  active: bookingData.status.index >= 2),
              _StatusTile(
                  label: localizations.statusEnRoute,
                  active: bookingData.status.index >= 3),
              _StatusTile(
                  label: localizations.statusCompleted,
                  active: bookingData.status.index >= 4),
              const SizedBox(height: 20),
              Text(localizations.policyTitle,
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              Text(localizations.policyBody),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => EditBookingScreen(booking: bookingData),
                        ),
                      ).then((_) {
                        ref.invalidate(bookingDetailProvider(bookingData.id));
                        ref.invalidate(upcomingBookingsProvider);
                      });
                    },
                      child: Text(localizations.reschedule),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: PrimaryButton(
                      label: localizations.cancelBooking,
                      onPressed: () async {
                        final dialogContext = context;
                        final confirmed = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text(localizations.cancelConfirmTitle),
                            content: Text(localizations.cancelConfirmMessage),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(false),
                                child: Text(localizations.keepBooking),
                              ),
                              FilledButton(
                                onPressed: () => Navigator.of(context).pop(true),
                                child: Text(localizations.confirmCancel),
                              ),
                            ],
                          ),
                        );
                        if (confirmed == true && dialogContext.mounted) {
                          final repo = ref.read(bookingRepositoryProvider);
                          await repo.cancelBooking(bookingData.id);
                          ref.invalidate(upcomingBookingsProvider);
                          ref.invalidate(bookingDetailProvider(bookingData.id));
                          if (!dialogContext.mounted) return;
                          ScaffoldMessenger.of(dialogContext).showSnackBar(
                            SnackBar(content: Text(localizations.cancelConfirmed)),
                          );
                          Navigator.of(dialogContext).pop();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
      loading: () => Scaffold(
        appBar: AppBar(title: Text(localizations.bookingDetails)),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => Scaffold(
        appBar: AppBar(title: Text(localizations.bookingDetails)),
        body: Center(child: Text('${localizations.errorLabel}: $error')),
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

class EditBookingScreen extends StatelessWidget {
  const EditBookingScreen({super.key, required this.booking});

  final Booking booking;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final dateController = TextEditingController(
      text: booking.dateTime.toLocal().toString().split('.').first,
    );

    return Scaffold(
      appBar: AppBar(title: Text(localizations.editBookingTitle)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            decoration: InputDecoration(hintText: booking.pickup),
          ),
          const SizedBox(height: 12),
          TextField(
            decoration: InputDecoration(hintText: booking.dropoff),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: dateController,
            readOnly: true,
            decoration: InputDecoration(
              hintText: localizations.selectDate,
            ),
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 365)),
              );
              if (picked != null) {
                dateController.text = picked.toLocal().toString().split(' ').first;
              }
            },
          ),
          const SizedBox(height: 20),
          PrimaryButton(
            label: localizations.saveChanges,
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(localizations.rescheduleConfirmed)),
              );
            },
          ),
        ],
      ),
    );
  }
}
