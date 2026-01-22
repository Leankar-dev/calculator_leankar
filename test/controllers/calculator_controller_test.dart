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

    // ============================================
    // TESTES DE EDGE CASES
    // ============================================

    group('Limites de entrada', () {
      test('deve limitar número de dígitos (máximo 15)', () {
        // Tenta adicionar 20 dígitos
        for (int i = 0; i < 20; i++) {
          controller.appendNumber('9');
        }
        // Remove separadores de milhares para contar dígitos
        final digitsOnly = controller.displayText.replaceAll('.', '');
        expect(digitsOnly.length, lessThanOrEqualTo(15));
      });

      test('deve limitar casas decimais', () {
        controller.appendNumber('1');
        controller.appendDecimal();
        // Tenta adicionar 15 dígitos após a vírgula
        for (int i = 0; i < 15; i++) {
          controller.appendNumber('3');
        }
        final parts = controller.displayText.split(',');
        expect(parts.length, 2);
        // O limite é de 15 dígitos no total (não apenas decimais)
        final totalDigits =
            parts[0].replaceAll('.', '').length + parts[1].length;
        expect(totalDigits, lessThanOrEqualTo(15));
      });

      test('não deve permitir múltiplos zeros no início', () {
        controller.appendNumber('0');
        controller.appendNumber('0');
        controller.appendNumber('0');
        expect(controller.displayText, '0');
      });

      test('deve permitir zero após vírgula', () {
        controller.appendDecimal();
        controller.appendNumber('0');
        controller.appendNumber('0');
        controller.appendNumber('5');
        expect(controller.displayText, '0,005');
      });
    });

    group('Comportamento após erro', () {
      test('deve limpar erro ao digitar novo número', () {
        // Causa erro de divisão por zero
        controller.appendNumber('5');
        controller.setOperationType(OperationsType.division);
        controller.appendNumber('0');
        controller.calculateResult();
        expect(controller.displayText, 'Erro: Div/0');

        // Digita novo número
        controller.appendNumber('7');
        expect(controller.displayText, '7');
      });

      test('deve limpar erro ao adicionar decimal', () {
        // Causa erro
        controller.appendNumber('5');
        controller.setOperationType(OperationsType.division);
        controller.appendNumber('0');
        controller.calculateResult();
        expect(controller.displayText, 'Erro: Div/0');

        // Adiciona decimal
        controller.appendDecimal();
        expect(controller.displayText, '0,');
      });

      test('deve limpar erro ao definir operação', () {
        // Causa erro
        controller.appendNumber('5');
        controller.setOperationType(OperationsType.division);
        controller.appendNumber('0');
        controller.calculateResult();
        expect(controller.displayText, 'Erro: Div/0');

        // Define nova operação - limpa o erro e inicia nova operação com 0
        controller.setOperationType(OperationsType.addition);
        expect(controller.displayText, '0');
        // Após limpar erro e definir operação, a expressão mostra "0 +"
        expect(controller.expressionDisplay, '0 +');
      });

      test('deve limpar erro ao pressionar backspace', () {
        // Causa erro
        controller.appendNumber('5');
        controller.setOperationType(OperationsType.division);
        controller.appendNumber('0');
        controller.calculateResult();
        expect(controller.displayText, 'Erro: Div/0');

        // Pressiona backspace
        controller.backspace();
        expect(controller.displayText, '0');
        expect(controller.expressionDisplay, '');
      });

      test('não deve calcular porcentagem em estado de erro', () {
        // Causa erro
        controller.appendNumber('5');
        controller.setOperationType(OperationsType.division);
        controller.appendNumber('0');
        controller.calculateResult();
        expect(controller.displayText, 'Erro: Div/0');

        // Tenta calcular porcentagem
        controller.calculatePercentage();
        expect(controller.displayText, 'Erro: Div/0');
      });
    });

    group('Casos especiais de operação', () {
      test('não deve fazer nada ao pressionar = sem operação pendente', () {
        controller.appendNumber('5');
        controller.calculateResult();
        expect(controller.displayText, '5');
      });

      test('deve manter resultado ao pressionar = múltiplas vezes', () {
        controller.appendNumber('5');
        controller.setOperationType(OperationsType.addition);
        controller.appendNumber('3');
        controller.calculateResult();
        expect(controller.displayText, '8');

        // Pressiona = novamente (não deve mudar, pois operação foi limpa)
        controller.calculateResult();
        expect(controller.displayText, '8');
      });

      test('deve permitir mudar operador antes de digitar segundo número', () {
        controller.appendNumber('1');
        controller.appendNumber('0');
        controller.setOperationType(OperationsType.addition);
        expect(controller.expressionDisplay, '10 +');

        controller.setOperationType(OperationsType.subtraction);
        expect(controller.expressionDisplay, '10 -');

        controller.appendNumber('3');
        controller.calculateResult();
        expect(controller.displayText, '7');
      });

      test('deve calcular 0 dividido por número', () {
        controller.appendNumber('0');
        controller.setOperationType(OperationsType.division);
        controller.appendNumber('5');
        controller.calculateResult();
        expect(controller.displayText, '0');
      });

      test('deve calcular resultado negativo', () {
        controller.appendNumber('3');
        controller.setOperationType(OperationsType.subtraction);
        controller.appendNumber('1');
        controller.appendNumber('0');
        controller.calculateResult();
        expect(controller.displayText, '-7');
      });

      test('deve multiplicar por zero', () {
        controller.appendNumber('9');
        controller.appendNumber('9');
        controller.appendNumber('9');
        controller.setOperationType(OperationsType.multiplication);
        controller.appendNumber('0');
        controller.calculateResult();
        expect(controller.displayText, '0');
      });

      test('deve calcular operação encadeada que resulta em erro', () {
        controller.appendNumber('1');
        controller.setOperationType(OperationsType.subtraction);
        controller.appendNumber('1');
        controller.setOperationType(OperationsType.division);
        // Agora display é 0, então 0 / 0 deveria dar erro? Não, 5 / 0 dá erro
        // Vamos fazer: 5 + 5 = 10, depois / 0
        controller.clearDisplay();
        controller.appendNumber('5');
        controller.setOperationType(OperationsType.addition);
        controller.appendNumber('5');
        controller.setOperationType(OperationsType.division);
        expect(controller.displayText, '10');
        controller.appendNumber('0');
        controller.calculateResult();
        expect(controller.displayText, 'Erro: Div/0');
      });
    });

    group('Casos de borda de entrada', () {
      test('backspace quando display já é 0 deve manter 0', () {
        expect(controller.displayText, '0');
        controller.backspace();
        expect(controller.displayText, '0');
      });

      test('múltiplos backspaces devem parar em 0', () {
        controller.appendNumber('1');
        controller.appendNumber('2');
        controller.backspace();
        controller.backspace();
        controller.backspace();
        controller.backspace();
        expect(controller.displayText, '0');
      });

      test('backspace deve remover vírgula', () {
        controller.appendNumber('5');
        controller.appendDecimal();
        expect(controller.displayText, '5,');
        controller.backspace();
        expect(controller.displayText, '5');
      });

      test('deve iniciar com 0, antes de vírgula quando display é 0', () {
        controller.appendDecimal();
        expect(controller.displayText, '0,');
      });

      test('deve resetar display ao digitar número após resultado', () {
        controller.appendNumber('5');
        controller.setOperationType(OperationsType.addition);
        controller.appendNumber('3');
        controller.calculateResult();
        expect(controller.displayText, '8');

        // Digita novo número
        controller.appendNumber('2');
        expect(controller.displayText, '2');
      });

      test('deve continuar operação com resultado anterior', () {
        controller.appendNumber('5');
        controller.setOperationType(OperationsType.addition);
        controller.appendNumber('3');
        controller.calculateResult();
        expect(controller.displayText, '8');

        // Continua com nova operação
        controller.setOperationType(OperationsType.multiplication);
        controller.appendNumber('2');
        controller.calculateResult();
        expect(controller.displayText, '16');
      });
    });

    group('Histórico', () {
      test('deve carregar histórico vazio inicialmente', () async {
        await controller.loadHistory();
        expect(controller.history, isEmpty);
        expect(controller.isLoading, false);
        expect(controller.hasError, false);
      });

      test('deve adicionar cálculo ao histórico', () async {
        controller.appendNumber('5');
        controller.setOperationType(OperationsType.addition);
        controller.appendNumber('3');
        controller.calculateResult();

        // Aguarda o save assíncrono
        await Future.delayed(const Duration(milliseconds: 100));

        expect(controller.history, hasLength(1));
        expect(controller.history.first.expression, '5 + 3');
        expect(controller.history.first.result, '8');
      });

      test('deve limpar histórico', () async {
        // Adiciona item ao histórico
        controller.appendNumber('2');
        controller.setOperationType(OperationsType.multiplication);
        controller.appendNumber('3');
        controller.calculateResult();

        await Future.delayed(const Duration(milliseconds: 100));
        expect(controller.history, hasLength(1));

        controller.clearHistory();
        expect(controller.history, isEmpty);
      });

      test('deve usar resultado do histórico', () async {
        // Adiciona item ao histórico
        controller.appendNumber('1');
        controller.appendNumber('0');
        controller.setOperationType(OperationsType.addition);
        controller.appendNumber('5');
        controller.calculateResult();

        await Future.delayed(const Duration(milliseconds: 100));
        expect(controller.history, hasLength(1));

        // Limpa e usa o histórico
        controller.clearDisplay();
        controller.useHistoryResult(controller.history.first);

        expect(controller.displayText, '15');
        expect(controller.expressionDisplay, '');
      });

      test('deve tratar erro ao carregar histórico', () async {
        mockStorageService.shouldFail = true;
        await controller.loadHistory();

        expect(controller.history, isEmpty);
        expect(controller.hasError, true);
        expect(controller.isLoading, false);
      });

      test('não deve adicionar erro ao histórico', () async {
        controller.appendNumber('5');
        controller.setOperationType(OperationsType.division);
        controller.appendNumber('0');
        controller.calculateResult();

        await Future.delayed(const Duration(milliseconds: 100));

        expect(controller.history, isEmpty);
      });
    });

    group('Overflow e validação', () {
      test('deve mostrar erro de overflow para números muito grandes', () {
        // 1e15 * 100 > limite (precisa exceder 1e15)
        controller.appendNumber('1');
        for (int i = 0; i < 14; i++) {
          controller.appendNumber('0');
        }
        controller.setOperationType(OperationsType.multiplication);
        controller.appendNumber('1');
        controller.appendNumber('0');
        controller.appendNumber('0');
        controller.calculateResult();

        expect(controller.displayText, 'Erro: Overflow');
      });

      test('deve usar notação científica para números grandes permitidos', () {
        // Número >= 1e12 usa notação científica (scientificThresholdLarge)
        controller.appendNumber('1');
        for (int i = 0; i < 12; i++) {
          controller.appendNumber('0');
        }
        // 1e12 * 1 = 1e12
        controller.setOperationType(OperationsType.multiplication);
        controller.appendNumber('1');
        controller.calculateResult();

        // Deve usar notação científica
        expect(controller.displayText.contains('e'), isTrue);
      });
    });

    group('Edge cases de porcentagem', () {
      test('porcentagem de 0 deve ser 0', () {
        expect(controller.displayText, '0');
        controller.calculatePercentage();
        expect(controller.displayText, '0');
      });

      test('porcentagem de 100 deve ser 1', () {
        controller.appendNumber('1');
        controller.appendNumber('0');
        controller.appendNumber('0');
        controller.calculatePercentage();
        expect(controller.displayText, '1');
      });

      test('porcentagem em operação de subtração', () {
        // 200 - 50% = 200 - 100 = 100
        controller.appendNumber('2');
        controller.appendNumber('0');
        controller.appendNumber('0');
        controller.setOperationType(OperationsType.subtraction);
        controller.appendNumber('5');
        controller.appendNumber('0');
        controller.calculatePercentage();
        expect(controller.displayText, '100');
      });

      test('porcentagem decimal', () {
        controller.appendNumber('5');
        controller.appendNumber('0');
        controller.appendDecimal();
        controller.appendNumber('5');
        controller.calculatePercentage();
        expect(controller.displayText, '0,505');
      });
    });

    group('Operações com decimais edge cases', () {
      test('deve calcular divisão com resultado decimal longo', () {
        controller.appendNumber('1');
        controller.setOperationType(OperationsType.division);
        controller.appendNumber('3');
        controller.calculateResult();

        // Deve ter vírgula e casas decimais limitadas
        expect(controller.displayText.contains(','), isTrue);
        final parts = controller.displayText.split(',');
        expect(parts[1].length, lessThanOrEqualTo(8));
      });

      test('deve remover zeros desnecessários do resultado', () {
        controller.appendNumber('2');
        controller.appendDecimal();
        controller.appendNumber('5');
        controller.setOperationType(OperationsType.multiplication);
        controller.appendNumber('2');
        controller.calculateResult();

        expect(controller.displayText, '5');
      });

      test('deve manter precisão em operações decimais', () {
        controller.appendNumber('0');
        controller.appendDecimal();
        controller.appendNumber('1');
        controller.setOperationType(OperationsType.addition);
        controller.appendNumber('0');
        controller.appendDecimal();
        controller.appendNumber('2');
        controller.calculateResult();

        expect(controller.displayText, '0,3');
      });
    });
  });
}
