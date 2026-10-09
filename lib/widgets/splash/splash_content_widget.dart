import 'package:calculator_05122025/models/splash_layout_metrics.dart';
import 'package:calculator_05122025/utils/constants/app_sizes.dart';
import 'package:calculator_05122025/utils/constants/app_strings.dart';
import 'package:calculator_05122025/widgets/splash/splash_logo_widget.dart';
import 'package:calculator_05122025/widgets/splash/splash_orbit_widget.dart';
import 'package:calculator_05122025/widgets/splash/splash_tagline_widget.dart';
import 'package:calculator_05122025/widgets/splash/splash_title_widget.dart';
import 'package:flutter/widgets.dart';

class SplashContentWidget extends StatelessWidget {
  final Animation<double> animation;
  final bool showOrbit;

  const SplashContentWidget({
    super.key,
    required this.animation,
    required this.showOrbit,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final metrics = SplashLayoutMetrics.fromShortestSide(
          constraints.biggest.shortestSide,
        );
        final titleTop =
            (constraints.maxHeight / 2 + metrics.titleOffsetFromCenter).clamp(
              0.0,
              constraints.maxHeight,
            );
        return Stack(
          fit: StackFit.expand,
          children: [
            Center(
              child: Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  if (showOrbit)
                    SplashOrbitWidget(
                      animation: animation,
                      tileExtent: metrics.tileExtent,
                    ),
                  SplashLogoWidget(
                    animation: animation,
                    logoWidth: metrics.logoWidth,
                  ),
                ],
              ),
            ),
            Positioned(
              top: titleTop,
              left: 0,
              right: 0,
              bottom: 0,
              child: SafeArea(
                top: false,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SplashTitleWidget(
                          animation: animation,
                          text: AppStrings.appName,
                        ),
                        const SizedBox(height: AppSizes.splashTaglineGap),
                        SplashTaglineWidget(animation: animation),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
