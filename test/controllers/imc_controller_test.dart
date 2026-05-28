import 'package:calculator_05122025/controllers/imc_controller.dart';
import 'package:calculator_05122025/utils/enums/imc_classification.dart';
import 'package:calculator_05122025/utils/enums/imc_error_type.dart';
import 'package:flutter_test/flutter_test.dart';
import '../mocks/mock_logger_service.dart';

void main() {
  late ImcController controller;

  setUp(() {
    controller = ImcController(logger: MockLoggerService());
  });

  tearDown(() {
    controller.dispose();
  });

  group('estado inicial', () {
    test('weightInput deve estar vazio', () {
      expect(controller.weightInput, '');
    });

    test('heightInput deve estar vazio', () {
      expect(controller.heightInput, '');
    });

    test('result deve ser null', () {
      expect(controller.result, isNull);
    });

    test('errorType deve ser null', () {
      expect(controller.errorType, isNull);
    });

    test('hasResult deve ser false', () {
      expect(controller.hasResult, isFalse);
    });

    test('hasError deve ser false', () {
      expect(controller.hasError, isFalse);
    });
  });

  group('setWeight', () {
    test('deve atualizar weightInput', () {
      controller.setWeight('70');
      expect(controller.weightInput, '70');
    });

    test('deve limpar resultado anterior', () {
      controller.setWeight('70');
      controller.setHeight('170');
      controller.calculate();
      expect(controller.hasResult, isTrue);

      controller.setWeight('80');
      expect(controller.hasResult, isFalse);
    });

    test('deve limpar errorType anterior', () {
      controller.setWeight('0');
      controller.calculate();
      expect(controller.hasError, isTrue);

      controller.setWeight('70');
      expect(controller.hasError, isFalse);
    });

    test('deve notificar listeners', () {
      int count = 0;
      controller.addListener(() => count++);
      controller.setWeight('70');
      expect(count, 1);
    });
  });

  group('setHeight', () {
    test('deve atualizar heightInput', () {
      controller.setHeight('170');
      expect(controller.heightInput, '170');
    });

    test('deve limpar resultado anterior', () {
      controller.setWeight('70');
      controller.setHeight('170');
      controller.calculate();
      expect(controller.hasResult, isTrue);

      controller.setHeight('180');
      expect(controller.hasResult, isFalse);
    });
  });

  group('calculate — casos válidos', () {
    test('70kg 170cm deve produzir IMC normal', () {
      controller.setWeight('70');
      controller.setHeight('170');
      controller.calculate();

      expect(controller.hasResult, isTrue);
      expect(controller.hasError, isFalse);
      expect(controller.result!.classification, ImcClassification.normal);
      expect(controller.result!.imc, closeTo(24.22, 0.01));
    });

    test('50kg 170cm deve produzir underweight', () {
      controller.setWeight('50');
      controller.setHeight('170');
      controller.calculate();

      expect(controller.result!.classification, ImcClassification.underweight);
    });

    test('90kg 170cm deve produzir obesityI', () {
      controller.setWeight('90');
      controller.setHeight('170');
      controller.calculate();

      expect(controller.result!.classification, ImcClassification.obesityI);
    });

    test('deve aceitar vírgula como separador decimal no peso', () {
      controller.setWeight('70,5');
      controller.setHeight('170');
      controller.calculate();

      expect(controller.hasResult, isTrue);
      expect(controller.result!.weightKg, closeTo(70.5, 0.001));
    });

    test('deve aceitar ponto como separador decimal no peso', () {
      controller.setWeight('70.5');
      controller.setHeight('170');
      controller.calculate();

      expect(controller.hasResult, isTrue);
      expect(controller.result!.weightKg, closeTo(70.5, 0.001));
    });

    test('deve aceitar vírgula como separador decimal na altura', () {
      controller.setWeight('70');
      controller.setHeight('170,5');
      controller.calculate();

      expect(controller.hasResult, isTrue);
    });
  });

  group('calculate — validação de peso', () {
    test('peso vazio deve gerar erro de peso inválido', () {
      controller.setHeight('170');
      controller.calculate();

      expect(controller.hasError, isTrue);
      expect(controller.errorType, ImcErrorType.invalidWeight);
    });

    test('peso 0 deve gerar erro', () {
      controller.setWeight('0');
      controller.setHeight('170');
      controller.calculate();

      expect(controller.hasError, isTrue);
    });

    test('peso negativo deve gerar erro', () {
      controller.setWeight('-5');
      controller.setHeight('170');
      controller.calculate();

      expect(controller.hasError, isTrue);
    });

    test('peso 501 deve gerar erro (acima do limite)', () {
      controller.setWeight('501');
      controller.setHeight('170');
      controller.calculate();

      expect(controller.hasError, isTrue);
      expect(controller.errorType, ImcErrorType.invalidWeight);
    });

    test('peso 500 deve ser válido (no limite)', () {
      controller.setWeight('500');
      controller.setHeight('170');
      controller.calculate();

      expect(controller.hasResult, isTrue);
    });
  });

  group('calculate — validação de altura', () {
    test('altura vazia deve gerar erro de altura inválida', () {
      controller.setWeight('70');
      controller.calculate();

      expect(controller.hasError, isTrue);
      expect(controller.errorType, ImcErrorType.invalidHeight);
    });

    test('altura 0 deve gerar erro', () {
      controller.setWeight('70');
      controller.setHeight('0');
      controller.calculate();

      expect(controller.hasError, isTrue);
    });

    test('altura 49 deve gerar erro (abaixo do limite)', () {
      controller.setWeight('70');
      controller.setHeight('49');
      controller.calculate();

      expect(controller.hasError, isTrue);
      expect(controller.errorType, ImcErrorType.invalidHeight);
    });

    test('altura 251 deve gerar erro (acima do limite)', () {
      controller.setWeight('70');
      controller.setHeight('251');
      controller.calculate();

      expect(controller.hasError, isTrue);
    });

    test('altura 50 deve ser válida (no limite inferior)', () {
      controller.setWeight('70');
      controller.setHeight('50');
      controller.calculate();

      expect(controller.hasResult, isTrue);
    });

    test('altura 250 deve ser válida (no limite superior)', () {
      controller.setWeight('70');
      controller.setHeight('250');
      controller.calculate();

      expect(controller.hasResult, isTrue);
    });
  });

  group('reset', () {
    test('deve limpar todos os campos e resultado', () {
      controller.setWeight('70');
      controller.setHeight('170');
      controller.calculate();
      expect(controller.hasResult, isTrue);

      controller.reset();

      expect(controller.weightInput, '');
      expect(controller.heightInput, '');
      expect(controller.result, isNull);
      expect(controller.errorType, isNull);
      expect(controller.hasResult, isFalse);
      expect(controller.hasError, isFalse);
    });

    test('deve notificar listeners ao resetar', () {
      int count = 0;
      controller.addListener(() => count++);
      controller.reset();
      expect(count, 1);
    });
  });
}
