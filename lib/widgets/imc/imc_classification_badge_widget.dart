import 'package:calculator_05122025/utils/constants/app_sizes.dart';
import 'package:calculator_05122025/utils/enums/imc_classification.dart';
import 'package:flutter/material.dart';

class ImcClassificationBadgeWidget extends StatelessWidget {
  final ImcClassification classification;

  const ImcClassificationBadgeWidget({
    super.key,
    required this.classification,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.imcBadgePaddingH,
        vertical: AppSizes.imcBadgePaddingV,
      ),
      decoration: BoxDecoration(
        color: classification.color.withAlpha(38),
        borderRadius: BorderRadius.circular(AppSizes.imcBadgeBorderRadius),
        border: Border.all(
          color: classification.color,
          width: AppSizes.imcBadgeBorderWidth,
        ),
      ),
      child: Text(
        classification.label,
        style: TextStyle(
          color: classification.color,
          fontWeight: FontWeight.bold,
          fontSize: AppSizes.imcBadgeFontSize,
        ),
      ),
    );
  }
}
