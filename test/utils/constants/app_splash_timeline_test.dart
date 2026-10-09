import 'package:calculator_05122025/utils/constants/app_splash_timeline.dart';
import 'package:flutter/animation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppSplashTimeline', () {
    final intervals = <String, Interval>{
      'background': AppSplashTimeline.background,
      'logoArrival': AppSplashTimeline.logoArrival,
      'logoPress': AppSplashTimeline.logoPress,
      'keysBurst': AppSplashTimeline.keysBurst,
      'title': AppSplashTimeline.title,
      'tagline': AppSplashTimeline.tagline,
      'shimmer': AppSplashTimeline.shimmer,
      'orbitDrift': AppSplashTimeline.orbitDrift,
      'exit': AppSplashTimeline.exit,
    };

    test('todos os intervalos começam antes de terminar', () {
      intervals.forEach((name, interval) {
        expect(interval.begin, lessThan(interval.end), reason: name);
      });
    });

    test('todos os intervalos ficam dentro de 0 e 1', () {
      intervals.forEach((name, interval) {
        expect(interval.begin, greaterThanOrEqualTo(0.0), reason: name);
        expect(interval.end, lessThanOrEqualTo(1.0), reason: name);
      });
    });

    test('a saída começa em exitStart e termina no fim da animação', () {
      expect(AppSplashTimeline.exitStart, AppSplashTimeline.exit.begin);
      expect(AppSplashTimeline.exit.end, 1.0);
    });

    test('a explosão de teclas termina quando a deriva da órbita começa', () {
      expect(
        AppSplashTimeline.keysBurst.end,
        lessThanOrEqualTo(AppSplashTimeline.orbitDrift.begin + 0.0001),
      );
    });

    test('a deriva da órbita termina antes da saída', () {
      expect(
        AppSplashTimeline.orbitDrift.end,
        lessThanOrEqualTo(AppSplashTimeline.exit.begin),
      );
    });

    test('o título termina antes da tagline', () {
      expect(
        AppSplashTimeline.title.end,
        lessThan(AppSplashTimeline.tagline.end),
      );
    });

    test('o aperto do logo acontece durante a chegada', () {
      expect(
        AppSplashTimeline.logoPress.begin,
        greaterThanOrEqualTo(AppSplashTimeline.logoArrival.begin),
      );
      expect(
        AppSplashTimeline.logoPress.end,
        lessThanOrEqualTo(AppSplashTimeline.logoArrival.end),
      );
    });

    test('todas as durações são positivas', () {
      final durations = <String, Duration>{
        'totalDuration': AppSplashTimeline.totalDuration,
        'skipDuration': AppSplashTimeline.skipDuration,
        'routeTransitionDuration': AppSplashTimeline.routeTransitionDuration,
        'reducedMotionHold': AppSplashTimeline.reducedMotionHold,
        'reducedMotionTransition': AppSplashTimeline.reducedMotionTransition,
      };

      durations.forEach((name, duration) {
        expect(duration, greaterThan(Duration.zero), reason: name);
      });
    });

    test('pular é mais rápido que a animação completa', () {
      expect(
        AppSplashTimeline.skipDuration,
        lessThan(AppSplashTimeline.totalDuration),
      );
    });
  });
}
