import 'package:calculator_05122025/utils/enums/token_type.dart';

class ExpressionToken {
  final TokenType type;
  final String value;

  const ExpressionToken({required this.type, required this.value});
}
