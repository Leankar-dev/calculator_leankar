import 'package:calculator_05122025/services/logger_service.dart';
import 'package:calculator_05122025/utils/constants/app_strings.dart';
import 'package:calculator_05122025/utils/enums/error_type.dart';
import 'package:calculator_05122025/utils/number_formatter.dart';
import 'package:calculator_05122025/utils/result.dart';

const String _calculationLogTag = 'Calculation';

class ErrorHandler {
  static const int _maxInputDigits = 15;

  final LoggerService _logger;

  ErrorHandler({LoggerService? logger})
    : _logger = logger ?? LoggerService.instance;

  static final ErrorHandler _instance = ErrorHandler();
  static ErrorHandler get instance => _instance;

  Result<double> validateCalculationResult(double value) {
    if (value.isNaN) {
      _logger.logError(
        ErrorType.notANumber,
        tag: _calculationLogTag,
        details: 'Resultado: $value',
      );
      return Result.failure(ErrorType.notANumber);
    }

    if (value.isInfinite) {
      _logger.logError(
        ErrorType.infinity,
        tag: _calculationLogTag,
        details: 'Resultado: $value',
      );
      return Result.failure(ErrorType.infinity);
    }

    if (value.abs() > AppStrings.maxDisplayValue) {
      _logger.logError(
        ErrorType.overflow,
        tag: _calculationLogTag,
        details: 'Valor: $value',
      );
      return Result.failure(ErrorType.overflow);
    }

    return Result.success(value);
  }

  Result<double> parseDouble(String value) {
    if (value.isEmpty) {
      return Result.failure(
        ErrorType.invalidNumber,
        'Valor vazio não pode ser convertido',
      );
    }

    final parsed = NumberFormatter.parse(value);

    if (parsed == null) {
      _logger.logError(
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
      _logger.logError(
        ErrorType.divisionByZero,
        tag: _calculationLogTag,
        details: '$dividend / $divisor',
      );
      return Result.failure(ErrorType.divisionByZero);
    }

    final result = dividend / divisor;
    return validateCalculationResult(result);
  }

  bool isValidNumberInput(
    String currentDisplay,
    String newDigit, {
    String decimalSeparator = AppStrings.decimalSeparator,
  }) {
    if (newDigit == decimalSeparator) {
      if (currentDisplay.contains(decimalSeparator)) {
        _logger.debug(
          'Tentativa de adicionar segundo separador decimal',
          tag: 'Input',
        );
        return false;
      }
    }

    final wouldBe = currentDisplay + newDigit;
    final digitCount = wouldBe
        .replaceAll(decimalSeparator, '')
        .replaceAll(AppStrings.subtractionSymbol, '')
        .length;
    if (digitCount > _maxInputDigits) {
      _logger.debug('Número muito longo: $wouldBe', tag: 'Input');
      return false;
    }

    return true;
  }
}
