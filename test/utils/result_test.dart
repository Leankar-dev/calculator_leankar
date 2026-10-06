import 'package:calculator_05122025/utils/enums/error_type.dart';
import 'package:calculator_05122025/utils/result.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Result', () {
    group('sucesso', () {
      final result = Result<int>.success(42);

      test('expõe o valor e não possui erro', () {
        expect(result.isSuccess, isTrue);
        expect(result.isFailure, isFalse);
        expect(result.value, 42);
        expect(result.valueOrNull, 42);
        expect(result.error, isNull);
        expect(result.errorDetails, isNull);
        expect(result.errorMessage, '');
        expect(result.errorFullMessage, '');
      });

      test('fold executa onSuccess', () {
        final folded = result.fold(
          onSuccess: (value) => 'ok $value',
          onFailure: (error, details) => 'falha',
        );

        expect(folded, 'ok 42');
      });

      test('map transforma o valor', () {
        final mapped = result.map((value) => value * 2);

        expect(mapped.value, 84);
      });

      test('getOrElse e getOrElseCompute retornam o valor', () {
        expect(result.getOrElse(0), 42);
        expect(result.getOrElseCompute(() => 0), 42);
      });

      test('toString descreve o sucesso', () {
        expect(result.toString(), 'Result.success(42)');
      });

      test('Success preserva valores nulos de tipos anuláveis', () {
        final nullable = Result<int?>.success(null);

        expect(nullable.isSuccess, isTrue);
        expect(nullable.getOrElse(7), isNull);
      });
    });

    group('falha', () {
      final result = Result<int>.failure(ErrorType.invalidNumber, 'detalhe');

      test('expõe o erro e não possui valor', () {
        expect(result.isFailure, isTrue);
        expect(result.isSuccess, isFalse);
        expect(result.valueOrNull, isNull);
        expect(result.error, ErrorType.invalidNumber);
        expect(result.errorDetails, 'detalhe');
        expect(result.errorMessage, ErrorType.invalidNumber.shortMessage);
        expect(result.errorFullMessage, ErrorType.invalidNumber.fullMessage);
      });

      test('acessar value lança StateError', () {
        expect(() => result.value, throwsStateError);
      });

      test('fold executa onFailure com erro e detalhes', () {
        final folded = result.fold(
          onSuccess: (value) => 'ok',
          onFailure: (error, details) => '${error.name}:$details',
        );

        expect(folded, 'invalidNumber:detalhe');
      });

      test('map preserva o erro sem executar a transformação', () {
        var transformCalled = false;
        final mapped = result.map((value) {
          transformCalled = true;
          return value;
        });

        expect(transformCalled, isFalse);
        expect(mapped.error, ErrorType.invalidNumber);
        expect(mapped.errorDetails, 'detalhe');
      });

      test('getOrElse e getOrElseCompute retornam o padrão', () {
        expect(result.getOrElse(7), 7);
        expect(result.getOrElseCompute(() => 9), 9);
      });

      test('toString descreve a falha com detalhes', () {
        expect(
          result.toString(),
          'Result.failure(${ErrorType.invalidNumber}: detalhe)',
        );
      });

      test('toString descreve a falha sem detalhes', () {
        expect(
          Result<int>.failure(ErrorType.unknown).toString(),
          'Result.failure(${ErrorType.unknown})',
        );
      });
    });

    test('permite pattern matching exaustivo', () {
      String describe(Result<int> result) {
        return switch (result) {
          Success<int>(:final data) => 'sucesso $data',
          Failure<int>(:final errorType) => 'falha ${errorType.name}',
        };
      }

      expect(describe(Result.success(1)), 'sucesso 1');
      expect(describe(Result.failure(ErrorType.unknown)), 'falha unknown');
    });
  });
}
