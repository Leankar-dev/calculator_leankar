import 'package:calculator_05122025/services/error_handler.dart';
import 'package:calculator_05122025/utils/enums/error_type.dart';
import 'package:calculator_05122025/utils/result.dart';

class MockErrorHandler extends ErrorHandler {
  @override
  Result<double> validateCalculationResult(double value) {
    if (value.isNaN) return Result.failure(ErrorType.notANumber);
    if (value.isInfinite) return Result.failure(ErrorType.infinity);
    if (value.abs() > 1e15) return Result.failure(ErrorType.overflow);
    return Result.success(value);
  }

  @override
  Result<double> parseDouble(String value, {String decimalSeparator = ','}) {
    if (value.isEmpty) {
      return Result.failure(ErrorType.invalidNumber, 'Valor vazio');
    }
    final cleaned = value.replaceAll('.', '').replaceAll(decimalSeparator, '.');
    final parsed = double.tryParse(cleaned);
    if (parsed == null) {
      return Result.failure(ErrorType.invalidNumber, 'Inválido: $value');
    }
    return Result.success(parsed);
  }

  @override
  Result<double> safeDivide(double dividend, double divisor) {
    if (divisor == 0) return Result.failure(ErrorType.divisionByZero);
    return validateCalculationResult(dividend / divisor);
  }

  @override
  Result<T> tryExecute<T>(
    T Function() operation, {
    ErrorType defaultError = ErrorType.unknown,
    String? tag,
  }) {
    try {
      return Result.success(operation());
    } catch (e) {
      return Result.failure(defaultError, e.toString());
    }
  }

  @override
  Future<Result<T>> tryExecuteAsync<T>(
    Future<T> Function() operation, {
    ErrorType defaultError = ErrorType.unknown,
    String? tag,
  }) async {
    try {
      return Result.success(await operation());
    } catch (e) {
      return Result.failure(defaultError, e.toString());
    }
  }

  @override
  bool isValidNumberInput(
    String currentDisplay,
    String newDigit, {
    String decimalSeparator = ',',
  }) {
    if (newDigit == decimalSeparator &&
        currentDisplay.contains(decimalSeparator)) {
      return false;
    }
    final wouldBe = currentDisplay + newDigit;
    return wouldBe
            .replaceAll(decimalSeparator, '')
            .replaceAll('-', '')
            .length <=
        15;
  }
}
