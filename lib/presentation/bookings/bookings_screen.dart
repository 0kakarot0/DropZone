import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart' hide Card;
import 'package:intl/intl.dart';
import 'package:dropzone_app/data/services/payment_service.dart';
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
      child: Column(
        children: [
          Material(
            color: Theme.of(context).colorScheme.surface,
            child: TabBar(
              tabs: [
                Tab(text: localizations.upcoming),
                Tab(text: localizations.past),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                _BookingList(provider: upcomingBookingsProvider),
                _BookingList(provider: pastBookingsProvider),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

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
          padding: const EdgeInsets.all(16),
          itemCount: bookings.length,
          itemBuilder: (context, index) {
            final booking = bookings[index];
            return _BookingCard(booking: booking);
          },
        );
      },
      loading: () => ListView(
        padding: const EdgeInsets.all(16),
        children: const [SkeletonCard(), SkeletonCard(), SkeletonCard()],
      ),
      error: (error, _) =>
          Center(child: Text('${localizations.errorLabel}: $error')),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _BookingCard extends ConsumerStatefulWidget {
  const _BookingCard({required this.booking});
  final Booking booking;

  @override
  ConsumerState<_BookingCard> createState() => _BookingCardState();
}

class _BookingCardState extends ConsumerState<_BookingCard> {
  bool _paying = false;

  Future<void> _payNow() async {
    setState(() => _paying = true);
    try {
      final paymentSvc = ref.read(paymentServiceProvider);
      final intentResult =
          await paymentSvc.createPaymentIntent(widget.booking.id);

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          merchantDisplayName: 'DropZone Chauffeur',
          paymentIntentClientSecret: intentResult.clientSecret,
          style: Theme.of(context).brightness == Brightness.dark
              ? ThemeMode.dark
              : ThemeMode.light,
        ),
      );
      await Stripe.instance.presentPaymentSheet();

      // Confirm with backend — verifies PaymentIntent status with Stripe.
      await paymentSvc.confirmPayment(widget.booking.id);

      // Force-invalidate so Riverpod re-fetches from the server
      // and every watching widget (including this card) rebuilds.
      ref.invalidate(bookingsProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Payment successful! Booking confirmed.')),
        );
      }
    } on StripeException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(e.error.localizedMessage ?? 'Payment cancelled.')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Payment failed: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _paying = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final booking = widget.booking;
    final isPending = booking.status == BookingStatus.pendingPayment;
    final dateFmt = DateFormat('dd MMM yyyy • HH:mm');

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
              builder: (_) => BookingDetailScreen(booking: booking)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Pending payment warning banner ────────────────────────────
            if (isPending)
              Container(
                color: Colors.amber.shade700,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.warning_amber_rounded,
                            color: Colors.white, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          'Payment pending',
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge
                              ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'This booking will be automatically cancelled if '
                      'payment is not received before the scheduled ride '
                      '(${dateFmt.format(booking.dateTime.toLocal())}).',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: Colors.white),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.amber.shade800,
                        ),
                        onPressed: _paying ? null : _payNow,
                        child: _paying
                            ? const SizedBox(
                                height: 18,
                                width: 18,
                                child: CircularProgressIndicator(strokeWidth: 2))
                            : const Text('Pay Now',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),

            // ── Booking details ───────────────────────────────────────────
            ListTile(
              title: Text('#${booking.id} · ${booking.pickup} → ${booking.dropoff}'),
              subtitle: Text(dateFmt.format(booking.dateTime.toLocal())),
              trailing: _StatusChip(status: booking.status),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});
  final BookingStatus status;

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (status) {
      BookingStatus.pendingPayment => ('Pending', Colors.amber.shade700),
      BookingStatus.confirmed => ('Confirmed', Colors.green),
      BookingStatus.cancelled => ('Cancelled', Colors.red),
      BookingStatus.rescheduled => ('Rescheduled', Colors.blue),
      _ => ('Created', Colors.grey),
    };

    return Chip(
      label: Text(label,
          style: const TextStyle(color: Colors.white, fontSize: 11)),
      backgroundColor: color,
      padding: EdgeInsets.zero,
      visualDensity: VisualDensity.compact,
    );
  }
}
