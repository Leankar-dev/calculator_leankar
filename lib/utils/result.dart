import 'package:calculator_05122025/utils/enums/error_type.dart';

sealed class Result<T> {
  const Result();

  factory Result.success(T value) = Success<T>;

  factory Result.failure(ErrorType error, [String? details]) = Failure<T>;

  bool get isSuccess => this is Success<T>;

  bool get isFailure => this is Failure<T>;

  T get value => switch (this) {
    Success<T>(:final data) => data,
    Failure<T>(:final errorType) => throw StateError(
      'Tentativa de acessar valor de um Result com erro: ${errorType.fullMessage}',
    ),
  };

  T? get valueOrNull => switch (this) {
    Success<T>(:final data) => data,
    Failure<T>() => null,
  };

  ErrorType? get error => switch (this) {
    Success<T>() => null,
    Failure<T>(:final errorType) => errorType,
  };

  String? get errorDetails => switch (this) {
    Success<T>() => null,
    Failure<T>(:final details) => details,
  };

  String get errorMessage => error?.shortMessage ?? '';

  String get errorFullMessage => error?.fullMessage ?? '';

  R fold<R>({
    required R Function(T value) onSuccess,
    required R Function(ErrorType error, String? details) onFailure,
  }) {
    return switch (this) {
      Success<T>(:final data) => onSuccess(data),
      Failure<T>(:final errorType, :final details) => onFailure(
        errorType,
        details,
      ),
    };
  }

  Result<R> map<R>(R Function(T value) transform) {
    return switch (this) {
      Success<T>(:final data) => Result.success(transform(data)),
      Failure<T>(:final errorType, :final details) => Result.failure(
        errorType,
        details,
      ),
    };
  }

  T getOrElse(T defaultValue) {
    return switch (this) {
      Success<T>(:final data) => data,
      Failure<T>() => defaultValue,
    };
  }

  T getOrElseCompute(T Function() compute) {
    return switch (this) {
      Success<T>(:final data) => data,
      Failure<T>() => compute(),
    };
  }
}

final class Success<T> extends Result<T> {
  final T data;

  const Success(this.data);

  @override
  String toString() => 'Result.success($data)';
}

final class Failure<T> extends Result<T> {
  final ErrorType errorType;
  final String? details;

  const Failure(this.errorType, [this.details]);

  @override
  String toString() {
    final detailsSuffix = details != null ? ': $details' : '';
    return 'Result.failure($errorType$detailsSuffix)';
  }
}
