import 'package:calculator_05122025/utils/constants/app_sizes.dart';
import 'package:calculator_05122025/utils/constants/app_splash_timeline.dart';
import 'package:calculator_05122025/utils/constants/app_strings.dart';
import 'package:calculator_05122025/widgets/splash/splash_shimmer_widget.dart';
import 'package:flutter/widgets.dart';

class SplashLogoWidget extends StatelessWidget {
  final Animation<double> animation;
  final double logoWidth;
  final double startScale;

  const SplashLogoWidget({
    super.key,
    required this.animation,
    required this.logoWidth,
    required this.startScale,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: animation,
        child: SplashShimmerWidget(
          animation: animation,
          child: Image.asset(
            AppStrings.splashLogoAssetPath,
            width: logoWidth,
            fit: BoxFit.contain,
            filterQuality: FilterQuality.medium,
            gaplessPlayback: true,
            excludeFromSemantics: true,
          ),
        ),
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAt(animation.value),
            child: child,
          );
        },
      ),
    );
  }

  double _scaleAt(double value) {
    final arrival = AppSplashTimeline.logoArrival.transform(value);
    final exit = AppSplashTimeline.exit.transform(value);
    return _lerp(startScale, 1.0, arrival) *
        _pressScale(value) *
        _lerp(1.0, AppSizes.splashLogoExitScale, exit);
  }

  double _pressScale(double value) {
    final progress = AppSplashTimeline.logoPress.transform(value);
    const segmentCount = 3;
    final segmentPosition = progress * segmentCount;
    if (segmentPosition < 1) {
      return _lerp(1.0, AppSizes.splashLogoPressScale, segmentPosition);
    }
    if (segmentPosition < 2) {
      return _lerp(
        AppSizes.splashLogoPressScale,
        AppSizes.splashLogoReleaseScale,
        segmentPosition - 1,
      );
    }
    return _lerp(AppSizes.splashLogoReleaseScale, 1.0, segmentPosition - 2);
  }

  double _lerp(double begin, double end, double progress) {
    return begin + (end - begin) * progress;
  }
}
