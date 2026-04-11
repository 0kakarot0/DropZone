import 'dart:async';

import 'package:dropzone_driver_app/domain/entities/driver_auth_session.dart';
import 'package:dropzone_driver_app/domain/repositories/driver_auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

/// Firebase-backed auth repository for the driver app.
///
/// After Firebase sign-in succeeds, [authStateChanges] emits a
/// [DriverAuthSession.signedIn] with the user's UID and ID token.
/// The downstream Dio interceptor attaches the token automatically.
///
/// Driver-profile linkage validation (whether a `drivers` table row
/// exists for this Firebase UID) is handled at the provider level
/// via a GET /api/driver/profile call — not here — so the auth
/// layer stays protocol-agnostic.
class FirebaseDriverAuthRepository implements DriverAuthRepository {
  FirebaseDriverAuthRepository({FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  final FirebaseAuth _firebaseAuth;

  @override
  Stream<DriverAuthSession> authStateChanges() {
    return _firebaseAuth.authStateChanges().asyncMap((user) async {
      if (user == null) {
        return const DriverAuthSession.signedOut();
      }

      final idToken = await user.getIdToken();
      return DriverAuthSession.signedIn(
        uid: user.uid,
        email: user.email,
        idToken: idToken,
      );
    });
  }

  @override
  Future<void> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    // authStateChanges stream will emit the new session automatically.
  }

  @override
  Future<void> signInAsDemoDriver() async {
    // In Firebase mode, demo sign-in uses real test credentials.
    debugPrint(
      '[FirebaseDriverAuth] signInAsDemoDriver is a no-op in Firebase mode. '
      'Use signInWithEmailAndPassword with test credentials instead.',
    );
  }

  @override
  Future<void> signInAsUnlinkedDriver() async {
    debugPrint(
      '[FirebaseDriverAuth] Unlinked-driver simulation is only available '
      'in placeholder auth mode.',
    );
  }

  @override
  Future<void> signOut() => _firebaseAuth.signOut();

  @override
  void dispose() {}
}
