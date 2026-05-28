import 'package:calculator_05122025/models/imc_result.dart';
import 'package:calculator_05122025/utils/enums/imc_classification.dart';
import 'package:calculator_05122025/widgets/imc/imc_ideal_weight_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../helpers/l10n_test_app.dart';

void main() {
  ImcResult buildResult({
    required double weightKg,
    required double heightCm,
    required double imc,
    required ImcClassification classification,
  }) {
    return ImcResult(
      weightKg: weightKg,
      heightCm: heightCm,
      imc: imc,
      classification: classification,
      calculatedAt: DateTime(2026, 5, 28).toUtc(),
    );
  }

  Widget buildTestWidget(ImcResult result) {
    return L10nTestApp(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: ImcIdealWeightWidget(result: result),
          ),
        ),
      ),
    );
  }

  group('ImcIdealWeightWidget — dentro da faixa ideal (normal)', () {
    late ImcResult result;

    setUp(() {
      result = buildResult(
        weightKg: 70.0,
        heightCm: 170.0,
        imc: 24.22,
        classification: ImcClassification.normal,
      );
    });

    testWidgets('deve exibir seção PESO IDEAL', (tester) async {
      await tester.pumpWidget(buildTestWidget(result));

      expect(find.text('PESO IDEAL'), findsOneWidget);
    });

    testWidgets('deve exibir label Faixa saudável', (tester) async {
      await tester.pumpWidget(buildTestWidget(result));

      expect(find.text('Faixa saudável'), findsOneWidget);
    });

    testWidgets('deve exibir badge Dentro do ideal', (tester) async {
      await tester.pumpWidget(buildTestWidget(result));

      expect(find.text('Dentro do ideal'), findsOneWidget);
    });
  });

  group('ImcIdealWeightWidget — acima do ideal (overweight)', () {
    late ImcResult result;

    setUp(() {
      result = buildResult(
        weightKg: 80.0,
        heightCm: 170.0,
        imc: 27.68,
        classification: ImcClassification.overweight,
      );
    });

    testWidgets('deve exibir badge Acima do ideal', (tester) async {
      await tester.pumpWidget(buildTestWidget(result));

      expect(find.text('Acima do ideal'), findsOneWidget);
    });

    testWidgets('deve exibir label Diferença', (tester) async {
      await tester.pumpWidget(buildTestWidget(result));

      expect(find.text('Diferença'), findsOneWidget);
    });
  });

  group('ImcIdealWeightWidget — abaixo do ideal (underweight)', () {
    late ImcResult result;

    setUp(() {
      result = buildResult(
        weightKg: 50.0,
        heightCm: 170.0,
        imc: 17.3,
        classification: ImcClassification.underweight,
      );
    });

    testWidgets('deve exibir badge Abaixo do ideal', (tester) async {
      await tester.pumpWidget(buildTestWidget(result));

      expect(find.text('Abaixo do ideal'), findsOneWidget);
    });
  });
}
