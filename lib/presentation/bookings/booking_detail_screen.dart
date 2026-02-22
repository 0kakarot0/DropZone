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
      case BookingStatus.requested:
        return l.statusRequested;
      case BookingStatus.confirmed:
        return l.statusConfirmed;
      case BookingStatus.driverAssigned:
        return l.statusDriverAssigned;
      case BookingStatus.enRoute:
        return l.statusEnRoute;
      case BookingStatus.completed:
        return l.statusCompleted;
      case BookingStatus.cancelled:
        return l.statusCancelled;
    }
  }

  Future<void> _onDelete(AppLocalizations l) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.deleteBookingTitle),
        content: Text(l.deleteBookingMessage),
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
            child: Text(l.confirmDelete),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    await ref
        .read(upcomingBookingsProvider.notifier)
        .deleteBooking(_booking.id);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l.bookingDeletedConfirmed)),
    );

    // Navigate back to the bookings list (one level up)
    Navigator.of(context).pop();
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

    return Scaffold(
      appBar: AppBar(title: Text(l.bookingDetails)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Card(
            child: ListTile(
              title: Text(_booking.id),
              subtitle: Text('${_booking.pickup} → ${_booking.dropoff}'),
              trailing: Text('AED ${_booking.price.toStringAsFixed(0)}'),
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
          const SizedBox(height: 20),
          Text(l.statusTimeline,
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          _StatusTile(
              label: _statusLabel(l, _booking.status), active: true),
          _StatusTile(
              label: l.statusConfirmed,
              active: _booking.status.index >= 1),
          _StatusTile(
              label: l.statusDriverAssigned,
              active: _booking.status.index >= 2),
          _StatusTile(
              label: l.statusEnRoute,
              active: _booking.status.index >= 3),
          _StatusTile(
              label: l.statusCompleted,
              active: _booking.status.index >= 4),
          const SizedBox(height: 20),
          Text(l.policyTitle,
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(l.policyBody),
          const SizedBox(height: 20),
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
                  onPressed: () => _onDelete(l),
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
// _StatusTile
// ─────────────────────────────────────────────────────────────────────────────

class _StatusTile extends StatelessWidget {
  const _StatusTile({required this.label, required this.active});

  final String label;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        active ? Icons.check_circle : Icons.circle_outlined,
        color: active ? Colors.green : Colors.grey,
      ),
      title: Text(label),
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

  /// Combined DateTime from the picked date + time.
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
          .read(upcomingBookingsProvider.notifier)
          .rescheduleBooking(widget.booking.id, _combined);
      if (mounted) Navigator.of(context).pop(updated);
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
          // Pickup (read-only preview — full editing out of scope for this sprint)
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

          // ── Date picker tile ──────────────────────────────────────────────
          Text(l.date,
              style: Theme.of(context).textTheme.titleMedium),
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

          // ── Time picker tile ──────────────────────────────────────────────
          Text(l.time,
              style: Theme.of(context).textTheme.titleMedium),
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
