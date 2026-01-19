import 'package:calculator_05122025/controllers/calculator_controller.dart';
import 'package:calculator_05122025/utils/enums/operations_type.dart';
import 'package:flutter_test/flutter_test.dart';

import '../mocks/mock_storage_service.dart';

void main() {
  late CalculatorController controller;
  late MockStorageService mockStorageService;

  setUp(() {
    mockStorageService = MockStorageService();
    controller = CalculatorController(storageService: mockStorageService);
  });

  group('CalculatorController', () {
    group('Estado inicial', () {
      test('displayText deve ser "0" inicialmente', () {
        expect(controller.displayText, '0');
      });

      test('expressionDisplay deve ser vazio inicialmente', () {
        expect(controller.expressionDisplay, '');
      });
    });

    group('appendNumber', () {
      test('deve substituir 0 por número digitado', () {
        controller.appendNumber('5');
        expect(controller.displayText, '5');
      });

      test('deve concatenar números', () {
        controller.appendNumber('1');
        controller.appendNumber('2');
        controller.appendNumber('3');
        expect(controller.displayText, '123');
      });

      test('deve permitir múltiplos zeros após outro número', () {
        controller.appendNumber('1');
        controller.appendNumber('0');
        controller.appendNumber('0');
        expect(controller.displayText, '100');
      });
    });

    group('appendDecimal', () {
      test('deve adicionar vírgula ao número', () {
        controller.appendNumber('5');
        controller.appendDecimal();
        expect(controller.displayText, '5,');
      });

      test('não deve adicionar vírgula duplicada', () {
        controller.appendNumber('5');
        controller.appendDecimal();
        controller.appendDecimal();
        expect(controller.displayText, '5,');
      });

      test('deve adicionar "0," quando display está em 0', () {
        controller.appendDecimal();
        expect(controller.displayText, '0,');
      });
    });

    group('clearDisplay', () {
      test('deve resetar para estado inicial', () {
        controller.appendNumber('1');
        controller.appendNumber('2');
        controller.appendNumber('3');
        controller.clearDisplay();
        expect(controller.displayText, '0');
        expect(controller.expressionDisplay, '');
      });
    });

    group('backspace', () {
      test('deve remover último dígito', () {
        controller.appendNumber('1');
        controller.appendNumber('2');
        controller.appendNumber('3');
        controller.backspace();
        expect(controller.displayText, '12');
      });

      test('deve mostrar 0 quando apenas um dígito resta', () {
        controller.appendNumber('5');
        controller.backspace();
        expect(controller.displayText, '0');
      });
    });

    group('Operações aritméticas', () {
      test('deve realizar adição corretamente', () {
        controller.appendNumber('5');
        controller.setOperationType(OperationsType.addition);
        controller.appendNumber('3');
        controller.calculateResult();
        expect(controller.displayText, '8');
      });

      test('deve realizar subtração corretamente', () {
        controller.appendNumber('1');
        controller.appendNumber('0');
        controller.setOperationType(OperationsType.subtraction);
        controller.appendNumber('4');
        controller.calculateResult();
        expect(controller.displayText, '6');
      });

      test('deve realizar multiplicação corretamente', () {
        controller.appendNumber('6');
        controller.setOperationType(OperationsType.multiplication);
        controller.appendNumber('7');
        controller.calculateResult();
        expect(controller.displayText, '42');
      });

      test('deve realizar divisão corretamente', () {
        controller.appendNumber('2');
        controller.appendNumber('0');
        controller.setOperationType(OperationsType.division);
        controller.appendNumber('4');
        controller.calculateResult();
        expect(controller.displayText, '5');
      });

      test('deve mostrar erro na divisão por zero', () {
        controller.appendNumber('5');
        controller.setOperationType(OperationsType.division);
        controller.appendNumber('0');
        controller.calculateResult();
        expect(controller.displayText, 'Erro: Div/0');
      });

      test('deve mostrar expressão durante operação', () {
        controller.appendNumber('5');
        controller.setOperationType(OperationsType.addition);
        expect(controller.expressionDisplay, '5 +');
      });
    });

    group('calculatePercentage', () {
      test('deve calcular porcentagem simples', () {
        controller.appendNumber('5');
        controller.appendNumber('0');
        controller.calculatePercentage();
        expect(controller.displayText, '0,5');
      });

      test('deve calcular porcentagem em operação', () {
        controller.appendNumber('2');
        controller.appendNumber('0');
        controller.appendNumber('0');
        controller.setOperationType(OperationsType.addition);
        controller.appendNumber('1');
        controller.appendNumber('0');
        controller.calculatePercentage();
        expect(controller.displayText, '20');
      });
    });

    group('Operações encadeadas', () {
      test('deve realizar operações em sequência', () {
        controller.appendNumber('5');
        controller.setOperationType(OperationsType.addition);
        controller.appendNumber('5');
        controller.setOperationType(OperationsType.multiplication);
        expect(controller.displayText, '10');
        controller.appendNumber('2');
        controller.calculateResult();
        expect(controller.displayText, '20');
      });
    });

    group('Números decimais', () {
      test('deve operar com números decimais', () {
        controller.appendNumber('2');
        controller.appendDecimal();
        controller.appendNumber('5');
        controller.setOperationType(OperationsType.multiplication);
        controller.appendNumber('4');
        controller.calculateResult();
        expect(controller.displayText, '10');
      });

      test('deve formatar resultado decimal corretamente', () {
        controller.appendNumber('1');
        controller.setOperationType(OperationsType.division);
        controller.appendNumber('4');
        controller.calculateResult();
        expect(controller.displayText, '0,25');
      });
    });

    group('Notificações', () {
      test('deve notificar listeners ao mudar estado', () {
        int notifyCount = 0;
        controller.addListener(() => notifyCount++);

        controller.appendNumber('5');
        expect(notifyCount, 1);

        controller.setOperationType(OperationsType.addition);
        expect(notifyCount, 2);

        controller.appendNumber('3');
        expect(notifyCount, 3);

        controller.calculateResult();
        expect(notifyCount, 4);
      });
    });
  });
}
