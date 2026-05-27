import 'package:calculator_05122025/widgets/imc/imc_input_field_widget.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late TextEditingController textController;

  setUp(() {
    textController = TextEditingController();
  });

  tearDown(() {
    textController.dispose();
  });

  Widget buildTestWidget({void Function(String)? onChanged}) {
    return NeumorphicApp(
      home: Scaffold(
        body: ImcInputFieldWidget(
          label: 'Peso',
          unit: 'kg',
          hint: '70,0',
          controller: textController,
          onChanged: onChanged ?? (_) {},
        ),
      ),
    );
  }

  group('ImcInputFieldWidget', () {
    testWidgets('deve renderizar o label', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      expect(find.text('Peso'), findsOneWidget);
    });

    testWidgets('deve renderizar a unidade', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      expect(find.text('kg'), findsOneWidget);
    });

    testWidgets('deve renderizar o hint no TextField', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.decoration?.hintText, '70,0');
    });

    testWidgets('deve chamar onChanged ao digitar', (tester) async {
      String captured = '';
      await tester.pumpWidget(buildTestWidget(onChanged: (v) => captured = v));

      await tester.enterText(find.byType(TextField), '75');

      expect(captured, '75');
    });

    testWidgets('deve renderizar TextField com teclado numérico', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestWidget());

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(
        textField.keyboardType,
        const TextInputType.numberWithOptions(decimal: true),
      );
    });
  });
}
