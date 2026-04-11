import 'package:dropzone_driver_app/core/di/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(driverProfileProvider);
    final authController = ref.read(authSessionProvider.notifier);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: profileAsync.when(
        data: (profile) => ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          children: [
            // ── Avatar + name ──
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor:
                        theme.colorScheme.primary.withValues(alpha: 0.1),
                    child: Text(
                      profile.displayName.isNotEmpty
                          ? profile.displayName[0].toUpperCase()
                          : 'D',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    profile.displayName,
                    style: theme.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${profile.vehicleType} • ${profile.vehiclePlate}',
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ── Info card ──
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _ProfileRow(
                      icon: Icons.email_outlined,
                      label: 'Email',
                      value: profile.email,
                    ),
                    _ProfileRow(
                      icon: Icons.phone_outlined,
                      label: 'Phone',
                      value: profile.phone,
                    ),
                    _ProfileRow(
                      icon: Icons.circle,
                      iconSize: 12,
                      iconColor: _statusColor(profile.status),
                      label: 'Status',
                      value: profile.status,
                    ),
                    _ProfileRow(
                      icon: Icons.star_rounded,
                      iconColor: const Color(0xFFC89B3C),
                      label: 'Rating',
                      value:
                          profile.rating?.toStringAsFixed(1) ?? 'Not yet rated',
                      isLast: true,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // ── Sign out ──
            FilledButton.icon(
              onPressed: authController.signOut,
              icon: const Icon(Icons.logout),
              label: const Text('Sign out'),
              style: FilledButton.styleFrom(
                backgroundColor: theme.colorScheme.error,
                foregroundColor: theme.colorScheme.onError,
              ),
            ),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, size: 48),
                const SizedBox(height: 12),
                Text(error.toString()),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: () => ref.invalidate(driverProfileProvider),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _statusColor(String status) {
    return switch (status) {
      'AVAILABLE' => const Color(0xFF2D8B4E),
      'BUSY' => const Color(0xFFF59E0B),
      'OFFLINE' => const Color(0xFF64748B),
      _ => const Color(0xFF64748B),
    };
  }
}

class _ProfileRow extends StatelessWidget {
  const _ProfileRow({
    required this.icon,
    required this.label,
    required this.value,
    this.iconSize = 18,
    this.iconColor,
    this.isLast = false,
  });

  final IconData icon;
  final String label;
  final String value;
  final double iconSize;
  final Color? iconColor;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              Icon(
                icon,
                size: iconSize,
                color: iconColor ?? theme.textTheme.bodyMedium?.color,
              ),
              const SizedBox(width: 12),
              SizedBox(
                width: 72,
                child: Text(
                  label,
                  style: theme.textTheme.bodyMedium,
                ),
              ),
              Expanded(
                child: Text(
                  value,
                  style: theme.textTheme.bodyLarge,
                ),
              ),
            ],
          ),
        ),
        if (!isLast)
          Divider(height: 1, color: theme.dividerColor),
      ],
    );
  }
}
