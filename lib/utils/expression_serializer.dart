import 'package:calculator_05122025/models/expression_token.dart';
import 'package:calculator_05122025/utils/enums/token_type.dart';
import 'package:calculator_05122025/utils/extensions/expression_token_extension.dart';

class ExpressionSerializer {
  ExpressionSerializer._();

  static const String _implicitMultiplication = ' × ';

  static String serialize(List<ExpressionToken> tokens, String currentInput) {
    final buffer = StringBuffer();
    ExpressionToken? previous;

    for (final token in tokens) {
      if (token.type == TokenType.binaryOperator) {
        buffer.write(' ${token.value} ');
      } else {
        if (previous != null && previous.closesValue && token.opensValue) {
          buffer.write(_implicitMultiplication);
        }
        buffer.write(token.value);
      }
      previous = token;
    }

    if (currentInput.isNotEmpty) {
      if (previous != null && previous.closesValue) {
        buffer.write(_implicitMultiplication);
      }
      buffer.write(currentInput);
    }

    return buffer.toString().trim();
  }

  static String serializeWithClosedParens(
    List<ExpressionToken> tokens,
    String currentInput,
  ) {
    final expression = serialize(tokens, currentInput);
    final unclosedCount = tokens.unclosedParenCount;
    if (unclosedCount <= 0) {
      return expression;
    }
    return expression + ')' * unclosedCount;
  }
}
