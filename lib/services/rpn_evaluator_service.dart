import 'dart:math' as math;

import 'package:calculator_05122025/models/expression_token.dart';
import 'package:calculator_05122025/utils/constants/app_strings.dart';
import 'package:calculator_05122025/utils/enums/angle_mode.dart';
import 'package:calculator_05122025/utils/enums/scientific_error_type.dart';
import 'package:calculator_05122025/utils/enums/token_type.dart';
import 'package:calculator_05122025/utils/exceptions/scientific_calculation_exception.dart';
import 'package:calculator_05122025/utils/number_formatter.dart';

class RpnEvaluatorService {
  static const int _maxFactorialInput = 170;
  static const double _integerTolerance = 1e-9;

  double evaluate(List<ExpressionToken> rpn, AngleMode angleMode) {
    final stack = <double>[];

    for (final token in rpn) {
      switch (token.type) {
        case TokenType.number:
          stack.add(_parseNumber(token.value));
          break;
        case TokenType.constant:
          stack.add(_constantValue(token.value));
          break;
        case TokenType.unaryMinus:
          stack.add(-_pop(stack));
          break;
        case TokenType.postfixOperator:
          stack.add(_applyPostfix(token.value, _pop(stack)));
          break;
        case TokenType.unaryFunction:
          stack.add(_applyFunction(token.value, _pop(stack), angleMode));
          break;
        case TokenType.binaryOperator:
          final right = _pop(stack);
          final left = _pop(stack);
          stack.add(_applyBinaryOperator(token.value, left, right));
          break;
        case TokenType.openParen:
        case TokenType.closeParen:
          throw const ScientificCalculationException(
            ScientificErrorType.syntaxError,
          );
      }
    }

    if (stack.length != 1) {
      throw const ScientificCalculationException(
        ScientificErrorType.syntaxError,
      );
    }

    final result = stack.single;
    _validateResult(result);
    return result;
  }

  double _pop(List<double> stack) {
    if (stack.isEmpty) {
      throw const ScientificCalculationException(
        ScientificErrorType.syntaxError,
      );
    }
    return stack.removeLast();
  }

  double _parseNumber(String lexeme) {
    final parsed = NumberFormatter.parse(lexeme);
    if (parsed == null) {
      throw const ScientificCalculationException(
        ScientificErrorType.syntaxError,
      );
    }
    return parsed;
  }

  double _constantValue(String symbol) {
    if (symbol == 'π') {
      return math.pi;
    }
    if (symbol == 'e') {
      return math.e;
    }
    throw const ScientificCalculationException(
      ScientificErrorType.syntaxError,
    );
  }

  double _degreesToRadians(double degrees) => degrees * math.pi / 180;

  double _radiansToDegrees(double radians) => radians * 180 / math.pi;

  double _toRadiansIfNeeded(double value, AngleMode angleMode) {
    return angleMode == AngleMode.deg ? _degreesToRadians(value) : value;
  }

  double _fromRadiansIfNeeded(double value, AngleMode angleMode) {
    return angleMode == AngleMode.deg ? _radiansToDegrees(value) : value;
  }

  double _applyFunction(String name, double operand, AngleMode angleMode) {
    switch (name) {
      case 'sin':
        return math.sin(_toRadiansIfNeeded(operand, angleMode));
      case 'cos':
        return math.cos(_toRadiansIfNeeded(operand, angleMode));
      case 'tan':
        return math.tan(_toRadiansIfNeeded(operand, angleMode));
      case 'asin':
        _requireDomain(operand >= -1 && operand <= 1);
        return _fromRadiansIfNeeded(math.asin(operand), angleMode);
      case 'acos':
        _requireDomain(operand >= -1 && operand <= 1);
        return _fromRadiansIfNeeded(math.acos(operand), angleMode);
      case 'atan':
        return _fromRadiansIfNeeded(math.atan(operand), angleMode);
      case 'log':
        _requireDomain(operand > 0);
        return math.log(operand) / math.ln10;
      case 'ln':
        _requireDomain(operand > 0);
        return math.log(operand);
      case '√':
        _requireDomain(operand >= 0);
        return math.sqrt(operand);
      case '³√':
        return operand < 0
            ? -math.pow(-operand, 1 / 3).toDouble()
            : math.pow(operand, 1 / 3).toDouble();
      case 'abs':
        return operand.abs();
      default:
        throw const ScientificCalculationException(
          ScientificErrorType.syntaxError,
        );
    }
  }

  double _applyPostfix(String symbol, double operand) {
    switch (symbol) {
      case '!':
        return _factorial(operand);
      case '²':
        return operand * operand;
      case '³':
        return operand * operand * operand;
      case '⁻¹':
        if (operand == 0) {
          throw const ScientificCalculationException(
            ScientificErrorType.divisionByZero,
          );
        }
        return 1 / operand;
      default:
        throw const ScientificCalculationException(
          ScientificErrorType.syntaxError,
        );
    }
  }

  double _factorial(double value) {
    final isInteger = (value - value.round()).abs() < _integerTolerance;
    if (!isInteger || value < 0) {
      throw const ScientificCalculationException(
        ScientificErrorType.factorialDomainError,
      );
    }
    final rounded = value.round();
    if (rounded > _maxFactorialInput) {
      throw const ScientificCalculationException(
        ScientificErrorType.factorialOverflow,
      );
    }
    double result = 1;
    for (var i = 2; i <= rounded; i++) {
      result *= i;
    }
    return result;
  }

  double _applyBinaryOperator(String symbol, double left, double right) {
    switch (symbol) {
      case '+':
        return left + right;
      case '-':
        return left - right;
      case '×':
        return left * right;
      case '÷':
        if (right == 0) {
          throw const ScientificCalculationException(
            ScientificErrorType.divisionByZero,
          );
        }
        return left / right;
      case '^':
        return math.pow(left, right).toDouble();
      case 'P':
        return _permutation(left, right);
      default:
        throw const ScientificCalculationException(
          ScientificErrorType.syntaxError,
        );
    }
  }

  double _permutation(double n, double r) {
    final nIsInteger = (n - n.round()).abs() < _integerTolerance;
    final rIsInteger = (r - r.round()).abs() < _integerTolerance;
    if (!nIsInteger || !rIsInteger || n < 0 || r < 0 || r > n) {
      throw const ScientificCalculationException(
        ScientificErrorType.domainError,
      );
    }
    final roundedN = n.round();
    final roundedR = r.round();
    double result = 1;
    for (var i = 0; i < roundedR; i++) {
      result *= (roundedN - i);
    }
    return result;
  }

  void _requireDomain(bool isValid) {
    if (!isValid) {
      throw const ScientificCalculationException(
        ScientificErrorType.domainError,
      );
    }
  }

  void _validateResult(double result) {
    if (result.isNaN) {
      throw const ScientificCalculationException(
        ScientificErrorType.domainError,
      );
    }
    if (result.isInfinite || result.abs() > AppStrings.maxDisplayValue) {
      throw const ScientificCalculationException(
        ScientificErrorType.overflow,
      );
    }
  }
}
