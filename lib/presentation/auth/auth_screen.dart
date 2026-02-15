import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:dropzone_app/presentation/widgets/primary_button.dart';
import 'package:dropzone_app/l10n/app_localizations.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(localizations.appTitle)),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              localizations.authTitle,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 20),
            const TextField(
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(hintText: '+971 5X XXX XXXX'),
            ),
            const SizedBox(height: 12),
            const TextField(
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(hintText: 'email@example.com'),
            ),
            const SizedBox(height: 20),
            PrimaryButton(
              label: localizations.sendOtp,
              onPressed: () => context.go('/auth/otp'),
            ),
          ],
        ),
      ),
    );
  }
}
