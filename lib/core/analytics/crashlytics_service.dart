abstract class CrashlyticsService {
  Future<void> recordError(Object error, StackTrace stack);
}

class MockCrashlyticsService implements CrashlyticsService {
  @override
  Future<void> recordError(Object error, StackTrace stack) async {
    return;
  }
}
