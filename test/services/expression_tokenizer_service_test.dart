import 'package:calculator_05122025/models/expression_token.dart';
import 'package:calculator_05122025/services/expression_tokenizer_service.dart';
import 'package:calculator_05122025/utils/enums/scientific_error_type.dart';
import 'package:calculator_05122025/utils/enums/token_type.dart';
import 'package:calculator_05122025/utils/exceptions/scientific_calculation_exception.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late ExpressionTokenizerService tokenizer;

  setUp(() {
    tokenizer = ExpressionTokenizerService();
  });

  void expectTokens(
    List<ExpressionToken> tokens,
    List<(TokenType, String)> expected,
  ) {
    expect(
      tokens.length,
      expected.length,
      reason: 'quantidade de tokens diferente: $tokens',
    );
    for (var i = 0; i < tokens.length; i++) {
      expect(tokens[i].type, expected[i].$1, reason: 'tipo do token $i');
      expect(tokens[i].value, expected[i].$2, reason: 'valor do token $i');
    }
  }

  group('ExpressionTokenizerService', () {
    group('Números', () {
      test('número inteiro simples', () {
        final tokens = tokenizer.tokenize('123');
        expectTokens(tokens, [(TokenType.number, '123')]);
      });

      test('número com vírgula decimal', () {
        final tokens = tokenizer.tokenize('12,5');
        expectTokens(tokens, [(TokenType.number, '12,5')]);
      });

      test('número com separador de milhar e decimal', () {
        final tokens = tokenizer.tokenize('1.234,56');
        expectTokens(tokens, [(TokenType.number, '1.234,56')]);
      });
    });

    group('Notação científica vs. constante de Euler', () {
      test('1,5e10 é um único token numérico', () {
        final tokens = tokenizer.tokenize('1,5e10');
        expectTokens(tokens, [(TokenType.number, '1,5e10')]);
      });

      test('2e3 vira número em notação científica, não 2 × e', () {
        final tokens = tokenizer.tokenize('2e3');
        expectTokens(tokens, [(TokenType.number, '2e3')]);
      });

      test('e isolado é a constante de Euler', () {
        final tokens = tokenizer.tokenize('e');
        expectTokens(tokens, [(TokenType.constant, 'e')]);
      });

      test('2 + e usa a constante, não notação científica', () {
        final tokens = tokenizer.tokenize('2+e');
        expectTokens(tokens, [
          (TokenType.number, '2'),
          (TokenType.binaryOperator, '+'),
          (TokenType.constant, 'e'),
        ]);
      });

      test('5e sem dígito depois vira número × constante', () {
        final tokens = tokenizer.tokenize('5e');
        expectTokens(tokens, [
          (TokenType.number, '5'),
          (TokenType.binaryOperator, '×'),
          (TokenType.constant, 'e'),
        ]);
      });
    });

    group('Funções-prefixo', () {
      test('sin( vira unaryFunction + openParen', () {
        final tokens = tokenizer.tokenize('sin(30)');
        expectTokens(tokens, [
          (TokenType.unaryFunction, 'sin'),
          (TokenType.openParen, '('),
          (TokenType.number, '30'),
          (TokenType.closeParen, ')'),
        ]);
      });

      test('asin( diferente de sin(', () {
        final tokens = tokenizer.tokenize('asin(0,5)');
        expectTokens(tokens, [
          (TokenType.unaryFunction, 'asin'),
          (TokenType.openParen, '('),
          (TokenType.number, '0,5'),
          (TokenType.closeParen, ')'),
        ]);
      });

      test('³√( (cbrt) diferente de √( (sqrt)', () {
        final tokens = tokenizer.tokenize('³√(8)');
        expectTokens(tokens, [
          (TokenType.unaryFunction, '³√'),
          (TokenType.openParen, '('),
          (TokenType.number, '8'),
          (TokenType.closeParen, ')'),
        ]);
      });

      test('√( sozinho continua reconhecido corretamente', () {
        final tokens = tokenizer.tokenize('√(9)');
        expectTokens(tokens, [
          (TokenType.unaryFunction, '√'),
          (TokenType.openParen, '('),
          (TokenType.number, '9'),
          (TokenType.closeParen, ')'),
        ]);
      });

      test('abs( para |x|', () {
        final tokens = tokenizer.tokenize('abs(-5)');
        expectTokens(tokens, [
          (TokenType.unaryFunction, 'abs'),
          (TokenType.openParen, '('),
          (TokenType.unaryMinus, '-'),
          (TokenType.number, '5'),
          (TokenType.closeParen, ')'),
        ]);
      });
    });

    group('Pós-fixos', () {
      test('fatorial', () {
        final tokens = tokenizer.tokenize('5!');
        expectTokens(tokens, [
          (TokenType.number, '5'),
          (TokenType.postfixOperator, '!'),
        ]);
      });

      test('quadrado', () {
        final tokens = tokenizer.tokenize('3²');
        expectTokens(tokens, [
          (TokenType.number, '3'),
          (TokenType.postfixOperator, '²'),
        ]);
      });

      test('cubo isolado não é confundido com ³√(', () {
        final tokens = tokenizer.tokenize('3³');
        expectTokens(tokens, [
          (TokenType.number, '3'),
          (TokenType.postfixOperator, '³'),
        ]);
      });

      test('recíproco', () {
        final tokens = tokenizer.tokenize('5⁻¹');
        expectTokens(tokens, [
          (TokenType.number, '5'),
          (TokenType.postfixOperator, '⁻¹'),
        ]);
      });

      test('pós-fixos encadeados (3²!)', () {
        final tokens = tokenizer.tokenize('3²!');
        expectTokens(tokens, [
          (TokenType.number, '3'),
          (TokenType.postfixOperator, '²'),
          (TokenType.postfixOperator, '!'),
        ]);
      });
    });

    group('Constantes', () {
      test('π isolado', () {
        final tokens = tokenizer.tokenize('π');
        expectTokens(tokens, [(TokenType.constant, 'π')]);
      });
    });

    group('Parênteses', () {
      test('parênteses simples', () {
        final tokens = tokenizer.tokenize('(2+3)');
        expectTokens(tokens, [
          (TokenType.openParen, '('),
          (TokenType.number, '2'),
          (TokenType.binaryOperator, '+'),
          (TokenType.number, '3'),
          (TokenType.closeParen, ')'),
        ]);
      });
    });

    group('Sinal unário', () {
      test('- no início da expressão vira unaryMinus', () {
        final tokens = tokenizer.tokenize('-3');
        expectTokens(tokens, [
          (TokenType.unaryMinus, '-'),
          (TokenType.number, '3'),
        ]);
      });

      test('- logo após ( vira unaryMinus', () {
        final tokens = tokenizer.tokenize('log(-1)');
        expectTokens(tokens, [
          (TokenType.unaryFunction, 'log'),
          (TokenType.openParen, '('),
          (TokenType.unaryMinus, '-'),
          (TokenType.number, '1'),
          (TokenType.closeParen, ')'),
        ]);
      });

      test('- logo após um número é subtração binária', () {
        final tokens = tokenizer.tokenize('3-5');
        expectTokens(tokens, [
          (TokenType.number, '3'),
          (TokenType.binaryOperator, '-'),
          (TokenType.number, '5'),
        ]);
      });

      test('- logo após um pós-fixo é subtração binária (3! - 5)', () {
        final tokens = tokenizer.tokenize('3!-5');
        expectTokens(tokens, [
          (TokenType.number, '3'),
          (TokenType.postfixOperator, '!'),
          (TokenType.binaryOperator, '-'),
          (TokenType.number, '5'),
        ]);
      });

      test('--3 encadeia dois unaryMinus', () {
        final tokens = tokenizer.tokenize('--3');
        expectTokens(tokens, [
          (TokenType.unaryMinus, '-'),
          (TokenType.unaryMinus, '-'),
          (TokenType.number, '3'),
        ]);
      });

      test('---3 encadeia três unaryMinus', () {
        final tokens = tokenizer.tokenize('---3');
        expectTokens(tokens, [
          (TokenType.unaryMinus, '-'),
          (TokenType.unaryMinus, '-'),
          (TokenType.unaryMinus, '-'),
          (TokenType.number, '3'),
        ]);
      });

      test('- logo após operador binário vira unaryMinus', () {
        final tokens = tokenizer.tokenize('2×-3');
        expectTokens(tokens, [
          (TokenType.number, '2'),
          (TokenType.binaryOperator, '×'),
          (TokenType.unaryMinus, '-'),
          (TokenType.number, '3'),
        ]);
      });
    });

    group('Multiplicação implícita', () {
      test('número seguido de constante', () {
        final tokens = tokenizer.tokenize('2π');
        expectTokens(tokens, [
          (TokenType.number, '2'),
          (TokenType.binaryOperator, '×'),
          (TokenType.constant, 'π'),
        ]);
      });

      test('constante seguida de número', () {
        final tokens = tokenizer.tokenize('π2');
        expectTokens(tokens, [
          (TokenType.constant, 'π'),
          (TokenType.binaryOperator, '×'),
          (TokenType.number, '2'),
        ]);
      });

      test('número seguido de função', () {
        final tokens = tokenizer.tokenize('3sin(30)');
        expectTokens(tokens, [
          (TokenType.number, '3'),
          (TokenType.binaryOperator, '×'),
          (TokenType.unaryFunction, 'sin'),
          (TokenType.openParen, '('),
          (TokenType.number, '30'),
          (TokenType.closeParen, ')'),
        ]);
      });

      test('parênteses adjacentes', () {
        final tokens = tokenizer.tokenize('(2+3)(4+5)');
        expectTokens(tokens, [
          (TokenType.openParen, '('),
          (TokenType.number, '2'),
          (TokenType.binaryOperator, '+'),
          (TokenType.number, '3'),
          (TokenType.closeParen, ')'),
          (TokenType.binaryOperator, '×'),
          (TokenType.openParen, '('),
          (TokenType.number, '4'),
          (TokenType.binaryOperator, '+'),
          (TokenType.number, '5'),
          (TokenType.closeParen, ')'),
        ]);
      });

      test('pós-fixo seguido de número', () {
        final tokens = tokenizer.tokenize('3!2');
        expectTokens(tokens, [
          (TokenType.number, '3'),
          (TokenType.postfixOperator, '!'),
          (TokenType.binaryOperator, '×'),
          (TokenType.number, '2'),
        ]);
      });

      test('2(-3) não injeta × perto do sinal unário', () {
        final tokens = tokenizer.tokenize('2(-3)');
        expectTokens(tokens, [
          (TokenType.number, '2'),
          (TokenType.binaryOperator, '×'),
          (TokenType.openParen, '('),
          (TokenType.unaryMinus, '-'),
          (TokenType.number, '3'),
          (TokenType.closeParen, ')'),
        ]);
      });
    });

    group('Erros', () {
      test('caractere não reconhecido lança syntaxError', () {
        expect(
          () => tokenizer.tokenize('2 & 3'),
          throwsA(
            isA<ScientificCalculationException>().having(
              (e) => e.errorType,
              'errorType',
              ScientificErrorType.syntaxError,
            ),
          ),
        );
      });

      test('expressão vazia lança emptyExpression', () {
        expect(
          () => tokenizer.tokenize(''),
          throwsA(
            isA<ScientificCalculationException>().having(
              (e) => e.errorType,
              'errorType',
              ScientificErrorType.emptyExpression,
            ),
          ),
        );
      });
    });
  });
}
