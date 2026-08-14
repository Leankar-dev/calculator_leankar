import 'dart:math' as math;

import 'package:calculator_05122025/models/expression_token.dart';
import 'package:calculator_05122025/services/rpn_evaluator_service.dart';
import 'package:calculator_05122025/utils/enums/angle_mode.dart';
import 'package:calculator_05122025/utils/enums/scientific_error_type.dart';
import 'package:calculator_05122025/utils/enums/token_type.dart';
import 'package:calculator_05122025/utils/exceptions/scientific_calculation_exception.dart';
import 'package:flutter_test/flutter_test.dart';

ExpressionToken _number(String value) =>
    ExpressionToken(type: TokenType.number, value: value);

ExpressionToken _op(String value) =>
    ExpressionToken(type: TokenType.binaryOperator, value: value);

ExpressionToken _postfix(String value) =>
    ExpressionToken(type: TokenType.postfixOperator, value: value);

ExpressionToken _unaryMinus() =>
    const ExpressionToken(type: TokenType.unaryMinus, value: '-');

ExpressionToken _function(String value) =>
    ExpressionToken(type: TokenType.unaryFunction, value: value);

ExpressionToken _constant(String value) =>
    ExpressionToken(type: TokenType.constant, value: value);

Matcher _hasErrorType(ScientificErrorType errorType) {
  return isA<ScientificCalculationException>().having(
    (e) => e.errorType,
    'errorType',
    errorType,
  );
}

void main() {
  late RpnEvaluatorService evaluator;

  setUp(() {
    evaluator = RpnEvaluatorService();
  });

  group('RpnEvaluatorService', () {
    group('Operadores binários', () {
      test('soma', () {
        final result = evaluator.evaluate(
          [_number('2'), _number('3'), _op('+')],
          AngleMode.deg,
        );
        expect(result, 5);
      });

      test('subtração', () {
        final result = evaluator.evaluate(
          [_number('10'), _number('3'), _op('-')],
          AngleMode.deg,
        );
        expect(result, 7);
      });

      test('multiplicação', () {
        final result = evaluator.evaluate(
          [_number('4'), _number('5'), _op('×')],
          AngleMode.deg,
        );
        expect(result, 20);
      });

      test('divisão', () {
        final result = evaluator.evaluate(
          [_number('10'), _number('4'), _op('÷')],
          AngleMode.deg,
        );
        expect(result, 2.5);
      });

      test('divisão por zero lança divisionByZero', () {
        expect(
          () => evaluator.evaluate(
            [_number('5'), _number('0'), _op('÷')],
            AngleMode.deg,
          ),
          throwsA(_hasErrorType(ScientificErrorType.divisionByZero)),
        );
      });

      test('potência', () {
        final result = evaluator.evaluate(
          [_number('2'), _number('10'), _op('^')],
          AngleMode.deg,
        );
        expect(result, 1024);
      });

      test('nPr (permutação)', () {
        final result = evaluator.evaluate(
          [_number('5'), _number('3'), _op('P')],
          AngleMode.deg,
        );
        expect(result, 60);
      });
    });

    group('Trigonometria', () {
      test('sin em DEG', () {
        final result = evaluator.evaluate(
          [_number('30'), _function('sin')],
          AngleMode.deg,
        );
        expect(result, closeTo(0.5, 1e-9));
      });

      test('sin em RAD não converte grau→radiano', () {
        final result = evaluator.evaluate(
          [_number('90'), _function('sin')],
          AngleMode.rad,
        );
        expect(result, closeTo(math.sin(90), 1e-9));
      });

      test('cos em DEG', () {
        final result = evaluator.evaluate(
          [_number('0'), _function('cos')],
          AngleMode.deg,
        );
        expect(result, closeTo(1, 1e-9));
      });

      test('asin converte de volta para grau em modo DEG', () {
        final result = evaluator.evaluate(
          [_number('0,5'), _function('asin')],
          AngleMode.deg,
        );
        expect(result, closeTo(30, 1e-6));
      });

      test('asin dentro de uma soma usa o valor já convertido', () {
        final result = evaluator.evaluate(
          [_number('0,5'), _function('asin'), _number('10'), _op('+')],
          AngleMode.deg,
        );
        expect(result, closeTo(40, 1e-6));
      });

      test('asin em RAD não converte', () {
        final result = evaluator.evaluate(
          [_number('0,5'), _function('asin')],
          AngleMode.rad,
        );
        expect(result, closeTo(math.asin(0.5), 1e-9));
      });

      test('asin fora do domínio lança domainError', () {
        expect(
          () => evaluator.evaluate(
            [_number('2'), _function('asin')],
            AngleMode.deg,
          ),
          throwsA(_hasErrorType(ScientificErrorType.domainError)),
        );
      });
    });

    group('Logaritmos', () {
      test('log base 10', () {
        final result = evaluator.evaluate(
          [_number('100'), _function('log')],
          AngleMode.deg,
        );
        expect(result, closeTo(2, 1e-9));
      });

      test('ln(e) = 1', () {
        final result = evaluator.evaluate(
          [_constant('e'), _function('ln')],
          AngleMode.deg,
        );
        expect(result, closeTo(1, 1e-9));
      });

      test('log de número negativo lança domainError', () {
        expect(
          () => evaluator.evaluate(
            [_number('1'), _unaryMinus(), _function('log')],
            AngleMode.deg,
          ),
          throwsA(_hasErrorType(ScientificErrorType.domainError)),
        );
      });
    });

    group('Potência e raiz', () {
      test('raiz quadrada', () {
        final result = evaluator.evaluate(
          [_number('9'), _function('√')],
          AngleMode.deg,
        );
        expect(result, closeTo(3, 1e-9));
      });

      test('raiz quadrada de negativo lança domainError', () {
        expect(
          () => evaluator.evaluate(
            [_number('1'), _unaryMinus(), _function('√')],
            AngleMode.deg,
          ),
          throwsA(_hasErrorType(ScientificErrorType.domainError)),
        );
      });

      test('raiz cúbica de negativo funciona (não é domainError)', () {
        final result = evaluator.evaluate(
          [_number('8'), _unaryMinus(), _function('³√')],
          AngleMode.deg,
        );
        expect(result, closeTo(-2, 1e-9));
      });

      test('quadrado pós-fixo', () {
        final result = evaluator.evaluate(
          [_number('4'), _postfix('²')],
          AngleMode.deg,
        );
        expect(result, 16);
      });

      test('cubo pós-fixo', () {
        final result = evaluator.evaluate(
          [_number('3'), _postfix('³')],
          AngleMode.deg,
        );
        expect(result, 27);
      });

      test('recíproco pós-fixo', () {
        final result = evaluator.evaluate(
          [_number('4'), _postfix('⁻¹')],
          AngleMode.deg,
        );
        expect(result, 0.25);
      });

      test('recíproco de zero lança divisionByZero', () {
        expect(
          () =>
              evaluator.evaluate([_number('0'), _postfix('⁻¹')], AngleMode.deg),
          throwsA(_hasErrorType(ScientificErrorType.divisionByZero)),
        );
      });
    });

    group('Fatorial', () {
      test('5! = 120', () {
        final result = evaluator.evaluate(
          [_number('5'), _postfix('!')],
          AngleMode.deg,
        );
        expect(result, 120);
      });

      test('pós-fixos encadeados: 3²! = 9! = 362880', () {
        final result = evaluator.evaluate(
          [_number('3'), _postfix('²'), _postfix('!')],
          AngleMode.deg,
        );
        expect(result, 362880);
      });

      test('fatorial de negativo lança factorialDomainError', () {
        expect(
          () => evaluator.evaluate(
            [_number('1'), _unaryMinus(), _postfix('!')],
            AngleMode.deg,
          ),
          throwsA(_hasErrorType(ScientificErrorType.factorialDomainError)),
        );
      });

      test('fatorial de não-inteiro lança factorialDomainError', () {
        expect(
          () => evaluator.evaluate(
            [_number('2,5'), _postfix('!')],
            AngleMode.deg,
          ),
          throwsA(_hasErrorType(ScientificErrorType.factorialDomainError)),
        );
      });

      test('fatorial acima de 170 lança factorialOverflow', () {
        expect(
          () => evaluator.evaluate(
            [_number('200'), _postfix('!')],
            AngleMode.deg,
          ),
          throwsA(_hasErrorType(ScientificErrorType.factorialOverflow)),
        );
      });

      test('tolerância de ponto flutuante aceita quase-inteiro', () {
        final result = evaluator.evaluate(
          [_number('5.000000000000001'), _postfix('!')],
          AngleMode.deg,
        );
        expect(result, 120);
      });
    });

    group('Sinal unário', () {
      test('-3 vira -3', () {
        final result = evaluator.evaluate(
          [_number('3'), _unaryMinus()],
          AngleMode.deg,
        );
        expect(result, -3);
      });

      test('---3 = -3 (número ímpar de negações)', () {
        final result = evaluator.evaluate(
          [_number('3'), _unaryMinus(), _unaryMinus(), _unaryMinus()],
          AngleMode.deg,
        );
        expect(result, -3);
      });
    });

    group('Erros gerais', () {
      test('resultado NaN lança domainError', () {
        expect(
          () => evaluator.evaluate(
            [_number('8'), _unaryMinus(), _number('0,5'), _op('^')],
            AngleMode.deg,
          ),
          throwsA(_hasErrorType(ScientificErrorType.domainError)),
        );
      });

      test('resultado acima do limite lança overflow', () {
        expect(
          () => evaluator.evaluate(
            [_number('10'), _number('20'), _op('^')],
            AngleMode.deg,
          ),
          throwsA(_hasErrorType(ScientificErrorType.overflow)),
        );
      });

      test('pilha vazia ao desempilhar lança syntaxError (não RangeError)', () {
        expect(
          () => evaluator.evaluate([_op('+')], AngleMode.deg),
          throwsA(_hasErrorType(ScientificErrorType.syntaxError)),
        );
      });

      test('mais de um valor sobrando na pilha lança syntaxError', () {
        expect(
          () => evaluator.evaluate([_number('2'), _number('3')], AngleMode.deg),
          throwsA(_hasErrorType(ScientificErrorType.syntaxError)),
        );
      });
    });
  });
}
