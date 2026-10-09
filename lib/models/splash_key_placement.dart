import 'dart:math' as math;

import 'package:calculator_05122025/utils/constants/app_sizes.dart';
import 'package:calculator_05122025/utils/constants/app_splash_timeline.dart';
import 'package:calculator_05122025/utils/enums/splash_symbol.dart';
import 'package:flutter/animation.dart';

class SplashKeyPlacement {
  final Offset offset;
  final double scale;
  final double rotation;

  const SplashKeyPlacement({
    required this.offset,
    required this.scale,
    required this.rotation,
  });

  factory SplashKeyPlacement.fromAnimation({
    required SplashSymbol symbol,
    required double animationValue,
    required double radius,
  }) {
    final burst = _burstProgress(symbol, animationValue);
    final exit = AppSplashTimeline.keysExit.transform(animationValue);
    final presence = burst * (1 - exit);

    final driftDegrees =
        AppSplashTimeline.orbitDrift.transform(animationValue) *
        AppSizes.splashOrbitDriftDegrees;
    final angleRadians = (symbol.angleDegrees + driftDegrees) * math.pi / 180;
    final effectiveRadius = radius * presence;

    return SplashKeyPlacement(
      offset:
          Offset(math.cos(angleRadians), math.sin(angleRadians)) *
              effectiveRadius +
          Offset(0, _floatOffset(symbol, animationValue, burst)),
      scale: presence.clamp(0.0, AppSizes.splashKeyMaxScale),
      rotation: (1 - burst.clamp(0.0, 1.0)) * -AppSizes.splashKeyEntryRotation,
    );
  }

  double get distanceFromCenter => offset.distance;

  static double _burstProgress(SplashSymbol symbol, double animationValue) {
    final keysProgress = AppSplashTimeline.keysBurst.transform(animationValue);
    final localProgress =
        ((keysProgress - symbol.delayFraction) / AppSizes.splashKeyBurstSpan)
            .clamp(0.0, 1.0);
    return Curves.easeOutBack.transform(localProgress);
  }

  static double _floatOffset(
    SplashSymbol symbol,
    double animationValue,
    double burst,
  ) {
    if (animationValue >= AppSplashTimeline.exitStart) {
      return 0.0;
    }
    final phase =
        animationValue * 2 * math.pi * AppSizes.splashKeyFloatCycles +
        symbol.index;
    return math.sin(phase) *
        AppSizes.splashKeyFloatAmplitude *
        burst.clamp(0.0, 1.0);
  }
}
