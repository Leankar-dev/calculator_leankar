import 'package:calculator_05122025/services/expression_evaluator_service.dart';
import 'package:calculator_05122025/utils/enums/angle_mode.dart';
import 'package:calculator_05122025/utils/exceptions/scientific_calculation_exception.dart';

class MockExpressionEvaluatorService extends ExpressionEvaluatorService {
  double? resultToReturn;
  ScientificCalculationException? exceptionToThrow;
  String? lastExpression;
  AngleMode? lastAngleMode;
  int callCount = 0;

  @override
  double evaluate(String expression, AngleMode angleMode) {
    callCount++;
    lastExpression = expression;
    lastAngleMode = angleMode;
    if (exceptionToThrow != null) {
      throw exceptionToThrow!;
    }
    return resultToReturn ?? 0;
  }
}
