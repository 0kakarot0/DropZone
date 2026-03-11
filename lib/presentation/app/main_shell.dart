import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:dropzone_app/l10n/app_localizations.dart';
import 'package:dropzone_app/presentation/booking_flow/booking_draft_provider.dart';

class MainShell extends ConsumerWidget {
  const MainShell({super.key, required this.child});

  final Widget child;

  int _locationToIndex(String location) {
    if (location.startsWith('/bookings')) return 1;
    return 0;
  }

  String _title(String location, AppLocalizations l) {
    if (location.startsWith('/bookings')) return l.navBookings;
    return l.appTitle;
  }

  /// Intercepts nav when user has unsaved booking progress.
  /// Returns true if navigation should proceed.
  Future<bool> _guardNav(BuildContext context, WidgetRef ref) async {
    final location = GoRouterState.of(context).uri.toString();
    if (location != '/book') return true; // not in booking flow

    final draft = ref.read(bookingDraftProvider);
    if (!draft.hasProgress) return true; // nothing entered yet

    final result = await showModalBottomSheet<bool>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const Icon(Icons.edit_note_rounded, size: 40),
            const SizedBox(height: 12),
            Text(
              'Leave booking?',
              style: Theme.of(ctx).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'You have unsaved booking details. Your progress will be saved '
              'as a draft so you can continue later.',
              textAlign: TextAlign.center,
              style: Theme.of(ctx).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(ctx).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 24),
            // Continue Booking
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: const Text('Continue Booking'),
              ),
            ),
            const SizedBox(height: 10),
            // Leave (draft is kept automatically)
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Navigator.of(ctx).pop(true),
                child: const Text('Leave'),
              ),
            ),
          ],
        ),
      ),
    );

    return result == true;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final location = GoRouterState.of(context).uri.toString();
    final currentIndex = _locationToIndex(location);
    final localizations = AppLocalizations.of(context);
    final user = FirebaseAuth.instance.currentUser;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      // ── AppBar with hamburger ─────────────────────────────────────────────
      appBar: AppBar(
        title: Text(_title(location, localizations)),
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: const Icon(Icons.menu),
            tooltip: 'Menu',
            onPressed: () => Scaffold.of(ctx).openDrawer(),
          ),
        ),
      ),

      // ── Hamburger drawer ──────────────────────────────────────────────────
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.fromLTRB(20, 28, 20, 24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [colorScheme.primary, colorScheme.primaryContainer],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: colorScheme.onPrimary.withOpacity(0.2),
                      child: Icon(Icons.person,
                          size: 34, color: colorScheme.onPrimary),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      user?.displayName ?? user?.email ?? 'Guest',
                      style: TextStyle(
                        color: colorScheme.onPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (user?.email != null)
                      Text(
                        user!.email!,
                        style: TextStyle(
                          color: colorScheme.onPrimary.withOpacity(0.8),
                          fontSize: 13,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 8),

              // Profile
              ListTile(
                leading: const Icon(Icons.person_outline),
                title: Text(localizations.navProfile),
                onTap: () async {
                  if (!await _guardNav(context, ref)) return;
                  if (!context.mounted) return;
                  Navigator.pop(context);
                  context.go('/profile');
                },
              ),

              // Support
              ListTile(
                leading: const Icon(Icons.support_agent_outlined),
                title: Text(localizations.navSupport),
                onTap: () async {
                  if (!await _guardNav(context, ref)) return;
                  if (!context.mounted) return;
                  Navigator.pop(context);
                  context.go('/support');
                },
              ),

              const Divider(indent: 16, endIndent: 16),

              // Sign out
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.redAccent),
                title: const Text('Sign Out',
                    style: TextStyle(color: Colors.redAccent)),
                onTap: () async {
                  Navigator.pop(context);
                  await FirebaseAuth.instance.signOut();
                },
              ),

              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'DropZone Chauffeur',
                  style: TextStyle(
                      color: colorScheme.onSurfaceVariant, fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),

      body: child,

      // ── Bottom nav: Home + Bookings only ─────────────────────────────────
      bottomNavigationBar: NavigationBar(
        backgroundColor: Colors.white,
        selectedIndex: currentIndex,
        onDestinationSelected: (index) async {
          if (!await _guardNav(context, ref)) return;
          if (!context.mounted) return;
          switch (index) {
            case 0:
              context.go('/');
            case 1:
              context.go('/bookings');
          }
        },
        destinations: <NavigationDestination>[
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home),
            label: localizations.navHome,
          ),
          NavigationDestination(
            icon: const Icon(Icons.event_note_outlined),
            selectedIcon: const Icon(Icons.event_note),
            label: localizations.navBookings,
          ),
        ],
      ),
    );
  }
}
