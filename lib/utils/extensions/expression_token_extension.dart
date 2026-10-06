import 'package:calculator_05122025/models/expression_token.dart';
import 'package:calculator_05122025/utils/enums/token_type.dart';

extension ExpressionTokenExtension on ExpressionToken {
  bool get closesValue {
    return type == TokenType.number ||
        type == TokenType.closeParen ||
        type == TokenType.postfixOperator ||
        type == TokenType.constant;
  }

  bool get opensValue {
    return type == TokenType.number ||
        type == TokenType.constant ||
        type == TokenType.unaryFunction ||
        type == TokenType.openParen;
  }

  bool get expectsOperandAfter {
    return type == TokenType.binaryOperator ||
        type == TokenType.openParen ||
        type == TokenType.unaryMinus;
  }
}

extension ExpressionTokenListExtension on List<ExpressionToken> {
  bool get expectsOperand => isEmpty || last.expectsOperandAfter;

  int get unclosedParenCount {
    var openCount = 0;
    for (final token in this) {
      if (token.type == TokenType.openParen) {
        openCount++;
      } else if (token.type == TokenType.closeParen) {
        openCount--;
      }
    }
    return openCount;
  }
}
