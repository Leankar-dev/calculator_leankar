enum OperationsType {
  addition(symbol: '+'),
  subtraction(symbol: '-'),
  multiplication(symbol: '×'),
  division(symbol: '÷')
  ;

  final String symbol;

  const OperationsType({required this.symbol});
}
