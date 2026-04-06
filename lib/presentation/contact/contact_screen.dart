import 'package:flutter/material.dart';
import 'package:dropzone_app/l10n/app_localizations.dart';
import 'package:dropzone_app/presentation/widgets/primary_button.dart';
import 'package:dropzone_app/presentation/widgets/result_popup.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(localizations.contactDriverTitle)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Card(
            child: ListTile(
              title: Text(localizations.maskedCallTitle),
              subtitle: Text(localizations.maskedCallBody),
              trailing: const Icon(Icons.phone),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              title: Text(localizations.inAppChatTitle),
              subtitle: Text(localizations.inAppChatBody),
              trailing: const Icon(Icons.chat_bubble_outline),
            ),
          ),
          const SizedBox(height: 20),
          PrimaryButton(
            label: localizations.startMaskedCall,
            onPressed: () async {
              await showDialog<void>(
                context: context,
                barrierDismissible: false,
                builder: (dialogCtx) => ResultPopup(
                  title: localizations.maskedCallUnavailableTitle,
                  message: localizations.maskedCallUnavailableMessage,
                  type: ResultType.error,
                  buttonLabel: localizations.dismissLabel,
                  onAction: () {
                    Navigator.of(dialogCtx).pop();
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
