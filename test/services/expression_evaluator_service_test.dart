import 'package:calculator_05122025/services/expression_evaluator_service.dart';
import 'package:calculator_05122025/utils/enums/angle_mode.dart';
import 'package:calculator_05122025/utils/enums/scientific_error_type.dart';
import 'package:calculator_05122025/utils/exceptions/scientific_calculation_exception.dart';
import 'package:flutter_test/flutter_test.dart';

Matcher _hasErrorType(ScientificErrorType errorType) {
  return isA<ScientificCalculationException>().having(
    (e) => e.errorType,
    'errorType',
    errorType,
  );
}

void main() {
  late ExpressionEvaluatorService evaluator;

  setUp(() {
    evaluator = ExpressionEvaluatorService();
  });

  group('ExpressionEvaluatorService — integração (casos da seção 7)', () {
    test('soma simples: 2 + 3 = 5', () {
      expect(evaluator.evaluate('2 + 3', AngleMode.deg), 5);
    });

    test('precedência: 2 + 3 × 4 = 14', () {
      expect(evaluator.evaluate('2 + 3 × 4', AngleMode.deg), 14);
    });

    test('parênteses: (2 + 3) × 4 = 20', () {
      expect(evaluator.evaluate('(2 + 3) × 4', AngleMode.deg), 20);
    });

    test('sin DEG: sin(30) = 0,5', () {
      expect(evaluator.evaluate('sin(30)', AngleMode.deg), closeTo(0.5, 1e-9));
    });

    test('sin RAD: sin(π÷6) ≈ 0,5', () {
      expect(
        evaluator.evaluate('sin(π÷6)', AngleMode.rad),
        closeTo(0.5, 1e-6),
      );
    });

    test('arcsin DEG converte de volta: sin⁻¹(0,5) = 30', () {
      expect(evaluator.evaluate('asin(0,5)', AngleMode.deg), closeTo(30, 1e-6));
    });

    test('log base 10: log(100) = 2', () {
      expect(evaluator.evaluate('log(100)', AngleMode.deg), closeTo(2, 1e-9));
    });

    test('ln(e) = 1', () {
      expect(evaluator.evaluate('ln(e)', AngleMode.deg), closeTo(1, 1e-9));
    });

    test('potência: 2^10 = 1024', () {
      expect(evaluator.evaluate('2^10', AngleMode.deg), 1024);
    });

    test('raiz quadrada: √(9) = 3', () {
      expect(evaluator.evaluate('√(9)', AngleMode.deg), closeTo(3, 1e-9));
    });

    test('fatorial: 5! = 120', () {
      expect(evaluator.evaluate('5!', AngleMode.deg), 120);
    });

    test('constante π', () {
      expect(
        evaluator.evaluate('π', AngleMode.deg),
        closeTo(3.14159265, 1e-8),
      );
    });

    test('domínio inválido: log(-1)', () {
      expect(
        () => evaluator.evaluate('log(-1)', AngleMode.deg),
        throwsA(_hasErrorType(ScientificErrorType.domainError)),
      );
    });

    test('divisão por zero: 5 ÷ 0', () {
      expect(
        () => evaluator.evaluate('5 ÷ 0', AngleMode.deg),
        throwsA(_hasErrorType(ScientificErrorType.divisionByZero)),
      );
    });

    test('parênteses desbalanceados (abertura sem fechamento)', () {
      expect(
        () => evaluator.evaluate('(2 + 3', AngleMode.deg),
        throwsA(_hasErrorType(ScientificErrorType.unbalancedParens)),
      );
    });

    test('parênteses desbalanceados (fechamento sem abertura)', () {
      expect(
        () => evaluator.evaluate('2 + 3)', AngleMode.deg),
        throwsA(_hasErrorType(ScientificErrorType.unbalancedParens)),
      );
    });

    test('fatorial overflow: 200!', () {
      expect(
        () => evaluator.evaluate('200!', AngleMode.deg),
        throwsA(_hasErrorType(ScientificErrorType.factorialOverflow)),
      );
    });

    test('encadeamento de funções em RAD: sin(cos(0)) ≈ 0,8415', () {
      expect(
        evaluator.evaluate('sin(cos(0))', AngleMode.rad),
        closeTo(0.8415, 1e-4),
      );
    });

    test('notação científica: 1,5e3 + 500 = 2000', () {
      expect(evaluator.evaluate('1,5e3 + 500', AngleMode.deg), 2000);
    });

    test('pós-fixo após binário: 2 + 3! = 8', () {
      expect(evaluator.evaluate('2 + 3!', AngleMode.deg), 8);
    });

    test('pós-fixos encadeados: 3²! = 362880', () {
      expect(evaluator.evaluate('3²!', AngleMode.deg), 362880);
    });

    test('pós-fixo após parênteses: (2+3)! = 120', () {
      expect(evaluator.evaluate('(2+3)!', AngleMode.deg), 120);
    });

    test('pós-fixo após função-prefixo: √(16)! = 24', () {
      expect(evaluator.evaluate('√(16)!', AngleMode.deg), 24);
    });

    test('pós-fixo após função com sinal unário dentro: abs(-5)² = 25', () {
      expect(evaluator.evaluate('abs(-5)²', AngleMode.deg), 25);
    });

    test('sinal unário + pós-fixo: -3! = -6', () {
      expect(evaluator.evaluate('-3!', AngleMode.deg), -6);
    });

    test('sinal unário + potência: -3^2 = -9', () {
      expect(evaluator.evaluate('-3^2', AngleMode.deg), -9);
    });

    test('sinal unário encadeado 3×: ---3 = -3', () {
      expect(evaluator.evaluate('---3', AngleMode.deg), -3);
    });

    test('expoente negativo digitado após ^: 2^-3 = 0,125', () {
      expect(evaluator.evaluate('2^-3', AngleMode.deg), closeTo(0.125, 1e-9));
    });

    test(
      'inversa trig dentro de expressão maior: asin(0,5) + 10 = 40 em DEG',
      () {
        expect(
          evaluator.evaluate('asin(0,5) + 10', AngleMode.deg),
          closeTo(40, 1e-6),
        );
      },
    );

    test('2e3 é notação científica, não 2 × e', () {
      expect(evaluator.evaluate('2e3', AngleMode.deg), 2000);
    });

    test('2 + e usa a constante de Euler', () {
      expect(
        evaluator.evaluate('2 + e', AngleMode.deg),
        closeTo(4.71828, 1e-5),
      );
    });

    test(
      'fatorial com imprecisão de ponto flutuante: (0,1 × 10 × 5)! = 120',
      () {
        expect(evaluator.evaluate('(0,1 × 10 × 5)!', AngleMode.deg), 120);
      },
    );

    test('multiplicação implícita: número + constante: 2π', () {
      expect(evaluator.evaluate('2π', AngleMode.deg), closeTo(6.28318, 1e-5));
    });

    test('multiplicação implícita: constante + número: π2', () {
      expect(evaluator.evaluate('π2', AngleMode.deg), closeTo(6.28318, 1e-5));
    });

    test('multiplicação implícita: constante + função: πsin(30) em DEG', () {
      expect(
        evaluator.evaluate('πsin(30)', AngleMode.deg),
        closeTo(1.5707963, 1e-6),
      );
    });

    test('multiplicação implícita: constante + parêntese: π(2+3)', () {
      expect(
        evaluator.evaluate('π(2+3)', AngleMode.deg),
        closeTo(15.70796, 1e-5),
      );
    });

    test('multiplicação implícita: número + função: 3sin(30) em DEG', () {
      expect(
        evaluator.evaluate('3sin(30)', AngleMode.deg),
        closeTo(1.5, 1e-9),
      );
    });

    test('multiplicação implícita: parênteses adjacentes: (2+3)(4+5) = 45', () {
      expect(evaluator.evaluate('(2+3)(4+5)', AngleMode.deg), 45);
    });

    test('multiplicação implícita: pós-fixo + número: 3!2 = 12', () {
      expect(evaluator.evaluate('3!2', AngleMode.deg), 12);
    });

    test('multiplicação implícita + sinal unário sem colisão: 2(-3) = -6', () {
      expect(evaluator.evaluate('2(-3)', AngleMode.deg), -6);
    });
  });
}
