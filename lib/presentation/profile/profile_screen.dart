import 'package:flutter/material.dart';
import 'package:dropzone_app/presentation/widgets/primary_button.dart';
import 'package:dropzone_app/l10n/app_localizations.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(localizations.profileTitle)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(localizations.profileDetails,
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          const TextField(decoration: InputDecoration(hintText: 'Full name')),
          const SizedBox(height: 12),
          const TextField(decoration: InputDecoration(hintText: '+971 5X XXX XXXX')),
          const SizedBox(height: 12),
          const TextField(decoration: InputDecoration(hintText: 'email@example.com')),
          const SizedBox(height: 24),
          Text(localizations.savedPassengers,
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          _PassengerTile(name: localizations.passengerSelf),
          _PassengerTile(name: localizations.passengerAssistant),
          _PassengerTile(name: localizations.passengerExecutive),
          const SizedBox(height: 24),
          Text(localizations.corporateMode,
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          SwitchListTile(
            value: false,
            onChanged: (_) {},
            title: Text(localizations.businessAccountToggle),
            subtitle: Text(localizations.corporateSubtitle),
          ),
          const SizedBox(height: 12),
          const TextField(decoration: InputDecoration(hintText: 'Company name')),
          const SizedBox(height: 12),
          const TextField(decoration: InputDecoration(hintText: 'Cost center')),
          const SizedBox(height: 12),
          const TextField(decoration: InputDecoration(hintText: 'Notes for driver')),
          const SizedBox(height: 20),
          PrimaryButton(label: localizations.saveProfile, onPressed: () {}),
        ],
      ),
    );
  }
}

class _PassengerTile extends StatelessWidget {
  const _PassengerTile({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(name),
        trailing: const Icon(Icons.edit),
      ),
    );
  }
}
