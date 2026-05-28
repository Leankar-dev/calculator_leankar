import 'package:calculator_05122025/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';

enum ImcClassification {
  underweight(
    color: AppColors.imcUnderweight,
    minImc: 0,
    maxImc: 18.5,
  ),
  normal(
    color: AppColors.imcNormal,
    minImc: 18.5,
    maxImc: 25.0,
  ),
  overweight(
    color: AppColors.imcOverweight,
    minImc: 25.0,
    maxImc: 30.0,
  ),
  obesityI(
    color: AppColors.imcObesityI,
    minImc: 30.0,
    maxImc: 35.0,
  ),
  obesityII(
    color: AppColors.imcObesityII,
    minImc: 35.0,
    maxImc: 40.0,
  ),
  obesityIII(
    color: AppColors.imcObesityIII,
    minImc: 40.0,
    maxImc: double.infinity,
  );

  final Color color;
  final double minImc;
  final double maxImc;

  const ImcClassification({
    required this.color,
    required this.minImc,
    required this.maxImc,
  });

  static ImcClassification fromImc(double imc) {
    for (final classification in ImcClassification.values) {
      if (imc >= classification.minImc && imc < classification.maxImc) {
        return classification;
      }
    }
    return ImcClassification.obesityIII;
  }
}
