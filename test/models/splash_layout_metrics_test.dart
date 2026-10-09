import 'package:calculator_05122025/models/splash_layout_metrics.dart';
import 'package:calculator_05122025/utils/constants/app_sizes.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SplashLayoutMetrics', () {
    test('calcula as medidas proporcionais à largura de referência', () {
      final metrics = SplashLayoutMetrics.fromShortestSide(AppSizes.baseWidth);

      final expectedLogoWidth =
          AppSizes.baseWidth * AppSizes.splashLogoWidthFactor;
      final expectedTile = expectedLogoWidth * AppSizes.splashLogoTileFactor;
      final expectedKey = expectedTile * AppSizes.splashKeyExtentFactor;

      expect(metrics.logoWidth, closeTo(expectedLogoWidth, 0.0001));
      expect(metrics.tileExtent, closeTo(expectedTile, 0.0001));
      expect(metrics.keyExtent, closeTo(expectedKey, 0.0001));
      expect(
        metrics.orbitRadius,
        closeTo(
          expectedTile * AppSizes.splashOrbitRadiusFactor + expectedKey / 2,
          0.0001,
        ),
      );
    });

    test('a distância até o título soma raio, meia tecla e o espaçamento', () {
      final metrics = SplashLayoutMetrics.fromShortestSide(AppSizes.baseWidth);

      expect(
        metrics.titleOffsetFromCenter,
        closeTo(
          metrics.orbitRadius + metrics.keyExtent / 2 + AppSizes.splashTitleGap,
          0.0001,
        ),
      );
    });

    test('limita telas largas à largura máxima da calculadora', () {
      final wide = SplashLayoutMetrics.fromShortestSide(2000);
      final limit = SplashLayoutMetrics.fromShortestSide(
        AppSizes.maxCalculatorWidth,
      );

      expect(wide.tileExtent, limit.tileExtent);
      expect(wide.orbitRadius, limit.orbitRadius);
    });

    test('limita telas estreitas à largura mínima', () {
      final narrow = SplashLayoutMetrics.fromShortestSide(100);
      final limit = SplashLayoutMetrics.fromShortestSide(AppSizes.minWidth);

      expect(narrow.tileExtent, limit.tileExtent);
    });

    test('fromTileExtent preserva o ladrilho e deriva o restante', () {
      final metrics = SplashLayoutMetrics.fromTileExtent(80);

      expect(metrics.tileExtent, 80);
      expect(metrics.keyExtent, 80 * AppSizes.splashKeyExtentFactor);
      expect(
        metrics.logoWidth,
        closeTo(80 / AppSizes.splashLogoTileFactor, 0.0001),
      );
    });

    test('as medidas crescem junto com a tela', () {
      final small = SplashLayoutMetrics.fromShortestSide(320);
      final large = SplashLayoutMetrics.fromShortestSide(480);

      expect(large.logoWidth, greaterThan(small.logoWidth));
      expect(large.orbitRadius, greaterThan(small.orbitRadius));
    });
  });
}
