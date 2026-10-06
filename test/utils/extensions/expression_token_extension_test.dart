import 'package:calculator_05122025/models/expression_token.dart';
import 'package:calculator_05122025/utils/enums/token_type.dart';
import 'package:calculator_05122025/utils/extensions/expression_token_extension.dart';
import 'package:flutter_test/flutter_test.dart';

ExpressionToken _token(TokenType type, [String value = 'x']) =>
    ExpressionToken(type: type, value: value);

void main() {
  group('ExpressionTokenExtension', () {
    test('closesValue é verdadeiro para número, constante, ")" e pós-fixo', () {
      expect(_token(TokenType.number).closesValue, isTrue);
      expect(_token(TokenType.constant).closesValue, isTrue);
      expect(_token(TokenType.closeParen).closesValue, isTrue);
      expect(_token(TokenType.postfixOperator).closesValue, isTrue);
    });

    test('closesValue é falso para operadores, funções e "("', () {
      expect(_token(TokenType.binaryOperator).closesValue, isFalse);
      expect(_token(TokenType.unaryFunction).closesValue, isFalse);
      expect(_token(TokenType.unaryMinus).closesValue, isFalse);
      expect(_token(TokenType.openParen).closesValue, isFalse);
    });

    test('opensValue é verdadeiro para número, constante, função e "("', () {
      expect(_token(TokenType.number).opensValue, isTrue);
      expect(_token(TokenType.constant).opensValue, isTrue);
      expect(_token(TokenType.unaryFunction).opensValue, isTrue);
      expect(_token(TokenType.openParen).opensValue, isTrue);
    });

    test('opensValue é falso para operadores, pós-fixos e ")"', () {
      expect(_token(TokenType.binaryOperator).opensValue, isFalse);
      expect(_token(TokenType.postfixOperator).opensValue, isFalse);
      expect(_token(TokenType.closeParen).opensValue, isFalse);
      expect(_token(TokenType.unaryMinus).opensValue, isFalse);
    });

    test(
      'expectsOperandAfter é verdadeiro após operador, "(" e menos unário',
      () {
        expect(_token(TokenType.binaryOperator).expectsOperandAfter, isTrue);
        expect(_token(TokenType.openParen).expectsOperandAfter, isTrue);
        expect(_token(TokenType.unaryMinus).expectsOperandAfter, isTrue);
      },
    );

    test('expectsOperandAfter é falso após valores completos', () {
      expect(_token(TokenType.number).expectsOperandAfter, isFalse);
      expect(_token(TokenType.closeParen).expectsOperandAfter, isFalse);
      expect(_token(TokenType.postfixOperator).expectsOperandAfter, isFalse);
    });
  });

  group('ExpressionTokenListExtension', () {
    test('expectsOperand é verdadeiro para lista vazia', () {
      expect(<ExpressionToken>[].expectsOperand, isTrue);
    });

    test('expectsOperand considera apenas o último token', () {
      expect(
        [
          _token(TokenType.number),
          _token(TokenType.binaryOperator),
        ].expectsOperand,
        isTrue,
      );
      expect(
        [
          _token(TokenType.binaryOperator),
          _token(TokenType.number),
        ].expectsOperand,
        isFalse,
      );
    });

    test('unclosedParenCount conta parênteses abertos sem fechamento', () {
      expect(<ExpressionToken>[].unclosedParenCount, 0);
      expect(
        [
          _token(TokenType.openParen),
          _token(TokenType.openParen),
        ].unclosedParenCount,
        2,
      );
      expect(
        [
          _token(TokenType.openParen),
          _token(TokenType.number),
          _token(TokenType.closeParen),
        ].unclosedParenCount,
        0,
      );
    });

    test('unclosedParenCount é negativo com fechamentos em excesso', () {
      expect([_token(TokenType.closeParen)].unclosedParenCount, -1);
    });
  });
}
