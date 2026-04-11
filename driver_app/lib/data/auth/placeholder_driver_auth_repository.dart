import 'dart:async';

import 'package:dropzone_driver_app/domain/entities/driver_auth_session.dart';
import 'package:dropzone_driver_app/domain/repositories/driver_auth_repository.dart';

class PlaceholderDriverAuthRepository implements DriverAuthRepository {
  PlaceholderDriverAuthRepository();

  final StreamController<DriverAuthSession> _controller =
      StreamController<DriverAuthSession>.broadcast();
  DriverAuthSession _currentSession = const DriverAuthSession.signedOut();

  @override
  Stream<DriverAuthSession> authStateChanges() async* {
    yield _currentSession;
    yield* _controller.stream;
  }

  @override
  Future<void> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    // In placeholder mode, any credentials sign in as the demo driver.
    return signInAsDemoDriver();
  }

  @override
  Future<void> signInAsDemoDriver() async {
    _emit(const DriverAuthSession.checking());
    await Future<void>.delayed(const Duration(milliseconds: 350));
    _emit(
      const DriverAuthSession.signedIn(
        uid: 'demo-driver-1',
        email: 'driver@dropzone.local',
      ),
    );
  }

  @override
  Future<void> signInAsUnlinkedDriver() async {
    _emit(const DriverAuthSession.checking());
    await Future<void>.delayed(const Duration(milliseconds: 350));
    _emit(const DriverAuthSession.driverAccountMissing());
  }

  @override
  Future<void> signOut() async {
    _emit(const DriverAuthSession.signedOut());
  }

  @override
  void dispose() {
    _controller.close();
  }

  void _emit(DriverAuthSession session) {
    _currentSession = session;
    _controller.add(_currentSession);
  }
}
