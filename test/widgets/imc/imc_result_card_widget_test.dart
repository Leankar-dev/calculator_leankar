import 'package:calculator_05122025/models/imc_result.dart';
import 'package:calculator_05122025/utils/enums/imc_classification.dart';
import 'package:calculator_05122025/widgets/imc/imc_classification_badge_widget.dart';
import 'package:calculator_05122025/widgets/imc/imc_gauge_widget.dart';
import 'package:calculator_05122025/widgets/imc/imc_result_card_widget.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  ImcResult buildResult({
    double weightKg = 70.0,
    double heightCm = 170.0,
    double imc = 24.22,
    ImcClassification classification = ImcClassification.normal,
  }) {
    return ImcResult(
      weightKg: weightKg,
      heightCm: heightCm,
      imc: imc,
      classification: classification,
      calculatedAt: DateTime(2026, 5, 27).toUtc(),
    );
  }

  Widget buildTestWidget(ImcResult result) {
    return NeumorphicApp(
      home: Scaffold(
        body: SingleChildScrollView(
          child: ImcResultCardWidget(result: result),
        ),
      ),
    );
  }

  group('ImcResultCardWidget', () {
    testWidgets('deve renderizar ImcGaugeWidget', (tester) async {
      await tester.pumpWidget(buildTestWidget(buildResult()));

      expect(find.byType(ImcGaugeWidget), findsOneWidget);
    });

    testWidgets('deve renderizar ImcClassificationBadgeWidget', (tester) async {
      await tester.pumpWidget(buildTestWidget(buildResult()));

      expect(find.byType(ImcClassificationBadgeWidget), findsOneWidget);
    });

    testWidgets('deve exibir valor IMC formatado no gauge', (tester) async {
      await tester.pumpWidget(buildTestWidget(buildResult(imc: 24.22)));

      expect(find.text('24,2'), findsOneWidget);
    });

    testWidgets('deve exibir label da classificação', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(buildResult(classification: ImcClassification.normal)),
      );

      expect(find.text('Peso normal'), findsOneWidget);
    });

    testWidgets('deve exibir peso formatado', (tester) async {
      await tester.pumpWidget(buildTestWidget(buildResult(weightKg: 70.0)));

      expect(find.text('70,0 kg'), findsOneWidget);
    });

    testWidgets('deve exibir altura formatada', (tester) async {
      await tester.pumpWidget(buildTestWidget(buildResult(heightCm: 170.0)));

      expect(find.text('170 cm'), findsOneWidget);
    });

    testWidgets('deve exibir label Peso e label Altura', (tester) async {
      await tester.pumpWidget(buildTestWidget(buildResult()));

      expect(find.text('Peso'), findsWidgets);
      expect(find.text('Altura'), findsOneWidget);
    });

    testWidgets('deve exibir badge correto para underweight', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          buildResult(
            imc: 17.0,
            classification: ImcClassification.underweight,
          ),
        ),
      );

      expect(find.text('Abaixo do peso'), findsOneWidget);
    });
  });
}
