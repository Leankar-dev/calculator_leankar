import 'package:calculator_05122025/utils/enums/scientific_function_insertion.dart';
import 'package:calculator_05122025/utils/enums/scientific_function_type.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ScientificFunctionType', () {
    test('funções de prefixo carregam o lexema usado na expressão', () {
      final expected = {
        ScientificFunctionType.sin: 'sin',
        ScientificFunctionType.cos: 'cos',
        ScientificFunctionType.tan: 'tan',
        ScientificFunctionType.asin: 'asin',
        ScientificFunctionType.acos: 'acos',
        ScientificFunctionType.atan: 'atan',
        ScientificFunctionType.log: 'log',
        ScientificFunctionType.ln: 'ln',
        ScientificFunctionType.sqrt: '√',
        ScientificFunctionType.cbrt: '³√',
        ScientificFunctionType.absoluteValue: 'abs',
      };

      expected.forEach((function, lexeme) {
        expect(
          function.insertion,
          ScientificFunctionInsertion.prefixFunction,
          reason: function.name,
        );
        expect(function.lexeme, lexeme, reason: function.name);
      });
    });

    test('operadores pós-fixos carregam o símbolo usado na expressão', () {
      final expected = {
        ScientificFunctionType.square: '²',
        ScientificFunctionType.cube: '³',
        ScientificFunctionType.reciprocal: '⁻¹',
        ScientificFunctionType.factorial: '!',
      };

      expected.forEach((function, symbol) {
        expect(
          function.insertion,
          ScientificFunctionInsertion.postfixOperator,
          reason: function.name,
        );
        expect(function.lexeme, symbol, reason: function.name);
      });
    });

    test('exp10 e expE inserem uma potência com base fixa', () {
      expect(
        ScientificFunctionType.exp10.insertion,
        ScientificFunctionInsertion.powerOfNumber,
      );
      expect(ScientificFunctionType.exp10.lexeme, '10');
      expect(
        ScientificFunctionType.expE.insertion,
        ScientificFunctionInsertion.powerOfConstant,
      );
      expect(ScientificFunctionType.expE.lexeme, 'e');
    });

    test('operações binárias não são inseríveis como função', () {
      for (final function in [
        ScientificFunctionType.power,
        ScientificFunctionType.nthRoot,
        ScientificFunctionType.permutation,
        ScientificFunctionType.combination,
      ]) {
        expect(
          function.insertion,
          ScientificFunctionInsertion.notInsertable,
          reason: function.name,
        );
      }
    });

    test('power usa o símbolo de potência da expressão', () {
      expect(ScientificFunctionType.power.lexeme, '^');
    });
  });
}
