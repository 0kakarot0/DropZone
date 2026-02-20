import 'package:flutter/material.dart';
import 'package:dropzone_app/l10n/app_localizations.dart';
import 'package:dropzone_app/presentation/widgets/primary_button.dart';
import 'package:dropzone_app/presentation/widgets/result_popup.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(localizations.supportTitle)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(localizations.helpCenterTitle,
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          _SupportTile(title: localizations.helpTopicPayment),
          _SupportTile(title: localizations.helpTopicDriver),
          _SupportTile(title: localizations.helpTopicLostItem),
          const SizedBox(height: 20),
          Text(localizations.reportIssueTitle,
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            items: [
              localizations.issueCategoryPayment,
              localizations.issueCategoryDriver,
              localizations.issueCategoryOther,
            ]
                .map((item) => DropdownMenuItem(value: item, child: Text(item)))
                .toList(),
            onChanged: (_) {},
            decoration: InputDecoration(hintText: localizations.selectCategory),
          ),
          const SizedBox(height: 12),
          TextField(
            maxLines: 4,
            decoration: InputDecoration(hintText: localizations.issueDescriptionHint),
          ),
          const SizedBox(height: 16),
          PrimaryButton(
            label: localizations.submitIssue,
            onPressed: () async {
              await showDialog<void>(
                context: context,
                barrierDismissible: false,
                builder: (context) => ResultPopup(
                  title: localizations.issueSubmittedTitle,
                  message: localizations.issueSubmittedMessage,
                  type: ResultType.success,
                  buttonLabel: localizations.goHome,
                  onAction: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).popUntil((route) => route.isFirst);
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

class _SupportTile extends StatelessWidget {
  const _SupportTile({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(title),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}
