import 'package:calculator_05122025/utils/constants.dart';
import 'package:calculator_05122025/utils/constants/app_strings.dart';
import 'package:calculator_05122025/utils/responsive_utils.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';

class ButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? color;
  final bool isAccent;

  const ButtonWidget({
    super.key,
    required this.text,
    required this.onPressed,
    this.color,
    this.isAccent = false,
  });

  String _getSemanticLabel(String text) {
    switch (text) {
      case AppStrings.divisionSymbol:
        return AppStrings.semanticDivide;
      case AppStrings.multiplicationSymbol:
        return AppStrings.semanticMultiply;
      case AppStrings.subtractionSymbol:
        return AppStrings.semanticSubtract;
      case AppStrings.additionSymbol:
        return AppStrings.semanticAdd;
      case AppStrings.backspaceSymbol:
        return AppStrings.semanticBackspace;
      case AppStrings.percentSymbol:
        return AppStrings.semanticPercent;
      case '=':
        return AppStrings.semanticEquals;
      case 'C':
        return AppStrings.semanticClear;
      case AppStrings.decimalSeparator:
        return AppStrings.semanticDecimalSeparator;
      default:
        return text;
    }
  }

  @override
  Widget build(BuildContext context) {
    final baseColor = NeumorphicTheme.baseColor(context);
    final bool hasCustomColor = color != null;
    final buttonFontSize = ResponsiveUtils.getButtonFontSize(context);
    final buttonPadding = ResponsiveUtils.getButtonPadding(context);
    final buttonSpacing = ResponsiveUtils.getButtonSpacing(context);

    return Expanded(
      child: Padding(
        padding: EdgeInsets.all(buttonSpacing),
        child: Semantics(
          button: true,
          label: _getSemanticLabel(text),
          child: NeumorphicButton(
            onPressed: () {
              HapticFeedback.lightImpact();
              onPressed();
            },
            style: NeumorphicStyle(
              shape: NeumorphicShape.concave,
              boxShape: NeumorphicBoxShape.roundRect(
                BorderRadius.circular(AppConstants.buttonBorderRadius),
              ),
              depth: AppConstants.buttonDepth,
              intensity: AppConstants.buttonIntensity,
              surfaceIntensity: AppConstants.buttonSurfaceIntensity,
              color: hasCustomColor
                  ? color!.withValues(alpha: AppConstants.colorAlpha)
                  : baseColor,
              lightSource: LightSource.topLeft,
            ),
            padding: EdgeInsets.all(buttonPadding),
            child: Center(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: buttonFontSize,
                  fontWeight: FontWeight.bold,
                  color: hasCustomColor ? color : AppConstants.primaryTextColor,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
