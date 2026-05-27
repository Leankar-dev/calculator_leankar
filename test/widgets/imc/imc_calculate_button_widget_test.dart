import 'package:calculator_05122025/widgets/imc/imc_calculate_button_widget.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget buildTestWidget({required VoidCallback onPressed}) {
    return NeumorphicApp(
      home: Scaffold(
        body: Center(
          child: ImcCalculateButtonWidget(onPressed: onPressed),
        ),
      ),
    );
  }

  group('ImcCalculateButtonWidget', () {
    testWidgets('deve renderizar o texto do botão', (tester) async {
      await tester.pumpWidget(buildTestWidget(onPressed: () {}));

      expect(find.text('Calcular IMC'), findsOneWidget);
    });

    testWidgets('deve chamar onPressed ao ser tocado', (tester) async {
      bool pressed = false;
      await tester.pumpWidget(
        buildTestWidget(onPressed: () => pressed = true),
      );

      await tester.tap(find.text('Calcular IMC'));
      await tester.pumpAndSettle();

      expect(pressed, isTrue);
    });
  });
}
