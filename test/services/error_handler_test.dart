import 'package:calculator_05122025/services/error_handler.dart';
import 'package:calculator_05122025/utils/enums/error_type.dart';
import 'package:flutter_test/flutter_test.dart';

import '../mocks/mock_logger_service.dart';

void main() {
  late ErrorHandler errorHandler;

  setUp(() {
    errorHandler = ErrorHandler(logger: MockLoggerService());
  });

  group('ErrorHandler', () {
    group('validateCalculationResult', () {
      test('aceita valores dentro do limite', () {
        final result = errorHandler.validateCalculationResult(123.45);

        expect(result.isSuccess, isTrue);
        expect(result.value, 123.45);
      });

      test('aceita exatamente o valor máximo de exibição', () {
        expect(errorHandler.validateCalculationResult(1e15).isSuccess, isTrue);
        expect(
          errorHandler.validateCalculationResult(-1e15).isSuccess,
          isTrue,
        );
      });

      test('rejeita NaN com notANumber', () {
        final result = errorHandler.validateCalculationResult(double.nan);

        expect(result.error, ErrorType.notANumber);
      });

      test('rejeita infinito com infinity', () {
        final result = errorHandler.validateCalculationResult(
          double.infinity,
        );

        expect(result.error, ErrorType.infinity);
      });

      test('rejeita valores acima do limite com overflow', () {
        final result = errorHandler.validateCalculationResult(1.1e15);

        expect(result.error, ErrorType.overflow);
      });
    });

    group('parseDouble', () {
      test('converte número com vírgula decimal', () {
        expect(errorHandler.parseDouble('3,14').value, 3.14);
      });

      test('converte decimal com ponto iniciado por zero', () {
        expect(errorHandler.parseDouble('0.123').value, 0.123);
      });

      test('falha para texto vazio', () {
        final result = errorHandler.parseDouble('');

        expect(result.error, ErrorType.invalidNumber);
      });

      test('falha para texto não numérico', () {
        final result = errorHandler.parseDouble('abc');

        expect(result.error, ErrorType.invalidNumber);
        expect(result.errorDetails, contains('abc'));
      });
    });

    group('safeDivide', () {
      test('divide valores válidos', () {
        expect(errorHandler.safeDivide(10, 4).value, 2.5);
      });

      test('falha ao dividir por zero', () {
        final result = errorHandler.safeDivide(10, 0);

        expect(result.error, ErrorType.divisionByZero);
      });

      test('falha quando o quociente excede o limite', () {
        final result = errorHandler.safeDivide(1e15, 1e-5);

        expect(result.error, ErrorType.overflow);
      });
    });

    group('isValidNumberInput', () {
      test('aceita dígitos até o limite de 15', () {
        expect(errorHandler.isValidNumberInput('12345678901234', '5'), isTrue);
      });

      test('rejeita o 16º dígito', () {
        expect(
          errorHandler.isValidNumberInput('123456789012345', '6'),
          isFalse,
        );
      });

      test('não conta a vírgula decimal no limite de dígitos', () {
        expect(
          errorHandler.isValidNumberInput('1234567,8901234', '5'),
          isTrue,
        );
      });

      test('rejeita um segundo separador decimal', () {
        expect(errorHandler.isValidNumberInput('1,5', ','), isFalse);
      });

      test('aceita o primeiro separador decimal', () {
        expect(errorHandler.isValidNumberInput('15', ','), isTrue);
      });
    });
  });
}
