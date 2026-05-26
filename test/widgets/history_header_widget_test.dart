import 'package:calculator_05122025/utils/constants/app_strings.dart';
import 'package:calculator_05122025/widgets/history_header_widget.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget createTestWidget({
    bool hasHistory = false,
    VoidCallback? onClearHistory,
  }) {
    return NeumorphicApp(
      home: Scaffold(
        body: HistoryHeaderWidget(
          hasHistory: hasHistory,
          onClearHistory: onClearHistory ?? () {},
        ),
      ),
    );
  }

  Widget createTestWidgetWithRoute({
    required bool hasHistory,
    VoidCallback? onClearHistory,
  }) {
    return NeumorphicApp(
      home: Builder(
        builder: (ctx) => Scaffold(
          body: ElevatedButton(
            onPressed: () => Navigator.push(
              ctx,
              MaterialPageRoute(
                builder: (_) => Scaffold(
                  body: HistoryHeaderWidget(
                    hasHistory: hasHistory,
                    onClearHistory: onClearHistory ?? () {},
                  ),
                ),
              ),
            ),
            child: const Text('open'),
          ),
        ),
      ),
    );
  }

  group('HistoryHeaderWidget', () {
    testWidgets('deve exibir título History quando histórico está vazio',
        (tester) async {
      await tester.pumpWidget(createTestWidget(hasHistory: false));

      expect(find.text(AppStrings.historyTitle), findsOneWidget);
    });

    testWidgets('deve exibir título History quando há histórico',
        (tester) async {
      await tester.pumpWidget(createTestWidget(hasHistory: true));

      expect(find.text(AppStrings.historyTitle), findsOneWidget);
    });

    testWidgets('não deve exibir botão Clear quando histórico vazio',
        (tester) async {
      await tester.pumpWidget(createTestWidget(hasHistory: false));

      expect(find.text(AppStrings.historyClearButton), findsNothing);
    });

    testWidgets('deve exibir botão Clear quando há histórico', (tester) async {
      await tester.pumpWidget(createTestWidget(hasHistory: true));

      expect(find.text(AppStrings.historyClearButton), findsOneWidget);
    });

    testWidgets('não deve exibir NeumorphicButton quando histórico vazio',
        (tester) async {
      await tester.pumpWidget(createTestWidget(hasHistory: false));

      expect(find.byType(NeumorphicButton), findsNothing);
    });

    testWidgets('deve exibir NeumorphicButton quando há histórico',
        (tester) async {
      await tester.pumpWidget(createTestWidget(hasHistory: true));

      expect(find.byType(NeumorphicButton), findsOneWidget);
    });

    testWidgets('deve chamar onClearHistory ao pressionar Clear',
        (tester) async {
      bool called = false;

      await tester.pumpWidget(
        createTestWidgetWithRoute(
          hasHistory: true,
          onClearHistory: () => called = true,
        ),
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      await tester.tap(find.text(AppStrings.historyClearButton));
      await tester.pumpAndSettle();

      expect(called, isTrue);
    });
  });
}
