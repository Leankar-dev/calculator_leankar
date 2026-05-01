import 'package:calculator_05122025/widgets/history_empty_state_widget.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget createTestWidget() {
    return const NeumorphicApp(
      home: Scaffold(
        body: HistoryEmptyStateWidget(),
      ),
    );
  }

  group('HistoryEmptyStateWidget', () {
    testWidgets('deve exibir ícone de histórico', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byIcon(Icons.history), findsOneWidget);
    });

    testWidgets('deve exibir texto de estado vazio', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('Sem Histórico de cálculos'), findsOneWidget);
    });

    testWidgets('deve centralizar o conteúdo', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byType(Center), findsWidgets);
    });
  });
}
