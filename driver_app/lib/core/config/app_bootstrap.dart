import 'package:dropzone_driver_app/core/config/app_config.dart';
import 'package:firebase_core/firebase_core.dart';

class DriverAppBootstrap {
  static Future<void> initialize(DriverAppConfig config) async {
    if (!config.enableFirebaseAuth) {
      return;
    }

    await Firebase.initializeApp();
  }
}
