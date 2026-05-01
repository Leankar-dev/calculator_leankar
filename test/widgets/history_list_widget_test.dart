import 'package:calculator_05122025/models/calculation_history.dart';
import 'package:calculator_05122025/widgets/history_item_widget.dart';
import 'package:calculator_05122025/widgets/history_list_widget.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  CalculationHistory createItem(String expression, String result) {
    return CalculationHistory(
      expression: expression,
      result: result,
      timestamp: DateTime(2026, 1, 15, 10, 0),
    );
  }

  Widget createTestWidget(
    List<CalculationHistory> history,
    void Function(CalculationHistory) onItemTap,
  ) {
    return NeumorphicApp(
      home: Scaffold(
        body: SizedBox(
          height: 400,
          child: HistoryListWidget(history: history, onItemTap: onItemTap),
        ),
      ),
    );
  }

  group('HistoryListWidget', () {
    testWidgets('deve renderizar HistoryItemWidget para cada item',
        (tester) async {
      final history = [
        createItem('5 + 3', '8'),
        createItem('10 - 4', '6'),
        createItem('3 × 7', '21'),
      ];

      await tester.pumpWidget(createTestWidget(history, (_) {}));

      expect(find.byType(HistoryItemWidget), findsNWidgets(3));
    });

    testWidgets('deve exibir expressões de todos os itens', (tester) async {
      final history = [
        createItem('2 + 2', '4'),
        createItem('9 ÷ 3', '3'),
      ];

      await tester.pumpWidget(createTestWidget(history, (_) {}));

      expect(find.text('2 + 2'), findsOneWidget);
      expect(find.text('9 ÷ 3'), findsOneWidget);
    });

    testWidgets('deve renderizar lista vazia sem erros', (tester) async {
      await tester.pumpWidget(createTestWidget([], (_) {}));

      expect(find.byType(HistoryItemWidget), findsNothing);
    });

    testWidgets('deve usar ListView para renderização', (tester) async {
      final history = [createItem('1 + 1', '2')];

      await tester.pumpWidget(createTestWidget(history, (_) {}));

      expect(find.byType(ListView), findsOneWidget);
    });
  });
}
