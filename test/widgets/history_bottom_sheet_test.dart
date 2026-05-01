import 'package:calculator_05122025/models/calculation_history.dart';
import 'package:calculator_05122025/widgets/history_bottom_sheet.dart';
import 'package:calculator_05122025/widgets/history_empty_state_widget.dart';
import 'package:calculator_05122025/widgets/history_header_widget.dart';
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

  Widget createTestWidget({
    List<CalculationHistory> history = const [],
    void Function(CalculationHistory)? onItemTap,
    VoidCallback? onClearHistory,
  }) {
    return NeumorphicApp(
      home: Scaffold(
        body: HistoryBottomSheet(
          history: history,
          onItemTap: onItemTap ?? (_) {},
          onClearHistory: onClearHistory ?? () {},
        ),
      ),
    );
  }

  group('HistoryBottomSheet', () {
    testWidgets('deve exibir HistoryHeaderWidget sempre', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byType(HistoryHeaderWidget), findsOneWidget);
    });

    testWidgets('deve exibir HistoryEmptyStateWidget quando histórico vazio',
        (tester) async {
      await tester.pumpWidget(createTestWidget(history: []));

      expect(find.byType(HistoryEmptyStateWidget), findsOneWidget);
    });

    testWidgets('não deve exibir HistoryListWidget quando histórico vazio',
        (tester) async {
      await tester.pumpWidget(createTestWidget(history: []));

      expect(find.byType(HistoryListWidget), findsNothing);
    });

    testWidgets('deve exibir HistoryListWidget quando há itens',
        (tester) async {
      final history = [createItem('5 + 3', '8')];

      await tester.pumpWidget(createTestWidget(history: history));

      expect(find.byType(HistoryListWidget), findsOneWidget);
    });

    testWidgets('não deve exibir HistoryEmptyStateWidget quando há itens',
        (tester) async {
      final history = [createItem('2 × 4', '8')];

      await tester.pumpWidget(createTestWidget(history: history));

      expect(find.byType(HistoryEmptyStateWidget), findsNothing);
    });

    testWidgets('deve exibir texto "History" no cabeçalho', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('History'), findsOneWidget);
    });

    testWidgets('deve exibir botão Clear quando há itens', (tester) async {
      final history = [createItem('3 + 3', '6')];

      await tester.pumpWidget(createTestWidget(history: history));

      expect(find.text('Clear'), findsOneWidget);
    });

    testWidgets('não deve exibir botão Clear quando histórico vazio',
        (tester) async {
      await tester.pumpWidget(createTestWidget(history: []));

      expect(find.text('Clear'), findsNothing);
    });
  });
}
