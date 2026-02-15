import 'package:flutter/material.dart';
import 'package:dropzone_app/domain/entities/payment.dart';
import 'package:dropzone_app/l10n/app_localizations.dart';

class ReceiptScreen extends StatelessWidget {
  const ReceiptScreen({super.key, required this.receipt});

  final PaymentReceipt receipt;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(localizations.receiptTitle)),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Card(
          child: ListTile(
            title: Text('${receipt.currency} ${receipt.amount.toStringAsFixed(0)}'),
            subtitle: Text(localizations.receiptId(receipt.id)),
            trailing: const Icon(Icons.file_download),
          ),
        ),
      ),
    );
  }
}
