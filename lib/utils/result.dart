import 'package:calculator_05122025/utils/enums/error_type.dart';

class Result<T> {
  final T? _value;
  final ErrorType? _error;
  final String? _errorDetails;

  const Result._({T? value, ErrorType? error, String? errorDetails})
    : _value = value,
      _error = error,
      _errorDetails = errorDetails;

  factory Result.success(T value) => Result._(value: value);

  factory Result.failure(ErrorType error, [String? details]) =>
      Result._(error: error, errorDetails: details);

  bool get isSuccess => _error == null;

  bool get isFailure => _error != null;

  T get value {
    if (_error != null) {
      throw StateError(
        'Tentativa de acessar valor de um Result com erro: ${_error.fullMessage}',
      );
    }
    return _value as T;
  }

  T? get valueOrNull => _value;

  ErrorType? get error => _error;

  String? get errorDetails => _errorDetails;

  String get errorMessage => _error?.shortMessage ?? '';

  String get errorFullMessage => _error?.fullMessage ?? '';

  R fold<R>({
    required R Function(T value) onSuccess,
    required R Function(ErrorType error, String? details) onFailure,
  }) {
    if (isSuccess) {
      return onSuccess(_value as T);
    } else {
      return onFailure(_error!, _errorDetails);
    }
  }

  Result<R> map<R>(R Function(T value) transform) {
    if (isSuccess) {
      return Result.success(transform(_value as T));
    } else {
      return Result.failure(_error!, _errorDetails);
    }
  }

  T getOrElse(T defaultValue) => isSuccess ? _value as T : defaultValue;

  T getOrElseCompute(T Function() compute) =>
      isSuccess ? _value as T : compute();

  @override
  String toString() {
    if (isSuccess) {
      return 'Result.success($_value)';
    } else {
      return 'Result.failure($_error${_errorDetails != null ? ': $_errorDetails' : ''})';
    }
  }
}
