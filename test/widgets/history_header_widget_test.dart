import 'package:calculator_05122025/widgets/history_header_widget.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:flutter_test/flutter_test.dart';
import '../helpers/l10n_test_app.dart';

void main() {
  Widget createTestWidget({
    bool hasHistory = false,
    VoidCallback? onClearHistory,
  }) {
    return L10nTestApp(
      child: Scaffold(
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
    return L10nTestApp(
      child: Builder(
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
    testWidgets('deve exibir título Histórico quando histórico está vazio', (
      tester,
    ) async {
      await tester.pumpWidget(createTestWidget(hasHistory: false));

      expect(find.text('Histórico'), findsOneWidget);
    });

    testWidgets('deve exibir título Histórico quando há histórico', (
      tester,
    ) async {
      await tester.pumpWidget(createTestWidget(hasHistory: true));

      expect(find.text('Histórico'), findsOneWidget);
    });

    testWidgets('não deve exibir botão Limpar quando histórico vazio', (
      tester,
    ) async {
      await tester.pumpWidget(createTestWidget(hasHistory: false));

      expect(find.text('Limpar'), findsNothing);
    });

    testWidgets('deve exibir botão Limpar quando há histórico', (tester) async {
      await tester.pumpWidget(createTestWidget(hasHistory: true));

      expect(find.text('Limpar'), findsOneWidget);
    });

    testWidgets('não deve exibir NeumorphicButton quando histórico vazio', (
      tester,
    ) async {
      await tester.pumpWidget(createTestWidget(hasHistory: false));

      expect(find.byType(NeumorphicButton), findsNothing);
    });

    testWidgets('deve exibir NeumorphicButton quando há histórico', (
      tester,
    ) async {
      await tester.pumpWidget(createTestWidget(hasHistory: true));

      expect(find.byType(NeumorphicButton), findsOneWidget);
    });

    testWidgets('deve chamar onClearHistory ao pressionar Limpar', (
      tester,
    ) async {
      bool called = false;

      await tester.pumpWidget(
        createTestWidgetWithRoute(
          hasHistory: true,
          onClearHistory: () => called = true,
        ),
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Limpar'));
      await tester.pumpAndSettle();

      expect(called, isTrue);
    });
  });
}
