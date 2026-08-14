import 'package:calculator_05122025/models/expression_token.dart';
import 'package:calculator_05122025/services/shunting_yard_service.dart';
import 'package:calculator_05122025/utils/enums/scientific_error_type.dart';
import 'package:calculator_05122025/utils/enums/token_type.dart';
import 'package:calculator_05122025/utils/exceptions/scientific_calculation_exception.dart';
import 'package:flutter_test/flutter_test.dart';

ExpressionToken _number(String value) =>
    ExpressionToken(type: TokenType.number, value: value);

ExpressionToken _op(String value) =>
    ExpressionToken(type: TokenType.binaryOperator, value: value);

const _openParen = ExpressionToken(type: TokenType.openParen, value: '(');
const _closeParen = ExpressionToken(type: TokenType.closeParen, value: ')');

ExpressionToken _postfix(String value) =>
    ExpressionToken(type: TokenType.postfixOperator, value: value);

ExpressionToken _unaryMinus() =>
    const ExpressionToken(type: TokenType.unaryMinus, value: '-');

ExpressionToken _function(String value) =>
    ExpressionToken(type: TokenType.unaryFunction, value: value);

ExpressionToken _constant(String value) =>
    ExpressionToken(type: TokenType.constant, value: value);

void main() {
  late ShuntingYardService shuntingYard;

  setUp(() {
    shuntingYard = ShuntingYardService();
  });

  void expectRpn(
    List<ExpressionToken> rpn,
    List<(TokenType, String)> expected,
  ) {
    expect(
      rpn.length,
      expected.length,
      reason: 'quantidade de tokens RPN diferente: $rpn',
    );
    for (var i = 0; i < rpn.length; i++) {
      expect(rpn[i].type, expected[i].$1, reason: 'tipo do token RPN $i');
      expect(rpn[i].value, expected[i].$2, reason: 'valor do token RPN $i');
    }
  }

  group('ShuntingYardService', () {
    test('2 + 3 vira 2 3 +', () {
      final rpn = shuntingYard.toRpn([_number('2'), _op('+'), _number('3')]);
      expectRpn(rpn, [
        (TokenType.number, '2'),
        (TokenType.number, '3'),
        (TokenType.binaryOperator, '+'),
      ]);
    });

    test('precedência: 2 + 3 × 4 vira 2 3 4 × +', () {
      final rpn = shuntingYard.toRpn([
        _number('2'),
        _op('+'),
        _number('3'),
        _op('×'),
        _number('4'),
      ]);
      expectRpn(rpn, [
        (TokenType.number, '2'),
        (TokenType.number, '3'),
        (TokenType.number, '4'),
        (TokenType.binaryOperator, '×'),
        (TokenType.binaryOperator, '+'),
      ]);
    });

    test('parênteses alteram a precedência: (2 + 3) × 4', () {
      final rpn = shuntingYard.toRpn([
        _openParen,
        _number('2'),
        _op('+'),
        _number('3'),
        _closeParen,
        _op('×'),
        _number('4'),
      ]);
      expectRpn(rpn, [
        (TokenType.number, '2'),
        (TokenType.number, '3'),
        (TokenType.binaryOperator, '+'),
        (TokenType.number, '4'),
        (TokenType.binaryOperator, '×'),
      ]);
    });

    test('associatividade à direita do ^: 2^3^2 vira 2 3 2 ^ ^', () {
      final rpn = shuntingYard.toRpn([
        _number('2'),
        _op('^'),
        _number('3'),
        _op('^'),
        _number('2'),
      ]);
      expectRpn(rpn, [
        (TokenType.number, '2'),
        (TokenType.number, '3'),
        (TokenType.number, '2'),
        (TokenType.binaryOperator, '^'),
        (TokenType.binaryOperator, '^'),
      ]);
    });

    test('associatividade à esquerda de -: 10-3-2 vira 10 3 - 2 -', () {
      final rpn = shuntingYard.toRpn([
        _number('10'),
        _op('-'),
        _number('3'),
        _op('-'),
        _number('2'),
      ]);
      expectRpn(rpn, [
        (TokenType.number, '10'),
        (TokenType.number, '3'),
        (TokenType.binaryOperator, '-'),
        (TokenType.number, '2'),
        (TokenType.binaryOperator, '-'),
      ]);
    });

    test('função-prefixo: sin(30) vira 30 sin', () {
      final rpn = shuntingYard.toRpn([
        _function('sin'),
        _openParen,
        _number('30'),
        _closeParen,
      ]);
      expectRpn(rpn, [
        (TokenType.number, '30'),
        (TokenType.unaryFunction, 'sin'),
      ]);
    });

    test('pós-fixo não vai para a pilha: 2 + 3! vira 2 3 ! +', () {
      final rpn = shuntingYard.toRpn([
        _number('2'),
        _op('+'),
        _number('3'),
        _postfix('!'),
      ]);
      expectRpn(rpn, [
        (TokenType.number, '2'),
        (TokenType.number, '3'),
        (TokenType.postfixOperator, '!'),
        (TokenType.binaryOperator, '+'),
      ]);
    });

    test('pós-fixos encadeados aplicam da esquerda pra direita: 3²!', () {
      final rpn = shuntingYard.toRpn([
        _number('3'),
        _postfix('²'),
        _postfix('!'),
      ]);
      expectRpn(rpn, [
        (TokenType.number, '3'),
        (TokenType.postfixOperator, '²'),
        (TokenType.postfixOperator, '!'),
      ]);
    });

    test(
      'sinal unário com precedência menor que pós-fixo: -3! vira 3 ! neg',
      () {
        final rpn = shuntingYard.toRpn([
          _unaryMinus(),
          _number('3'),
          _postfix('!'),
        ]);
        expectRpn(rpn, [
          (TokenType.number, '3'),
          (TokenType.postfixOperator, '!'),
          (TokenType.unaryMinus, '-'),
        ]);
      },
    );

    test(
      'sinal unário com precedência menor que potência: -3^2 vira 3 2 ^ neg',
      () {
        final rpn = shuntingYard.toRpn([
          _unaryMinus(),
          _number('3'),
          _op('^'),
          _number('2'),
        ]);
        expectRpn(rpn, [
          (TokenType.number, '3'),
          (TokenType.number, '2'),
          (TokenType.binaryOperator, '^'),
          (TokenType.unaryMinus, '-'),
        ]);
      },
    );

    test('sinal unário encadeado: ---3', () {
      final rpn = shuntingYard.toRpn([
        _unaryMinus(),
        _unaryMinus(),
        _unaryMinus(),
        _number('3'),
      ]);
      expectRpn(rpn, [
        (TokenType.number, '3'),
        (TokenType.unaryMinus, '-'),
        (TokenType.unaryMinus, '-'),
        (TokenType.unaryMinus, '-'),
      ]);
    });

    test('multiplicação implícita já resolvida vira operador × normal: 2π', () {
      final rpn = shuntingYard.toRpn([_number('2'), _op('×'), _constant('π')]);
      expectRpn(rpn, [
        (TokenType.number, '2'),
        (TokenType.constant, 'π'),
        (TokenType.binaryOperator, '×'),
      ]);
    });

    group('Parênteses desbalanceados', () {
      test('abertura sem fechamento lança unbalancedParens', () {
        expect(
          () => shuntingYard.toRpn([
            _openParen,
            _number('2'),
            _op('+'),
            _number('3'),
          ]),
          throwsA(
            isA<ScientificCalculationException>().having(
              (e) => e.errorType,
              'errorType',
              ScientificErrorType.unbalancedParens,
            ),
          ),
        );
      });

      test('fechamento sem abertura lança unbalancedParens', () {
        expect(
          () => shuntingYard.toRpn([
            _number('2'),
            _op('+'),
            _number('3'),
            _closeParen,
          ]),
          throwsA(
            isA<ScientificCalculationException>().having(
              (e) => e.errorType,
              'errorType',
              ScientificErrorType.unbalancedParens,
            ),
          ),
        );
      });
    });
  });
}
