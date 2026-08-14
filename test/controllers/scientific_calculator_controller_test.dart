import 'package:calculator_05122025/controllers/scientific_calculator_controller.dart';
import 'package:calculator_05122025/utils/enums/angle_mode.dart';
import 'package:calculator_05122025/utils/enums/scientific_error_type.dart';
import 'package:calculator_05122025/utils/enums/scientific_function_type.dart';
import 'package:calculator_05122025/utils/exceptions/scientific_calculation_exception.dart';
import 'package:flutter_test/flutter_test.dart';

import '../mocks/mock_expression_evaluator_service.dart';
import '../mocks/mock_logger_service.dart';

void main() {
  late ScientificCalculatorController controller;
  late MockExpressionEvaluatorService mockEvaluator;
  late MockLoggerService mockLogger;

  setUp(() {
    mockEvaluator = MockExpressionEvaluatorService();
    mockLogger = MockLoggerService();
    controller = ScientificCalculatorController(
      evaluator: mockEvaluator,
      logger: mockLogger,
    );
  });

  group('ScientificCalculatorController', () {
    group('Estado inicial', () {
      test('expressionDisplay começa vazio', () {
        expect(controller.expressionDisplay, '');
      });

      test('resultDisplay começa em 0', () {
        expect(controller.resultDisplay, '0');
      });

      test('isShiftActive e isShiftLocked começam desligados', () {
        expect(controller.isShiftActive, false);
        expect(controller.isShiftLocked, false);
      });

      test('angleMode começa em DEG', () {
        expect(controller.angleMode, AngleMode.deg);
      });

      test('hasError começa falso', () {
        expect(controller.hasError, false);
      });
    });

    group('appendNumber / appendDecimal', () {
      test('primeiro dígito substitui o 0 inicial', () {
        mockEvaluator.resultToReturn = 5;
        controller.appendNumber('5');
        expect(controller.expressionDisplay, '5');
      });

      test('dígitos seguintes concatenam', () {
        mockEvaluator.resultToReturn = 123;
        controller.appendNumber('1');
        controller.appendNumber('2');
        controller.appendNumber('3');
        expect(controller.expressionDisplay, '123');
      });

      test('appendDecimal adiciona separador decimal uma única vez', () {
        mockEvaluator.resultToReturn = 1.5;
        controller.appendNumber('1');
        controller.appendDecimal();
        controller.appendNumber('5');
        controller.appendDecimal();
        expect(controller.expressionDisplay, '1,5');
      });

      test('0 digitado como primeiro dígito de um novo número não some', () {
        mockEvaluator.resultToReturn = 5;
        controller.appendNumber('5');
        controller.setBinaryOperator('+');
        mockEvaluator.resultToReturn = 5;
        controller.appendNumber('0');
        expect(controller.expressionDisplay, '5 + 0');
      });

      test('appendNumber depois de erro limpa e recomeça', () {
        mockEvaluator.exceptionToThrow = const ScientificCalculationException(
          ScientificErrorType.domainError,
        );
        controller.appendNumber('1');
        controller.calculateResult();
        expect(controller.hasError, true);

        mockEvaluator.exceptionToThrow = null;
        mockEvaluator.resultToReturn = 7;
        controller.appendNumber('7');
        expect(controller.hasError, false);
        expect(controller.expressionDisplay, '7');
      });
    });

    group('calculatePercentage', () {
      test('divide o valor em edição por 100', () {
        mockEvaluator.resultToReturn = 0.5;
        controller.appendNumber('5');
        controller.appendNumber('0');
        controller.calculatePercentage();
        expect(controller.expressionDisplay, '0,5');
      });

      test('sem nada em edição não faz nada', () {
        controller.calculatePercentage();
        expect(controller.expressionDisplay, '');
      });
    });

    group('openParen / closeParen', () {
      test('parênteses aparecem na expressão', () {
        mockEvaluator.resultToReturn = 5;
        controller.openParen();
        controller.appendNumber('2');
        controller.setBinaryOperator('+');
        controller.appendNumber('3');
        controller.closeParen();
        expect(controller.expressionDisplay, '(2 + 3)');
      });
    });

    group('appendFunction — funções-prefixo', () {
      test('sin( não tenta avaliar (guarda de posição do preview)', () {
        controller.appendFunction(ScientificFunctionType.sin);
        expect(controller.expressionDisplay, 'sin(');
        expect(mockEvaluator.callCount, 0);
        expect(controller.resultDisplay, '0');
      });

      test('fechar o parêntese já avalia normalmente', () {
        controller.appendFunction(ScientificFunctionType.sin);
        mockEvaluator.resultToReturn = 0.5;
        controller.appendNumber('3');
        controller.appendNumber('0');
        controller.closeParen();
        expect(controller.expressionDisplay, 'sin(30)');
        expect(controller.resultDisplay, '0,5');
      });

      test('auto-closure no preview fecha parênteses pendentes', () {
        controller.appendFunction(ScientificFunctionType.sin);
        mockEvaluator.resultToReturn = 0.5;
        controller.appendNumber('3');
        expect(mockEvaluator.lastExpression, 'sin(3)');
      });

      test('asin( é diferente de sin(', () {
        controller.appendFunction(ScientificFunctionType.asin);
        expect(controller.expressionDisplay, 'asin(');
      });
    });

    group('appendFunction — pós-fixos', () {
      test('fatorial aplica direto ao número digitado', () {
        mockEvaluator.resultToReturn = 120;
        controller.appendNumber('5');
        controller.appendFunction(ScientificFunctionType.factorial);
        expect(controller.expressionDisplay, '5!');
      });

      test('quadrado', () {
        mockEvaluator.resultToReturn = 16;
        controller.appendNumber('4');
        controller.appendFunction(ScientificFunctionType.square);
        expect(controller.expressionDisplay, '4²');
      });
    });

    group('appendFunction — açúcar 10^x / e^x', () {
      test('10^x insere número 10 e o operador ^', () {
        mockEvaluator.resultToReturn = 1000;
        controller.appendFunction(ScientificFunctionType.exp10);
        controller.appendNumber('3');
        expect(controller.expressionDisplay, '10 ^ 3');
      });

      test('e^x insere a constante e e o operador ^', () {
        mockEvaluator.resultToReturn = 1;
        controller.appendFunction(ScientificFunctionType.expE);
        controller.appendNumber('0');
        expect(controller.expressionDisplay, 'e ^ 0');
      });
    });

    group('appendFunction — SHIFT auto-reset', () {
      test(
        'toque momentâneo desliga sozinho após função com variante SHIFT',
        () {
          controller.toggleShift();
          expect(controller.isShiftActive, true);
          controller.appendFunction(ScientificFunctionType.asin);
          expect(controller.isShiftActive, false);
        },
      );

      test('lockShift mantém isShiftActive ligado entre múltiplas funções', () {
        controller.lockShift();
        expect(controller.isShiftActive, true);
        expect(controller.isShiftLocked, true);
        controller.appendFunction(ScientificFunctionType.asin);
        expect(controller.isShiftActive, true);
        controller.appendFunction(ScientificFunctionType.acos);
        expect(controller.isShiftActive, true);
      });
    });

    group('appendConstant', () {
      test('π isolado', () {
        mockEvaluator.resultToReturn = 3.14;
        controller.appendConstant('π');
        expect(controller.expressionDisplay, 'π');
      });

      test('número seguido de constante insere × na exibição', () {
        mockEvaluator.resultToReturn = 6.28;
        controller.appendNumber('2');
        controller.appendConstant('π');
        expect(controller.expressionDisplay, '2 × π');
      });
    });

    group('setBinaryOperator — sinal unário', () {
      test('- no início vira sinal unário, não operador binário', () {
        controller.setBinaryOperator('-');
        controller.appendNumber('3');
        expect(controller.expressionDisplay, '-3');
      });

      test('- depois de um número é subtração binária', () {
        mockEvaluator.resultToReturn = -2;
        controller.appendNumber('3');
        controller.setBinaryOperator('-');
        controller.appendNumber('5');
        expect(controller.expressionDisplay, '3 - 5');
      });

      test('- depois de um pós-fixo é subtração binária', () {
        controller.appendNumber('3');
        controller.appendFunction(ScientificFunctionType.factorial);
        mockEvaluator.resultToReturn = 1;
        controller.setBinaryOperator('-');
        controller.appendNumber('5');
        expect(controller.expressionDisplay, '3! - 5');
      });

      test('--3 encadeia dois sinais unários', () {
        controller.setBinaryOperator('-');
        controller.setBinaryOperator('-');
        controller.appendNumber('3');
        expect(controller.expressionDisplay, '--3');
      });
    });

    group('setBinaryOperator — xʸ e nPr desligam SHIFT quando não travado', () {
      test('xʸ (^) desliga SHIFT momentâneo após uso', () {
        controller.toggleShift();
        controller.appendNumber('2');
        controller.setBinaryOperator('^');
        expect(controller.isShiftActive, false);
      });

      test('nPr (P) desliga SHIFT momentâneo após uso', () {
        controller.toggleShift();
        controller.appendNumber('5');
        controller.setBinaryOperator('P');
        expect(controller.isShiftActive, false);
      });

      test('+ não mexe no SHIFT', () {
        controller.toggleShift();
        controller.appendNumber('2');
        controller.setBinaryOperator('+');
        expect(controller.isShiftActive, true);
      });
    });

    group('calculateResult', () {
      test('sucesso: mostra resultado formatado e reseta a expressão', () {
        mockEvaluator.resultToReturn = 5;
        controller.appendNumber('2');
        controller.setBinaryOperator('+');
        controller.appendNumber('3');
        controller.calculateResult();
        expect(controller.resultDisplay, '5');
        expect(controller.expressionDisplay, '5');
      });

      test('resultado vira ponto de partida para o próximo cálculo', () {
        mockEvaluator.resultToReturn = 5;
        controller.appendNumber('2');
        controller.setBinaryOperator('+');
        controller.appendNumber('3');
        controller.calculateResult();

        mockEvaluator.resultToReturn = 15;
        controller.setBinaryOperator('×');
        controller.appendNumber('3');
        expect(mockEvaluator.lastExpression, '5 × 3');
      });

      test(
        'erro: liga hasError e não altera resultDisplay/expressionDisplay para o inválido',
        () {
          mockEvaluator.exceptionToThrow = const ScientificCalculationException(
            ScientificErrorType.divisionByZero,
          );
          controller.appendNumber('5');
          controller.setBinaryOperator('÷');
          controller.appendNumber('0');
          controller.calculateResult();
          expect(controller.hasError, true);
          expect(
            controller.state.errorType,
            ScientificErrorType.divisionByZero,
          );
          expect(controller.resultDisplay, '0');
          expect(controller.expressionDisplay, '');
        },
      );

      test('= sem nada digitado não faz nada', () {
        controller.calculateResult();
        expect(mockEvaluator.callCount, 0);
        expect(controller.resultDisplay, '0');
      });

      test('= em estado de erro não faz nada', () {
        mockEvaluator.exceptionToThrow = const ScientificCalculationException(
          ScientificErrorType.syntaxError,
        );
        controller.appendNumber('1');
        controller.calculateResult();
        final callsAfterError = mockEvaluator.callCount;
        controller.calculateResult();
        expect(mockEvaluator.callCount, callsAfterError);
      });
    });

    group('backspace', () {
      test('remove um caractere de currentInput em digitação', () {
        mockEvaluator.resultToReturn = 12;
        controller.appendNumber('1');
        controller.appendNumber('2');
        controller.appendNumber('3');
        controller.backspace();
        expect(controller.expressionDisplay, '12');
      });

      test('remove o último token quando currentInput já está resetado', () {
        mockEvaluator.resultToReturn = 5;
        controller.appendNumber('5');
        controller.setBinaryOperator('+');
        controller.backspace();
        expect(controller.expressionDisplay, '5');
      });

      test(
        'remove o par unaryFunction + openParen de uma função recém-aberta',
        () {
          controller.appendFunction(ScientificFunctionType.sin);
          expect(controller.expressionDisplay, 'sin(');
          controller.backspace();
          expect(controller.expressionDisplay, '');
        },
      );

      test('não remove o par se já houver conteúdo dentro dos parênteses', () {
        controller.appendFunction(ScientificFunctionType.sin);
        mockEvaluator.resultToReturn = 0;
        controller.appendNumber('3');
        controller.backspace();
        expect(controller.expressionDisplay, 'sin(');
      });

      test('backspace em estado inicial não faz nada', () {
        controller.backspace();
        expect(controller.expressionDisplay, '');
      });
    });

    group('clearAll', () {
      test(
        'limpa a expressão mas preserva memória, ângulo e SHIFT travado',
        () {
          mockEvaluator.resultToReturn = 7;
          controller.appendNumber('7');
          controller.memoryAdd();
          controller.toggleAngleMode();
          controller.lockShift();

          controller.appendNumber('9');
          controller.clearAll();

          expect(controller.expressionDisplay, '');
          expect(controller.state.hasMemoryValue, true);
          expect(controller.state.memoryValue, 7);
          expect(controller.angleMode, AngleMode.rad);
          expect(controller.isShiftLocked, true);
        },
      );
    });

    group('Memória', () {
      test('M+ soma o último resultDisplay válido à memória', () {
        mockEvaluator.resultToReturn = 5;
        controller.appendNumber('5');
        controller.memoryAdd();
        expect(controller.state.hasMemoryValue, true);
        expect(controller.state.memoryValue, 5);
      });

      test('M- subtrai o último resultDisplay válido da memória', () {
        mockEvaluator.resultToReturn = 10;
        controller.appendNumber('1');
        controller.appendNumber('0');
        controller.memoryAdd();

        mockEvaluator.resultToReturn = 4;
        controller.clearAll();
        controller.appendNumber('4');
        controller.memorySubtract();

        expect(controller.state.memoryValue, 6);
      });

      test('M+ sem expressão válida é ignorado', () {
        controller.memoryAdd();
        expect(controller.state.hasMemoryValue, false);
      });

      test('MC zera a memória sem alterar a expressão em edição', () {
        mockEvaluator.resultToReturn = 5;
        controller.appendNumber('5');
        controller.memoryAdd();
        controller.clearAll();

        mockEvaluator.resultToReturn = 9;
        controller.appendNumber('9');
        controller.memoryClear();
        expect(controller.state.hasMemoryValue, false);
        expect(controller.state.memoryValue, 0);
        expect(controller.expressionDisplay, '9');
      });

      test('MR desabilitado (sem efeito) quando não há memória guardada', () {
        controller.appendNumber('2');
        controller.memoryRecall();
        expect(controller.expressionDisplay, '2');
      });

      test('MR insere valor canônico, sem separador de milhar', () {
        mockEvaluator.resultToReturn = 1500;
        controller.appendNumber('1');
        controller.appendNumber('5');
        controller.appendNumber('0');
        controller.appendNumber('0');
        controller.memoryAdd();

        controller.clearAll();
        mockEvaluator.resultToReturn = 1501;
        controller.setBinaryOperator('+');
        controller.appendNumber('1');
        controller.memoryRecall();
        expect(mockEvaluator.lastExpression, contains('1500'));
        expect(mockEvaluator.lastExpression, isNot(contains('1.500')));
      });

      test(
        'MR depois de um número já completo produz multiplicação implícita',
        () {
          mockEvaluator.resultToReturn = 5;
          controller.appendNumber('5');
          controller.memoryAdd();

          controller.clearAll();
          controller.appendNumber('2');
          mockEvaluator.resultToReturn = 10;
          controller.memoryRecall();
          expect(controller.expressionDisplay, '2 × 5');
        },
      );
    });

    group('Preview em tempo real', () {
      test(
        'erro no preview mantém o último valor válido, sem propagar exceção',
        () {
          mockEvaluator.resultToReturn = 5;
          controller.appendNumber('5');
          expect(controller.resultDisplay, '5');

          mockEvaluator.exceptionToThrow = const ScientificCalculationException(
            ScientificErrorType.syntaxError,
          );
          controller.setBinaryOperator('+');
          controller.appendNumber('3');
          expect(controller.resultDisplay, '5');
          expect(controller.hasError, false);
        },
      );

      test(
        'guarda: não avalia enquanto espera operando após operador binário',
        () {
          mockEvaluator.resultToReturn = 5;
          controller.appendNumber('5');
          final callsBefore = mockEvaluator.callCount;
          controller.setBinaryOperator('+');
          expect(mockEvaluator.callCount, callsBefore);
        },
      );

      test('guarda: não avalia logo após sinal unário', () {
        controller.setBinaryOperator('-');
        expect(mockEvaluator.callCount, 0);
      });
    });
  });
}
