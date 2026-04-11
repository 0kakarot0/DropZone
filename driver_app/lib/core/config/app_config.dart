class DriverAppConfig {
  const DriverAppConfig({
    required this.apiBaseUrl,
    required this.useMockDriverBackend,
    required this.enableFirebaseAuth,
  });

  const DriverAppConfig.development()
      : apiBaseUrl = 'http://localhost:8080',
        useMockDriverBackend = true,
        enableFirebaseAuth = false;

  final String apiBaseUrl;
  final bool useMockDriverBackend;
  final bool enableFirebaseAuth;
}
