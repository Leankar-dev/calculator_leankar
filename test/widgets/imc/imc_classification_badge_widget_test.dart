import 'package:calculator_05122025/utils/enums/imc_classification.dart';
import 'package:calculator_05122025/widgets/imc/imc_classification_badge_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../helpers/l10n_test_app.dart';

void main() {
  Widget buildTestWidget(ImcClassification classification) {
    return L10nTestApp(
      child: Scaffold(
        body: ImcClassificationBadgeWidget(classification: classification),
      ),
    );
  }

  group('ImcClassificationBadgeWidget', () {
    testWidgets('deve exibir label para underweight', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(ImcClassification.underweight),
      );

      expect(find.text('Abaixo do peso'), findsOneWidget);
    });

    testWidgets('deve exibir label para normal', (tester) async {
      await tester.pumpWidget(buildTestWidget(ImcClassification.normal));

      expect(find.text('Peso normal'), findsOneWidget);
    });

    testWidgets('deve exibir label para overweight', (tester) async {
      await tester.pumpWidget(buildTestWidget(ImcClassification.overweight));

      expect(find.text('Sobrepeso'), findsOneWidget);
    });

    testWidgets('deve exibir label para obesityI', (tester) async {
      await tester.pumpWidget(buildTestWidget(ImcClassification.obesityI));

      expect(find.text('Obesidade Grau I'), findsOneWidget);
    });

    testWidgets('deve exibir label para obesityII', (tester) async {
      await tester.pumpWidget(buildTestWidget(ImcClassification.obesityII));

      expect(find.text('Obesidade Grau II'), findsOneWidget);
    });

    testWidgets('deve exibir label para obesityIII', (tester) async {
      await tester.pumpWidget(buildTestWidget(ImcClassification.obesityIII));

      expect(find.text('Obesidade Grau III'), findsOneWidget);
    });
  });
}
