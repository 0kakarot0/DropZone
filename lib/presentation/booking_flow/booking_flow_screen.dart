import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart' hide Card;
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:dropzone_app/data/services/payment_service.dart';
import 'package:dropzone_app/presentation/booking_flow/booking_draft_provider.dart';
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
  int passengers = 1;
  String notes = '';

  DateTime? _pickedDate;
  TimeOfDay? _pickedTime;

  // The price estimate is stored as plain widget state.
  AsyncValue<PriceEstimate> _priceEstimate = const AsyncValue.loading();
  bool _estimateFetched = false;

  @override
  void initState() {
    super.initState();
    // Restore any previously saved draft so the user doesn't lose progress.
    final draft = ref.read(bookingDraftProvider);
    if (draft.hasProgress) {
      currentStep = draft.currentStep;
      tripType = draft.tripType;
      vehicleClass = draft.vehicleClass;
      pickup = draft.pickup;
      dropoff = draft.dropoff;
      passengers = draft.passengers;
      notes = draft.notes;
      _pickedDate = draft.pickedDate;
      _pickedTime = draft.pickedTime;
    }
  }

  /// Persists the current field values to the draft provider.
  void _saveDraft() {
    ref.read(bookingDraftProvider.notifier).update((_) => BookingDraft(
          currentStep: currentStep,
          tripType: tripType,
          vehicleClass: vehicleClass,
          pickup: pickup,
          dropoff: dropoff,
          passengers: passengers,
          notes: notes,
          pickedDate: _pickedDate,
          pickedTime: _pickedTime,
        ));
  }

  DateTime get _resolvedDateTime {
    if (_pickedDate == null) {
      // Use a fixed time (4 h from init) so the value never drifts between
      // builds. Calling DateTime.now() in build() created ever-changing
      // provider keys that bypassed Riverpod's cache on every rebuild.
      return _defaultPickupTime;
    }
    final t = _pickedTime ?? TimeOfDay.now();
    return DateTime(
        _pickedDate!.year, _pickedDate!.month, _pickedDate!.day, t.hour, t.minute);
  }

  // Computed once when the State object is created.
  late final DateTime _defaultPickupTime =
      DateTime.now().add(const Duration(hours: 4));

  /// Calls the estimate API exactly once when the summary step is shown.
  /// Subsequent rebuilds have no effect because [_estimateFetched] is guarded.
  Future<void> _fetchEstimateOnce() async {
    if (_estimateFetched) return;
    _estimateFetched = true;

    // Show loading immediately.
    setState(() => _priceEstimate = const AsyncValue.loading());

    try {
      final repo = ref.read(bookingRepositoryProvider);
      final result = await repo.estimatePrice(
        serviceType: tripType,
        pickupTime: _resolvedDateTime,
        passengers: passengers,
      );
      if (mounted) setState(() => _priceEstimate = AsyncValue.data(result));
    } catch (e, st) {
      if (mounted) setState(() => _priceEstimate = AsyncValue.error(e, st));
    }
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
    if (picked != null) {
      setState(() => _pickedDate = picked);
      _saveDraft();
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _pickedTime ?? TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() => _pickedTime = picked);
      _saveDraft();
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    // _priceEstimate is plain widget state — never watched via a provider.
    // No provider rebuild can trigger an API call.
    final priceAsync = _priceEstimate;
    final dateFmt = DateFormat('dd MMM yyyy');

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.bookingTitle),
      ),
      body: Stepper(
        type: StepperType.vertical,
        currentStep: currentStep,
        onStepContinue: () async {
          if (currentStep < 5) {
            final nextStep = currentStep + 1;
            setState(() => currentStep = nextStep);
            _saveDraft();
            // Trigger ONE estimate fetch when entering the summary step (index 5).
            if (nextStep == 5) _fetchEstimateOnce();
            return;
          }

          // Don't allow confirming while estimate is still loading or failed.
          final messenger = ScaffoldMessenger.of(context);
          if (_priceEstimate.isLoading) {
            messenger.showSnackBar(
              const SnackBar(content: Text('Price estimate is still loading, please wait…')),
            );
            return;
          }
          if (_priceEstimate.hasError) {
            // Let user retry the estimate before confirming.
            setState(() => _estimateFetched = false);
            _fetchEstimateOnce();
            messenger.showSnackBar(
              const SnackBar(content: Text('Could not load price estimate — retrying…')),
            );
            return;
          }

          try {
            final repository = ref.read(bookingRepositoryProvider);
            final analytics = ref.read(analyticsProvider);
            final paymentSvc = ref.read(paymentServiceProvider);

            final booking = Booking(
              id: -1,
              tripType: tripType,
              pickup: pickup.isEmpty ? localizations.pickup : pickup,
              dropoff: dropoff.isEmpty ? localizations.dropoff : dropoff,
              dateTime: _resolvedDateTime,
              vehicleClass: vehicleClass,
              status: BookingStatus.created,
              passengers: passengers,
              notes: notes.isNotEmpty ? notes : null,
              priceEstimateCents: _priceEstimate.value?.totalCents,
              currency: _priceEstimate.value?.currency ?? 'AED',
            );

            // 1. Create the booking.
            final createdBooking = await repository.createBooking(booking);
            await analytics.trackEvent('booking_created', params: {
              'tripType': tripType.name,
              'vehicleClass': vehicleClass.name,
            });
            if (!mounted) return;

            // 2. Fetch a Stripe PaymentIntent for the new booking.
            final intentResult =
                await paymentSvc.createPaymentIntent(createdBooking.id);
            if (!mounted) return;

            // 3. Initialise the Stripe PaymentSheet.
            await Stripe.instance.initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
                merchantDisplayName: 'DropZone Chauffeur',
                paymentIntentClientSecret: intentResult.clientSecret,
                style: Theme.of(context).brightness == Brightness.dark
                    ? ThemeMode.dark
                    : ThemeMode.light,
              ),
            );
            if (!mounted) return;

            // 4. Present the PaymentSheet — blocks until user completes / cancels.
            await Stripe.instance.presentPaymentSheet();
            if (!mounted) return;

            // 5. Confirm with backend (verifies with Stripe; webhook is secondary safety net).
            await paymentSvc.confirmPayment(createdBooking.id);
            if (!mounted) return;

            // 6. Invalidate so the bookings screen fetches fresh data showing CONFIRMED.
            ref.invalidate(bookingsProvider);

            // 7. Clear the draft — booking flow completed successfully.
            ref.read(bookingDraftProvider.notifier).clear();

            // 8. Success — navigate to bookings list.
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(localizations.bookingCreated)),
            );
            if (!mounted) return;
            GoRouter.of(context).go('/bookings');
          } on StripeException catch (e) {
            if (!mounted) return;
            final msg = e.error.localizedMessage ?? 'Payment cancelled.';
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(msg)),
            );
          } catch (e) {
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Unable to complete booking: $e'),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
          }
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
              label: currentStep == 5
                  ? localizations.confirmRequest
                  : localizations.continueLabel,
              onPressed: details.onStepContinue,
            ),
          );
        },
        steps: [
          // ── Step 1: Trip type ──────────────────────────────────────────────
          Step(
            title: Text(localizations.tripType),
            content: Column(
              children: [
                _SelectTile(
                  label: localizations.tripAirportPickup,
                  selected: tripType == TripType.airportPickup,
                  onTap: () {
                    setState(() => tripType = TripType.airportPickup);
                    _saveDraft();
                  },
                ),
                _SelectTile(
                  label: localizations.tripAirportDrop,
                  selected: tripType == TripType.airportDrop,
                  onTap: () {
                    setState(() => tripType = TripType.airportDrop);
                    _saveDraft();
                  },
                ),
                _SelectTile(
                  label: localizations.tripBusiness,
                  selected: tripType == TripType.business,
                  onTap: () {
                    setState(() => tripType = TripType.business);
                    _saveDraft();
                  },
                ),
              ],
            ),
          ),

          // ── Step 2: Pickup / Dropoff ───────────────────────────────────────
          Step(
            title: Text(localizations.pickup),
            content: Column(
              children: [
                TextField(
                  decoration:
                      const InputDecoration(hintText: 'Pickup location'),
                  controller: TextEditingController(text: pickup),
                  onChanged: (v) => pickup = v,
                ),
                const SizedBox(height: 12),
                TextField(
                  decoration:
                      const InputDecoration(hintText: 'Drop‑off location'),
                  controller: TextEditingController(text: dropoff),
                  onChanged: (v) => dropoff = v,
                ),
              ],
            ),
          ),

          // ── Step 3: Date & Time ────────────────────────────────────────────
          Step(
            title: Text(localizations.date),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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

          // ── Step 4: Passengers ─────────────────────────────────────────────
          Step(
            title: Text(localizations.passengers),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  localizations.passengers,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    IconButton(
                      onPressed: passengers > 1
                          ? () => setState(() => passengers--)
                          : null,
                      icon: const Icon(Icons.remove_circle_outline),
                    ),
                    Text(
                      '$passengers',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    IconButton(
                      onPressed: passengers < 10
                          ? () => setState(() => passengers++)
                          : null,
                      icon: const Icon(Icons.add_circle_outline),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextField(
                  maxLines: 3,
                  decoration: const InputDecoration(
                    hintText: 'Notes for driver (optional)',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (v) => notes = v,
                ),
              ],
            ),
          ),

          // ── Step 5: Vehicle class ──────────────────────────────────────────
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

          // ── Step 6: Summary ────────────────────────────────────────────────
          Step(
            title: Text(localizations.summary),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(localizations.estimatedPrice),
                const SizedBox(height: 8),
                priceAsync.when(
                  data: (estimate) => Text(
                    '${estimate.currency} ${estimate.totalAed.toStringAsFixed(0)}',
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
