import 'package:flutter/material.dart';
import 'package:dropzone_app/presentation/widgets/primary_button.dart';
import 'package:dropzone_app/l10n/app_localizations.dart';

class TripTrackingScreen extends StatelessWidget {
  const TripTrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(localizations.tripTrackingTitle)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: Colors.blueGrey.shade100,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Text(localizations.mapPlaceholder),
            ),
          ),
          const SizedBox(height: 20),
          Card(
            child: ListTile(
              title: Text(localizations.driverAssignedTitle),
              subtitle: Text(localizations.driverAssignedSubtitle),
              trailing: const Icon(Icons.directions_car),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              title: Text(localizations.etaLabel),
              subtitle: Text(localizations.etaValue('12 min')),
            ),
          ),
          const SizedBox(height: 20),
          PrimaryButton(
            label: localizations.contactDriver,
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(localizations.contactDriverHint)),
              );
            },
          ),
        ],
      ),
    );
  }
}
