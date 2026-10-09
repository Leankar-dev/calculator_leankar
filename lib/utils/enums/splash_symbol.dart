import 'package:calculator_05122025/utils/constants/app_colors.dart';
import 'package:calculator_05122025/utils/constants/app_strings.dart';
import 'package:flutter/painting.dart';

enum SplashSymbol {
  addition(
    label: AppStrings.additionSymbol,
    color: AppColors.operationButton,
    angleDegrees: -90.0,
    delayFraction: 0.00,
  ),
  multiplication(
    label: AppStrings.multiplicationSymbol,
    color: AppColors.clearButton,
    angleDegrees: -30.0,
    delayFraction: 0.10,
  ),
  equals(
    label: AppStrings.equalsButtonText,
    color: AppColors.scientificFunction,
    angleDegrees: 30.0,
    delayFraction: 0.20,
  ),
  division(
    label: AppStrings.divisionSymbol,
    color: AppColors.equalsButton,
    angleDegrees: 90.0,
    delayFraction: 0.30,
  ),
  percent(
    label: AppStrings.percentSymbol,
    color: AppColors.scientificShiftActive,
    angleDegrees: 150.0,
    delayFraction: 0.40,
  ),
  subtraction(
    label: AppStrings.subtractionSymbol,
    color: AppColors.backspaceButton,
    angleDegrees: 210.0,
    delayFraction: 0.50,
  );

  const SplashSymbol({
    required this.label,
    required this.color,
    required this.angleDegrees,
    required this.delayFraction,
  });

  final String label;
  final Color color;
  final double angleDegrees;
  final double delayFraction;
}
