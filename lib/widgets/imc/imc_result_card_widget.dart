import 'package:calculator_05122025/models/imc_result.dart';
import 'package:calculator_05122025/utils/constants/app_colors.dart';
import 'package:calculator_05122025/utils/constants/app_sizes.dart';
import 'package:calculator_05122025/utils/constants/app_strings.dart';
import 'package:calculator_05122025/widgets/imc/imc_classification_badge_widget.dart';
import 'package:calculator_05122025/widgets/imc/imc_gauge_widget.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';

class ImcResultCardWidget extends StatelessWidget {
  final ImcResult result;

  const ImcResultCardWidget({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return Neumorphic(
      style: NeumorphicStyle(
        depth: AppSizes.imcResultCardDepth,
        intensity: AppSizes.imcResultCardIntensity,
        boxShape: NeumorphicBoxShape.roundRect(
          const BorderRadius.all(
            Radius.circular(AppSizes.imcResultCardBorderRadius),
          ),
        ),
      ),
      padding: const EdgeInsets.all(AppSizes.imcResultCardPadding),
      child: Column(
        children: [
          ImcGaugeWidget(
            imc: result.imc,
            classification: result.classification,
          ),
          const SizedBox(height: AppSizes.imcResultGaugeToBadgeSpacing),
          ImcClassificationBadgeWidget(classification: result.classification),
          const SizedBox(height: AppSizes.imcResultBadgeToDetailSpacing),
          _DetailRow(
            label: AppStrings.imcWeightLabel,
            value: result.formattedWeight,
          ),
          const SizedBox(height: AppSizes.imcResultDetailRowSpacing),
          _DetailRow(
            label: AppStrings.imcHeightLabel,
            value: result.formattedHeight,
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(color: AppColors.secondaryText),
        ),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: AppSizes.imcResultDetailFontSize,
          ),
        ),
      ],
    );
  }
}
