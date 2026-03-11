import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:dropzone_app/domain/entities/booking.dart';
import 'package:dropzone_app/presentation/widgets/primary_button.dart';
import 'package:dropzone_app/l10n/app_localizations.dart';
import 'package:dropzone_app/presentation/bookings/booking_providers.dart';

// ─────────────────────────────────────────────────────────────────────────────
// BookingDetailScreen
// ─────────────────────────────────────────────────────────────────────────────

class BookingDetailScreen extends ConsumerStatefulWidget {
  const BookingDetailScreen({super.key, required this.booking});

  final Booking booking;

  @override
  ConsumerState<BookingDetailScreen> createState() =>
      _BookingDetailScreenState();
}

class _BookingDetailScreenState extends ConsumerState<BookingDetailScreen> {
  late Booking _booking;

  @override
  void initState() {
    super.initState();
    _booking = widget.booking;
  }

  String _statusLabel(AppLocalizations l, BookingStatus status) {
    switch (status) {
      case BookingStatus.pendingPayment:
        return 'Pending Payment';
      case BookingStatus.confirmed:
      case BookingStatus.created:
        return l.statusConfirmed;
      case BookingStatus.rescheduled:
        return l.statusDriverAssigned;
      case BookingStatus.cancelled:
        return l.statusCancelled;
    }
  }

  Future<void> _onCancel(AppLocalizations l) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.cancelConfirmTitle),
        content: Text(l.cancelConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l.keepBooking),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(l.confirmCancel),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    try {
      await ref.read(bookingsProvider.notifier).cancelBooking(_booking.id);
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.cancelConfirmed)),
      );
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${l.errorLabel}: $e')),
      );
    }
  }

  Future<void> _onReschedule(AppLocalizations l) async {
    final updated = await Navigator.of(context).push<Booking>(
      MaterialPageRoute(
        builder: (_) => EditBookingScreen(booking: _booking),
      ),
    );

    if (updated != null && mounted) {
      setState(() => _booking = updated);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.rescheduleSuccess)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final dateFmt = DateFormat('dd MMM yyyy, HH:mm');
    final eventsAsync = ref.watch(bookingEventsProvider(_booking.id));

    return Scaffold(
      appBar: AppBar(title: Text(l.bookingDetails)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Card(
            child: ListTile(
              title: Text('#${_booking.id}'),
              subtitle: Text('${_booking.pickup} → ${_booking.dropoff}'),
              trailing: Text(
                _booking.priceEstimateCents != null
                    ? 'AED ${_booking.priceAed.toStringAsFixed(0)}'
                    : '',
              ),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              dateFmt.format(_booking.dateTime.toLocal()),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
          if (_booking.passengers != null)
            Padding(
              padding: const EdgeInsets.only(top: 4, left: 4),
              child: Text(
                '${l.passengers}: ${_booking.passengers}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          if (_booking.notes != null && _booking.notes!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 4, left: 4),
              child: Text(
                _booking.notes!,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          const SizedBox(height: 20),

          // ── Status chip ───────────────────────────────────────────────────
          Row(
            children: [
              Chip(
                label: Text(_statusLabel(l, _booking.status)),
                backgroundColor:
                    _booking.status == BookingStatus.cancelled
                        ? Theme.of(context).colorScheme.errorContainer
                        : Theme.of(context).colorScheme.primaryContainer,
              ),
            ],
          ),
          const SizedBox(height: 20),

          // ── Event timeline ────────────────────────────────────────────────
          Text(l.statusTimeline,
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          eventsAsync.when(
            data: (events) {
              if (events.isEmpty) {
                return Text(l.emptyBookings,
                    style: Theme.of(context).textTheme.bodyMedium);
              }
              return Column(
                children: events
                    .map((e) => _EventTile(event: e))
                    .toList(),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) =>
                Text('${l.errorLabel}: $e'),
          ),
          const SizedBox(height: 20),

          // ── Cancellation policy ───────────────────────────────────────────
          Text(l.policyTitle,
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(l.policyBody),
          const SizedBox(height: 20),

          // ── Action buttons ────────────────────────────────────────────────
          if (_booking.status != BookingStatus.cancelled)
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _onReschedule(l),
                    child: Text(l.reschedule),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: PrimaryButton(
                    label: l.cancelBooking,
                    onPressed: () => _onCancel(l),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _EventTile
// ─────────────────────────────────────────────────────────────────────────────

class _EventTile extends StatelessWidget {
  const _EventTile({required this.event});
  final BookingEvent event;

  @override
  Widget build(BuildContext context) {
    final timeFmt = DateFormat('dd MMM, HH:mm');
    return ListTile(
      dense: true,
      leading: const Icon(Icons.circle, size: 10),
      title: Text(event.description),
      subtitle: Text(timeFmt.format(event.createdAt.toLocal())),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// EditBookingScreen
// ─────────────────────────────────────────────────────────────────────────────

class EditBookingScreen extends ConsumerStatefulWidget {
  const EditBookingScreen({super.key, required this.booking});

  final Booking booking;

  @override
  ConsumerState<EditBookingScreen> createState() => _EditBookingScreenState();
}

class _EditBookingScreenState extends ConsumerState<EditBookingScreen> {
  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final dt = widget.booking.dateTime.toLocal();
    _selectedDate = DateTime(dt.year, dt.month, dt.day);
    _selectedTime = TimeOfDay(hour: dt.hour, minute: dt.minute);
  }

  DateTime get _combined => DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _selectedTime.hour,
        _selectedTime.minute,
      );

  Future<void> _pickDate() async {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate.isAfter(tomorrow) ? _selectedDate : tomorrow,
      firstDate: tomorrow,
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null) setState(() => _selectedTime = picked);
  }

  Future<void> _save(AppLocalizations l) async {
    setState(() => _saving = true);
    try {
      final updated = await ref
          .read(bookingsProvider.notifier)
          .rescheduleBooking(widget.booking.id, _combined);
      if (mounted) Navigator.of(context).pop(updated);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${l.errorLabel}: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final dateFmt = DateFormat('dd MMM yyyy');

    return Scaffold(
      appBar: AppBar(title: Text(l.editBookingTitle)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            readOnly: true,
            decoration: InputDecoration(
              hintText: widget.booking.pickup,
              labelText: l.pickup,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            readOnly: true,
            decoration: InputDecoration(
              hintText: widget.booking.dropoff,
              labelText: l.dropoff,
            ),
          ),
          const SizedBox(height: 20),

          Text(l.date, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          InkWell(
            onTap: _pickDate,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today_outlined),
                  const SizedBox(width: 12),
                  Text(dateFmt.format(_selectedDate)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          Text(l.time, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          InkWell(
            onTap: _pickTime,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.access_time_outlined),
                  const SizedBox(width: 12),
                  Text(_selectedTime.format(context)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          PrimaryButton(
            label: _saving ? '…' : l.saveChanges,
            onPressed: _saving ? null : () => _save(l),
          ),
        ],
      ),
    );
  }
}
