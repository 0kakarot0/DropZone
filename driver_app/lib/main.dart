import 'package:dropzone_driver_app/core/config/app_bootstrap.dart';
import 'package:dropzone_driver_app/core/config/app_config.dart';
import 'package:dropzone_driver_app/core/di/providers.dart';
import 'package:dropzone_driver_app/presentation/app/driver_app.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const config = DriverAppConfig.development();
  await DriverAppBootstrap.initialize(config);

  runApp(
    ProviderScope(
      overrides: [
        appConfigProvider.overrideWithValue(config),
      ],
      child: const DriverApp(),
    ),
  );
}
