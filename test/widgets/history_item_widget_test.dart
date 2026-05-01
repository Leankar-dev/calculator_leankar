import 'package:calculator_05122025/models/calculation_history.dart';
import 'package:calculator_05122025/widgets/history_item_widget.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

void main() {
  CalculationHistory createItem({
    String expression = '5 + 3',
    String result = '8',
    DateTime? timestamp,
  }) {
    return CalculationHistory(
      expression: expression,
      result: result,
      timestamp: timestamp ?? DateTime(2026, 1, 15, 10, 30),
    );
  }

  Widget createTestWidget(
    CalculationHistory item,
    void Function(CalculationHistory) onItemTap,
  ) {
    return NeumorphicApp(
      home: Scaffold(
        body: HistoryItemWidget(item: item, onItemTap: onItemTap),
      ),
    );
  }

  Widget createTestWidgetWithRoute(
    CalculationHistory item,
    void Function(CalculationHistory) onItemTap,
  ) {
    return NeumorphicApp(
      home: Builder(
        builder: (ctx) => Scaffold(
          body: Center(
            child: ElevatedButton(
              onPressed: () => Navigator.push(
                ctx,
                MaterialPageRoute(
                  builder: (_) => Scaffold(
                    body: HistoryItemWidget(item: item, onItemTap: onItemTap),
                  ),
                ),
              ),
              child: const Text('open'),
            ),
          ),
        ),
      ),
    );
  }

  group('HistoryItemWidget', () {
    testWidgets('deve exibir a expressão do cálculo', (tester) async {
      final item = createItem(expression: '10 × 5');

      await tester.pumpWidget(createTestWidget(item, (_) {}));

      expect(find.text('10 × 5'), findsOneWidget);
    });

    testWidgets('deve exibir o resultado com prefixo "= "', (tester) async {
      final item = createItem(result: '50');

      await tester.pumpWidget(createTestWidget(item, (_) {}));

      expect(find.text('= 50'), findsOneWidget);
    });

    testWidgets('deve exibir o timestamp formatado', (tester) async {
      final timestamp = DateTime(2026, 3, 25, 14, 45);
      final item = createItem(timestamp: timestamp);
      final expectedFormat = DateFormat('dd/MM HH:mm').format(timestamp);

      await tester.pumpWidget(createTestWidget(item, (_) {}));

      expect(find.text(expectedFormat), findsOneWidget);
    });

    testWidgets('deve conter NeumorphicButton', (tester) async {
      final item = createItem();

      await tester.pumpWidget(createTestWidget(item, (_) {}));

      expect(find.byType(NeumorphicButton), findsOneWidget);
    });

    testWidgets('deve chamar onItemTap com o item correto ao pressionar',
        (tester) async {
      final item = createItem(expression: '7 + 3', result: '10');
      CalculationHistory? tapped;

      await tester.pumpWidget(
        createTestWidgetWithRoute(item, (i) => tapped = i),
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(NeumorphicButton));
      await tester.pumpAndSettle();

      expect(tapped?.expression, '7 + 3');
      expect(tapped?.result, '10');
    });
  });
}
