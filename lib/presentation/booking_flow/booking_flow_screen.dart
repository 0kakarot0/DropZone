import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:dropzone_app/presentation/widgets/primary_button.dart';
import 'package:dropzone_app/l10n/app_localizations.dart';
import 'package:dropzone_app/presentation/bookings/booking_providers.dart';
import 'package:dropzone_app/domain/entities/booking.dart';
import 'package:dropzone_app/core/di/providers.dart';

class BookingFlowScreen extends ConsumerStatefulWidget {
  const BookingFlowScreen({super.key});

  @override
  ConsumerState<BookingFlowScreen> createState() => _BookingFlowScreenState();
}

class _BookingFlowScreenState extends ConsumerState<BookingFlowScreen> {
  int currentStep = 0;
  TripType tripType = TripType.airportPickup;
  VehicleClass vehicleClass = VehicleClass.sedan;
  String pickup = '';
  String dropoff = '';

  // Date/time chosen via pickers — defaults to +4 h from now if not set.
  DateTime? _pickedDate;
  TimeOfDay? _pickedTime;

  DateTime get _resolvedDateTime {
    if (_pickedDate == null) {
      return DateTime.now().add(const Duration(hours: 4));
    }
    final t = _pickedTime ?? TimeOfDay.now();
    return DateTime(
        _pickedDate!.year, _pickedDate!.month, _pickedDate!.day, t.hour, t.minute);
  }

  Future<void> _pickDate() async {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    final picked = await showDatePicker(
      context: context,
      initialDate: _pickedDate != null && _pickedDate!.isAfter(tomorrow)
          ? _pickedDate!
          : tomorrow,
      firstDate: tomorrow,
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) setState(() => _pickedDate = picked);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _pickedTime ?? TimeOfDay.now(),
    );
    if (picked != null) setState(() => _pickedTime = picked);
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final priceAsync = ref.watch(priceEstimateProvider(vehicleClass));
    final dateFmt = DateFormat('dd MMM yyyy');

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.bookingTitle),
      ),
      body: Stepper(
        type: StepperType.vertical,
        currentStep: currentStep,
        onStepContinue: () async {
          if (currentStep < 4) {
            setState(() => currentStep += 1);
            return;
          }
          final repository = ref.read(bookingRepositoryProvider);
          final analytics = ref.read(analyticsProvider);
          final booking = Booking(
            id: 'TEMP',
            tripType: tripType,
            pickup: pickup.isEmpty ? localizations.pickup : pickup,
            dropoff: dropoff.isEmpty ? localizations.dropoff : dropoff,
            dateTime: _resolvedDateTime,
            vehicleClass: vehicleClass,
            status: BookingStatus.requested,
            price: priceAsync.value ?? 250,
          );
          final messenger = ScaffoldMessenger.of(context);
          final router = GoRouter.of(context);
          await repository.createBooking(booking);
          await analytics.trackEvent('booking_created', params: {
            'tripType': tripType.name,
            'vehicleClass': vehicleClass.name,
          });
          if (!mounted) return;
          messenger.showSnackBar(
            SnackBar(content: Text(localizations.bookingCreated)),
          );
          if (!mounted) return;
          router.go('/payment');
        },
        onStepCancel: () {
          if (currentStep > 0) {
            setState(() => currentStep -= 1);
          }
        },
        controlsBuilder: (context, details) {
          return Padding(
            padding: const EdgeInsets.only(top: 16),
            child: PrimaryButton(
              label: currentStep == 4
                  ? localizations.confirmRequest
                  : localizations.continueLabel,
              onPressed: details.onStepContinue,
            ),
          );
        },
        steps: [
          // ── Step 1: Trip type ─────────────────────────────────────────────
          Step(
            title: Text(localizations.tripType),
            content: Column(
              children: [
                _SelectTile(
                  label: localizations.tripAirportPickup,
                  selected: tripType == TripType.airportPickup,
                  onTap: () => setState(() => tripType = TripType.airportPickup),
                ),
                _SelectTile(
                  label: localizations.tripAirportDrop,
                  selected: tripType == TripType.airportDrop,
                  onTap: () => setState(() => tripType = TripType.airportDrop),
                ),
                _SelectTile(
                  label: localizations.tripBusiness,
                  selected: tripType == TripType.business,
                  onTap: () => setState(() => tripType = TripType.business),
                ),
              ],
            ),
          ),

          // ── Step 2: Pickup / Dropoff ──────────────────────────────────────
          Step(
            title: Text(localizations.pickup),
            content: Column(
              children: [
                TextField(
                  decoration:
                      const InputDecoration(hintText: 'Pickup location'),
                  onChanged: (v) => pickup = v,
                ),
                const SizedBox(height: 12),
                TextField(
                  decoration:
                      const InputDecoration(hintText: 'Drop‑off location'),
                  onChanged: (v) => dropoff = v,
                ),
              ],
            ),
          ),

          // ── Step 3: Date & Time (pickers) ─────────────────────────────────
          Step(
            title: Text(localizations.date),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Date picker tile
                Text(localizations.date,
                    style: Theme.of(context).textTheme.labelLarge),
                const SizedBox(height: 6),
                InkWell(
                  onTap: _pickDate,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Theme.of(context).colorScheme.outline),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today_outlined),
                        const SizedBox(width: 12),
                        Text(
                          _pickedDate != null
                              ? dateFmt.format(_pickedDate!)
                              : localizations.noDateSelected,
                          style: _pickedDate == null
                              ? Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(color: Colors.grey)
                              : null,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Time picker tile
                Text(localizations.time,
                    style: Theme.of(context).textTheme.labelLarge),
                const SizedBox(height: 6),
                InkWell(
                  onTap: _pickedDate != null ? _pickTime : null,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: _pickedDate != null
                            ? Theme.of(context).colorScheme.outline
                            : Colors.grey.shade300,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.access_time_outlined,
                          color: _pickedDate == null ? Colors.grey : null,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          _pickedTime != null
                              ? _pickedTime!.format(context)
                              : localizations.noTimeSelected,
                          style: _pickedTime == null
                              ? Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(color: Colors.grey)
                              : null,
                        ),
                      ],
                    ),
                  ),
                ),
                if (_pickedDate == null)
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      'Select a date first',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: Colors.grey),
                    ),
                  ),
              ],
            ),
          ),

          // ── Step 4: Vehicle class ─────────────────────────────────────────
          Step(
            title: Text(localizations.vehicleClass),
            content: Column(
              children: [
                _SelectTile(
                  label: localizations.vehicleSedan,
                  selected: vehicleClass == VehicleClass.sedan,
                  onTap: () => setState(() => vehicleClass = VehicleClass.sedan),
                ),
                _SelectTile(
                  label: localizations.vehicleSUV,
                  selected: vehicleClass == VehicleClass.suv,
                  onTap: () => setState(() => vehicleClass = VehicleClass.suv),
                ),
                _SelectTile(
                  label: localizations.vehicleLuxury,
                  selected: vehicleClass == VehicleClass.luxury,
                  onTap: () =>
                      setState(() => vehicleClass = VehicleClass.luxury),
                ),
                _SelectTile(
                  label: localizations.vehicleVan,
                  selected: vehicleClass == VehicleClass.van,
                  onTap: () => setState(() => vehicleClass = VehicleClass.van),
                ),
              ],
            ),
          ),

          // ── Step 5: Summary ───────────────────────────────────────────────
          Step(
            title: Text(localizations.summary),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(localizations.estimatedPrice),
                const SizedBox(height: 8),
                priceAsync.when(
                  data: (price) => Text(
                    'AED ${price.toStringAsFixed(0)}',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  loading: () =>
                      const Text('—', semanticsLabel: 'Loading'),
                  error: (e, _) =>
                      Text('${localizations.errorLabel}: $e'),
                ),
                const SizedBox(height: 8),
                Text(localizations.surchargeNote),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SelectTile extends StatelessWidget {
  const _SelectTile({required this.label, this.selected = false, this.onTap});

  final String label;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(label),
        trailing: Icon(selected ? Icons.check_circle : Icons.circle_outlined),
        onTap: onTap,
      ),
    );
  }
}
