import 'dart:math' as math;

import 'package:calculator_05122025/services/trigonometry_service.dart';
import 'package:calculator_05122025/utils/enums/angle_mode.dart';
import 'package:calculator_05122025/utils/enums/scientific_error_type.dart';
import 'package:calculator_05122025/utils/exceptions/scientific_calculation_exception.dart';
import 'package:flutter_test/flutter_test.dart';

Matcher _hasErrorType(ScientificErrorType errorType) {
  return isA<ScientificCalculationException>().having(
    (e) => e.errorType,
    'errorType',
    errorType,
  );
}

void main() {
  late TrigonometryService trigonometry;

  setUp(() {
    trigonometry = TrigonometryService();
  });

  group('TrigonometryService', () {
    group('sin em graus', () {
      test('retorna valores exatos nos múltiplos de 90°', () {
        expect(trigonometry.sin(0, AngleMode.deg), 0);
        expect(trigonometry.sin(90, AngleMode.deg), 1);
        expect(trigonometry.sin(180, AngleMode.deg), 0);
        expect(trigonometry.sin(270, AngleMode.deg), -1);
        expect(trigonometry.sin(360, AngleMode.deg), 0);
      });

      test('reduz ângulos fora de uma volta, inclusive negativos', () {
        expect(trigonometry.sin(450, AngleMode.deg), 1);
        expect(trigonometry.sin(-90, AngleMode.deg), -1);
        expect(trigonometry.sin(-180, AngleMode.deg), 0);
      });

      test('calcula ângulos intermediários normalmente', () {
        expect(trigonometry.sin(30, AngleMode.deg), closeTo(0.5, 1e-12));
      });
    });

    group('cos em graus', () {
      test('retorna valores exatos nos múltiplos de 90°', () {
        expect(trigonometry.cos(0, AngleMode.deg), 1);
        expect(trigonometry.cos(90, AngleMode.deg), 0);
        expect(trigonometry.cos(180, AngleMode.deg), -1);
        expect(trigonometry.cos(270, AngleMode.deg), 0);
      });

      test('calcula ângulos intermediários normalmente', () {
        expect(trigonometry.cos(60, AngleMode.deg), closeTo(0.5, 1e-12));
      });
    });

    group('tan em graus', () {
      test('retorna zero nos múltiplos de 180°', () {
        expect(trigonometry.tan(0, AngleMode.deg), 0);
        expect(trigonometry.tan(180, AngleMode.deg), 0);
        expect(trigonometry.tan(-180, AngleMode.deg), 0);
      });

      test('lança domainError onde a tangente é indefinida', () {
        expect(
          () => trigonometry.tan(90, AngleMode.deg),
          throwsA(_hasErrorType(ScientificErrorType.domainError)),
        );
        expect(
          () => trigonometry.tan(270, AngleMode.deg),
          throwsA(_hasErrorType(ScientificErrorType.domainError)),
        );
        expect(
          () => trigonometry.tan(-90, AngleMode.deg),
          throwsA(_hasErrorType(ScientificErrorType.domainError)),
        );
      });

      test('calcula 45° como 1', () {
        expect(trigonometry.tan(45, AngleMode.deg), closeTo(1, 1e-12));
      });
    });

    group('em radianos', () {
      test('não converte o argumento', () {
        expect(trigonometry.sin(90, AngleMode.rad), math.sin(90));
        expect(trigonometry.cos(1, AngleMode.rad), math.cos(1));
      });

      test('zera o ruído de sin(π) e cos(π/2)', () {
        expect(trigonometry.sin(math.pi, AngleMode.rad), 0);
        expect(trigonometry.cos(math.pi / 2, AngleMode.rad), 0);
      });

      test('lança domainError para tan(π/2)', () {
        expect(
          () => trigonometry.tan(math.pi / 2, AngleMode.rad),
          throwsA(_hasErrorType(ScientificErrorType.domainError)),
        );
      });

      test('tan(π) resulta em 0', () {
        expect(trigonometry.tan(math.pi, AngleMode.rad), 0);
      });
    });

    group('funções inversas', () {
      test('asin e acos convertem para graus', () {
        expect(trigonometry.asin(1, AngleMode.deg), closeTo(90, 1e-9));
        expect(trigonometry.acos(0, AngleMode.deg), closeTo(90, 1e-9));
        expect(trigonometry.atan(1, AngleMode.deg), closeTo(45, 1e-9));
      });

      test('asin e acos mantêm radianos em RAD', () {
        expect(trigonometry.asin(1, AngleMode.rad), math.pi / 2);
        expect(trigonometry.acos(1, AngleMode.rad), 0);
        expect(trigonometry.atan(1, AngleMode.rad), math.pi / 4);
      });

      test('asin e acos fora de [-1, 1] lançam domainError', () {
        expect(
          () => trigonometry.asin(1.5, AngleMode.deg),
          throwsA(_hasErrorType(ScientificErrorType.domainError)),
        );
        expect(
          () => trigonometry.acos(-1.5, AngleMode.rad),
          throwsA(_hasErrorType(ScientificErrorType.domainError)),
        );
      });
    });

    test('argumentos não finitos não recebem valor exato', () {
      expect(trigonometry.sin(double.infinity, AngleMode.deg).isNaN, true);
      expect(trigonometry.cos(double.nan, AngleMode.deg).isNaN, true);
    });
  });
}
