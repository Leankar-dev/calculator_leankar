import 'package:calculator_05122025/utils/constants/app_colors.dart';
import 'package:calculator_05122025/utils/constants/app_sizes.dart';
import 'package:calculator_05122025/utils/constants/app_splash_timeline.dart';
import 'package:calculator_05122025/utils/responsive_utils.dart';
import 'package:flutter/widgets.dart';

class SplashTitleWidget extends StatelessWidget {
  static const String _spaceCharacter = ' ';

  final Animation<double> animation;
  final String text;

  const SplashTitleWidget({
    super.key,
    required this.animation,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final fontSize = ResponsiveUtils.getSplashTitleFontSize(context);
    final letters = text.split('');
    return ExcludeSemantics(
      child: RepaintBoundary(
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: AnimatedBuilder(
            animation: animation,
            builder: (context, child) {
              final titleProgress = AppSplashTimeline.title.transform(
                animation.value,
              );
              final visibility =
                  1 - AppSplashTimeline.exit.transform(animation.value);
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (var index = 0; index < letters.length; index++)
                    if (letters[index] == _spaceCharacter)
                      SizedBox(
                        width: fontSize * AppSizes.splashTitleSpaceFactor,
                      )
                    else
                      _SplashTitleLetterWidget(
                        letter: letters[index],
                        fontSize: fontSize,
                        progress: _letterProgress(
                          titleProgress,
                          index,
                          letters.length,
                        ),
                        visibility: visibility,
                      ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  double _letterProgress(double titleProgress, int index, int letterCount) {
    const span = AppSplashTimeline.titleLetterSpan;
    final rawProgress = ((titleProgress * (letterCount + span) - index) / span)
        .clamp(0.0, 1.0);
    return Curves.easeOut.transform(rawProgress);
  }
}

class _SplashTitleLetterWidget extends StatelessWidget {
  final String letter;
  final double fontSize;
  final double progress;
  final double visibility;

  const _SplashTitleLetterWidget({
    required this.letter,
    required this.fontSize,
    required this.progress,
    required this.visibility,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: progress * visibility,
      child: Transform.translate(
        offset: Offset(0, (1 - progress) * AppSizes.splashLetterRise),
        child: Text(
          letter,
          style: TextStyle(
            color: AppColors.splashTitle,
            fontWeight: FontWeight.bold,
            fontSize: fontSize,
            letterSpacing: AppSizes.splashTitleLetterSpacing,
          ),
        ),
      ),
    );
  }
}
