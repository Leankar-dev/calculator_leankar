import 'package:calculator_05122025/utils/enums/operations_type.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('OperationsType', () {
    test('cada operação expõe o símbolo exibido', () {
      expect(OperationsType.addition.symbol, '+');
      expect(OperationsType.subtraction.symbol, '-');
      expect(OperationsType.multiplication.symbol, '×');
      expect(OperationsType.division.symbol, '÷');
    });

    test('porcentagem é relativa ao primeiro operando em + e -', () {
      expect(
        OperationsType.addition.percentageIsRelativeToFirstOperand,
        isTrue,
      );
      expect(
        OperationsType.subtraction.percentageIsRelativeToFirstOperand,
        isTrue,
      );
    });

    test('porcentagem é apenas o valor dividido por 100 em × e ÷', () {
      expect(
        OperationsType.multiplication.percentageIsRelativeToFirstOperand,
        isFalse,
      );
      expect(
        OperationsType.division.percentageIsRelativeToFirstOperand,
        isFalse,
      );
    });
  });
}
