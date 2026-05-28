import 'package:calculator_05122025/models/imc_result.dart';
import 'package:calculator_05122025/utils/enums/imc_classification.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ImcResult.calculate', () {
    test('deve calcular IMC corretamente para 70kg e 170cm', () {
      final result = ImcResult.calculate(weightKg: 70.0, heightCm: 170.0);

      expect(result.imc, closeTo(24.22, 0.01));
      expect(result.classification, ImcClassification.normal);
    });

    test('deve retornar classificação underweight para 50kg e 170cm', () {
      final result = ImcResult.calculate(weightKg: 50.0, heightCm: 170.0);

      expect(result.classification, ImcClassification.underweight);
    });

    test('deve retornar classificação obesityI para 90kg e 170cm', () {
      final result = ImcResult.calculate(weightKg: 90.0, heightCm: 170.0);

      expect(result.classification, ImcClassification.obesityI);
    });

    test('calculatedAt deve ser UTC', () {
      final result = ImcResult.calculate(weightKg: 70.0, heightCm: 170.0);

      expect(result.calculatedAt.isUtc, isTrue);
    });

    test('deve armazenar weightKg e heightCm corretamente', () {
      final result = ImcResult.calculate(weightKg: 75.5, heightCm: 180.0);

      expect(result.weightKg, 75.5);
      expect(result.heightCm, 180.0);
    });
  });

  group('ImcResult formatters', () {
    late ImcResult result;

    setUp(() {
      result = ImcResult.calculate(weightKg: 70.0, heightCm: 170.0);
    });

    test('formattedImc deve usar vírgula e 1 casa decimal', () {
      expect(result.formattedImc, '24,2');
    });

    test('formattedWeight deve exibir peso com vírgula e sufixo kg', () {
      final r = ImcResult.calculate(weightKg: 70.0, heightCm: 170.0);
      expect(r.formattedWeight, '70,0 kg');
    });

    test('formattedHeight deve exibir altura inteira com sufixo cm', () {
      expect(result.formattedHeight, '170 cm');
    });

    test('formattedImc para valor com arredondamento', () {
      final r = ImcResult(
        weightKg: 70.0,
        heightCm: 170.0,
        imc: 24.26,
        classification: ImcClassification.normal,
        calculatedAt: DateTime.now().toUtc(),
      );
      expect(r.formattedImc, '24,3');
    });
  });

  group('ImcResult peso ideal', () {
    test('idealWeightMin para 170cm deve ser 53,5 kg', () {
      final result = ImcResult.calculate(weightKg: 70.0, heightCm: 170.0);
      expect(result.idealWeightMin, closeTo(53.5, 0.1));
    });

    test('idealWeightMax para 170cm deve ser 72,0 kg', () {
      final result = ImcResult.calculate(weightKg: 70.0, heightCm: 170.0);
      expect(result.idealWeightMax, closeTo(72.0, 0.1));
    });

    test(
      'idealWeightDifference deve ser 0,0 quando peso está dentro da faixa',
      () {
        final result = ImcResult.calculate(weightKg: 70.0, heightCm: 170.0);
        expect(result.idealWeightDifference, 0.0);
      },
    );

    test('idealWeightDifference deve ser positivo quando acima da faixa', () {
      final result = ImcResult.calculate(weightKg: 90.0, heightCm: 170.0);
      expect(result.idealWeightDifference, greaterThan(0));
    });

    test('idealWeightDifference deve ser negativo quando abaixo da faixa', () {
      final result = ImcResult.calculate(weightKg: 50.0, heightCm: 170.0);
      expect(result.idealWeightDifference, lessThan(0));
    });

    test('formattedIdealWeightRange deve usar vírgula e separador –', () {
      final result = ImcResult.calculate(weightKg: 70.0, heightCm: 170.0);
      expect(result.formattedIdealWeightRange, contains('–'));
      expect(result.formattedIdealWeightRange, contains('kg'));
      expect(result.formattedIdealWeightRange, isNot(contains('.')));
    });

    test(
      'formattedIdealWeightDifference deve retornar string vazia quando dentro da faixa',
      () {
        final result = ImcResult.calculate(weightKg: 70.0, heightCm: 170.0);
        expect(result.formattedIdealWeightDifference, isEmpty);
      },
    );

    test(
      'formattedIdealWeightDifference deve ter sinal + quando acima da faixa',
      () {
        final result = ImcResult.calculate(weightKg: 90.0, heightCm: 170.0);
        expect(result.formattedIdealWeightDifference, startsWith('+'));
      },
    );

    test(
      'formattedIdealWeightDifference deve ter sinal - quando abaixo da faixa',
      () {
        final result = ImcResult.calculate(weightKg: 50.0, heightCm: 170.0);
        expect(result.formattedIdealWeightDifference, startsWith('-'));
      },
    );
  });
}
