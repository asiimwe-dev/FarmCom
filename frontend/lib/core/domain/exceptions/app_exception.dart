/// Base exception for all FarmCom errors
abstract class AppException implements Exception {
  final String message;
  final String? code;
  final StackTrace? stackTrace;

  AppException(
    this.message, {
    this.code,
    this.stackTrace,
  });

  @override
  String toString() => 'AppException: $message (code: $code)';
}

/// Network-related errors (no internet, timeout, server error)
class NetworkException extends AppException {
  NetworkException(
    super.message, {
    String? code,
    super.stackTrace,
  }) : super(
    code: code ?? 'NETWORK_ERROR',
  );
}

/// Local storage errors (Isar, permissions)
class StorageException extends AppException {
  StorageException(
    super.message, {
    String? code,
    super.stackTrace,
  }) : super(
    code: code ?? 'STORAGE_ERROR',
  );
}

/// Authentication errors (invalid OTP, unauthorized)
class AuthException extends AppException {
  AuthException(
    super.message, {
    String? code,
    super.stackTrace,
  }) : super(
    code: code ?? 'AUTH_ERROR',
  );
}

/// Sync-related errors (conflict resolution, pending items)
class SyncException extends AppException {
  SyncException(
    super.message, {
    String? code,
    super.stackTrace,
  }) : super(
    code: code ?? 'SYNC_ERROR',
  );
}

/// Payment-related errors (insufficient funds, invalid transaction)
class PaymentException extends AppException {
  PaymentException(
    super.message, {
    String? code,
    super.stackTrace,
  }) : super(
    code: code ?? 'PAYMENT_ERROR',
  );
}

/// Invalid input errors (validation failed)
class ValidationException extends AppException {
  final Map<String, String>? fieldErrors;

  ValidationException(
    super.message, {
    String? code,
    this.fieldErrors,
    super.stackTrace,
  }) : super(
    code: code ?? 'VALIDATION_ERROR',
  );
}

/// Unknown/unexpected errors
class UnknownException extends AppException {
  UnknownException(
    super.message, {
    String? code,
    super.stackTrace,
  }) : super(
    code: code ?? 'UNKNOWN_ERROR',
  );
}
