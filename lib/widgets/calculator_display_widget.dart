import 'package:calculator_05122025/utils/constants/app_colors.dart';
import 'package:calculator_05122025/utils/constants/app_sizes.dart';
import 'package:calculator_05122025/utils/responsive_utils.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';

class CalculatorDisplayWidget extends StatelessWidget {
  final String displayText;
  final String expressionDisplay;

  const CalculatorDisplayWidget({
    super.key,
    required this.displayText,
    required this.expressionDisplay,
  });

  @override
  Widget build(BuildContext context) {
    final displayHeight = ResponsiveUtils.getDisplayHeight(context);
    final displayFontSize = ResponsiveUtils.getDisplayFontSize(context);
    final expressionFontSize = ResponsiveUtils.getExpressionFontSize(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth == 0) {
          return SizedBox(height: displayHeight);
        }
        return _DisplayContent(
          displayHeight: displayHeight,
          displayFontSize: displayFontSize,
          expressionFontSize: expressionFontSize,
          displayText: displayText,
          expressionDisplay: expressionDisplay,
        );
      },
    );
  }
}

class _DisplayContent extends StatelessWidget {
  final double displayHeight;
  final double displayFontSize;
  final double expressionFontSize;
  final String displayText;
  final String expressionDisplay;

  const _DisplayContent({
    required this.displayHeight,
    required this.displayFontSize,
    required this.expressionFontSize,
    required this.displayText,
    required this.expressionDisplay,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSizes.displayPadding),
      child: Neumorphic(
        style: NeumorphicStyle(
          shape: NeumorphicShape.concave,
          boxShape: NeumorphicBoxShape.roundRect(
            BorderRadius.circular(AppSizes.displayBorderRadius),
          ),
          depth: AppSizes.displayDepth,
          intensity: AppSizes.displayIntensity,
          lightSource: LightSource.topLeft,
          color: AppColors.operationButton.withValues(
            alpha: AppColors.colorAlpha,
          ),
        ),
        child: Container(
          constraints: BoxConstraints(minHeight: displayHeight),
          width: double.infinity,
          padding: const EdgeInsets.all(AppSizes.displayPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (expressionDisplay.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: AppSizes.displayExpressionSpacing,
                  ),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerRight,
                    child: Text(
                      expressionDisplay,
                      style: TextStyle(
                        fontSize: expressionFontSize,
                        color: AppColors.secondaryText,
                      ),
                    ),
                  ),
                ),
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerRight,
                child: Text(
                  displayText,
                  style: TextStyle(
                    fontSize: displayFontSize,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryText,
                  ),
                  maxLines: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
