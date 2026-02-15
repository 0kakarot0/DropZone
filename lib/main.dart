import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dropzone_app/presentation/app/app_router.dart';
import 'package:dropzone_app/presentation/theme/app_theme.dart';
import 'package:dropzone_app/l10n/app_localizations.dart';

void main() {
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
