import 'package:calculator_05122025/utils/constants/app_scientific_lexemes.dart';
import 'package:calculator_05122025/utils/enums/scientific_function_insertion.dart';

enum ScientificFunctionType {
  sin(ScientificFunctionInsertion.prefixFunction, AppScientificLexemes.sin),
  cos(ScientificFunctionInsertion.prefixFunction, AppScientificLexemes.cos),
  tan(ScientificFunctionInsertion.prefixFunction, AppScientificLexemes.tan),
  asin(ScientificFunctionInsertion.prefixFunction, AppScientificLexemes.asin),
  acos(ScientificFunctionInsertion.prefixFunction, AppScientificLexemes.acos),
  atan(ScientificFunctionInsertion.prefixFunction, AppScientificLexemes.atan),
  log(ScientificFunctionInsertion.prefixFunction, AppScientificLexemes.log),
  ln(ScientificFunctionInsertion.prefixFunction, AppScientificLexemes.ln),
  sqrt(ScientificFunctionInsertion.prefixFunction, AppScientificLexemes.sqrt),
  cbrt(ScientificFunctionInsertion.prefixFunction, AppScientificLexemes.cbrt),
  absoluteValue(
    ScientificFunctionInsertion.prefixFunction,
    AppScientificLexemes.absoluteValue,
  ),
  square(
    ScientificFunctionInsertion.postfixOperator,
    AppScientificLexemes.square,
  ),
  cube(ScientificFunctionInsertion.postfixOperator, AppScientificLexemes.cube),
  reciprocal(
    ScientificFunctionInsertion.postfixOperator,
    AppScientificLexemes.reciprocal,
  ),
  factorial(
    ScientificFunctionInsertion.postfixOperator,
    AppScientificLexemes.factorial,
  ),
  exp10(ScientificFunctionInsertion.powerOfNumber, AppScientificLexemes.exp10),
  expE(ScientificFunctionInsertion.powerOfConstant, AppScientificLexemes.expE),
  power(ScientificFunctionInsertion.notInsertable, AppScientificLexemes.power),
  nthRoot(
    ScientificFunctionInsertion.notInsertable,
    AppScientificLexemes.nthRoot,
  ),
  permutation(
    ScientificFunctionInsertion.notInsertable,
    AppScientificLexemes.permutation,
  ),
  combination(
    ScientificFunctionInsertion.notInsertable,
    AppScientificLexemes.combination,
  );

  final ScientificFunctionInsertion insertion;
  final String lexeme;

  const ScientificFunctionType(this.insertion, this.lexeme);

  static List<String> lexemesFor(ScientificFunctionInsertion insertion) {
    return [
      for (final function in values)
        if (function.insertion == insertion) function.lexeme,
    ];
  }
}
