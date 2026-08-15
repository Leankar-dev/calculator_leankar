import 'package:calculator_05122025/l10n/app_localizations.dart';
import 'package:calculator_05122025/utils/constants/app_colors.dart';
import 'package:calculator_05122025/utils/constants/app_scientific_strings.dart';
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
  final VoidCallback? onLongPress;

  const ButtonWidget({
    super.key,
    required this.text,
    required this.onPressed,
    this.color,
    this.isAccent = false,
    this.onLongPress,
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
      case AppScientificStrings.sin:
        return l10n.semanticSin;
      case AppScientificStrings.cos:
        return l10n.semanticCos;
      case AppScientificStrings.tan:
        return l10n.semanticTan;
      case AppScientificStrings.sinInverse:
        return l10n.semanticArcsin;
      case AppScientificStrings.cosInverse:
        return l10n.semanticArccos;
      case AppScientificStrings.tanInverse:
        return l10n.semanticArctan;
      case AppScientificStrings.log:
        return l10n.semanticLog;
      case AppScientificStrings.ln:
        return l10n.semanticLn;
      case AppScientificStrings.exp10:
        return l10n.semanticExp10;
      case AppScientificStrings.expE:
        return l10n.semanticExpE;
      case AppScientificStrings.square:
        return l10n.semanticSquare;
      case AppScientificStrings.cube:
        return l10n.semanticCube;
      case AppScientificStrings.power:
        return l10n.semanticPower;
      case AppScientificStrings.cbrt:
        return l10n.semanticCubeRoot;
      case AppScientificStrings.sqrt:
        return l10n.semanticSqrt;
      case AppScientificStrings.reciprocal:
        return l10n.semanticReciprocal;
      case AppScientificStrings.absoluteValue:
        return l10n.semanticAbsoluteValue;
      case AppScientificStrings.factorial:
        return l10n.semanticFactorial;
      case AppScientificStrings.permutation:
        return l10n.semanticPermutation;
      case AppScientificStrings.pi:
        return l10n.semanticPi;
      case AppScientificStrings.euler:
        return l10n.semanticEuler;
      case AppScientificStrings.openParen:
        return l10n.semanticOpenParen;
      case AppScientificStrings.closeParen:
        return l10n.semanticCloseParen;
      case AppScientificStrings.memoryAdd:
        return l10n.semanticMemoryAdd;
      case AppScientificStrings.memorySubtract:
        return l10n.semanticMemorySubtract;
      case AppScientificStrings.memoryRecall:
        return l10n.semanticMemoryRecall;
      case AppScientificStrings.memoryClear:
        return l10n.semanticMemoryClear;
      case AppScientificStrings.degMode:
      case AppScientificStrings.radMode:
        return l10n.semanticAngleModeToggle;
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
          child: GestureDetector(
            onLongPress: onLongPress,
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
      ),
    );
  }
}
