import 'package:calculator_05122025/utils/enums/operations_type.dart';
import 'package:calculator_05122025/widgets/calculator_display_widget.dart';
import 'package:calculator_05122025/widgets/calculator_footer_widget.dart';
import 'package:calculator_05122025/widgets/calculator_keypad_widget.dart';
import 'package:calculator_05122025/widgets/portrait_layout_widget.dart';
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
        body: PortraitLayoutWidget(
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

  group('PortraitLayoutWidget', () {
    testWidgets('deve renderizar CalculatorDisplayWidget', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byType(CalculatorDisplayWidget), findsOneWidget);
    });

    testWidgets('deve renderizar CalculatorKeypadWidget', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byType(CalculatorKeypadWidget), findsOneWidget);
    });

    testWidgets('deve renderizar CalculatorFooterWidget', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byType(CalculatorFooterWidget), findsOneWidget);
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

    testWidgets('deve exibir URL no rodapé', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('https://leankar.dev'), findsOneWidget);
    });
  });
}
