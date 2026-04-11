enum DriverAuthStatus {
  checking,
  signedOut,
  signedIn,
  driverAccountMissing,
}

class DriverAuthSession {
  const DriverAuthSession._({
    required this.status,
    this.uid,
    this.email,
    this.idToken,
    this.message,
  });

  const DriverAuthSession.checking()
      : this._(
          status: DriverAuthStatus.checking,
        );

  const DriverAuthSession.signedOut()
      : this._(
          status: DriverAuthStatus.signedOut,
        );

  const DriverAuthSession.signedIn({
    required String uid,
    String? email,
    String? idToken,
  }) : this._(
          status: DriverAuthStatus.signedIn,
          uid: uid,
          email: email,
          idToken: idToken,
        );

  const DriverAuthSession.driverAccountMissing({
    String message =
        'Your Firebase account is not linked to a driver profile yet.',
  }) : this._(
          status: DriverAuthStatus.driverAccountMissing,
          message: message,
        );

  final DriverAuthStatus status;
  final String? uid;
  final String? email;
  final String? idToken;
  final String? message;

  bool get isAuthenticated => status == DriverAuthStatus.signedIn;
  bool get isLoading => status == DriverAuthStatus.checking;
  bool get isDriverAccountMissing =>
      status == DriverAuthStatus.driverAccountMissing;
}
