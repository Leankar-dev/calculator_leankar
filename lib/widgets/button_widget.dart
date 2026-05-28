import 'package:calculator_05122025/l10n/app_localizations.dart';
import 'package:calculator_05122025/utils/constants/app_colors.dart';
import 'package:calculator_05122025/utils/constants/app_sizes.dart';
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

  String _getSemanticLabel(String text, AppLocalizations l10n) {
    switch (text) {
      case AppStrings.divisionSymbol:
        return l10n.semanticDivide;
      case AppStrings.multiplicationSymbol:
        return l10n.semanticMultiply;
      case AppStrings.subtractionSymbol:
        return l10n.semanticSubtract;
      case AppStrings.additionSymbol:
        return l10n.semanticAdd;
      case AppStrings.backspaceSymbol:
        return l10n.semanticBackspace;
      case AppStrings.percentSymbol:
        return l10n.semanticPercent;
      case '=':
        return l10n.semanticEquals;
      case 'C':
        return l10n.semanticClear;
      case AppStrings.decimalSeparator:
        return l10n.semanticDecimalSeparator;
      default:
        return text;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
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
          label: _getSemanticLabel(text, l10n),
          child: NeumorphicButton(
            onPressed: () {
              HapticFeedback.lightImpact();
              onPressed();
            },
            style: NeumorphicStyle(
              shape: NeumorphicShape.concave,
              boxShape: NeumorphicBoxShape.roundRect(
                BorderRadius.circular(AppSizes.buttonBorderRadius),
              ),
              depth: AppSizes.buttonDepth,
              intensity: AppSizes.buttonIntensity,
              surfaceIntensity: AppSizes.buttonSurfaceIntensity,
              color: hasCustomColor
                  ? color!.withValues(alpha: AppColors.colorAlpha)
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
                  color: hasCustomColor ? color : AppColors.primaryText,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
