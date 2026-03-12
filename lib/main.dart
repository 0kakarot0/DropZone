import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:dropzone_app/firebase_options.dart';
import 'package:dropzone_app/core/config/env.dart';
import 'package:dropzone_app/presentation/app/app_router.dart';
import 'package:dropzone_app/presentation/theme/app_theme.dart';
import 'package:dropzone_app/l10n/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialise Stripe with the publishable key for the current environment.
  Stripe.publishableKey = devEnv.stripePublishableKey;
  await Stripe.instance.applySettings();

  runApp(const ProviderScope(child: DropZoneApp()));
}

class DropZoneApp extends StatelessWidget {
  const DropZoneApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'DropZone Chauffeur',
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      routerConfig: appRouter,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}