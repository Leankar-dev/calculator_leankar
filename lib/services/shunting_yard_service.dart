import 'package:calculator_05122025/models/expression_token.dart';
import 'package:calculator_05122025/utils/enums/scientific_error_type.dart';
import 'package:calculator_05122025/utils/enums/token_type.dart';
import 'package:calculator_05122025/utils/exceptions/scientific_calculation_exception.dart';

class ShuntingYardService {
  static const int _postfixPrecedence = 7;
  static const int _prefixFunctionPrecedence = 6;
  static const int _powerPrecedence = 5;
  static const int _unaryMinusPrecedence = 4;
  static const int _multiplicativePrecedence = 3;
  static const int _additivePrecedence = 2;

  static const Set<String> _rightAssociativeOperators = {'^', 'P'};

  List<ExpressionToken> toRpn(List<ExpressionToken> infix) {
    final output = <ExpressionToken>[];
    final operatorStack = <ExpressionToken>[];

    for (final token in infix) {
      switch (token.type) {
        case TokenType.number:
        case TokenType.constant:
          output.add(token);
          break;
        case TokenType.unaryFunction:
        case TokenType.unaryMinus:
          operatorStack.add(token);
          break;
        case TokenType.postfixOperator:
          while (operatorStack.isNotEmpty &&
              _precedence(operatorStack.last) >= _postfixPrecedence) {
            output.add(operatorStack.removeLast());
          }
          output.add(token);
          break;
        case TokenType.binaryOperator:
          while (operatorStack.isNotEmpty &&
              operatorStack.last.type != TokenType.openParen &&
              _shouldPopBeforePushing(operatorStack.last, token)) {
            output.add(operatorStack.removeLast());
          }
          operatorStack.add(token);
          break;
        case TokenType.openParen:
          operatorStack.add(token);
          break;
        case TokenType.closeParen:
          while (operatorStack.isNotEmpty &&
              operatorStack.last.type != TokenType.openParen) {
            output.add(operatorStack.removeLast());
          }
          if (operatorStack.isEmpty) {
            throw const ScientificCalculationException(
              ScientificErrorType.unbalancedParens,
            );
          }
          operatorStack.removeLast();
          if (operatorStack.isNotEmpty &&
              operatorStack.last.type == TokenType.unaryFunction) {
            output.add(operatorStack.removeLast());
          }
          break;
      }
    }

    while (operatorStack.isNotEmpty) {
      final top = operatorStack.removeLast();
      if (top.type == TokenType.openParen) {
        throw const ScientificCalculationException(
          ScientificErrorType.unbalancedParens,
        );
      }
      output.add(top);
    }

    return output;
  }

  bool _shouldPopBeforePushing(ExpressionToken top, ExpressionToken incoming) {
    final topPrecedence = _precedence(top);
    final incomingPrecedence = _precedence(incoming);
    if (topPrecedence > incomingPrecedence) {
      return true;
    }
    if (topPrecedence == incomingPrecedence && _isLeftAssociative(incoming)) {
      return true;
    }
    return false;
  }

  bool _isLeftAssociative(ExpressionToken token) {
    if (token.type == TokenType.binaryOperator &&
        _rightAssociativeOperators.contains(token.value)) {
      return false;
    }
    return true;
  }

  int _precedence(ExpressionToken token) {
    switch (token.type) {
      case TokenType.postfixOperator:
        return _postfixPrecedence;
      case TokenType.unaryFunction:
        return _prefixFunctionPrecedence;
      case TokenType.unaryMinus:
        return _unaryMinusPrecedence;
      case TokenType.binaryOperator:
        if (_rightAssociativeOperators.contains(token.value)) {
          return _powerPrecedence;
        }
        if (token.value == '×' || token.value == '÷') {
          return _multiplicativePrecedence;
        }
        return _additivePrecedence;
      case TokenType.number:
      case TokenType.constant:
      case TokenType.openParen:
      case TokenType.closeParen:
        return 0;
    }
  }
}
