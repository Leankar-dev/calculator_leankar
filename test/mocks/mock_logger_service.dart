import 'package:calculator_05122025/services/logger_service.dart';
import 'package:calculator_05122025/utils/enums/error_type.dart';

class MockLoggerService extends LoggerService {
  @override
  void debug(String message, {String? tag, Object? data}) {}

  @override
  void info(String message, {String? tag, Object? data}) {}

  @override
  void warning(String message, {String? tag, Object? data}) {}

  @override
  void error(
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {}

  @override
  void logError(
    ErrorType errorType, {
    String? tag,
    String? details,
    Object? error,
    StackTrace? stackTrace,
  }) {}

  @override
  void logCalculation({
    required String operation,
    required String firstOperand,
    required String secondOperand,
    required String result,
  }) {}

  @override
  void logStorage(String action, {bool success = true, String? details}) {}
}
