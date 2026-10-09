import 'package:calculator_05122025/l10n/app_localizations.dart';
import 'package:calculator_05122025/utils/constants/app_colors.dart';
import 'package:calculator_05122025/utils/constants/app_sizes.dart';
import 'package:calculator_05122025/utils/constants/app_splash_timeline.dart';
import 'package:calculator_05122025/utils/responsive_utils.dart';
import 'package:flutter/widgets.dart';

class SplashTaglineWidget extends StatelessWidget {
  final Animation<double> animation;

  const SplashTaglineWidget({super.key, required this.animation});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return ExcludeSemantics(
      child: RepaintBoundary(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: ResponsiveUtils.getSplashTaglineMaxWidth(context),
          ),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: AnimatedBuilder(
              animation: animation,
              child: Text(
                l10n.splashTagline,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.splashTagline,
                  fontSize: ResponsiveUtils.getSplashTaglineFontSize(context),
                ),
              ),
              builder: (context, child) {
                final progress = AppSplashTimeline.tagline.transform(
                  animation.value,
                );
                final visibility =
                    1 - AppSplashTimeline.exit.transform(animation.value);
                return Opacity(
                  opacity: progress * visibility,
                  child: Transform.translate(
                    offset: Offset(
                      0,
                      (1 - progress) * AppSizes.splashTaglineRise,
                    ),
                    child: child,
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
