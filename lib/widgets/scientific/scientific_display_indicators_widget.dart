import 'package:calculator_05122025/utils/constants/app_colors.dart';
import 'package:calculator_05122025/utils/constants/app_scientific_strings.dart';
import 'package:calculator_05122025/utils/constants/app_sizes.dart';
import 'package:calculator_05122025/utils/enums/angle_mode.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';

class ScientificDisplayIndicatorsWidget extends StatelessWidget {
  final AngleMode angleMode;
  final bool hasMemoryValue;

  const ScientificDisplayIndicatorsWidget({
    super.key,
    required this.angleMode,
    required this.hasMemoryValue,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: AppSizes.scientificIndicatorBottomSpacing,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (hasMemoryValue) ...[
            const Text(
              AppScientificStrings.memoryIndicator,
              key: ValueKey('scientific_memory_indicator'),
              style: TextStyle(
                fontSize: AppSizes.scientificIndicatorFontSize,
                color: AppColors.secondaryText,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: AppSizes.scientificIndicatorSpacing),
          ],
          Text(
            angleMode == AngleMode.deg
                ? AppScientificStrings.degMode
                : AppScientificStrings.radMode,
            key: const ValueKey('scientific_angle_mode_indicator'),
            style: const TextStyle(
              fontSize: AppSizes.scientificIndicatorFontSize,
              color: AppColors.secondaryText,
            ),
          ),
        ],
      ),
    );
  }
}
