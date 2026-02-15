import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:dropzone_app/presentation/widgets/primary_button.dart';
import 'package:dropzone_app/l10n/app_localizations.dart';
import 'package:dropzone_app/presentation/bookings/booking_providers.dart';
import 'package:dropzone_app/domain/entities/booking.dart';

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
  DateTime? dateTime;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final priceAsync = ref.watch(priceEstimateProvider(vehicleClass));

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
          final booking = Booking(
            id: 'TEMP',
            tripType: tripType,
            pickup: pickup.isEmpty ? localizations.pickup : pickup,
            dropoff: dropoff.isEmpty ? localizations.dropoff : dropoff,
            dateTime: dateTime ?? DateTime.now().add(const Duration(hours: 4)),
            vehicleClass: vehicleClass,
            status: BookingStatus.requested,
            price: priceAsync.value ?? 250,
          );
          final messenger = ScaffoldMessenger.of(context);
          final router = GoRouter.of(context);
          await repository.createBooking(booking);
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
          Step(
            title: Text(localizations.pickup),
            content: Column(
              children: [
                TextField(
                  decoration: const InputDecoration(hintText: 'Pickup location'),
                  onChanged: (value) => pickup = value,
                ),
                const SizedBox(height: 12),
                TextField(
                  decoration: const InputDecoration(hintText: 'Drop‑off location'),
                  onChanged: (value) => dropoff = value,
                ),
              ],
            ),
          ),
          Step(
            title: Text(localizations.date),
            content: Column(
              children: [
                TextField(
                  decoration: const InputDecoration(hintText: 'Select date'),
                  onChanged: (_) => dateTime = DateTime.now().add(const Duration(days: 2)),
                ),
                const SizedBox(height: 12),
                TextField(
                  decoration: const InputDecoration(hintText: 'Select time'),
                  onChanged: (_) => dateTime = DateTime.now().add(const Duration(hours: 6)),
                ),
              ],
            ),
          ),
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
                  onTap: () => setState(() => vehicleClass = VehicleClass.luxury),
                ),
                _SelectTile(
                  label: localizations.vehicleVan,
                  selected: vehicleClass == VehicleClass.van,
                  onTap: () => setState(() => vehicleClass = VehicleClass.van),
                ),
              ],
            ),
          ),
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
                  loading: () => const Text('—'),
                  error: (error, _) => Text('${localizations.errorLabel}: $error'),
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
