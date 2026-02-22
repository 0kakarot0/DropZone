import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dropzone_app/presentation/bookings/booking_providers.dart';
import 'package:dropzone_app/presentation/bookings/booking_detail_screen.dart';
import 'package:dropzone_app/domain/entities/booking.dart';
import 'package:dropzone_app/presentation/widgets/skeleton_card.dart';
import 'package:dropzone_app/l10n/app_localizations.dart';

class BookingsScreen extends ConsumerWidget {
  const BookingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(localizations.bookingsTitle),
          bottom: TabBar(
            tabs: [
              Tab(text: localizations.upcoming),
              Tab(text: localizations.past),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _BookingList(provider: upcomingBookingsProvider),
            _BookingList(provider: pastBookingsProvider),
          ],
        ),
      ),
    );
  }
}

class _BookingList extends ConsumerWidget {
  const _BookingList({required this.provider});

  final ProviderListenable<AsyncValue<List<Booking>>> provider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context);
    final bookingsAsync = ref.watch(provider);

    return bookingsAsync.when(
      data: (bookings) {
        if (bookings.isEmpty) {
          return Center(
            child: Text(
              localizations.emptyBookings,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: bookings.length,
          itemBuilder: (context, index) {
            final booking = bookings[index];
            return Card(
              child: ListTile(
                title: Text(booking.id),
                subtitle: Text('${booking.pickup} → ${booking.dropoff}'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => BookingDetailScreen(booking: booking),
                  ),
                ),
              ),
            );
          },
        );
      },
      loading: () => ListView(
        padding: const EdgeInsets.all(20),
        children: const [
          SkeletonCard(),
          SkeletonCard(),
          SkeletonCard(),
        ],
      ),
      error: (error, _) => Center(child: Text('${localizations.errorLabel}: $error')),
    );
  }
}
