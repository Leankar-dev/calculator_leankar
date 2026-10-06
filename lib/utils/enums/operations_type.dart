enum OperationsType {
  addition(symbol: '+', percentageIsRelativeToFirstOperand: true),
  subtraction(symbol: '-', percentageIsRelativeToFirstOperand: true),
  multiplication(symbol: '×', percentageIsRelativeToFirstOperand: false),
  division(symbol: '÷', percentageIsRelativeToFirstOperand: false);

  final String symbol;
  final bool percentageIsRelativeToFirstOperand;

  const OperationsType({
    required this.symbol,
    required this.percentageIsRelativeToFirstOperand,
  });
}
