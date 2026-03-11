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
const Env devEnv = Env(
  environment: AppEnvironment.dev,
  apiBaseUrl: 'http://192.168.1.6:8080', // ← Mac LAN IP; update if network changes
  // Paste your Stripe test publishable key (pk_test_…) from Stripe Dashboard → Developers → API keys
  stripePublishableKey: 'pk_test_51T66xgElMPYHRgN64FgRKvi6Dor1G9HqWPVfeNDYNvvS8yHP9eUIRp9Be1bpdHsf16nTg6DHbMoBvNhjecg71T0j003DwS5c40',
);

const Env stageEnv = Env(
  environment: AppEnvironment.stage,
  apiBaseUrl: 'https://api.stage.dropzone.example',
  stripePublishableKey: 'pk_test_REPLACE_ME',
);

const Env prodEnv = Env(
  environment: AppEnvironment.prod,
  apiBaseUrl: 'https://api.dropzone.example',
  stripePublishableKey: 'pk_live_REPLACE_ME',
);
