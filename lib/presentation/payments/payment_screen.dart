import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dropzone_app/presentation/payments/payment_providers.dart';
import 'package:dropzone_app/presentation/widgets/primary_button.dart';
import 'package:dropzone_app/l10n/app_localizations.dart';
import 'package:dropzone_app/core/di/providers.dart';

class PaymentScreen extends ConsumerWidget {
  const PaymentScreen({super.key, this.amount = 320});

  final double amount;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context);
    final cardsAsync = ref.watch(savedCardsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(localizations.paymentTitle)),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(localizations.chooseCard, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            cardsAsync.when(
              data: (cards) => Column(
                children: cards
                    .map(
                      (card) => Card(
                        child: ListTile(
                          leading: const Icon(Icons.credit_card),
                          title: Text('${card.brand} •••• ${card.last4}'),
                          subtitle: Text(localizations.expires(card.expiry)),
                          trailing: const Icon(Icons.check_circle, color: Colors.green),
                        ),
                      ),
                    )
                    .toList(),
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Text('${localizations.errorLabel}: $error'),
            ),
            const SizedBox(height: 16),
            Text(localizations.amountDue(amount.toStringAsFixed(0))),
            const Spacer(),
            PrimaryButton(
              label: localizations.payNow,
              onPressed: () async {
                final analytics = ref.read(analyticsProvider);
                final receipt = await ref.read(payWithCardProvider(amount).future);
                await analytics.trackEvent('payment_success', params: {
                  'amount': amount,
                  'currency': 'AED',
                });
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(localizations.paymentSuccess(receipt.id))),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
