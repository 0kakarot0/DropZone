import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:dropzone_app/presentation/widgets/primary_button.dart';
import 'package:dropzone_app/presentation/widgets/result_popup.dart';
import 'package:dropzone_app/l10n/app_localizations.dart';
import 'package:dropzone_app/core/di/preferences_providers.dart';
import 'package:dropzone_app/domain/entities/user_preferences.dart';
import 'package:dropzone_app/domain/entities/user_profile.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _displayNameCtrl = TextEditingController();
  // ── Preferences fields ──────────────────────────────────────────────────
  final _prefPickupCtrl = TextEditingController();
  final _prefDropoffCtrl = TextEditingController();
  int _prefPassengers = 1;
  bool _corporateMode = false;
  bool _savingProfile = false;
  bool _prefsLoaded = false;
  bool _profileLoaded = false;

  @override
  void dispose() {
    _displayNameCtrl.dispose();
    _prefPickupCtrl.dispose();
    _prefDropoffCtrl.dispose();
    super.dispose();
  }

  void _loadProfile(UserProfile profile) {
    if (_profileLoaded) return;
    _profileLoaded = true;
    _displayNameCtrl.text = profile.displayName ?? '';
    _corporateMode = profile.corporateMode;
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
    final localizations = AppLocalizations.of(context);
    final prefs = UserPreferences(
      defaultPickup: _prefPickupCtrl.text.trim().isEmpty ? null : _prefPickupCtrl.text.trim(),
      defaultDropoff: _prefDropoffCtrl.text.trim().isEmpty ? null : _prefDropoffCtrl.text.trim(),
      defaultPassengers: _prefPassengers,
    );
    try {
      await ref.read(userPreferencesProvider.notifier).updatePreferences(prefs);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(localizations.preferencesSaved)),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(localizations.preferencesSaveError(e.toString())),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  Future<void> _saveProfile() async {
    final localizations = AppLocalizations.of(context);
    final current = ref.read(userProfileProvider).valueOrNull;
    if (current == null) return;

    setState(() => _savingProfile = true);
    try {
      await ref.read(userProfileProvider.notifier).updateProfile(
            current.copyWith(
              displayName: _displayNameCtrl.text.trim().isEmpty
                  ? null
                  : _displayNameCtrl.text.trim(),
              corporateMode: _corporateMode,
            ),
          );
      if (!mounted) return;
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
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(localizations.profileSaveError(e.toString())),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    } finally {
      if (mounted) setState(() => _savingProfile = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final profileAsync = ref.watch(userProfileProvider);
    final prefsAsync = ref.watch(userPreferencesProvider);
    final profile = profileAsync.valueOrNull;
    final email = profile?.email ?? '—';

    // Pre-fill controllers when data arrives.
    profileAsync.whenData(_loadProfile);
    prefsAsync.whenData(_loadPrefs);

    return Scaffold(
      appBar: AppBar(title: Text(localizations.profileTitle)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(localizations.profileDetails,
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          TextField(
            controller: _displayNameCtrl,
            decoration: InputDecoration(
              labelText: localizations.fullNameLabel,
              prefixIcon: const Icon(Icons.person_outline),
            ),
          ),
          const SizedBox(height: 12),
          InputDecorator(
            decoration: InputDecoration(
              labelText: localizations.emailLabel,
              prefixIcon: const Icon(Icons.email_outlined),
            ),
            child: Text(email),
          ),
          if (profileAsync.hasError) ...[
            const SizedBox(height: 12),
            Text(
              localizations.profileLoadError(profileAsync.error.toString()),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
            ),
          ],
          const SizedBox(height: 24),

          // ── Booking Preferences ──────────────────────────────────────────
          Text(localizations.bookingPreferencesTitle,
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(
            localizations.bookingPreferencesSubtitle,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _prefPickupCtrl,
            decoration: InputDecoration(
              hintText: localizations.defaultPickupHint,
              prefixIcon: Icon(Icons.my_location),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _prefDropoffCtrl,
            decoration: InputDecoration(
              hintText: localizations.defaultDropoffHint,
              prefixIcon: Icon(Icons.location_on),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(localizations.defaultPassengersLabel,
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
            label: localizations.savePreferences,
            onPressed: _savePreferences,
          ),
          const SizedBox(height: 24),

          Text(localizations.corporateMode,
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          SwitchListTile(
            value: _corporateMode,
            onChanged: (value) => setState(() => _corporateMode = value),
            title: Text(localizations.businessAccountToggle),
            subtitle: Text(localizations.corporateSubtitle),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              localizations.profileFieldsManagedNotice,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          const SizedBox(height: 20),
          if (_savingProfile)
            const Center(child: CircularProgressIndicator())
          else
            PrimaryButton(
              label: localizations.saveProfile,
              onPressed: profile == null ? null : _saveProfile,
            ),
        ],
      ),
    );
  }
}
