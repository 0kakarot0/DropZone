import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:dropzone_app/presentation/widgets/primary_button.dart';
import 'package:dropzone_app/l10n/app_localizations.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key, required this.verificationId});

  final String verificationId;

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final _otpController = TextEditingController();
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _verify() async {
    final code = _otpController.text.trim();
    if (code.length < 6) {
      setState(() => _error = 'Enter the 6-digit code.');
      return;
    }
    setState(() { _loading = true; _error = null; });

    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId,
        smsCode: code,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      if (mounted) context.go('/');
    } on FirebaseAuthException catch (e) {
      if (mounted) setState(() { _error = e.message ?? 'Invalid code.'; _loading = false; });
    } catch (e) {
      if (mounted) setState(() { _error = 'Error: $e'; _loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(localizations.verifyPhone)),
      body: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 24),
            Text(localizations.otpPrompt,
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center),
            const SizedBox(height: 32),
            TextField(
              controller: _otpController,
              keyboardType: TextInputType.number,
              maxLength: 6,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium,
              decoration: const InputDecoration(
                hintText: '— — — — — —',
                counterText: '',
              ),
            ),
            if (_error != null) ...[
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(_error!,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onErrorContainer),
                    textAlign: TextAlign.center),
              ),
            ],
            const SizedBox(height: 24),
            _loading
                ? const Center(child: CircularProgressIndicator())
                : PrimaryButton(
                    label: localizations.verifyAndContinue,
                    onPressed: _verify,
                  ),
          ],
        ),
      ),
    );
  }
}
