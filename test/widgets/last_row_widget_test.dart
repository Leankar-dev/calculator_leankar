import 'package:calculator_05122025/utils/constants.dart';
import 'package:calculator_05122025/utils/enums/operations_type.dart';
import 'package:calculator_05122025/widgets/last_row_widget.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget createTestWidget({
    void Function(String)? onNumberPressed,
    VoidCallback? onDecimal,
    VoidCallback? onCalculate,
    void Function(OperationsType)? onOperationPressed,
  }) {
    return NeumorphicApp(
      home: Scaffold(
        body: Row(
          children: [
            Expanded(
              child: LastRowWidget(
                onNumberPressed: onNumberPressed ?? (_) {},
                onDecimal: onDecimal ?? () {},
                onCalculate: onCalculate ?? () {},
                onOperationPressed: onOperationPressed ?? (_) {},
              ),
            ),
          ],
        ),
      ),
    );
  }

  group('LastRowWidget', () {
    testWidgets('deve exibir botão 0', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('0'), findsOneWidget);
    });

    testWidgets('deve exibir botão de decimal', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text(AppConstants.decimalSeparator), findsOneWidget);
    });

    testWidgets('deve exibir botão de igual', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('='), findsOneWidget);
    });

    testWidgets('deve exibir botão de adição', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text(AppConstants.additionSymbol), findsOneWidget);
    });

    testWidgets('deve chamar onNumberPressed com "0" ao pressionar 0',
        (tester) async {
      String? pressed;

      await tester.pumpWidget(
        createTestWidget(onNumberPressed: (n) => pressed = n),
      );

      await tester.tap(find.text('0'));
      await tester.pumpAndSettle();

      expect(pressed, '0');
    });

    testWidgets('deve chamar onDecimal ao pressionar vírgula', (tester) async {
      bool called = false;

      await tester.pumpWidget(createTestWidget(onDecimal: () => called = true));

      await tester.tap(find.text(AppConstants.decimalSeparator));
      await tester.pumpAndSettle();

      expect(called, isTrue);
    });

    testWidgets('deve chamar onCalculate ao pressionar =', (tester) async {
      bool called = false;

      await tester.pumpWidget(
        createTestWidget(onCalculate: () => called = true),
      );

      await tester.tap(find.text('='));
      await tester.pumpAndSettle();

      expect(called, isTrue);
    });

    testWidgets('deve chamar onOperationPressed com addition ao pressionar +',
        (tester) async {
      OperationsType? pressed;

      await tester.pumpWidget(
        createTestWidget(onOperationPressed: (op) => pressed = op),
      );

      await tester.tap(find.text(AppConstants.additionSymbol));
      await tester.pumpAndSettle();

      expect(pressed, OperationsType.addition);
    });
  });
}
