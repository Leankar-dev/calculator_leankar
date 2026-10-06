import 'package:calculator_05122025/utils/enums/scientific_function_insertion.dart';

enum ScientificFunctionType {
  sin(ScientificFunctionInsertion.prefixFunction, 'sin'),
  cos(ScientificFunctionInsertion.prefixFunction, 'cos'),
  tan(ScientificFunctionInsertion.prefixFunction, 'tan'),
  asin(ScientificFunctionInsertion.prefixFunction, 'asin'),
  acos(ScientificFunctionInsertion.prefixFunction, 'acos'),
  atan(ScientificFunctionInsertion.prefixFunction, 'atan'),
  log(ScientificFunctionInsertion.prefixFunction, 'log'),
  ln(ScientificFunctionInsertion.prefixFunction, 'ln'),
  sqrt(ScientificFunctionInsertion.prefixFunction, '√'),
  cbrt(ScientificFunctionInsertion.prefixFunction, '³√'),
  absoluteValue(ScientificFunctionInsertion.prefixFunction, 'abs'),
  square(ScientificFunctionInsertion.postfixOperator, '²'),
  cube(ScientificFunctionInsertion.postfixOperator, '³'),
  reciprocal(ScientificFunctionInsertion.postfixOperator, '⁻¹'),
  factorial(ScientificFunctionInsertion.postfixOperator, '!'),
  exp10(ScientificFunctionInsertion.powerOfNumber, '10'),
  expE(ScientificFunctionInsertion.powerOfConstant, 'e'),
  power(ScientificFunctionInsertion.notInsertable, '^'),
  nthRoot(ScientificFunctionInsertion.notInsertable, 'ʸ√'),
  permutation(ScientificFunctionInsertion.notInsertable, 'P'),
  combination(ScientificFunctionInsertion.notInsertable, 'C');

  final ScientificFunctionInsertion insertion;
  final String lexeme;

  const ScientificFunctionType(this.insertion, this.lexeme);
}
