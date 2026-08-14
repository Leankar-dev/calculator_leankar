import 'package:calculator_05122025/utils/enums/angle_mode.dart';
import 'package:calculator_05122025/utils/enums/scientific_function_type.dart';
import 'package:calculator_05122025/widgets/scientific/scientific_keypad_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/l10n_test_app.dart';

void main() {
  Widget createTestWidget({
    AngleMode angleMode = AngleMode.deg,
    bool isShiftActive = false,
    bool hasMemoryValue = false,
    void Function(String)? onBinaryOperator,
    void Function(String)? onNumberPressed,
  }) {
    return L10nTestApp(
      child: Scaffold(
        body: SingleChildScrollView(
          child: ScientificKeypadWidget(
            angleMode: angleMode,
            isShiftActive: isShiftActive,
            hasMemoryValue: hasMemoryValue,
            onToggleAngleMode: () {},
            onToggleShift: () {},
            onLockShift: () {},
            onPi: () {},
            onEuler: () {},
            onFunction: (ScientificFunctionType function) {},
            onBinaryOperator: onBinaryOperator ?? (_) {},
            onOpenParen: () {},
            onCloseParen: () {},
            onMemoryAdd: () {},
            onMemorySubtract: () {},
            onMemoryRecall: () {},
            onMemoryClear: () {},
            onClear: () {},
            onBackspace: () {},
            onPercentage: () {},
            onDecimal: () {},
            onCalculate: () {},
            onNumberPressed: onNumberPressed ?? (_) {},
          ),
        ),
      ),
    );
  }

  group('ScientificKeypadWidget', () {
    testWidgets('renderiza as 5 linhas científicas e o teclado reaproveitado', (
      tester,
    ) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('SHIFT'), findsOneWidget);
      expect(find.text('sin'), findsOneWidget);
      expect(find.text('log'), findsOneWidget);
      expect(find.text('('), findsOneWidget);
      expect(find.text('M+'), findsOneWidget);
      expect(find.text('C'), findsOneWidget);
      expect(find.text('7'), findsOneWidget);
      expect(find.text('='), findsOneWidget);
    });

    testWidgets(
      'toque em ÷ (linha reaproveitada) converte OperationsType para símbolo',
      (
        tester,
      ) async {
        String? received;
        await tester.pumpWidget(
          createTestWidget(onBinaryOperator: (op) => received = op),
        );
        await tester.tap(find.text('÷'));
        await tester.pumpAndSettle();
        expect(received, '÷');
      },
    );

    testWidgets('toque em número reaproveitado chama onNumberPressed', (
      tester,
    ) async {
      String? received;
      await tester.pumpWidget(
        createTestWidget(onNumberPressed: (digit) => received = digit),
      );
      await tester.tap(find.text('7'));
      await tester.pumpAndSettle();
      expect(received, '7');
    });
  });
}
