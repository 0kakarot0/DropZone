import 'package:flutter/material.dart';
import 'package:dropzone_app/presentation/widgets/primary_button.dart';
import 'package:dropzone_app/l10n/app_localizations.dart';

class BookingFlowScreen extends StatefulWidget {
  const BookingFlowScreen({super.key});

  @override
  State<BookingFlowScreen> createState() => _BookingFlowScreenState();
}

class _BookingFlowScreenState extends State<BookingFlowScreen> {
  int currentStep = 0;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.bookingTitle),
      ),
      body: Stepper(
        type: StepperType.vertical,
        currentStep: currentStep,
        onStepContinue: () {
          if (currentStep < 4) {
            setState(() => currentStep += 1);
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
                _SelectTile(label: localizations.tripAirportPickup),
                _SelectTile(label: localizations.tripAirportDrop),
                _SelectTile(label: localizations.tripBusiness),
              ],
            ),
          ),
          Step(
            title: Text(localizations.pickup),
            content: Column(
              children: const [
                TextField(decoration: InputDecoration(hintText: 'Pickup location')),
                SizedBox(height: 12),
                TextField(decoration: InputDecoration(hintText: 'Drop‑off location')),
              ],
            ),
          ),
          Step(
            title: Text(localizations.date),
            content: Column(
              children: const [
                TextField(decoration: InputDecoration(hintText: 'Select date')),
                SizedBox(height: 12),
                TextField(decoration: InputDecoration(hintText: 'Select time')),
              ],
            ),
          ),
          Step(
            title: Text(localizations.vehicleClass),
            content: Column(
              children: [
                _SelectTile(label: localizations.vehicleSedan),
                _SelectTile(label: localizations.vehicleSUV),
                _SelectTile(label: localizations.vehicleLuxury),
                _SelectTile(label: localizations.vehicleVan),
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
                Text(
                  localizations.pricePlaceholder,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SelectTile extends StatelessWidget {
  const _SelectTile({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(label),
        trailing: const Icon(Icons.circle_outlined),
      ),
    );
  }
}
