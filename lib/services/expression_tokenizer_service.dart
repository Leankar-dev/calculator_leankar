import 'package:calculator_05122025/models/expression_token.dart';
import 'package:calculator_05122025/utils/constants/app_strings.dart';
import 'package:calculator_05122025/utils/enums/scientific_error_type.dart';
import 'package:calculator_05122025/utils/enums/token_type.dart';
import 'package:calculator_05122025/utils/exceptions/scientific_calculation_exception.dart';
import 'package:calculator_05122025/utils/number_formatter.dart';

class ExpressionTokenizerService {
  static final RegExp _numberPattern = RegExp(r'\d[\d.,]*([eE][+-]?\d+)?');

  static const List<String> _prefixFunctionLexemes = [
    'asin(',
    'acos(',
    'atan(',
    'sin(',
    'cos(',
    'tan(',
    'log(',
    'ln(',
    '³√(',
    '√(',
    'abs(',
  ];

  static const List<String> _postfixLexemes = ['⁻¹', '!', '²', '³'];

  static const String _piSymbol = 'π';
  static const String _eulerSymbol = 'e';
  static const String _powerSymbol = '^';
  static const String _permutationSymbol = 'P';

  List<ExpressionToken> tokenize(String expression) {
    final tokens = <ExpressionToken>[];
    var index = 0;

    while (index < expression.length) {
      final char = expression[index];

      if (char == ' ') {
        index++;
        continue;
      }

      final numberMatch = _numberPattern.matchAsPrefix(expression, index);
      if (numberMatch != null) {
        final lexeme = numberMatch.group(0)!;
        if (NumberFormatter.parse(lexeme) == null) {
          throw ScientificCalculationException(
            ScientificErrorType.syntaxError,
            'Número inválido: "$lexeme"',
          );
        }
        tokens.add(ExpressionToken(type: TokenType.number, value: lexeme));
        index += lexeme.length;
        continue;
      }

      final prefixFunction = _matchLongestLexeme(
        expression,
        index,
        _prefixFunctionLexemes,
      );
      if (prefixFunction != null) {
        final functionName = prefixFunction.substring(
          0,
          prefixFunction.length - 1,
        );
        tokens.add(
          ExpressionToken(type: TokenType.unaryFunction, value: functionName),
        );
        tokens.add(
          const ExpressionToken(type: TokenType.openParen, value: '('),
        );
        index += prefixFunction.length;
        continue;
      }

      if (char == '(') {
        tokens.add(
          const ExpressionToken(type: TokenType.openParen, value: '('),
        );
        index++;
        continue;
      }

      if (char == ')') {
        tokens.add(
          const ExpressionToken(type: TokenType.closeParen, value: ')'),
        );
        index++;
        continue;
      }

      final postfixSymbol = _matchLongestLexeme(
        expression,
        index,
        _postfixLexemes,
      );
      if (postfixSymbol != null) {
        tokens.add(
          ExpressionToken(
            type: TokenType.postfixOperator,
            value: postfixSymbol,
          ),
        );
        index += postfixSymbol.length;
        continue;
      }

      if (char == _piSymbol) {
        tokens.add(
          const ExpressionToken(type: TokenType.constant, value: _piSymbol),
        );
        index++;
        continue;
      }

      if (char == _eulerSymbol) {
        tokens.add(
          const ExpressionToken(
            type: TokenType.constant,
            value: _eulerSymbol,
          ),
        );
        index++;
        continue;
      }

      if (_isBinaryOperatorChar(char)) {
        if (char == AppStrings.subtractionSymbol &&
            _expectsNewOperand(tokens)) {
          tokens.add(
            const ExpressionToken(type: TokenType.unaryMinus, value: '-'),
          );
        } else {
          tokens.add(
            ExpressionToken(type: TokenType.binaryOperator, value: char),
          );
        }
        index++;
        continue;
      }

      throw ScientificCalculationException(
        ScientificErrorType.syntaxError,
        'Caractere não reconhecido: "$char"',
      );
    }

    if (tokens.isEmpty) {
      throw const ScientificCalculationException(
        ScientificErrorType.emptyExpression,
      );
    }

    return _insertImplicitMultiplication(tokens);
  }

  String? _matchLongestLexeme(
    String expression,
    int index,
    List<String> candidates,
  ) {
    for (final candidate in candidates) {
      if (expression.startsWith(candidate, index)) {
        return candidate;
      }
    }
    return null;
  }

  bool _isBinaryOperatorChar(String char) {
    return char == AppStrings.additionSymbol ||
        char == AppStrings.subtractionSymbol ||
        char == AppStrings.multiplicationSymbol ||
        char == AppStrings.divisionSymbol ||
        char == _powerSymbol ||
        char == _permutationSymbol;
  }

  bool _expectsNewOperand(List<ExpressionToken> tokensSoFar) {
    if (tokensSoFar.isEmpty) {
      return true;
    }
    final last = tokensSoFar.last;
    return last.type == TokenType.binaryOperator ||
        last.type == TokenType.openParen ||
        last.type == TokenType.unaryMinus;
  }

  List<ExpressionToken> _insertImplicitMultiplication(
    List<ExpressionToken> tokens,
  ) {
    final result = <ExpressionToken>[tokens.first];
    for (var i = 1; i < tokens.length; i++) {
      final previous = tokens[i - 1];
      final current = tokens[i];
      if (_closesValue(previous) && _opensValue(current)) {
        result.add(
          const ExpressionToken(type: TokenType.binaryOperator, value: '×'),
        );
      }
      result.add(current);
    }
    return result;
  }

  bool _closesValue(ExpressionToken token) {
    return token.type == TokenType.number ||
        token.type == TokenType.closeParen ||
        token.type == TokenType.postfixOperator ||
        token.type == TokenType.constant;
  }

  bool _opensValue(ExpressionToken token) {
    return token.type == TokenType.number ||
        token.type == TokenType.constant ||
        token.type == TokenType.unaryFunction ||
        token.type == TokenType.openParen;
  }
}
