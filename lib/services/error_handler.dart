import 'package:calculator_05122025/services/logger_service.dart';
import 'package:calculator_05122025/utils/enums/error_type.dart';
import 'package:calculator_05122025/utils/number_formatter.dart';
import 'package:calculator_05122025/utils/result.dart';

class ErrorHandler {
  ErrorHandler._();

  static final ErrorHandler _instance = ErrorHandler._();
  static ErrorHandler get instance => _instance;

  Result<double> validateCalculationResult(double value) {
    if (value.isNaN) {
      logger.logError(
        ErrorType.notANumber,
        tag: 'Calculation',
        details: 'Resultado: $value',
      );
      return Result.failure(ErrorType.notANumber);
    }

    if (value.isInfinite) {
      logger.logError(
        ErrorType.infinity,
        tag: 'Calculation',
        details: 'Resultado: $value',
      );
      return Result.failure(ErrorType.infinity);
    }

    if (value.abs() > 1e15) {
      logger.logError(
        ErrorType.overflow,
        tag: 'Calculation',
        details: 'Valor: $value',
      );
      return Result.failure(ErrorType.overflow);
    }

    return Result.success(value);
  }

  Result<double> parseDouble(String value, {String decimalSeparator = ','}) {
    if (value.isEmpty) {
      return Result.failure(
        ErrorType.invalidNumber,
        'Valor vazio não pode ser convertido',
      );
    }

    final parsed = NumberFormatter.parse(value);

    if (parsed == null) {
      logger.logError(
        ErrorType.invalidNumber,
        tag: 'Parse',
        details: 'Não foi possível converter: $value',
      );
      return Result.failure(
        ErrorType.invalidNumber,
        'Não foi possível converter: $value',
      );
    }

    return Result.success(parsed);
  }

  Result<double> safeDivide(double dividend, double divisor) {
    if (divisor == 0) {
      logger.logError(
        ErrorType.divisionByZero,
        tag: 'Calculation',
        details: '$dividend / $divisor',
      );
      return Result.failure(ErrorType.divisionByZero);
    }

    final result = dividend / divisor;
    return validateCalculationResult(result);
  }

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

  bool isValidNumberInput(
    String currentDisplay,
    String newDigit, {
    String decimalSeparator = ',',
  }) {
    if (newDigit == decimalSeparator) {
      if (currentDisplay.contains(decimalSeparator)) {
        logger.debug(
          'Tentativa de adicionar segundo separador decimal',
          tag: 'Input',
        );
        return false;
      }
    }

    final wouldBe = currentDisplay + newDigit;
    if (wouldBe.replaceAll(decimalSeparator, '').replaceAll('-', '').length >
        15) {
      logger.debug('Número muito longo: $wouldBe', tag: 'Input');
      return false;
    }

    return true;
  }
}

ErrorHandler get errorHandler => ErrorHandler.instance;
