import 'package:flutter/animation.dart';

class AppSplashTimeline {
  AppSplashTimeline._();

  static const Duration totalDuration = Duration(milliseconds: 1800);
  static const Duration skipDuration = Duration(milliseconds: 280);
  static const Duration routeTransitionDuration = Duration(milliseconds: 350);
  static const Duration reducedMotionHold = Duration(milliseconds: 500);
  static const Duration reducedMotionTransition = Duration(milliseconds: 200);

  static const double exitStart = 0.78;
  static const double titleLetterSpan = 8.0;
  static const double shimmerSweepStart = -1.0;
  static const double shimmerSweepEnd = 2.0;

  static const Interval background = Interval(
    0.00,
    0.10,
    curve: Curves.easeOut,
  );
  static const Interval logoArrival = Interval(
    0.00,
    0.22,
    curve: Curves.easeOutBack,
  );
  static const Interval logoPress = Interval(
    0.10,
    0.22,
    curve: Curves.easeInOut,
  );
  static const Interval keysBurst = Interval(0.16, 0.46);
  static const Interval title = Interval(0.30, 0.56);
  static const Interval tagline = Interval(0.46, 0.66, curve: Curves.easeOut);
  static const Interval shimmer = Interval(
    0.50,
    0.72,
    curve: Curves.easeInOut,
  );
  static const Interval orbitDrift = Interval(
    0.46,
    0.78,
    curve: Curves.easeInOut,
  );
  static const Interval exit = Interval(
    exitStart,
    1.00,
    curve: Curves.easeInCubic,
  );
  static const Interval keysExit = Interval(
    exitStart,
    1.00,
    curve: Curves.easeInBack,
  );
}
