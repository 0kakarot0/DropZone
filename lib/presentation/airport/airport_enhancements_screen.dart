import 'package:flutter/material.dart';
import 'package:dropzone_app/l10n/app_localizations.dart';
import 'package:dropzone_app/presentation/widgets/primary_button.dart';

class AirportEnhancementsScreen extends StatelessWidget {
  const AirportEnhancementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(localizations.airportEnhancementsTitle)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(localizations.flightTrackingTitle,
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          const TextField(
            decoration: InputDecoration(hintText: 'EK 202'),
          ),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              title: Text(localizations.flightStatusLabel),
              subtitle: Text(localizations.flightStatusValue),
              trailing: const Icon(Icons.flight_takeoff),
            ),
          ),
          const SizedBox(height: 20),
          Text(localizations.meetGreetTitle,
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          Text(localizations.meetGreetBody),
          const SizedBox(height: 20),
          PrimaryButton(label: localizations.saveFlightInfo, onPressed: () {}),
        ],
      ),
    );
  }
}
