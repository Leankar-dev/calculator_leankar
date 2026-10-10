import 'package:calculator_05122025/utils/constants/app_sizes.dart';

class SplashLayoutMetrics {
  final double tileExtent;
  final double keyExtent;
  final double orbitRadius;

  const SplashLayoutMetrics._({
    required this.tileExtent,
    required this.keyExtent,
    required this.orbitRadius,
  });

  factory SplashLayoutMetrics.fromTileExtent(double tileExtent) {
    final keyExtent = tileExtent * AppSizes.splashKeyExtentFactor;
    return SplashLayoutMetrics._(
      tileExtent: tileExtent,
      keyExtent: keyExtent,
      orbitRadius:
          tileExtent * AppSizes.splashOrbitRadiusFactor + keyExtent / 2,
    );
  }

  factory SplashLayoutMetrics.fromShortestSide(double shortestSide) {
    final clampedSide = shortestSide.clamp(
      AppSizes.minWidth,
      AppSizes.maxCalculatorWidth,
    );
    final logoWidth = clampedSide * AppSizes.splashLogoWidthFactor;
    return SplashLayoutMetrics.fromTileExtent(
      logoWidth * AppSizes.splashLogoTileFactor,
    );
  }

  double get logoWidth => tileExtent / AppSizes.splashLogoTileFactor;

  double get logoStartScale =>
      (AppSizes.splashNativeLogoWidth / logoWidth).clamp(
        AppSizes.splashLogoStartScaleMin,
        AppSizes.splashLogoStartScaleMax,
      );

  double get titleOffsetFromCenter =>
      orbitRadius + keyExtent / 2 + AppSizes.splashTitleGap;
}
