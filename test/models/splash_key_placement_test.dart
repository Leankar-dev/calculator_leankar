import 'package:calculator_05122025/models/splash_key_placement.dart';
import 'package:calculator_05122025/utils/constants/app_sizes.dart';
import 'package:calculator_05122025/utils/constants/app_splash_timeline.dart';
import 'package:calculator_05122025/utils/enums/splash_symbol.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const radius = 100.0;

  SplashKeyPlacement placementAt(SplashSymbol symbol, double value) {
    return SplashKeyPlacement.fromAnimation(
      symbol: symbol,
      animationValue: value,
      radius: radius,
    );
  }

  group('SplashKeyPlacement', () {
    test('no início todas as teclas estão no centro e invisíveis', () {
      for (final symbol in SplashSymbol.values) {
        final placement = placementAt(symbol, 0.0);

        expect(placement.scale, 0.0, reason: symbol.name);
        expect(placement.distanceFromCenter, 0.0, reason: symbol.name);
      }
    });

    test('depois da explosão todas as teclas estão na órbita', () {
      for (final symbol in SplashSymbol.values) {
        final placement = placementAt(symbol, 0.5);

        expect(placement.scale, closeTo(1.0, 0.0001), reason: symbol.name);
        expect(
          placement.distanceFromCenter,
          closeTo(radius, AppSizes.splashKeyFloatAmplitude + 0.0001),
          reason: symbol.name,
        );
        expect(placement.rotation, closeTo(0.0, 0.0001), reason: symbol.name);
      }
    });

    test('as teclas aparecem em ordem conforme o atraso', () {
      final value = AppSplashTimeline.keysBurst.begin + 0.04;

      final scales = SplashSymbol.values
          .map((symbol) => placementAt(symbol, value).scale)
          .toList();

      for (var index = 1; index < scales.length; index++) {
        expect(scales[index], lessThanOrEqualTo(scales[index - 1]));
      }
      expect(scales.first, greaterThan(scales.last));
    });

    test('no fim da animação todas voltam ao centro e somem', () {
      for (final symbol in SplashSymbol.values) {
        final placement = placementAt(symbol, 1.0);

        expect(placement.scale, closeTo(0.0, 0.0001), reason: symbol.name);
        expect(
          placement.distanceFromCenter,
          closeTo(0.0, 0.0001),
          reason: symbol.name,
        );
      }
    });

    test('a escala nunca é negativa nem passa do máximo', () {
      for (final symbol in SplashSymbol.values) {
        for (var step = 0; step <= 100; step++) {
          final placement = placementAt(symbol, step / 100);

          expect(placement.scale, greaterThanOrEqualTo(0.0));
          expect(
            placement.scale,
            lessThanOrEqualTo(AppSizes.splashKeyMaxScale),
          );
        }
      }
    });

    test('as posições das seis teclas são distintas na órbita', () {
      final offsets = SplashSymbol.values
          .map((symbol) => placementAt(symbol, 0.5).offset)
          .toSet();

      expect(offsets, hasLength(SplashSymbol.values.length));
    });

    test('a deriva gira a órbita no sentido horário', () {
      final before = placementAt(SplashSymbol.addition, 0.46).offset;
      final after = placementAt(SplashSymbol.addition, 0.78).offset;

      expect(after.dx, greaterThan(before.dx));
    });

    test('a flutuação só existe antes da saída', () {
      final floating = placementAt(SplashSymbol.division, 0.6);
      final exiting = placementAt(SplashSymbol.division, 1.0);

      expect(floating.offset.dy, isNot(exiting.offset.dy));
      expect(exiting.offset.dy.abs(), lessThan(0.0001));
    });
  });
}
