import 'package:calculator_05122025/pages/imc_calculator_page.dart';
import 'package:calculator_05122025/widgets/imc/imc_calculate_button_widget.dart';
import 'package:calculator_05122025/widgets/imc/imc_input_field_widget.dart';
import 'package:calculator_05122025/widgets/imc/imc_result_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../helpers/l10n_test_app.dart';

void main() {
  Widget buildTestWidget() {
    return const L10nTestApp(
      child: ImcCalculatorPage(),
    );
  }

  group('ImcCalculatorPage', () {
    testWidgets('deve carregar sem erros com campos e botão visíveis', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pump();

      expect(find.byType(ImcInputFieldWidget), findsNWidgets(2));
      expect(find.byType(ImcCalculateButtonWidget), findsOneWidget);
    });

    testWidgets('deve exibir título na AppBar', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pump();

      expect(find.text('Calculadora IMC'), findsOneWidget);
    });

    testWidgets('campos em branco + calcular deve exibir mensagem de erro', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pump();

      await tester.tap(find.byType(ImcCalculateButtonWidget));
      await tester.pumpAndSettle();

      expect(find.byType(ImcResultCardWidget), findsNothing);
      expect(find.textContaining('inválido'), findsOneWidget);
    });

    testWidgets('deve exibir ImcResultCardWidget com valores válidos', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pump();

      final fields = find.byType(TextField);
      await tester.enterText(fields.first, '70');
      await tester.pump();
      await tester.enterText(fields.last, '170');
      await tester.pump();

      await tester.tap(find.byType(ImcCalculateButtonWidget));
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.byType(ImcResultCardWidget), findsOneWidget);
      expect(find.text('Peso normal'), findsOneWidget);
    });

    testWidgets('botão reset deve limpar campos e resultado', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pump();

      final fields = find.byType(TextField);
      await tester.enterText(fields.first, '70');
      await tester.pump();
      await tester.enterText(fields.last, '170');
      await tester.pump();

      await tester.tap(find.byType(ImcCalculateButtonWidget));
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.byType(ImcResultCardWidget), findsOneWidget);

      await tester.tap(find.byIcon(Icons.refresh));
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.byType(ImcResultCardWidget), findsNothing);
    });

    testWidgets('deve exibir botão de voltar na AppBar', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pump();

      expect(find.byIcon(Icons.arrow_back_ios_new), findsOneWidget);
    });
  });
}
