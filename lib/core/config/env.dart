enum AppEnvironment { dev, stage, prod }

class Env {
  const Env({required this.environment, required this.apiBaseUrl});

  final AppEnvironment environment;
  final String apiBaseUrl;
}

const Env devEnv = Env(
  environment: AppEnvironment.dev,
  apiBaseUrl: 'https://api.dev.dropzone.example',
);

const Env stageEnv = Env(
  environment: AppEnvironment.stage,
  apiBaseUrl: 'https://api.stage.dropzone.example',
);

const Env prodEnv = Env(
  environment: AppEnvironment.prod,
  apiBaseUrl: 'https://api.dropzone.example',
);
