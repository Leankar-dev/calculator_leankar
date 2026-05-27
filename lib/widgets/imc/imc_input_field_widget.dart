import 'package:calculator_05122025/utils/constants/app_colors.dart';
import 'package:calculator_05122025/utils/constants/app_sizes.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';

class ImcInputFieldWidget extends StatelessWidget {
  final String label;
  final String unit;
  final String hint;
  final TextEditingController controller;
  final void Function(String) onChanged;

  const ImcInputFieldWidget({
    super.key,
    required this.label,
    required this.unit,
    required this.hint,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: AppSizes.imcInputLabelFontSize,
            color: AppColors.secondaryText,
          ),
        ),
        const SizedBox(height: 8),
        Neumorphic(
          style: const NeumorphicStyle(
            depth: AppSizes.imcInputDepth,
            intensity: AppSizes.imcInputIntensity,
            boxShape: NeumorphicBoxShape.stadium(),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.imcInputInnerPaddingH,
            vertical: AppSizes.imcInputInnerPaddingV,
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: hint,
                    hintStyle: TextStyle(color: Colors.grey[400]),
                  ),
                  style: const TextStyle(fontSize: AppSizes.imcInputFontSize),
                  onChanged: onChanged,
                ),
              ),
              Text(
                unit,
                style: const TextStyle(
                  fontSize: AppSizes.imcInputUnitFontSize,
                  color: AppColors.secondaryText,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
