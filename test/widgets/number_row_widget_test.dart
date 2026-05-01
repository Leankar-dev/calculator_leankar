import 'package:calculator_05122025/utils/constants.dart';
import 'package:calculator_05122025/utils/enums/operations_type.dart';
import 'package:calculator_05122025/widgets/number_row_widget.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget createTestWidget({
    List<String> numbers = const ['7', '8', '9'],
    OperationsType operation = OperationsType.multiplication,
    String? operationSymbol,
    void Function(String)? onNumberPressed,
    void Function(OperationsType)? onOperationPressed,
  }) {
    return NeumorphicApp(
      home: Scaffold(
        body: Row(
          children: [
            Expanded(
              child: NumberRowWidget(
                numbers: numbers,
                operation: operation,
                operationSymbol:
                    operationSymbol ?? AppConstants.multiplicationSymbol,
                onNumberPressed: onNumberPressed ?? (_) {},
                onOperationPressed: onOperationPressed ?? (_) {},
              ),
            ),
          ],
        ),
      ),
    );
  }

  group('NumberRowWidget', () {
    testWidgets('deve exibir todos os números da lista', (tester) async {
      await tester.pumpWidget(
        createTestWidget(numbers: ['7', '8', '9']),
      );

      expect(find.text('7'), findsOneWidget);
      expect(find.text('8'), findsOneWidget);
      expect(find.text('9'), findsOneWidget);
    });

    testWidgets('deve exibir botão de operação', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          operation: OperationsType.division,
          operationSymbol: AppConstants.divisionSymbol,
        ),
      );

      expect(find.text(AppConstants.divisionSymbol), findsOneWidget);
    });

    testWidgets('deve chamar onNumberPressed com número correto',
        (tester) async {
      String? pressed;

      await tester.pumpWidget(
        createTestWidget(
          numbers: ['4', '5', '6'],
          onNumberPressed: (n) => pressed = n,
        ),
      );

      await tester.tap(find.text('5'));
      await tester.pumpAndSettle();

      expect(pressed, '5');
    });

    testWidgets('deve chamar onOperationPressed com operação correta',
        (tester) async {
      OperationsType? pressed;

      await tester.pumpWidget(
        createTestWidget(
          operation: OperationsType.subtraction,
          operationSymbol: AppConstants.subtractionSymbol,
          onOperationPressed: (op) => pressed = op,
        ),
      );

      await tester.tap(find.text(AppConstants.subtractionSymbol));
      await tester.pumpAndSettle();

      expect(pressed, OperationsType.subtraction);
    });

    testWidgets('deve renderizar texto de cada número e operação',
        (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          numbers: ['1', '2', '3'],
          operation: OperationsType.addition,
          operationSymbol: AppConstants.additionSymbol,
        ),
      );

      expect(find.text('1'), findsOneWidget);
      expect(find.text('2'), findsOneWidget);
      expect(find.text('3'), findsOneWidget);
      expect(find.text(AppConstants.additionSymbol), findsOneWidget);
    });
  });
}
