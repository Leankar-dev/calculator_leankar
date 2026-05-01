import 'package:calculator_05122025/utils/constants.dart';
import 'package:flutter/widgets.dart';

class ResponsiveUtils {
  static double _getScaleFactor(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final clampedWidth = width.clamp(
      AppConstants.minWidth,
      AppConstants.maxCalculatorWidth,
    );
    return clampedWidth / AppConstants.baseWidth;
  }

  static double getDisplayHeight(BuildContext context) {
    final scale = _getScaleFactor(context);
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    if (isLandscape) {
      return (AppConstants.displayHeightLandscape * scale).clamp(
        AppConstants.displayHeightLandscapeMin,
        AppConstants.displayHeightLandscapeMax,
      );
    }
    return (AppConstants.displayHeightPortrait * scale).clamp(
      AppConstants.displayHeightMin,
      AppConstants.displayHeightMax,
    );
  }

  static double getDisplayFontSize(BuildContext context) {
    final scale = _getScaleFactor(context);
    return (AppConstants.displayFontSize * scale).clamp(
      AppConstants.displayFontSizeMin,
      AppConstants.displayFontSizeMax,
    );
  }

  static double getExpressionFontSize(BuildContext context) {
    final scale = _getScaleFactor(context);
    return (AppConstants.expressionFontSize * scale).clamp(
      AppConstants.expressionFontSizeMin,
      AppConstants.expressionFontSizeMax,
    );
  }

  static double getButtonFontSize(BuildContext context) {
    final scale = _getScaleFactor(context);
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    if (isLandscape) {
      return (AppConstants.buttonFontSizeLandscape * scale).clamp(
        AppConstants.buttonFontSizeLandscapeMin,
        AppConstants.buttonFontSizeLandscapeMax,
      );
    }
    return (AppConstants.buttonFontSizePortrait * scale).clamp(
      AppConstants.buttonFontSizeMin,
      AppConstants.buttonFontSizeMax,
    );
  }

  static double getButtonPadding(BuildContext context) {
    final scale = _getScaleFactor(context);
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    if (isLandscape) {
      return (AppConstants.buttonPaddingLandscape * scale).clamp(
        AppConstants.buttonPaddingLandscapeMin,
        AppConstants.buttonPaddingLandscapeMax,
      );
    }
    return (AppConstants.buttonPaddingPortrait * scale).clamp(
      AppConstants.buttonPaddingMin,
      AppConstants.buttonPaddingMax,
    );
  }

  static double getButtonSpacing(BuildContext context) {
    final scale = _getScaleFactor(context);
    return (AppConstants.buttonSpacing * scale).clamp(
      AppConstants.buttonSpacingMin,
      AppConstants.buttonSpacingMax,
    );
  }

  static double getMaxCalculatorWidth() {
    return AppConstants.maxCalculatorWidth;
  }

  static bool isLandscape(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.landscape;
  }

  static bool isTablet(BuildContext context) {
    final shortestSide = MediaQuery.of(context).size.shortestSide;
    return shortestSide >= AppConstants.tabletBreakpoint;
  }
}
