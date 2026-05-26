import 'package:calculator_05122025/utils/constants/app_sizes.dart';
import 'package:flutter/widgets.dart';

class ResponsiveUtils {
  static double _getScaleFactor(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final clampedWidth = width.clamp(
      AppSizes.minWidth,
      AppSizes.maxCalculatorWidth,
    );
    return clampedWidth / AppSizes.baseWidth;
  }

  static double getDisplayHeight(BuildContext context) {
    final scale = _getScaleFactor(context);
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    if (isLandscape) {
      return (AppSizes.displayHeightLandscape * scale).clamp(
        AppSizes.displayHeightLandscapeMin,
        AppSizes.displayHeightLandscapeMax,
      );
    }
    return (AppSizes.displayHeightPortrait * scale).clamp(
      AppSizes.displayHeightMin,
      AppSizes.displayHeightMax,
    );
  }

  static double getDisplayFontSize(BuildContext context) {
    final scale = _getScaleFactor(context);
    return (AppSizes.displayFontSize * scale).clamp(
      AppSizes.displayFontSizeMin,
      AppSizes.displayFontSizeMax,
    );
  }

  static double getExpressionFontSize(BuildContext context) {
    final scale = _getScaleFactor(context);
    return (AppSizes.expressionFontSize * scale).clamp(
      AppSizes.expressionFontSizeMin,
      AppSizes.expressionFontSizeMax,
    );
  }

  static double getButtonFontSize(BuildContext context) {
    final scale = _getScaleFactor(context);
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    if (isLandscape) {
      return (AppSizes.buttonFontSizeLandscape * scale).clamp(
        AppSizes.buttonFontSizeLandscapeMin,
        AppSizes.buttonFontSizeLandscapeMax,
      );
    }
    return (AppSizes.buttonFontSizePortrait * scale).clamp(
      AppSizes.buttonFontSizeMin,
      AppSizes.buttonFontSizeMax,
    );
  }

  static double getButtonPadding(BuildContext context) {
    final scale = _getScaleFactor(context);
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    if (isLandscape) {
      return (AppSizes.buttonPaddingLandscape * scale).clamp(
        AppSizes.buttonPaddingLandscapeMin,
        AppSizes.buttonPaddingLandscapeMax,
      );
    }
    return (AppSizes.buttonPaddingPortrait * scale).clamp(
      AppSizes.buttonPaddingMin,
      AppSizes.buttonPaddingMax,
    );
  }

  static double getButtonSpacing(BuildContext context) {
    final scale = _getScaleFactor(context);
    return (AppSizes.buttonSpacing * scale).clamp(
      AppSizes.buttonSpacingMin,
      AppSizes.buttonSpacingMax,
    );
  }

  static double getMaxCalculatorWidth() {
    return AppSizes.maxCalculatorWidth;
  }

  static bool isLandscape(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.landscape;
  }

  static bool isTablet(BuildContext context) {
    final shortestSide = MediaQuery.of(context).size.shortestSide;
    return shortestSide >= AppSizes.tabletBreakpoint;
  }
}
