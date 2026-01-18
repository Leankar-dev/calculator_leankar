import 'package:calculator_05122025/widgets/calculator_display_widget.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget createTestWidget({
    required String displayText,
    required String expressionDisplay,
  }) {
    return NeumorphicApp(
      home: Scaffold(
        body: CalculatorDisplayWidget(
          displayText: displayText,
          expressionDisplay: expressionDisplay,
        ),
      ),
    );
  }

  group('CalculatorDisplayWidget', () {
    testWidgets('deve exibir o texto do display', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          displayText: '123',
          expressionDisplay: '',
        ),
      );

      expect(find.text('123'), findsOneWidget);
    });

    testWidgets('deve exibir a expressão quando não vazia', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          displayText: '5',
          expressionDisplay: '10 +',
        ),
      );

      expect(find.text('10 +'), findsOneWidget);
      expect(find.text('5'), findsOneWidget);
    });

    testWidgets('não deve exibir expressão quando vazia', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          displayText: '0',
          expressionDisplay: '',
        ),
      );

      expect(find.text('0'), findsOneWidget);
      final textWidgets = tester.widgetList<Text>(find.byType(Text));
      expect(textWidgets.length, 1);
    });

    testWidgets('deve conter widget Neumorphic', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          displayText: '0',
          expressionDisplay: '',
        ),
      );

      expect(find.byType(Neumorphic), findsOneWidget);
    });

    testWidgets('deve exibir números grandes corretamente', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          displayText: '999999999',
          expressionDisplay: '',
        ),
      );

      expect(find.text('999999999'), findsOneWidget);
      expect(find.byType(FittedBox), findsOneWidget);
    });

    testWidgets('deve exibir número decimal com vírgula', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          displayText: '3,14159',
          expressionDisplay: '',
        ),
      );

      expect(find.text('3,14159'), findsOneWidget);
    });

    testWidgets('deve exibir mensagem de erro', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          displayText: 'Erro',
          expressionDisplay: '',
        ),
      );

      expect(find.text('Erro'), findsOneWidget);
    });

    testWidgets('deve ter estilo de texto correto para display', (
      tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(
          displayText: '42',
          expressionDisplay: '',
        ),
      );

      final textWidget = tester.widget<Text>(find.text('42'));
      expect(textWidget.style?.fontSize, 48);
      expect(textWidget.style?.fontWeight, FontWeight.bold);
    });
  });
}
