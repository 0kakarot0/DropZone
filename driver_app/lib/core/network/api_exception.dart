/// Typed API exceptions for driver app network calls.
///
/// These map to HTTP status codes returned by the backend and provide
/// consistent, user-facing error messages across the app.
sealed class ApiException implements Exception {
  const ApiException(this.message);
  final String message;

  @override
  String toString() => message;
}

/// 401 — Firebase token missing, expired, or invalid.
class UnauthorizedException extends ApiException {
  const UnauthorizedException([
    super.message = 'Session expired. Please sign in again.',
  ]);
}

/// 403 — Authenticated but no linked driver record (or wrong role).
class ForbiddenException extends ApiException {
  const ForbiddenException([
    super.message = 'Your account is not linked to a driver profile.',
  ]);
}

/// 404 — Resource not found (ride, profile, etc.).
class NotFoundException extends ApiException {
  const NotFoundException([super.message = 'The requested resource was not found.']);
}

/// 409 — Conflict, typically another driver accepted the ride first.
class ConflictException extends ApiException {
  const ConflictException([
    super.message = 'This ride was already accepted by another driver.',
  ]);
}

/// 400 — Bad request, invalid payload or invalid status transition.
class BadRequestException extends ApiException {
  const BadRequestException([
    super.message = 'Invalid request. Please try again.',
  ]);
}

/// Catch-all for unexpected server errors (5xx, timeouts, etc.).
class ServerException extends ApiException {
  const ServerException([
    super.message = 'Something went wrong. Please try again later.',
  ]);
}

/// Parses a Dio status code into a typed [ApiException].
ApiException apiExceptionFromStatusCode(int? statusCode, [String? serverMessage]) {
  return switch (statusCode) {
    400 => BadRequestException(serverMessage ?? const BadRequestException().message),
    401 => const UnauthorizedException(),
    403 => ForbiddenException(serverMessage ?? const ForbiddenException().message),
    404 => NotFoundException(serverMessage ?? const NotFoundException().message),
    409 => ConflictException(serverMessage ?? const ConflictException().message),
    _ => ServerException(serverMessage ?? const ServerException().message),
  };
}
