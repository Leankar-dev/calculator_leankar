import 'package:calculator_05122025/utils/constants/app_colors.dart';
import 'package:calculator_05122025/utils/constants/app_sizes.dart';
import 'package:calculator_05122025/utils/constants/app_splash_timeline.dart';
import 'package:flutter/widgets.dart';

class SplashShimmerWidget extends StatelessWidget {
  final Animation<double> animation;
  final Widget child;

  const SplashShimmerWidget({
    super.key,
    required this.animation,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final transparentHighlight = AppColors.splashShimmerHighlight.withValues(
      alpha: 0.0,
    );
    return AnimatedBuilder(
      animation: animation,
      child: child,
      builder: (context, child) {
        final sweep = AppSplashTimeline.shimmer.transform(animation.value);
        final slide =
            AppSplashTimeline.shimmerSweepStart +
            (AppSplashTimeline.shimmerSweepEnd -
                    AppSplashTimeline.shimmerSweepStart) *
                sweep;
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                transparentHighlight,
                AppColors.splashShimmerHighlight,
                transparentHighlight,
              ],
              stops: const [
                AppSizes.splashShimmerBandStart,
                AppSizes.splashShimmerBandCenter,
                AppSizes.splashShimmerBandEnd,
              ],
              transform: _SplashShimmerSlideTransform(slide),
            ).createShader(bounds);
          },
          child: child,
        );
      },
    );
  }
}

class _SplashShimmerSlideTransform extends GradientTransform {
  final double slidePercent;

  const _SplashShimmerSlideTransform(this.slidePercent);

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(bounds.width * slidePercent, 0.0, 0.0);
  }
}
