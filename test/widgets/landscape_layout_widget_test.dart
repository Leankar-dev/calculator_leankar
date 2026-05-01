import 'package:calculator_05122025/utils/enums/operations_type.dart';
import 'package:calculator_05122025/widgets/calculator_display_widget.dart';
import 'package:calculator_05122025/widgets/calculator_keypad_widget.dart';
import 'package:calculator_05122025/widgets/landscape_layout_widget.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget createTestWidget({
    String displayText = '0',
    String expressionDisplay = '',
    VoidCallback? onClear,
    VoidCallback? onBackspace,
    VoidCallback? onPercentage,
    VoidCallback? onDecimal,
    VoidCallback? onCalculate,
    void Function(String)? onNumberPressed,
    void Function(OperationsType)? onOperationPressed,
  }) {
    return NeumorphicApp(
      home: Scaffold(
        body: LandscapeLayoutWidget(
          displayText: displayText,
          expressionDisplay: expressionDisplay,
          onClear: onClear ?? () {},
          onBackspace: onBackspace ?? () {},
          onPercentage: onPercentage ?? () {},
          onDecimal: onDecimal ?? () {},
          onCalculate: onCalculate ?? () {},
          onNumberPressed: onNumberPressed ?? (_) {},
          onOperationPressed: onOperationPressed ?? (_) {},
        ),
      ),
    );
  }

  group('LandscapeLayoutWidget', () {
    testWidgets('deve renderizar CalculatorDisplayWidget', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byType(CalculatorDisplayWidget), findsOneWidget);
    });

    testWidgets('deve renderizar CalculatorKeypadWidget', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byType(CalculatorKeypadWidget), findsOneWidget);
    });

    testWidgets('deve exibir texto do display', (tester) async {
      await tester.pumpWidget(createTestWidget(displayText: '42'));

      expect(find.text('42'), findsOneWidget);
    });

    testWidgets('deve exibir expressão do display', (tester) async {
      await tester.pumpWidget(
        createTestWidget(displayText: '3', expressionDisplay: '10 +'),
      );

      expect(find.text('10 +'), findsOneWidget);
    });

    testWidgets('deve usar layout Row com display e teclado lado a lado',
        (tester) async {
      await tester.pumpWidget(createTestWidget());

      final row = tester.widget<Row>(find.byType(Row).first);
      expect(row.crossAxisAlignment, CrossAxisAlignment.stretch);
    });
  });
}
