import 'package:calculator_05122025/models/expression_token.dart';
import 'package:calculator_05122025/utils/constants/app_scientific_lexemes.dart';
import 'package:calculator_05122025/utils/constants/app_scientific_strings.dart';
import 'package:calculator_05122025/utils/constants/app_strings.dart';
import 'package:calculator_05122025/utils/enums/scientific_error_type.dart';
import 'package:calculator_05122025/utils/enums/scientific_function_insertion.dart';
import 'package:calculator_05122025/utils/enums/scientific_function_type.dart';
import 'package:calculator_05122025/utils/enums/token_type.dart';
import 'package:calculator_05122025/utils/exceptions/scientific_calculation_exception.dart';
import 'package:calculator_05122025/utils/extensions/expression_token_extension.dart';
import 'package:calculator_05122025/utils/number_formatter.dart';

class ExpressionTokenizerService {
  static final RegExp _numberPattern = RegExp(r'\d[\d.,]*([eE][+-]?\d+)?');

  static final RegExp _validNumberFormat = RegExp(
    r'^(\d+|\d{1,3}(\.\d{3})+)(,\d*)?([eE][+-]?\d+)?$',
  );

  static final List<String> _prefixFunctionLexemes = [
    for (final lexeme in ScientificFunctionType.lexemesFor(
      ScientificFunctionInsertion.prefixFunction,
    ))
      '$lexeme${AppScientificStrings.openParen}',
  ];

  static final List<String> _postfixLexemes = ScientificFunctionType.lexemesFor(
    ScientificFunctionInsertion.postfixOperator,
  );

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
        if (!_validNumberFormat.hasMatch(lexeme) ||
            NumberFormatter.parse(lexeme) == null) {
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
          const ExpressionToken(
            type: TokenType.openParen,
            value: AppScientificStrings.openParen,
          ),
        );
        index += prefixFunction.length;
        continue;
      }

      if (char == AppScientificStrings.openParen) {
        tokens.add(
          const ExpressionToken(
            type: TokenType.openParen,
            value: AppScientificStrings.openParen,
          ),
        );
        index++;
        continue;
      }

      if (char == AppScientificStrings.closeParen) {
        tokens.add(
          const ExpressionToken(
            type: TokenType.closeParen,
            value: AppScientificStrings.closeParen,
          ),
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

      if (char == AppScientificStrings.pi) {
        tokens.add(
          const ExpressionToken(
            type: TokenType.constant,
            value: AppScientificStrings.pi,
          ),
        );
        index++;
        continue;
      }

      if (char == AppScientificStrings.euler) {
        tokens.add(
          const ExpressionToken(
            type: TokenType.constant,
            value: AppScientificStrings.euler,
          ),
        );
        index++;
        continue;
      }

      if (_isBinaryOperatorChar(char)) {
        if (char == AppStrings.subtractionSymbol && tokens.expectsOperand) {
          tokens.add(
            const ExpressionToken(
              type: TokenType.unaryMinus,
              value: AppStrings.subtractionSymbol,
            ),
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
    String? longestMatch;
    for (final candidate in candidates) {
      if (expression.startsWith(candidate, index) &&
          (longestMatch == null || candidate.length > longestMatch.length)) {
        longestMatch = candidate;
      }
    }
    return longestMatch;
  }

  bool _isBinaryOperatorChar(String char) {
    return char == AppStrings.additionSymbol ||
        char == AppStrings.subtractionSymbol ||
        char == AppStrings.multiplicationSymbol ||
        char == AppStrings.divisionSymbol ||
        char == AppScientificLexemes.power ||
        char == AppScientificLexemes.permutation;
  }

  List<ExpressionToken> _insertImplicitMultiplication(
    List<ExpressionToken> tokens,
  ) {
    final result = <ExpressionToken>[tokens.first];
    for (var i = 1; i < tokens.length; i++) {
      final previous = tokens[i - 1];
      final current = tokens[i];
      if (previous.closesValue && current.opensValue) {
        result.add(
          const ExpressionToken(
            type: TokenType.binaryOperator,
            value: AppStrings.multiplicationSymbol,
          ),
        );
      }
      result.add(current);
    }
    return result;
  }
}
