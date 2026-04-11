import 'dart:async';

import 'package:dropzone_driver_app/domain/entities/driver_auth_session.dart';
import 'package:dropzone_driver_app/domain/repositories/driver_auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DriverAuthController extends StateNotifier<DriverAuthSession> {
  DriverAuthController(this._repository)
      : super(const DriverAuthSession.checking()) {
    _subscription = _repository.authStateChanges().listen((session) {
      state = session;
    });
  }

  final DriverAuthRepository _repository;
  late final StreamSubscription<DriverAuthSession> _subscription;

  /// Real email/password sign-in (works in both Firebase and placeholder mode).
  Future<void> signInWithEmailAndPassword(
    String email,
    String password,
  ) =>
      _repository.signInWithEmailAndPassword(email, password);

  /// Demo driver placeholder sign-in.
  Future<void> signInAsDemoDriver() => _repository.signInAsDemoDriver();

  /// Simulate an unlinked driver account.
  Future<void> signInAsUnlinkedDriver() =>
      _repository.signInAsUnlinkedDriver();

  Future<void> signOut() => _repository.signOut();

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
