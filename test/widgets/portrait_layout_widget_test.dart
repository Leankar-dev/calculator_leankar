import 'package:calculator_05122025/utils/enums/operations_type.dart';
import 'package:calculator_05122025/widgets/calculator_display_widget.dart';
import 'package:calculator_05122025/widgets/calculator_keypad_widget.dart';
import 'package:calculator_05122025/widgets/portrait_layout_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../helpers/l10n_test_app.dart';

void main() {
  Widget createTestWidget({
    String displayText = '0',
    String expressionDisplay = '',
    Widget? keypad,
  }) {
    return L10nTestApp(
      child: Scaffold(
        body: PortraitLayoutWidget(
          displayText: displayText,
          expressionDisplay: expressionDisplay,
          keypad:
              keypad ??
              CalculatorKeypadWidget(
                onClear: () {},
                onBackspace: () {},
                onPercentage: () {},
                onDecimal: () {},
                onCalculate: () {},
                onNumberPressed: (_) {},
                onOperationPressed: (OperationsType op) {},
              ),
        ),
      ),
    );
  }

  group('PortraitLayoutWidget', () {
    testWidgets('deve renderizar CalculatorDisplayWidget', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byType(CalculatorDisplayWidget), findsOneWidget);
    });

    testWidgets('deve renderizar o keypad recebido', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byType(CalculatorKeypadWidget), findsOneWidget);
    });

    testWidgets('deve exibir texto do display', (tester) async {
      await tester.pumpWidget(createTestWidget(displayText: '99'));

      expect(find.text('99'), findsOneWidget);
    });

    testWidgets('deve exibir expressão do display', (tester) async {
      await tester.pumpWidget(
        createTestWidget(displayText: '5', expressionDisplay: '20 -'),
      );

      expect(find.text('20 -'), findsOneWidget);
    });
  });
}
