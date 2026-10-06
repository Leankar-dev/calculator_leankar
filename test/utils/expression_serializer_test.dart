import 'package:calculator_05122025/models/expression_token.dart';
import 'package:calculator_05122025/utils/enums/token_type.dart';
import 'package:calculator_05122025/utils/expression_serializer.dart';
import 'package:flutter_test/flutter_test.dart';

ExpressionToken _number(String value) =>
    ExpressionToken(type: TokenType.number, value: value);

ExpressionToken _operator(String value) =>
    ExpressionToken(type: TokenType.binaryOperator, value: value);

ExpressionToken _function(String value) =>
    ExpressionToken(type: TokenType.unaryFunction, value: value);

const ExpressionToken _openParen = ExpressionToken(
  type: TokenType.openParen,
  value: '(',
);

const ExpressionToken _closeParen = ExpressionToken(
  type: TokenType.closeParen,
  value: ')',
);

void main() {
  group('ExpressionSerializer.serialize', () {
    test('lista vazia e entrada vazia geram texto vazio', () {
      expect(ExpressionSerializer.serialize(const [], ''), '');
    });

    test('operadores binários recebem espaços ao redor', () {
      expect(
        ExpressionSerializer.serialize(
          [_number('2'), _operator('+')],
          '3',
        ),
        '2 + 3',
      );
    });

    test('insere multiplicação implícita entre número e "("', () {
      expect(
        ExpressionSerializer.serialize(
          [_number('2'), _openParen, _number('3'), _closeParen],
          '',
        ),
        '2 × (3)',
      );
    });

    test('insere multiplicação implícita entre ")" e entrada atual', () {
      expect(
        ExpressionSerializer.serialize(
          [_openParen, _number('2'), _closeParen],
          '5',
        ),
        '(2) × 5',
      );
    });

    test('não insere multiplicação entre função e seu parêntese', () {
      expect(
        ExpressionSerializer.serialize([_function('sin'), _openParen], '30'),
        'sin(30',
      );
    });
  });

  group('ExpressionSerializer.serializeWithClosedParens', () {
    test('fecha os parênteses que ficaram abertos', () {
      expect(
        ExpressionSerializer.serializeWithClosedParens(
          [_function('sin'), _openParen, _openParen],
          '30',
        ),
        'sin((30))',
      );
    });

    test('não altera expressões balanceadas', () {
      expect(
        ExpressionSerializer.serializeWithClosedParens(
          [_openParen, _number('2'), _closeParen],
          '',
        ),
        '(2)',
      );
    });

    test('não abre parênteses para fechamentos em excesso', () {
      expect(
        ExpressionSerializer.serializeWithClosedParens(
          [_number('2'), _closeParen],
          '',
        ),
        '2)',
      );
    });
  });
}
