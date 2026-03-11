/// Typed exceptions thrown by the data layer.
/// Presentation and use-case layers can pattern-match on these.
sealed class AppException implements Exception {
  const AppException(this.message);
  final String message;

  @override
  String toString() => message;
}

/// HTTP 400 – bad request body.
class BadRequestException extends AppException {
  const BadRequestException(super.message);
}

/// HTTP 401 – missing or expired Firebase token.
class UnauthorizedException extends AppException {
  const UnauthorizedException(super.message);
}

/// HTTP 403 – authenticated but not allowed.
class ForbiddenException extends AppException {
  const ForbiddenException(super.message);
}

/// HTTP 404 – resource not found.
class NotFoundException extends AppException {
  const NotFoundException(super.message);
}

/// HTTP 5xx or unexpected status.
class ServerException extends AppException {
  const ServerException(super.message);
}

/// Network timeout or no connectivity.
class NetworkException extends AppException {
  const NetworkException(super.message);
}

/// Any other unexpected error.
class UnknownException extends AppException {
  const UnknownException(super.message);
}
