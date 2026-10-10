import 'package:calculator_05122025/utils/constants/app_strings.dart';

enum OperationsType {
  addition(
    symbol: AppStrings.additionSymbol,
    percentageIsRelativeToFirstOperand: true,
  ),
  subtraction(
    symbol: AppStrings.subtractionSymbol,
    percentageIsRelativeToFirstOperand: true,
  ),
  multiplication(
    symbol: AppStrings.multiplicationSymbol,
    percentageIsRelativeToFirstOperand: false,
  ),
  division(
    symbol: AppStrings.divisionSymbol,
    percentageIsRelativeToFirstOperand: false,
  );

  final String symbol;
  final bool percentageIsRelativeToFirstOperand;

  const OperationsType({
    required this.symbol,
    required this.percentageIsRelativeToFirstOperand,
  });
}
