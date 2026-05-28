import 'package:calculator_05122025/models/imc_result.dart';
import 'package:calculator_05122025/utils/enums/imc_classification.dart';
import 'package:calculator_05122025/widgets/imc/imc_ideal_weight_widget.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:flutter_test/flutter_test.dart';

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
    return NeumorphicApp(
      home: Scaffold(
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

    testWidgets('deve exibir título PESO IDEAL', (tester) async {
      await tester.pumpWidget(buildTestWidget(result));
      expect(find.text('PESO IDEAL'), findsOneWidget);
    });

    testWidgets('deve exibir label Faixa saudável', (tester) async {
      await tester.pumpWidget(buildTestWidget(result));
      expect(find.text('Faixa saudável'), findsOneWidget);
    });

    testWidgets('deve exibir label Situação', (tester) async {
      await tester.pumpWidget(buildTestWidget(result));
      expect(find.text('Situação'), findsOneWidget);
    });

    testWidgets('deve exibir status Dentro do ideal', (tester) async {
      await tester.pumpWidget(buildTestWidget(result));
      expect(find.text('Dentro do ideal'), findsOneWidget);
    });

    testWidgets('não deve exibir label Diferença quando dentro da faixa', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestWidget(result));
      expect(find.text('Diferença'), findsNothing);
    });

    testWidgets('deve exibir a faixa de peso com vírgula e separador –', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestWidget(result));
      final rangeFinder = find.textContaining('–');
      expect(rangeFinder, findsOneWidget);
    });
  });

  group('ImcIdealWeightWidget — acima da faixa ideal (sobrepeso)', () {
    late ImcResult result;

    setUp(() {
      result = buildResult(
        weightKg: 90.0,
        heightCm: 170.0,
        imc: 31.14,
        classification: ImcClassification.obesityI,
      );
    });

    testWidgets('deve exibir status Acima do ideal', (tester) async {
      await tester.pumpWidget(buildTestWidget(result));
      expect(find.text('Acima do ideal'), findsOneWidget);
    });

    testWidgets('deve exibir label Diferença com sinal positivo', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestWidget(result));
      expect(find.text('Diferença'), findsOneWidget);
      final diffFinder = find.textContaining('+');
      expect(diffFinder, findsOneWidget);
    });
  });

  group('ImcIdealWeightWidget — abaixo da faixa ideal (underweight)', () {
    late ImcResult result;

    setUp(() {
      result = buildResult(
        weightKg: 50.0,
        heightCm: 170.0,
        imc: 17.30,
        classification: ImcClassification.underweight,
      );
    });

    testWidgets('deve exibir status Abaixo do ideal', (tester) async {
      await tester.pumpWidget(buildTestWidget(result));
      expect(find.text('Abaixo do ideal'), findsOneWidget);
    });

    testWidgets('deve exibir label Diferença com sinal negativo', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestWidget(result));
      expect(find.text('Diferença'), findsOneWidget);
      final diffFinder = find.textContaining('-');
      expect(diffFinder, findsOneWidget);
    });
  });
}
