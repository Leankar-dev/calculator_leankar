import 'package:calculator_05122025/utils/constants/app_colors.dart';
import 'package:calculator_05122025/utils/constants/app_sizes.dart';
import 'package:calculator_05122025/utils/constants/app_strings.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';

class ImcCalculateButtonWidget extends StatelessWidget {
  final VoidCallback onPressed;

  const ImcCalculateButtonWidget({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return NeumorphicButton(
      style: const NeumorphicStyle(
        depth: AppSizes.imcCalculateButtonDepth,
        intensity: AppSizes.imcCalculateButtonIntensity,
        color: AppColors.equalsButton,
        boxShape: NeumorphicBoxShape.stadium(),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.imcCalculateButtonPaddingH,
        vertical: AppSizes.imcCalculateButtonPaddingV,
      ),
      onPressed: onPressed,
      child: const Text(
        AppStrings.imcCalculateButtonLabel,
        style: TextStyle(
          fontSize: AppSizes.imcCalculateButtonFontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}
