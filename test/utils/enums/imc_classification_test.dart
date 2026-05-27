import 'package:calculator_05122025/utils/enums/imc_classification.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ImcClassification.fromImc', () {
    test('17.0 deve retornar underweight', () {
      expect(ImcClassification.fromImc(17.0), ImcClassification.underweight);
    });

    test('22.0 deve retornar normal', () {
      expect(ImcClassification.fromImc(22.0), ImcClassification.normal);
    });

    test('27.5 deve retornar overweight', () {
      expect(ImcClassification.fromImc(27.5), ImcClassification.overweight);
    });

    test('32.0 deve retornar obesityI', () {
      expect(ImcClassification.fromImc(32.0), ImcClassification.obesityI);
    });

    test('37.0 deve retornar obesityII', () {
      expect(ImcClassification.fromImc(37.0), ImcClassification.obesityII);
    });

    test('45.0 deve retornar obesityIII', () {
      expect(ImcClassification.fromImc(45.0), ImcClassification.obesityIII);
    });

    test('18.5 deve retornar normal (limite inclusivo inferior de normal)', () {
      expect(ImcClassification.fromImc(18.5), ImcClassification.normal);
    });

    test(
      '25.0 deve retornar overweight (limite inclusivo inferior de overweight)',
      () {
        expect(ImcClassification.fromImc(25.0), ImcClassification.overweight);
      },
    );

    test('0.0 deve retornar underweight', () {
      expect(ImcClassification.fromImc(0.0), ImcClassification.underweight);
    });

    test('100.0 deve retornar obesityIII', () {
      expect(ImcClassification.fromImc(100.0), ImcClassification.obesityIII);
    });
  });

  group('ImcClassification propriedades', () {
    test('underweight deve ter label correto', () {
      expect(ImcClassification.underweight.label, 'Abaixo do peso');
    });

    test('normal deve ter label correto', () {
      expect(ImcClassification.normal.label, 'Peso normal');
    });

    test('overweight deve ter label correto', () {
      expect(ImcClassification.overweight.label, 'Sobrepeso');
    });

    test('obesityI deve ter label correto', () {
      expect(ImcClassification.obesityI.label, 'Obesidade Grau I');
    });

    test('obesityII deve ter label correto', () {
      expect(ImcClassification.obesityII.label, 'Obesidade Grau II');
    });

    test('obesityIII deve ter label correto', () {
      expect(ImcClassification.obesityIII.label, 'Obesidade Grau III');
    });
  });
}
