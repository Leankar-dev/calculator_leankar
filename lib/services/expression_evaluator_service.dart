import 'package:calculator_05122025/services/expression_tokenizer_service.dart';
import 'package:calculator_05122025/services/rpn_evaluator_service.dart';
import 'package:calculator_05122025/services/shunting_yard_service.dart';
import 'package:calculator_05122025/utils/enums/angle_mode.dart';

class ExpressionEvaluatorService {
  final ExpressionTokenizerService _tokenizer;
  final ShuntingYardService _shuntingYard;
  final RpnEvaluatorService _rpnEvaluator;

  ExpressionEvaluatorService({
    ExpressionTokenizerService? tokenizer,
    ShuntingYardService? shuntingYard,
    RpnEvaluatorService? rpnEvaluator,
  }) : _tokenizer = tokenizer ?? ExpressionTokenizerService(),
       _shuntingYard = shuntingYard ?? ShuntingYardService(),
       _rpnEvaluator = rpnEvaluator ?? RpnEvaluatorService();

  double evaluate(String expression, AngleMode angleMode) {
    final tokens = _tokenizer.tokenize(expression);
    final rpn = _shuntingYard.toRpn(tokens);
    return _rpnEvaluator.evaluate(rpn, angleMode);
  }
}
