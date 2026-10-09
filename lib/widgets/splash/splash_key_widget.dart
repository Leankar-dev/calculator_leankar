import 'package:calculator_05122025/utils/constants/app_colors.dart';
import 'package:calculator_05122025/utils/constants/app_sizes.dart';
import 'package:calculator_05122025/utils/enums/splash_symbol.dart';
import 'package:flutter/widgets.dart';

class SplashKeyWidget extends StatelessWidget {
  final SplashSymbol symbol;
  final double extent;

  const SplashKeyWidget({
    super.key,
    required this.symbol,
    required this.extent,
  });

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Color.alphaBlend(
            symbol.color.withValues(alpha: AppColors.colorAlpha),
            AppColors.themeBaseLight,
          ),
          borderRadius: BorderRadius.circular(
            extent * AppSizes.splashKeyCornerFactor,
          ),
          boxShadow: const [
            BoxShadow(
              color: AppColors.splashKeyShadowDark,
              offset: Offset(
                AppSizes.splashKeyShadowOffset,
                AppSizes.splashKeyShadowOffset,
              ),
              blurRadius: AppSizes.splashKeyShadowBlur,
            ),
            BoxShadow(
              color: AppColors.splashKeyShadowLight,
              offset: Offset(
                -AppSizes.splashKeyShadowOffset,
                -AppSizes.splashKeyShadowOffset,
              ),
              blurRadius: AppSizes.splashKeyShadowBlur,
            ),
          ],
        ),
        child: SizedBox.square(
          dimension: extent,
          child: Center(
            child: FittedBox(
              child: Text(
                symbol.label,
                style: TextStyle(
                  color: symbol.color,
                  fontWeight: FontWeight.bold,
                  fontSize: extent * AppSizes.splashKeyLabelFactor,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
