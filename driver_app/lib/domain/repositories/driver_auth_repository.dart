import 'package:dropzone_driver_app/domain/entities/driver_auth_session.dart';

abstract class DriverAuthRepository {
  Stream<DriverAuthSession> authStateChanges();

  /// Real email/password sign-in (Firebase mode).
  Future<void> signInWithEmailAndPassword(String email, String password);

  /// Placeholder for demo driver simulation (mock mode only).
  Future<void> signInAsDemoDriver();

  /// Placeholder for unlinked-driver simulation (mock mode only).
  Future<void> signInAsUnlinkedDriver();

  Future<void> signOut();

  void dispose() {}
}
