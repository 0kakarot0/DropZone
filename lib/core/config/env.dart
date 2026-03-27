import 'package:flutter_dotenv/flutter_dotenv.dart';

enum AppEnvironment { dev, stage, prod }

class Env {
  const Env({
    required this.environment,
    required this.apiBaseUrl,
    required this.stripePublishableKey,
  });

  final AppEnvironment environment;
  final String apiBaseUrl;
  /// Stripe publishable key (pk_test_… for sandbox, pk_live_… for production).
  final String stripePublishableKey;
}

// iOS Simulator:       http://localhost:8080
// Android Emulator:    http://10.0.2.2:8080
// Physical device:     http://<your-mac-lan-ip>:8080  (run: ipconfig getifaddr en0)
Env get devEnv => Env(
  environment: AppEnvironment.dev,
  apiBaseUrl: dotenv.env['API_BASE_URL'] ?? 'http://127.0.0.1:8080',
  stripePublishableKey: dotenv.env['STRIPE_PUBLISHABLE_KEY'] ?? '',
);

Env get stageEnv => Env(
  environment: AppEnvironment.stage,
  apiBaseUrl: 'https://api.stage.dropzone.example',
  stripePublishableKey: 'pk_test_REPLACE_ME',
);

Env get prodEnv => Env(
  environment: AppEnvironment.prod,
  apiBaseUrl: 'https://api.dropzone.example',
  stripePublishableKey: 'pk_live_REPLACE_ME',
);
