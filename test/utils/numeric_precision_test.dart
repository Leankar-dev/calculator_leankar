import 'package:calculator_05122025/utils/numeric_precision.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('NumericPrecision', () {
    group('roundToSignificantDigits', () {
      test('remove o ruído de ponto flutuante de somas decimais', () {
        expect(NumericPrecision.roundToSignificantDigits(0.1 + 0.2), 0.3);
      });

      test('remove o ruído de raízes e logaritmos', () {
        expect(
          NumericPrecision.roundToSignificantDigits(2.0000000000000004),
          2,
        );
        expect(
          NumericPrecision.roundToSignificantDigits(2.9999999999999996),
          3,
        );
      });

      test('preserva valores com precisão legítima', () {
        expect(
          NumericPrecision.roundToSignificantDigits(1 / 3),
          closeTo(1 / 3, 1e-15),
        );
        expect(
          NumericPrecision.roundToSignificantDigits(123456.789),
          123456.789,
        );
        expect(NumericPrecision.roundToSignificantDigits(1e-300), 1e-300);
        expect(NumericPrecision.roundToSignificantDigits(1e300), 1e300);
      });

      test('não altera zero nem valores não finitos', () {
        expect(NumericPrecision.roundToSignificantDigits(0), 0);
        expect(
          NumericPrecision.roundToSignificantDigits(double.infinity),
          double.infinity,
        );
        expect(
          NumericPrecision.roundToSignificantDigits(double.nan).isNaN,
          true,
        );
      });
    });

    group('snapCancellationToZero', () {
      test('zera o resíduo de cancelamento entre operandos próximos', () {
        expect(
          NumericPrecision.snapCancellationToZero(
            result: 0.1 + 0.2 - 0.3,
            left: 0.1 + 0.2,
            right: 0.3,
          ),
          0,
        );
      });

      test('preserva diferenças pequenas porém legítimas', () {
        expect(
          NumericPrecision.snapCancellationToZero(
            result: 1e-10,
            left: 1,
            right: 1 - 1e-10,
          ),
          1e-10,
        );
      });

      test(
        'preserva resultados pequenos quando os operandos também são pequenos',
        () {
          expect(
            NumericPrecision.snapCancellationToZero(
              result: 1e-15,
              left: 1e-15,
              right: 0,
            ),
            1e-15,
          );
        },
      );
    });

    group('snapTrigonometricNoiseToZero', () {
      test('zera o ruído de funções trigonométricas', () {
        expect(
          NumericPrecision.snapTrigonometricNoiseToZero(
            result: 1.2246467991473532e-16,
            angleInRadians: 3.141592653589793,
          ),
          0,
        );
      });

      test('preserva valores legítimos para ângulos muito pequenos', () {
        expect(
          NumericPrecision.snapTrigonometricNoiseToZero(
            result: 1e-20,
            angleInRadians: 1e-20,
          ),
          1e-20,
        );
      });

      test('preserva valores trigonométricos normais', () {
        expect(
          NumericPrecision.snapTrigonometricNoiseToZero(
            result: 0.5,
            angleInRadians: 0.5235987755982988,
          ),
          0.5,
        );
      });
    });
  });
}
