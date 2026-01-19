import 'package:calculator_05122025/utils/enums/error_type.dart';

/// Classe que representa o resultado de uma operação que pode falhar.
/// Usa o padrão Result/Either para tratamento funcional de erros.
class Result<T> {
  final T? _value;
  final ErrorType? _error;
  final String? _errorDetails;

  const Result._({T? value, ErrorType? error, String? errorDetails})
      : _value = value,
        _error = error,
        _errorDetails = errorDetails;

  /// Cria um resultado de sucesso
  factory Result.success(T value) => Result._(value: value);

  /// Cria um resultado de erro
  factory Result.failure(ErrorType error, [String? details]) =>
      Result._(error: error, errorDetails: details);

  /// Retorna true se a operação foi bem sucedida
  bool get isSuccess => _error == null;

  /// Retorna true se a operação falhou
  bool get isFailure => _error != null;

  /// Obtém o valor (lança exceção se for erro)
  T get value {
    if (_error != null) {
      throw StateError(
          'Tentativa de acessar valor de um Result com erro: ${_error.fullMessage}');
    }
    return _value as T;
  }

  /// Obtém o valor ou null se for erro
  T? get valueOrNull => _value;

  /// Obtém o tipo de erro (null se sucesso)
  ErrorType? get error => _error;

  /// Obtém detalhes adicionais do erro
  String? get errorDetails => _errorDetails;

  /// Obtém a mensagem curta do erro ou string vazia
  String get errorMessage => _error?.shortMessage ?? '';

  /// Obtém a mensagem completa do erro ou string vazia
  String get errorFullMessage => _error?.fullMessage ?? '';

  /// Executa uma função se sucesso, outra se erro
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

  /// Transforma o valor se sucesso, mantém o erro se falha
  Result<R> map<R>(R Function(T value) transform) {
    if (isSuccess) {
      return Result.success(transform(_value as T));
    } else {
      return Result.failure(_error!, _errorDetails);
    }
  }

  /// Obtém o valor ou um valor padrão se erro
  T getOrElse(T defaultValue) => isSuccess ? _value as T : defaultValue;

  /// Obtém o valor ou executa uma função para obter valor padrão
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
