import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:dropzone_app/presentation/widgets/primary_button.dart';
import 'package:dropzone_app/presentation/widgets/result_popup.dart';
import 'package:dropzone_app/l10n/app_localizations.dart';
import 'package:dropzone_app/core/di/preferences_providers.dart';
import 'package:dropzone_app/domain/entities/user_preferences.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  // ── Preferences fields ──────────────────────────────────────────────────
  final _prefPickupCtrl = TextEditingController();
  final _prefDropoffCtrl = TextEditingController();
  int _prefPassengers = 1;
  bool _prefsLoaded = false;

  @override
  void dispose() {
    _prefPickupCtrl.dispose();
    _prefDropoffCtrl.dispose();
    super.dispose();
  }

  /// Load preferences into controllers once.
  void _loadPrefs(UserPreferences prefs) {
    if (_prefsLoaded) return;
    _prefsLoaded = true;
    _prefPickupCtrl.text = prefs.defaultPickup ?? '';
    _prefDropoffCtrl.text = prefs.defaultDropoff ?? '';
    _prefPassengers = prefs.defaultPassengers;
  }

  Future<void> _savePreferences() async {
    final prefs = UserPreferences(
      defaultPickup: _prefPickupCtrl.text.trim().isEmpty ? null : _prefPickupCtrl.text.trim(),
      defaultDropoff: _prefDropoffCtrl.text.trim().isEmpty ? null : _prefDropoffCtrl.text.trim(),
      defaultPassengers: _prefPassengers,
    );
    try {
      await ref.read(userPreferencesProvider.notifier).updatePreferences(prefs);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preferences saved!')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not save preferences: $e'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final prefsAsync = ref.watch(userPreferencesProvider);

    // Pre-fill controllers when data arrives.
    prefsAsync.whenData(_loadPrefs);

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

          // ── Booking Preferences ──────────────────────────────────────────
          Text('Booking Preferences',
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(
            'Set defaults that pre-fill your booking form.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _prefPickupCtrl,
            decoration: const InputDecoration(
              hintText: 'Default pickup location',
              prefixIcon: Icon(Icons.my_location),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _prefDropoffCtrl,
            decoration: const InputDecoration(
              hintText: 'Default drop-off location',
              prefixIcon: Icon(Icons.location_on),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text('Default passengers: ',
                  style: Theme.of(context).textTheme.bodyMedium),
              IconButton(
                onPressed: _prefPassengers > 1
                    ? () => setState(() => _prefPassengers--)
                    : null,
                icon: const Icon(Icons.remove_circle_outline),
              ),
              Text('$_prefPassengers',
                  style: Theme.of(context).textTheme.titleMedium),
              IconButton(
                onPressed: _prefPassengers < 10
                    ? () => setState(() => _prefPassengers++)
                    : null,
                icon: const Icon(Icons.add_circle_outline),
              ),
            ],
          ),
          const SizedBox(height: 12),
          PrimaryButton(
            label: 'Save Preferences',
            onPressed: _savePreferences,
          ),
          const SizedBox(height: 24),

          // ── Existing sections ────────────────────────────────────────────
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
          PrimaryButton(
            label: localizations.saveProfile,
            onPressed: () async {
              final router = GoRouter.of(context);
              await showDialog<void>(
                context: context,
                barrierDismissible: false,
                builder: (dialogCtx) => ResultPopup(
                  title: localizations.profileSavedTitle,
                  message: localizations.profileSavedMessage,
                  type: ResultType.success,
                  buttonLabel: localizations.goHome,
                  onAction: () {
                    Navigator.of(dialogCtx).pop();
                    router.go('/');
                  },
                ),
              );
            },
          ),
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
