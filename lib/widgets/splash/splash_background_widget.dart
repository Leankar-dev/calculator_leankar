import 'package:calculator_05122025/utils/constants/app_colors.dart';
import 'package:calculator_05122025/utils/constants/app_splash_timeline.dart';
import 'package:flutter/widgets.dart';

class SplashBackgroundWidget extends StatelessWidget {
  final Animation<double> animation;

  const SplashBackgroundWidget({super.key, required this.animation});

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          final progress = AppSplashTimeline.background.transform(
            animation.value,
          );
          return SizedBox.expand(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color.lerp(
                      AppColors.splashNativeFlat,
                      AppColors.splashGradientStart,
                      progress,
                    )!,
                    Color.lerp(
                      AppColors.splashNativeFlat,
                      AppColors.splashGradientEnd,
                      progress,
                    )!,
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
