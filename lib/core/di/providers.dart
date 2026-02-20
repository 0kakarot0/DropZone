import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dropzone_app/core/config/env.dart';
import 'package:dropzone_app/core/analytics/analytics_service.dart';
import 'package:dropzone_app/core/analytics/crashlytics_service.dart';

final envProvider = Provider<Env>((ref) => devEnv);

final analyticsProvider = Provider<AnalyticsService>((ref) {
  return MockAnalyticsService();
});

final crashlyticsProvider = Provider<CrashlyticsService>((ref) {
  return MockCrashlyticsService();
});
