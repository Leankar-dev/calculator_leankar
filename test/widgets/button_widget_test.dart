import 'package:calculator_05122025/widgets/button_widget.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget createTestWidget({
    required String text,
    required VoidCallback onPressed,
    Color? color,
  }) {
    return NeumorphicApp(
      home: Scaffold(
        body: Row(
          children: [
            ButtonWidget(
              text: text,
              onPressed: onPressed,
              color: color,
            ),
          ],
        ),
      ),
    );
  }

  group('ButtonWidget', () {
    testWidgets('deve exibir o texto corretamente', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          text: '5',
          onPressed: () {},
        ),
      );

      expect(find.text('5'), findsOneWidget);
    });

    testWidgets('deve chamar onPressed ao ser pressionado', (tester) async {
      bool wasPressed = false;

      await tester.pumpWidget(
        createTestWidget(
          text: '7',
          onPressed: () => wasPressed = true,
        ),
      );

      await tester.tap(find.text('7'));
      await tester.pumpAndSettle();

      expect(wasPressed, isTrue);
    });

    testWidgets('deve renderizar com cor customizada', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          text: 'C',
          onPressed: () {},
          color: Colors.red,
        ),
      );

      final textWidget = tester.widget<Text>(find.text('C'));
      expect(textWidget.style?.color, Colors.red);
    });

    testWidgets('deve renderizar sem cor customizada', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          text: '1',
          onPressed: () {},
        ),
      );

      final textWidget = tester.widget<Text>(find.text('1'));
      expect(textWidget.style?.color, Colors.black87);
    });

    testWidgets('deve conter NeumorphicButton', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          text: '0',
          onPressed: () {},
        ),
      );

      expect(find.byType(NeumorphicButton), findsOneWidget);
    });

    testWidgets('deve estar dentro de um Expanded', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          text: '9',
          onPressed: () {},
        ),
      );

      expect(find.byType(Expanded), findsOneWidget);
    });
  });
}
