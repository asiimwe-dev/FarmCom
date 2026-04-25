import 'package:equatable/equatable.dart';

/// Result wrapper - encapsulates success/failure
/// Pattern used across all usecases for consistent error handling
sealed class Result<T> extends Equatable {
  const Result();

  @override
  List<Object?> get props => [];
}

/// Success result containing data
class Success<T> extends Result<T> {
  final T data;

  const Success(this.data);

  @override
  List<Object?> get props => [data];
}

/// Failure result containing exception
class Failure<T> extends Result<T> {
  final Exception exception;
  final String message;
  final String? code;

  const Failure({
    required this.exception,
    required this.message,
    this.code,
  });

  @override
  List<Object?> get props => [exception, message, code];
}

/// Extension for cleaner Result handling
extension ResultX<T> on Result<T> {
  /// Execute function based on result type
  R fold<R>(
    R Function(Exception exception, String message, String? code) onFailure,
    R Function(T data) onSuccess,
  ) {
    if (this is Success<T>) {
      return onSuccess((this as Success<T>).data);
    } else if (this is Failure<T>) {
      final failure = this as Failure<T>;
      return onFailure(failure.exception, failure.message, failure.code);
    }
    throw StateError('Unknown Result type');
  }

  /// Get data or null
  T? getOrNull() {
    if (this is Success<T>) {
      return (this as Success<T>).data;
    }
    return null;
  }

  /// Check if result is success
  bool get isSuccess => this is Success<T>;

  /// Check if result is failure
  bool get isFailure => this is Failure<T>;
}
