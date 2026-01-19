import 'package:calculator_05122025/services/logger_service.dart';
import 'package:calculator_05122025/utils/enums/error_type.dart';
import 'package:calculator_05122025/utils/result.dart';

/// Serviço centralizado para tratamento de erros.
/// Fornece métodos utilitários para validação e conversão segura.
class ErrorHandler {
  ErrorHandler._();

  static final ErrorHandler _instance = ErrorHandler._();
  static ErrorHandler get instance => _instance;

  /// Valida se um resultado de cálculo é válido (não é NaN ou Infinity)
  Result<double> validateCalculationResult(double value) {
    if (value.isNaN) {
      logger.logError(ErrorType.notANumber,
          tag: 'Calculation', details: 'Resultado: $value');
      return Result.failure(ErrorType.notANumber);
    }

    if (value.isInfinite) {
      logger.logError(ErrorType.infinity,
          tag: 'Calculation', details: 'Resultado: $value');
      return Result.failure(ErrorType.infinity);
    }

    // Verifica overflow (números muito grandes para exibir)
    if (value.abs() > 1e15) {
      logger.logError(ErrorType.overflow,
          tag: 'Calculation', details: 'Valor: $value');
      return Result.failure(ErrorType.overflow);
    }

    return Result.success(value);
  }

  /// Faz parse seguro de string para double
  Result<double> parseDouble(String value, {String decimalSeparator = ','}) {
    if (value.isEmpty) {
      return Result.failure(
          ErrorType.invalidNumber, 'Valor vazio não pode ser convertido');
    }

    // Normaliza o separador decimal
    final normalized = value.replaceAll(decimalSeparator, '.');

    // Verifica caracteres inválidos
    if (!RegExp(r'^-?\d*\.?\d+$').hasMatch(normalized)) {
      logger.logError(ErrorType.invalidNumber,
          tag: 'Parse', details: 'Valor inválido: $value');
      return Result.failure(ErrorType.invalidNumber, 'Formato inválido: $value');
    }

    final parsed = double.tryParse(normalized);
    if (parsed == null) {
      logger.logError(ErrorType.invalidNumber,
          tag: 'Parse', details: 'Não foi possível converter: $value');
      return Result.failure(
          ErrorType.invalidNumber, 'Não foi possível converter: $value');
    }

    return Result.success(parsed);
  }

  /// Verifica divisão por zero
  Result<double> safeDivide(double dividend, double divisor) {
    if (divisor == 0) {
      logger.logError(ErrorType.divisionByZero,
          tag: 'Calculation', details: '$dividend / $divisor');
      return Result.failure(ErrorType.divisionByZero);
    }

    final result = dividend / divisor;
    return validateCalculationResult(result);
  }

  /// Executa uma operação com tratamento de erro
  Result<T> tryExecute<T>(
    T Function() operation, {
    ErrorType defaultError = ErrorType.unknown,
    String? tag,
  }) {
    try {
      final result = operation();
      return Result.success(result);
    } catch (e, stackTrace) {
      logger.logError(
        defaultError,
        tag: tag,
        details: e.toString(),
        error: e,
        stackTrace: stackTrace,
      );
      return Result.failure(defaultError, e.toString());
    }
  }

  /// Executa uma operação assíncrona com tratamento de erro
  Future<Result<T>> tryExecuteAsync<T>(
    Future<T> Function() operation, {
    ErrorType defaultError = ErrorType.unknown,
    String? tag,
  }) async {
    try {
      final result = await operation();
      return Result.success(result);
    } catch (e, stackTrace) {
      logger.logError(
        defaultError,
        tag: tag,
        details: e.toString(),
        error: e,
        stackTrace: stackTrace,
      );
      return Result.failure(defaultError, e.toString());
    }
  }

  /// Valida entrada de número (verifica múltiplos decimais, etc.)
  bool isValidNumberInput(String currentDisplay, String newDigit,
      {String decimalSeparator = ','}) {
    // Se for separador decimal
    if (newDigit == decimalSeparator) {
      // Não permite múltiplos separadores
      if (currentDisplay.contains(decimalSeparator)) {
        logger.debug(
          'Tentativa de adicionar segundo separador decimal',
          tag: 'Input',
        );
        return false;
      }
    }

    // Verifica se o número resultante não seria muito longo
    final wouldBe = currentDisplay + newDigit;
    if (wouldBe.replaceAll(decimalSeparator, '').replaceAll('-', '').length >
        15) {
      logger.debug('Número muito longo: $wouldBe', tag: 'Input');
      return false;
    }

    return true;
  }
}

/// Atalho global para o error handler
ErrorHandler get errorHandler => ErrorHandler.instance;
