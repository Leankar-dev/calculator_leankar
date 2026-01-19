import 'package:calculator_05122025/utils/constants.dart';
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

    return Padding(
      padding: const EdgeInsets.all(AppConstants.displayPadding),
      child: Neumorphic(
        style: NeumorphicStyle(
          shape: NeumorphicShape.concave,
          boxShape: NeumorphicBoxShape.roundRect(
            BorderRadius.circular(AppConstants.displayBorderRadius),
          ),
          depth: AppConstants.displayDepth,
          intensity: AppConstants.displayIntensity,
          lightSource: LightSource.topLeft,
          color: AppConstants.operationButtonColor.withValues(
            alpha: AppConstants.colorAlpha,
          ),
        ),
        child: Container(
          constraints: BoxConstraints(minHeight: displayHeight),
          width: double.infinity,
          padding: const EdgeInsets.all(AppConstants.displayPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (expressionDisplay.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerRight,
                    child: Text(
                      expressionDisplay,
                      style: TextStyle(
                        fontSize: expressionFontSize,
                        color: AppConstants.secondaryTextColor,
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
                    color: AppConstants.primaryTextColor,
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
